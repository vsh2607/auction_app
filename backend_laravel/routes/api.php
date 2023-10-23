<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BiddingController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProductUnitController;
use App\Http\Controllers\UserController;
use App\Models\Product;
use App\Models\ProductUnit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::prefix('auth')->group(function(){
    Route::post('login', [AuthController::class, 'login'])->name('login');
    Route::post('register', [AuthController::class, 'register'])->name('register');
    Route::post('login-token', [AuthController::class, 'loginWithToken'])->middleware("auth:sanctum")->name('login-token');
    Route::get('logout', [AuthController::class, 'logout'])->middleware("auth:sanctum")->name('logout');
});

Route::prefix('product')->middleware('auth:sanctum')->group(function(){
    Route::post('add-product', [ProductController::class, 'store'])->name('add-product');
    Route::get('get-products/{status}', [ProductController::class, 'getLatestProducts']);
    Route::get('get-product/{productId}', [ProductController::class, 'show']);
});

Route::prefix('bidding')->middleware('auth:sanctum')->group(function(){
    Route::post('add-bidding', [BiddingController::class, 'store'])->name('add-bidding');
    Route::get('get-bidders-by-productid/{productId}', [BiddingController::class, 'getBiddersByProductId']);
});

Route::prefix('user')->middleware('auth:sanctum')->group(function(){
    Route::get('get-user-bid-products/{productStatus}', [UserController::class, 'getAllBidProducts']);
    Route::get('get-user-profile', [UserController::class, 'show'])->name('get-user-profile');
    Route::get('get-all-users',[UserController::class, 'getAllUsers'])->name('get-all-users');
    Route::get('get-user-by-id/{userId}', [UserController::class, 'getUserById'])->name('get-user-by-id');
});

Route::get('get-product-unit', [ProductUnitController::class, 'index'])->name('get-product_unit');
