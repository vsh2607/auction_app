<?php

namespace App\Http\Controllers;

use App\Models\Bidding;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UserController extends Controller
{

    //Menampilkan semua product yang telah di bid
    //0 : finished, 1 : on progress
    public function getAllBidProducts($userId, $productStatus){

        $bidProducts = Bidding::with('product')->where('user_id', $userId)->whereHas('product', function($query) use($productStatus){
            $query->where('product_status', $productStatus);
        })->groupBy('product_id')->latest('created_at')->get();
        return $this->success($bidProducts);
    }

    public function show(string $id)
    {

    }



}
