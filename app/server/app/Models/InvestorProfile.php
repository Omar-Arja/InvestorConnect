<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InvestorProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'profile_picture_url',
        'location',
        'bio',
        'min_investment_amount',
        'max_investment_amount',
    ];

    protected $appends = [
        'full_name',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function investorPreferences()
    {
        return $this->hasOne(InvestorPreference::class);
    }

    // Attributes
    public function getFullNameAttribute()
    {
        return $this->user->name;
    }
}
