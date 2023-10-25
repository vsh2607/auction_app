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
    public function getAllBidProducts(){

        $data = Bidding::with('product')->select('product_id', DB::raw('MAX(bidding_amount) as max_bid_amount'))
    ->where('user_id', $this->user->id)
    ->groupBy('product_id')
    ->get();
        return $this->success($data);
    }





    //show current user profile
    public function show(){
        return $this->success($this->user);
    }

    public function getUserById($userId){
        $user = User::where('id', $userId)->first();
        return $this->success($user);
    }

    public function getAllUsers(){
        $users = User::orderBy('name', 'asc')->where('type', 'user')->get();
        return $this->success($users);
    }



}
