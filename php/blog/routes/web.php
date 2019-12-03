<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

use \App\Http\Resources\User as UserResource;
use \App\Http\Resources\UserCollection;
use \App\Http\Resources\PostCollection;
use \App\User;


Route::get('/', function () {
    //dd(app('redis.connection'));

    return view('welcome');
});

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');
Route::get('/demo', 'DemoController@index');//->middleware(['auth', 'password.confirm']);
Route::get('/users', function () {
    return UserResource::collection(User::with('posts')->get());
//    return new UserCollection(User::with('roles')->orderBy('id', 'desc')->paginate(1));
});

Route::get('/user/{id}', function (int $id) {
//    dump(User::find($id)->posts);
    return new PostCollection(User::find($id)->posts()->paginate(20));
});
