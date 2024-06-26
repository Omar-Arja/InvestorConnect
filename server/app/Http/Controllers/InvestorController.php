<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\InvestorProfile;
use App\Models\InvestorPreference;
use App\Models\Usertype;
use Illuminate\Support\Facades\Auth;

class InvestorController extends Controller
{
    public function createProfile(Request $request)
    {
        $request->validate([
            'profile_picture_file' => 'required|file',
            'location' => 'required|string',
            'bio' => 'required|string',
            'min_investment_amount' => 'required|string',
            'max_investment_amount' => 'required|string',
            'preferred_locations' => 'required|string',
            'industries' => 'required|string',
            'investment_stages' => 'required|string',
        ]);

        $user = Auth::user();

        if ($user->investorProfile || $user->startupProfile) {
            return response()->json([
                'status' => 'error',
                'message' => 'User already has a profile',
                'profile' => $user->investorProfile ? $user->investorProfile->load('investorPreferences') : $user->startupProfile->load('startupPreferences'),
            ]);
        }

        $request->preferred_locations = explode(',', $request->preferred_locations);
        $request->industries = explode(',', $request->industries);
        $request->investment_stages = explode(',', $request->investment_stages);
        $request->min_investment_amount = (int) $request->min_investment_amount;
        $request->max_investment_amount = (int) $request->max_investment_amount;

        // generate unique name for the uploaded file
        $profile_picture_name = uniqid() . '.' . $request->File('profile_picture_file')->extension();

        // store the uploaded file in the public disk
        $profile_picture_path = $request->File('profile_picture_file')->storeAs('images', $profile_picture_name, 'public');

        // generate URL for the uploaded file
        $profile_picture_url = asset('storage/' . $profile_picture_path);

        $investor_profile = InvestorProfile::create([
            'user_id' => $user->id,
            'profile_picture_url' => $profile_picture_url,
            'calendly_link' => $request->calendly_link ?? null,
            'location' => $request->location,
            'bio' => $request->bio,
            'min_investment_amount' => $request->min_investment_amount,
            'max_investment_amount' => $request->max_investment_amount,
        ]);

        $investor_preference = InvestorPreference::create([
            'investor_profile_id' => $investor_profile->id,
            'preferred_locations' => $request->preferred_locations,
            'industries' => $request->industries,
            'investment_stages' => $request->investment_stages,
        ]);

        $user->usertype()->associate(Usertype::where('name', 'investor')->first());
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Investor profile created successfully',
            'profile' => $investor_profile->load('investorPreferences'),
        ]);
    }

    public function getProfile()
    {
        $user = Auth::user();

        if (!$user->investorProfile) {
            return response()->json([
                'status' => 'error',
                'message' => 'User does not have an investor profile',
            ]);
        }

        return response()->json([
            'status' => 'success',
            'profile' => $user->investorProfile->load('investorPreferences'),
        ]);
    }
}
