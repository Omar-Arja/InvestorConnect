<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class Swipe extends Model
{
    use HasFactory;

    protected $fillable = [
        'swiper_id',
        'swiped_id',
        'direction',
    ];

    // Relationships
    public function swiper()
    {
        return $this->belongsTo(User::class, 'swiper_id');
    }

    public function swiped()
    {
        return $this->belongsTo(User::class, 'swiped_id');
    }

    // Methods
    public static function getMatches()
    {
        $matches = Swipe::where('swiped_id', Auth::id())
            ->where('direction', 'right')
            ->get();

        return $matches;
    }

    public static function getSwipedRight()
    {
        $swiped_right = Swipe::where('swiper_id', Auth::id())
            ->where('direction', 'right')
            ->get();

        return $swiped_right;
    }
}
