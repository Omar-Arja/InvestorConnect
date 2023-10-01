<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InvestorPreference extends Model
{
    use HasFactory;

    protected $fillable = [
        'investor_profile_id',
        'preferred_locations',
        'industries',
        'investment_stages',
    ];

    protected $casts = [
        'preferred_locations' => 'array',
        'industries' => 'array',
        'investment_stages' => 'array',
    ];

    // Relationships
    public function investorProfile()
    {
        return $this->belongsTo(InvestorProfile::class);
    }
}
