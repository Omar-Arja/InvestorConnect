<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Notification extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'body',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Methods
    public static function sendNotification($title, $body, $user_id = null)
    {
        if (!$user_id) {
            $user_id = Auth::id();
        }

        $notification = Notification::create([
            'user_id' => $user_id,
            'title' => $title,
            'body' => $body,
        ]);
    }
}
