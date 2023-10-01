<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class MatchedProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'investor_profile_id',
        'startup_profile_id',
    ];

    // Relationships
    public function investorProfile()
    {
        return $this->belongsTo(InvestorProfile::class);
    }

    public function startupProfile()
    {
        return $this->belongsTo(StartupProfile::class);
    }

    // Methods
    public static function getMatchedProfiles()
    {
        if (Auth::user()->usertype_name === 'investor') {
            $matched_profiles = MatchedProfile::where('investor_profile_id', Auth::user()->investorProfile->id)->get();
        } else {
            $matched_profiles = MatchedProfile::where('startup_profile_id', Auth::user()->startupProfile->id)->get();
        }

        return $matched_profiles;
    }
}
