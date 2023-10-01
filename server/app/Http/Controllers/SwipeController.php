<?php

namespace App\Http\Controllers;

use App\Http\Controllers\NotificationController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Exception;
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
            $user1 = $user;
            $user2 = User::find($request->swiped_id);

            $investor_id;
            $startup_id;
            
            if ($user1->usertype_name === 'investor') {
                $investor_id = $user1->investorProfile->id;
                $startup_id = $user2->startupProfile->id;
            } else {
                $investor_id = $user2->investorProfile->id;
                $startup_id = $user1->startupProfile->id;
            }
            
            $matched_profile = MatchedProfile::create([
                'investor_profile_id' => $investor_id,
                'startup_profile_id' => $startup_id,
            ]);

            Swipe::where('swiper_id', $request->swiped_id)
                ->where('swiped_id', $user->id)
                ->where('direction', 'right')
                ->delete();

            NotificationController::sendMatchNotification($user->id, $request->swiped_id);

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

        if ($potential_matches->isEmpty()) {
            return response()->json([
                'status' => 'success',
                'usertype_name' => Auth::user()->usertype_name == 'investor' ? 'startup' : 'investor',
                'potential_matches' => [],
            ]);
        }

        // get user profile and preferences
        $user_profile = $user->usertype_name === 'investor'
            ? $user->investorProfile->load('investorPreferences')
            : $user->startupProfile->load('startupPreferences');

        $response = Http::withOptions([
            'timeout' => 70,
        ])->withHeaders([
            'Content-Type' => 'application/json',
            'X-API-KEY' => 'sk_Mlk2W2jwcaikSmZfQ4wFckEvsb3Wpk2w3c7apl802yo',
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
            
        try {
            if (isset($data['matched_user_ids'])) {
                $matched_users = $data['matched_user_ids'];
                $potential_matches = [];

                foreach ($matched_users as $matched_user) {
                    $ai_analysis = $matched_user['ai_analysis'];
                    $user_id = $matched_user['id'];

                    $user = User::find($user_id);
                    if (!$user) {
                        continue;
                    }

                    $profile = $user->usertype_name === 'investor'
                        ? $user->investorProfile
                        : $user->startupProfile;

                    $profile != null ? $profile->ai_analysis = $ai_analysis : $profile = null;
                    if ($profile == null) {
                        continue;
                    }

                    $potential_matches[] = $profile;
                }
            } else {
                throw new Exception('No matched users');
            }
            
        } catch (Exception $e) {
            $potential_matches_profiles = [];

            foreach($potential_matches as $potential_match) {
                $profile = $potential_match->usertype_name === 'investor'
                    ? $potential_match->investorProfile
                    : $potential_match->startupProfile;

                $potential_matches_profiles[] = $profile;
            }
            $potential_matches = $potential_matches_profiles;
        }

        return response()->json([
            'status' => 'success',
            'usertype_name' => Auth::user()->usertype_name == 'investor' ? 'startup' : 'investor',
            'potential_matches' => $potential_matches,
        ]);
    }
}
