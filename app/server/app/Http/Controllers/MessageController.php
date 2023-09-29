<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Message;
use App\Models\MatchedProfile;
use Illuminate\Support\Facades\Auth;

class MessageController extends Controller
{
    public function sendMessage(Request $request)
    {
        $request->validate([
            'receiver_id' => 'required|integer',
            'message' => 'required|string',
        ]);

        $message = Message::create([
            'sender_id' => Auth::user()->id,
            'receiver_id' => $request->receiver_id,
            'message' => $request->message,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => $message,
        ]);
    }

    public function getMatchedProfilesWithMessages()
    {
        $user = Auth::user();
        $matched_profiles = MatchedProfile::getMatchedProfiles();

        $profiles = [];
        foreach ($matched_profiles as $matched_profile) {
            $other_user_profile = $user->usertype_name === 'investor' ? $matched_profile->startupProfile : $matched_profile->investorProfile;
            $other_user_id = $other_user_profile->user_id;

            $profile = [
                'id' => $other_user_profile->user_id,
                'full_name' => $other_user_profile->full_name,
                'calendly_link' => $other_user_profile->calendly_link,
                'profile_picture_url' => $other_user_profile->profile_picture_url ?? $other_user_profile->company_logo_url,
            ];

            $messages = Message::getMessages($other_user_id);

            $profiles[] = [
                'profile' => $profile,
                'messages' => $messages,
            ];
        }
        
        $profilesWithMessages = [];
        $profilesWithoutMessages = [];

        foreach ($profiles as $profile) {
            if (empty($profile['messages'])) {
                $profilesWithMessages[] = $profile;
            } else {
                $profilesWithoutMessages[] = $profile;
            }
        }

        $sortedProfilesWithMessages = collect($profilesWithMessages)->sortByDesc(function ($profile) {
            return $profile['messages']->last()->created_at;
        })->values()->all();

        $sortedProfilesWithoutMessages = collect($profilesWithoutMessages)->sortBy('profile.full_name')->values()->all();

        $profiles = array_merge($sortedProfilesWithMessages, $sortedProfilesWithoutMessages);

        return response()->json([
            'status' => 'success',
            'profiles' => $profiles,
        ]);
    }
}
