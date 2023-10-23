<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'name' => 'Valentino Sas Henry',
            'email' => 'evolutionvalen@gmail.com',
            'no_telp' => '08112643522',
            'password' => Hash::make('12345678'),
            'type' => 'user'
            
        ]);
        
        User::create([
            'name' => 'admin',
            'email' => 'admin@gmail.com',
            'no_telp' => '08112643522',
            'password' => Hash::make('admin123'),
            'type' => 'admin'

        ]);
    }
}
