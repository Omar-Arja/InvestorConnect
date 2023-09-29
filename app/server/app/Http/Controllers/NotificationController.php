<?php

namespace App\Http\Controllers;

use GuzzleHttp\Client;

use Illuminate\Http\Request;
use Kreait\Firebase\Messaging\Notification;
use Kreait\Firebase\Messaging\CloudMessage;
use App\Models\User;


class NotificationController extends Controller
{
    public static function sendMatchNotification($user1_id, $user2_id) {
        $fcm_url = 'https://fcm.googleapis.com/fcm/send';

        $user1 = User::find($user1_id);
        $user2 = User::find($user2_id);
        
        $user1_tokens = $user1->deviceTokens->pluck('token')->toArray();
        $user2_tokens = $user2->deviceTokens->pluck('token')->toArray();

        $user1_notification = [
            'title' => 'You have a new match!',
            'body' => 'You have matched with ' . $user2->name . '!',
            'priority' => 'high',
            'notification_priority' => 'max',
        ];

        $user2_notification = [
            'title' => 'You have a new match!',
            'body' => 'You have matched with ' . $user1->name . '!',
            'priority' => 'high',
            'notification_priority' => 'max',
        ];
        
        $client = new Client();

        foreach($user1_tokens as $token) {
            $data = [
                'notification' => $user1_notification,
                'to' => $token,
            ];

            $response = $client->post('https://fcm.googleapis.com/fcm/send', [
                'headers' => [
                    'Authorization' => 'key=' . env('FIREBASE_SERVER_KEY'),
                    'Content-Type' => 'application/json',
                ],
                'json' => $data,
            ]);

            $responseContent = $response->getBody()->getContents();
        }

        foreach($user2_tokens as $token) {
            $data = [
                'notification' => $user2_notification,
                'to' => $token,
            ];

            $response = $client->post('https://fcm.googleapis.com/fcm/send', [
                'headers' => [
                    'Authorization' => 'key=' . env('FIREBASE_SERVER_KEY'),
                    'Content-Type' => 'application/json',
                ],
                'json' => $data,
            ]);

            $responseContent = $response->getBody()->getContents();
        }
        
    }
}
