<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\InvestorController;
use App\Http\Controllers\StartupController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\SwipeController;
use App\Http\Controllers\NotificationController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::prefix('/auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);
});

Route::middleware('auth.api')->group(function () {

    Route::prefix('/investor')->group(function () {
        Route::post('/create-profile', [InvestorController::class, 'createProfile']);
        Route::get('/profile', [InvestorController::class, 'getProfile']);
        Route::post('/update-profile', [InvestorController::class, 'updateProfile']);
        Route::delete('/profile', [InvestorController::class, 'deleteProfile']);
    });

    Route::prefix('/startup')->group(function () {
        Route::post('/create-profile', [StartupController::class, 'createProfile']);
        Route::get('/profile', [StartupController::class, 'getProfile']);
        Route::post('/update-profile', [StartupController::class, 'updateProfile']);
        Route::delete('/profile', [StartupController::class, 'deleteProfile']);
    });

    Route::prefix('/profile')->group(function () {
        Route::get('/get', [ProfileController::class, 'getProfile']);
    });

    Route::prefix('/messages')->group(function () {
        Route::post('/send', [MessageController::class, 'sendMessage']);
        Route::get('/all', [MessageController::class, 'getMatchedProfilesWithMessages']);
    });

    Route::prefix('/swipe')->group(function () {
        Route::post('/right', [SwipeController::class, 'swipeRight']);
        Route::post('/left', [SwipeController::class, 'swipeLeft']);
        Route::get('/all', [SwipeController::class, 'getPotentialMatches']);
    });

    Route::prefix('/notifications')->group(function () {
        Route::get('/all', [NotificationController::class, 'getNotifications']);
    });

});
