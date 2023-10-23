<?php

namespace App\Http\Controllers;

use App\Models\Bidding;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class BiddingController extends Controller
{

    public function index()
    {

    }


    public function store(Request $request)
    {
        $data = $request->validate([
            'product_id' => [ 'required', Rule::exists('products', 'id')],
            'user_id' => ['required', Rule::exists('users', 'id')],
            'bidding_amount' => 'required|numeric'
        ]);

        $product = Product::where('id', $data['product_id'])->first();

        //Bid gagal karena bid price < current price
        if($product->product_current_price >= (int)$data['bidding_amount']){
            return $this->success(null, "Harga tawaran harus lebih dari ".$product->product_current_price);
        }

        //Bid Sukses
        Bidding::create($data);
        $product->update(['product_current_price' => (int)$data['bidding_amount']]);
        return $this->success($data, "Tawaran telah ditambahkan");

    }

    public function getBiddersByProductId(int $productId){
        $bidders = Bidding::with(['user'])->select('product_id', 'user_id', DB::raw('MAX(bidding_amount) as max_bidding_amount'))->where('product_id', $productId)->groupBy('user_id')->get();
        return $this->success($bidders);
    }


    public function show(Bidding $bidding)
    {

    }


}
