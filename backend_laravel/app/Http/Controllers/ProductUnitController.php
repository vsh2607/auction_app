<?php

namespace App\Http\Controllers;

use App\Models\ProductUnit;
use Illuminate\Http\Request;

class ProductUnitController extends Controller
{

    public function index()
    {
        $productUnits = ProductUnit::orderBy('unit_name', 'asc')->get();
        return $this->success($productUnits);
    }


}
