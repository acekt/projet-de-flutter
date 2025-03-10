<?php

use Illuminate\Support\Facades\Route;
use Modules\Like\Http\Controllers\LikeController;

/*
 *--------------------------------------------------------------------------
 * API Routes
 *--------------------------------------------------------------------------
 *
 * Here is where you can register API routes for your application. These
 * routes are loaded by the RouteServiceProvider within a group which
 * is assigned the "api" middleware group. Enjoy building your API!
 *
*/

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/posts/{postId}/like', [LikeController::class, 'toggleLike']);
});
