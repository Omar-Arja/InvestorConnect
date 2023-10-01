<?php

namespace Database\Seeders;
use Illuminate\Database\Seeder;
use Database\Seeders\UsertypesTableSeeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            UsertypesTableSeeder::class,
        ]);
    }
}
