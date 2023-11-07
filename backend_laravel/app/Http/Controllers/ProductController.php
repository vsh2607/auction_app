<?php

namespace App\Http\Controllers;

use App\Events\ProductAdded;
use App\Events\TimesUp;
use App\Models\Bidding;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class ProductController extends Controller
{

    public function store(Request $request) {
        $data = $request->validate([
            'product_img_path' => 'image|mimes:png,jpg,jpeg|max:2048',
            'product_name' => 'required|string',
            'product_size' => 'required|numeric',
            'product_unit' => 'required',
            'product_description' => 'required',
            'product_initial_price' => 'required|numeric',
            'product_ddl'=>'required'
        ]);


        if($data["product_img_path"] != null){
            $image = $request->file('product_img_path');
            $imageName = time().'_'.$request->product_name.'.'.$image->getClientOriginalExtension();
            $data['product_img_path'] = $imageName;
            $image->move('storage/product_images', $imageName);
        }

        $productData = [
            'product_img_path' => $data['product_img_path'],
            'product_name' => $data['product_name'],
            'product_size' => $data['product_size'],
            'product_unit' => $data['product_unit'],
            'product_description' => $data['product_description'],
            'product_initial_price' => $data['product_initial_price'],
            'product_current_price' => $data['product_initial_price'],
            'product_ddl'=> $data['product_ddl'],
            'product_status' => 1

        ];
        $product = Product::create($productData);
        $data = $this->success($product, 'Product addedd successfully');
        ProductAdded::dispatch($data);
        return $this->success($product, 'Product added successfully');
    }

    //0 : finished, 1 : on progress
    public function getLatestProducts(int $status){
        $products = Product::where('product_status', $status)->latest()->get();
        return $this->success($products, 'Products fetched successfully');

    }

    public function show(int $productId){
        $product = Product::where('id', $productId)->first();
        return $this->success($product, 'Product fetched successfully');
    }

    public function test(){
        // $products = Product::with(['biddings'])->select('user_id')->where('product_ddl', '<', Carbon::now())->where('product_status', 0)->get();
        $biddings = Bidding::with(['user'])->select('user_id')->whereHas('product', function($query){
            $query->where('product_ddl', '<', Carbon::now())->where('product_status', 0);
        })->get();

        $userId = [];
        foreach($biddings as $bidding){
            $userId[] = $bidding->user_id;
        }

        TimesUp::dispatch(array_values(array_unique($userId)));
    
        return $this->success($biddings);
    }





}
