<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StartupPreference extends Model
{
    use HasFactory;

    protected $fillable = [
        'startup_profile_id',
        'preferred_locations',
        'min_investment_amount',
        'max_investment_amount',
    ];

    protected $casts = [
        'preferred_locations' => 'array',
    ];

    // Relationships
    public function startupProfile()
    {
        return $this->belongsTo(StartupProfile::class);
    }
}
