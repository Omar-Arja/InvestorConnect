<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UsertypesTableSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('usertypes')->insert([
            ['name' => 'admin'],
            ['name' => 'investor'],
            ['name' => 'startup'],
            ['name' => 'pending'],
        ]);
    }
}
