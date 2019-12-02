<?php


namespace App\Http\Controllers;


use App\Models\Comment;
use App\Models\Destination;
use App\Models\Flight;
use App\Models\Post;
use App\Models\Role;
use App\Models\Supplier;
use App\User;

class DemoController
{


    public function index() {

//        $comments = Post::find(1)->comments;
//        dump($comments->toJson());
//
//        $post = Comment::find(1)->post;
//        dump($post->toJson());
//
//        dump(User::find(1)->roles()->orderBy('id', 'DESC')->get()->toArray());
//
//
//        dump(Role::find(1)->users->toArray());

        dump(Supplier::find(1)->userHistory->toArray());

        dump(Supplier::find(1)->userPosts->toArray());
        return '0';
    }
}
