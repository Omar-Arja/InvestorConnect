<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
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

        return response()->json([
            'status' => 'success',
            'user_profile' => $user_profile,
            'potential_matches' => $potential_matches,
        ]);
    }


}
