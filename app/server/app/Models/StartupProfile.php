<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StartupProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'company_name',
        'company_logo_url',
        'industries',
        'location',
        'investment_stage',
        'pitch_video_url',
        'company_description',
    ];

    protected $casts = [
        'industries' => 'array',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function startupPreferences()
    {
        return $this->hasOne(StartupPreference::class);
    }
}
