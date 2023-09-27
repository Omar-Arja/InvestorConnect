<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\http;
use App\Models\Swipe;
use App\Models\MatchedProfile;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class SwipeController extends Controller
{
    public function swipeRight(Request $request)
    {
        $request->validate([
            'swiped_id' => 'required|integer',
        ]);

        $user = Auth::user();

        // check if the user has already swiped right on this user
        $swiped_right = Swipe::where('swiper_id', $user->id)
            ->where('swiped_id', $request->swiped_id)
            ->where('direction', 'right')
            ->first();

        if ($swiped_right) {
            return response()->json([
                'status' => 'error',
                'message' => 'You have already swiped right on this user.',
            ]);
        }

        $swiped_right = Swipe::where('swiper_id', $request->swiped_id)
            ->where('swiped_id', $user->id)
            ->where('direction', 'right')
            ->first();

        if ($swiped_right) {
            $matched_profile = MatchedProfile::create([
                'investor_profile_id' => $user->usertype_name === 'investor' ? $user->investorProfile->id : $request->swiped_id,
                'startup_profile_id' => $user->usertype_name === 'startup' ? $user->startupProfile->id : $request->swiped_id,
            ]);

            Swipe::where('swiper_id', $request->swiped_id)
                ->where('swiped_id', $user->id)
                ->where('direction', 'right')
                ->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'matched',
                'matched_profile' => $matched_profile,
            ]);
        } else {
            Swipe::create([
                'swiper_id' => $user->id,
                'swiped_id' => $request->swiped_id,
                'direction' => 'right',
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'swiped right',
            ]);
        }
    }

    public function swipeLeft(Request $request)
    {
        $request->validate([
            'swiped_id' => 'required|integer',
        ]);

        $user = Auth::user();

        $swiped_left = Swipe::where('swiper_id', $user->id)
            ->where('swiped_id', $request->swiped_id)
            ->where('direction', 'left')
            ->first();

        if ($swiped_left) {
            return response()->json([
                'status' => 'error',
                'message' => 'You have already swiped left on this user.',
            ]);
        } else if (Swipe::where('swiper_id', $user->id)
            ->where('swiped_id', $request->swiped_id)
            ->where('direction', 'right')
            ->first()) {
            return response()->json([
                'status' => 'error',
                'message' => 'You have already swiped right on this user.',
            ]);
        }

        Swipe::create([
            'swiper_id' => $user->id,
            'swiped_id' => $request->swiped_id,
            'direction' => 'left',
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'swiped left',
        ]);
    }

    public function getPotentialMatches()
    {
        $user = Auth::user();

        // get all users that the current user has swiped right on
        $swiped_right_ids = Swipe::where('swiper_id', $user->id)
            ->where('direction', 'right')
            ->pluck('swiped_id')
            ->toArray();

        // get all users that the current user has matched with
        $matched_profiles = MatchedProfile::getMatchedProfiles();
        $matches_users_ids = [];
        foreach ($matched_profiles as $matched_profile) {
            if ($user->usertype_name === 'investor') {
                $matches_users_ids[] = $matched_profile->startupProfile->user_id;
            } else {
                $matches_users_ids[] = $matched_profile->investorProfile->user_id;
            }
        }

        // get all users filtered by the above
        $potential_matches = User::where('id', '!=', $user->id)
            ->where('usertype_id', '!=', $user->usertype_id)
            ->whereNotIn('id', $swiped_right_ids)
            ->whereNotIn('id', $matches_users_ids)
            ->with(['investorProfile', 'startupProfile'])
            ->get();

        // add swiped_right boolean property to each user
        foreach ($potential_matches as $potential_match) {
            $swiped_right = Swipe::where('swiper_id', $potential_match->id)
                ->where('swiped_id', $user->id)
                ->where('direction', 'right')
                ->first();

            $potential_match->swiped_right = $swiped_right ? true : false;
        }

        // get user profile and preferences
        $user_profile = $user->usertype_name === 'investor'
            ? $user->investorProfile->load('investorPreferences')
            : $user->startupProfile->load('startupPreferences');

        $response = Http::withOptions([
            'timeout' => 60,
        ])->withHeaders([
            'Content-Type' => 'application/json',
            'X-API-KEY' => Env('FORGE_API_KEY'),
        ])
        ->post('https://api.theforgeai.com/v1/apps/65139e5bc4b84c2fdd707f3b/view/run', [
            'user_inputs' => [
                'user_profile_2' => [
                    'value' => json_encode($user_profile),
                ],
                'potential_matches_3' => [
                    'value' => json_encode($potential_matches),
                ],
            ],
        ]);

        $responseData = $response['user_outputs']['matched_users_5']['value'];
        $data = json_decode($responseData, true);

        if ($data) {
            $matched_users = $data['matched_user_ids'];

            $potential_matches = [];
            
            foreach($matched_users as $matched_user) {
                $ai_analysis = $matched_user['ai_analysis'];
                $user_id = $matched_user['id'];
                $user = User::find($user_id);
                $profile = $user->usertype_name === 'investor'
                    ? $user->investorProfile
                    : $user->startupProfile;

                $profile->ai_analysis = $ai_analysis;

                $swiped_right = Swipe::where('swiper_id', $user->id)
                    ->where('swiped_id', $user->id)
                    ->where('direction', 'right')
                    ->first();

                $profile->swiped_right = $swiped_right ? true : false;
                
                $potential_matches[] = $profile;
            }
        }

        return response()->json([
            'status' => 'success',
            'usertype_name' => $user->usertype_name == 'investor' ? 'startup' : 'investor',
            'potential_matches' => $potential_matches,
        ]);
    }
}
