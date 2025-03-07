<?php

namespace Modules\Auth\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Modules\Auth\Models\User;

class AuthController extends Controller
{
    //Enregistrer un user
    public function register(Request $request){

        //valider les champs
        $champs = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6|confirmed'
        ]);

        //créer un user
        $user = User::create([
            'name' => $champs['name'],
            'email' => $champs['email'],
            'password' => bcrypt($champs['password'])
        ]);

        //la classe retour "user" et "token" comme reponse
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken
        ],200);
    }

    //Se connecter
    public function login(Request $request){

        //valider les champs
        $champs = $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6'
        ]);

        //tentative de connexion
        if(!Auth::attempt($champs)){
            return response([
                'message' => 'Informations d\'identification non valides'
            ],403);
        }

        $user = auth()->user();
        
        //la classe retour "user" et "token" comme reponse
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken
        ],200);
    }

    //Se deconnecter
    public function logout(){
        auth()->user()->tokens()->delete();
        return response([
            'message' => 'Déconnexion réussie'
        ],200);
    }

    //Afficher le profil utilisateur
    public function user(){
        return response([
            'user' => auth()->user()
        ],200);
    }
}
