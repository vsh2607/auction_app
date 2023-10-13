<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request){

        $isValid = $this->isValidChecker($request);



        if(!$isValid['success']){
            return $this->error($isValid['message'], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $user = $isValid['user'];
        $token = $user->createToken(User::USER_TOKEN);

        return $this->success([
            'user' => $user,
            'token' => $token->plainTextToken
        ], 'Login successfully');
    }

    private function isValidChecker(Request $request){




        $data = $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);


        $user = User::where('email', $data['email'])->first();
        if($user === null){
            return [
                'success' => false,
                'message' => 'Invalid Credentials'
            ];
        }

        if(Hash::check($data["password"], $user->password)){
            return [
                'success' => true,
                'user' => $user
            ];
        }

        return [
            'success' => false,
            'message' => 'Invalid Credentials'
        ];


    }


    public function register(Request $request){

        $data = $request->validate([
            'email' => 'required|unique:users|email',
            'password' => 'required|confirmed',
            'no_telp' => 'required',
            'name' => 'required'
        ]);

        $data["password"] = Hash::make($data["password"]);
        $user = User::create($data);
        $token = $user->createToken(User::USER_TOKEN);

        return $this->success(['user' => $user, 'token' => $token->plainTextToken], 'User has been registered successfully');
    }

    public function loginWithToken(){
        return $this->success(auth()->user(),'Login successfully!');
    }

    public function logout(Request $request){
        $request->user()->currentAccessToken()->delete();
        return $this->success(null, "Logout successfully");
    }
}
