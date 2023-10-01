<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Message extends Model
{
    use HasFactory;

    protected $fillable = [
      'sender_id',
      'receiver_id',
      'message',
    ];

    protected $casts = [
        'sender_id' => 'integer',
        'receiver_id' => 'integer',
    ];

    protected $appends = [
        'is_sender',
    ];

    // Relationships
    public function sender()
    {
        return $this->belongsTo(User::class, 'sender_id');
    }

    public function receiver()
    {
        return $this->belongsTo(User::class, 'receiver_id');
    }

    // Attributes
    public function getIsSenderAttribute()
    {
        return $this->sender_id === Auth::user()->id;
    }

    // Methods
    public static function getMessages($other_user_id)
    {
        $messages = Message::where('sender_id', Auth::user()->id)
            ->where('receiver_id', $other_user_id)
            ->orWhere('sender_id', $other_user_id)
            ->where('receiver_id', Auth::user()->id)
            ->get();

        return $messages;
    }
}
