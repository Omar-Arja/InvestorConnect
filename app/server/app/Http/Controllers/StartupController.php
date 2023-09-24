<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\StartupProfile;
use App\Models\StartupPreference;
use App\Models\UserType;
use Illuminate\Support\Facades\Auth;

class StartupController extends Controller
{
    public function createProfile(Request $request)
    {
        $request->validate([
            'company_name' => 'required|string',
            'calendly_link' => 'required|string|sometimes',
            'company_logo_file' => 'required|file',
            'industries' => 'required|string',
            'location' => 'required|string',
            'investment_stage' => 'required|string',
            'pitch_video_file' => 'required|file',
            'company_description' => 'required|string',
            'preferred_locations' => 'required|string',
            'min_investment_amount' => 'required|string',
            'max_investment_amount' => 'required|string',
        ]);

        $user = Auth::user();

        if ($user->startupProfile || $user->investorProfile) {
            return response()->json([
                'status' => 'error',
                'message' => 'User already has a profile',
                'profile' => $user->startupProfile ? $user->startupProfile->load('startupPreferences') : $user->investorProfile->load('investorPreferences'),
            ]);
        }

        $request->industries = explode(',', $request->industries);
        $request->preferred_locations = explode(',', $request->preferred_locations);
        $request->min_investment_amount = (int) $request->min_investment_amount;
        $request->max_investment_amount = (int) $request->max_investment_amount;

        // Generate unique names for the uploaded files
        $company_logo_name = uniqid() . '.' . $request->File('company_logo_file')->extension();
        $pitch_video_name = uniqid() . '.' . $request->File('pitch_video_file')->extension();

        // Store the uploaded files in the public disk
        $company_logo_path = $request->File('company_logo_file')->storeAs('images', $company_logo_name, 'public');
        $pitch_video_path = $request->File('pitch_video_file')->storeAs('videos', $pitch_video_name, 'public');

        // Generate URLs for the uploaded files
        $company_logo_url = asset('storage/' . $company_logo_path);
        $pitch_video_url = asset('storage/' . $pitch_video_path);

        $startup_profile = StartupProfile::create([
            'user_id' => $user->id,
            'company_name' => $request->company_name,
            'calendly_link' => $request->calendly_link ?? null,
            'company_logo_url' => $company_logo_url,
            'industries' => $request->industries,
            'location' => $request->location,
            'investment_stage' => $request->investment_stage,
            'pitch_video_url' => $pitch_video_url,
            'company_description' => $request->company_description,
        ]);

        StartupPreference::create([
            'startup_profile_id' => $startup_profile->id,
            'preferred_locations' => $request->preferred_locations,
            'min_investment_amount' => $request->min_investment_amount,
            'max_investment_amount' => $request->max_investment_amount,
        ]);

        $user->userType()->associate(UserType::where('name', 'startup')->first());
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Profile created successfully',
            'profile' => $startup_profile->load('startupPreferences'),
        ], 201);
    }

    public function updateProfile(Request $request)
    {
        $request->validate([
            'company_name' => 'required|string',
            'calendl_link' => 'required|string|sometimes',
            'company_logo_file' => 'required|file',
            'industries' => 'required|string',
            'location' => 'required|string',
            'investment_stage' => 'required|string',
            'pitch_video_file' => 'required|file',
            'company_description' => 'required|string', 
            'preferred_locations' => 'required|string',
            'min_investment_amount' => 'required|string',
            'max_investment_amount' => 'required|string',
        ]);

        $request->industries = explode(',', $request->industries);
        $request->preferred_locations = explode(',', $request->preferred_locations);
        $request->min_investment_amount = (int) $request->min_investment_amount;
        $request->max_investment_amount = (int) $request->max_investment_amount;

        $user = Auth::user();

        if (!$user->startupProfile) {
            return response()->json([
                'status' => 'error',
                'message' => 'User does not have a profile',
            ]);
        }

        // Generate unique names for the uploaded files
        $company_logo_name = uniqid() . '.' . $request->File('company_logo_file')->extension();
        $pitch_video_name = uniqid() . '.' . $request->File('pitch_video_file')->extension();

        // Store the uploaded files in the public disk
        $company_logo_path = $request->File('company_logo_file')->storeAs('images', $company_logo_name, 'public');
        $pitch_video_path = $request->File('pitch_video_file')->storeAs('videos', $pitch_video_name, 'public');

        // Generate URLs for the uploaded files
        $company_logo_url = asset('storage/' . $company_logo_path);
        $pitch_video_url = asset('storage/' . $pitch_video_path);

        $startup_profile = StartupProfile::where('user_id', $user->id)->first();

        $startup_profile->update([
            'company_name' => $request->company_name,
            'calendly_link' => $request->calendly_link ?? null,
            'company_logo_url' => $company_logo_url,
            'industries' => $request->industries,
            'location' => $request->location,
            'investment_stage' => $request->investment_stage,
            'pitch_video_url' => $pitch_video_url,
            'company_description' => $request->company_description,
        ]);

        $startup_profile->startupPreferences->update([
            'preferred_locations' => $request->preferred_locations,
            'min_investment_amount' => $request->min_investment_amount,
            'max_investment_amount' => $request->max_investment_amount,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Profile updated successfully',
            'profile' => $startup_profile->load('startupPreferences'),
        ], 200);
    }

    public function getProfile()
    {
        $user = Auth::user();

        if (!$user->startupProfile) {
            return response()->json([
                'status' => 'error',
                'message' => 'User does not have a profile',
            ]);
        }

        $startup_profile = StartupProfile::where('user_id', $user->id)->first();

        return response()->json([
            'status' => 'success',
            'message' => 'Profile retrieved successfully',
            'profile' => $startup_profile,
        ], 200);
    }

    public function deleteProfile()
    {
        $user = Auth::user();

        if (!$user->startupProfile) {
            return response()->json([
                'status' => 'error',
                'message' => 'User does not have a profile',
            ]);
        }

        $startup_profile = StartupProfile::where('user_id', $user->id)->first();

        $startup_profile->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Profile deleted successfully',
        ], 200);
    }

}
