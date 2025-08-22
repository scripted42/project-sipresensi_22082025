<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\DynamicQRToken;

class DynamicQRTokenSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Membuat beberapa token QR dinamis untuk pengujian
        DynamicQRToken::factory()->count(5)->create();
        
        // Membuat beberapa token yang sudah digunakan
        DynamicQRToken::factory()->used()->count(3)->create();
        
        // Membuat beberapa token yang sudah kadaluarsa
        DynamicQRToken::factory()->expired()->count(2)->create();
    }
}