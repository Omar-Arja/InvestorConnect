<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('investor_profiles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('profile_picture_url');
            $table->string('calendly_link')->nullable();
            $table->string('location');
            $table->text('bio');
            $table->decimal('min_investment_amount', 10, 2);
            $table->decimal('max_investment_amount', 10, 2);
            $table->timestamps();
        });

        Schema::create('investor_preferences', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('investor_profile_id');
            $table->json('preferred_locations');
            $table->json('industries');
            $table->json('investment_stages');
            $table->timestamps();
        });

        // Foreign keys
        Schema::table('investor_profiles', function (Blueprint $table) {
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::table('investor_preferences', function (Blueprint $table) {
            $table->foreign('investor_profile_id')->references('id')->on('investor_profiles')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('investor_preferences');
        Schema::dropIfExists('investor_profiles');
    }
};
