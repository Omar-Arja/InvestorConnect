<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('matched_profiles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('investor_profile_id');
            $table->unsignedBigInteger('startup_profile_id');
            $table->timestamps();
        });

        Schema::create('messages', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('sender_id');
            $table->unsignedBigInteger('receiver_id');
            $table->text('message');
            $table->timestamps();
        });

        // Foreign keys
        Schema::table('matched_profiles', function (Blueprint $table) {
            $table->foreign('investor_profile_id')->references('id')->on('investor_profiles')->onDelete('cascade');
            $table->foreign('startup_profile_id')->references('id')->on('startup_profiles')->onDelete('cascade');
        });

        Schema::table('messages', function (Blueprint $table) {
            $table->foreign('sender_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('receiver_id')->references('id')->on('users')->onDelete('cascade');
        });
        
    }

    public function down(): void
    {
        Schema::dropIfExists('messages');
        Schema::dropIfExists('matched_profiles');
    }
};
