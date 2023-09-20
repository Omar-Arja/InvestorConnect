<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserTypesTableSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('usertypes')->insert([
            'name' => 'pending',
            'name' => 'admin',
            'name' => 'investor',
            'name' => 'startup',
        ]);
    }
}
