<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('startup_profiles', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('company_name');
            $table->string('company_logo_url');
            $table->json('industries');
            $table->string('location');
            $table->string('investment_stage');
            $table->string('pitch_video_url');
            $table->text('company_description');
            $table->timestamps();
        });

        Schema::create('startup_preferences', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('startup_profile_id');
            $table->json('preferred_locations');
            $table->decimal('min_investment_amount', 10, 2);
            $table->decimal('max_investment_amount', 10, 2);
            $table->timestamps();
        });

        // Foreign keys
        Schema::table('startup_profiles', function (Blueprint $table) {
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
        
        Schema::table('startup_preferences', function (Blueprint $table) {
            $table->foreign('startup_profile_id')->references('id')->on('startup_profiles') ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('startup_preferences');
        Schema::dropIfExists('startup_profiles');
    }
};
