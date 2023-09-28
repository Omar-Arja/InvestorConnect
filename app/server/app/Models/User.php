<?php

namespace App\Models;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'google_id',
        'usertype_id',
        'email',
        'password',
    ];

    protected $hidden = [
        'usertype_id',
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    protected $appends = [
        'usertype_name',
    ];

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    // Relationships
    public function usertype()
    {
        return $this->belongsTo(Usertype::class);
    }

    public function startupProfile()
    {
        return $this->hasOne(StartupProfile::class);
    }

    public function investorProfile()
    {
        return $this->hasOne(InvestorProfile::class);
    }

    public function matchedProfiles()
    {
        return $this->hasMany(MatchedProfile::class);
    }

    public function receivedMessages()
    {
        return $this->hasMany(Message::class, 'receiver_id');
    }

    public function sentMessages()
    {
        return $this->hasMany(Message::class, 'sender_id');
    }

    public function swipes()
    {
        return $this->hasMany(Swipe::class, 'swiper_id');
    }

    public function swiped()
    {
        return $this->hasMany(Swipe::class, 'swiped_id');
    }

    public function deviceTokens()
    {
        return $this->hasMany(DeviceToken::class);
    }
    
    // Attributes
    public function getUsertypeNameAttribute()
    {
        return $this->usertype->name;
    }
}