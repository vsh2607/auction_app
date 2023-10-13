<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ProductUnitsSeeder extends Seeder
{

    public function run(): void
    {
        DB::table('product_units')->insert([
            'unit_name' => 'kg'
        ]);

        DB::table('product_units')->insert([
            'unit_name' => 'g'
        ]);

        DB::table('product_units')->insert([
            'unit_name' => 'm'
        ]);

        DB::table('product_units')->insert([
            'unit_name' => 'buah'
        ]);

        DB::table('product_units')->insert([
            'unit_name' => 'ton'
        ]);

        DB::table('product_units')->insert([
            'unit_name' => 'kuintal'
        ]);



    }
}
