<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests, DispatchesJobs;

    public function success(mixed $data, string $message = "success", int $statusCode = 200){
        return response()->json([
            'data' => $data,
            'success' => true,
            'message' => $message
        ], $statusCode);
    }


    public function error(string $message, int $statusCode = 400){
        return response()->json([
            'data' => null,
            'success' => false,
            'message' => $message
        ], $statusCode);
    }
}
