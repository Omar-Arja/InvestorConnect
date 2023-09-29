<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class ProfileController extends Controller
{
    public function getProfile()
    {
        $user = Auth::user();

        if ($user->usertype_name === 'investor') {
            $profile = $user->investorProfile;
        } else {
            $profile = $user->startupProfile;
        }

        return response()->json([
            'status' => 'success',
            'usertype_name' => $user->usertype_name,
            'profile' => $profile,
        ]);
    }
}
