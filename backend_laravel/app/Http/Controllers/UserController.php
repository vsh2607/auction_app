<?php

namespace App\Http\Controllers;

use App\Models\Bidding;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UserController extends Controller
{

    protected $user;
    public function __construct(){
        $this->middleware(function($request, $next){
            $this->user = auth()->user();
            return $next($request);
        });
    }

    //Menampilkan semua product yang telah di bid user
    //0 : finished, 1 : on progress
    public function getAllBidProducts($productStatus){

        $data = Bidding::with('product')->select('product_id', DB::raw('MAX(bidding_amount) as max_bid_amount'))
    ->where('user_id', $this->user->id)
    ->whereHas('product', function($query) use($productStatus){
        $query->where('product_status', $productStatus);
    })
    ->groupBy('product_id')
    ->get();
        return $this->success($data);
    }



    //show current user profile
    public function show(){
        return $this->success($this->user);
    }

    public function getAllUsers(){
        $users = User::orderBy('name', 'asc')->get();
        return $this->success($users);
    }



}
