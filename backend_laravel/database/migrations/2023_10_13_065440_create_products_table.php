<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('product_img_path')->nullable();
            $table->string('product_name');
            $table->integer('product_size');
            $table->string('product_unit');
            $table->string('product_description');
            $table->integer('product_status');
            $table->integer('product_initial_price');
            $table->integer('product_current_price');
            $table->datetime('product_ddl');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
