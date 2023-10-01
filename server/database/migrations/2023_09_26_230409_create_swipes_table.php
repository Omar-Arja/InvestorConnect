<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('swipes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('swiper_id');
            $table->unsignedBigInteger('swiped_id');
            $table->enum('direction', ['left', 'right']);
            $table->timestamps();
        });

        Schema::create('matched_profiles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('investor_profile_id');
            $table->unsignedBigInteger('startup_profile_id');
            $table->timestamps();
        });

        // Foreign keys
        Schema::table('swipes', function (Blueprint $table) {
            $table->foreign('swiper_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('swiped_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::table('matched_profiles', function (Blueprint $table) {
            $table->foreign('investor_profile_id')->references('id')->on('investor_profiles')->onDelete('cascade');
            $table->foreign('startup_profile_id')->references('id')->on('startup_profiles')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('swipes');
        Schema::dropIfExists('matched_profiles');
    }
};
