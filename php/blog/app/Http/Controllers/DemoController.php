<?php


namespace App\Http\Controllers;


use App\Models\Author;
use App\Models\Book;
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

//        dump(Supplier::find(1)->userHistory->toArray());
//
//        dump(Supplier::find(1)->userPosts->toArray());
//        dump(Post::has('comments')->first()->comments()->orderBy('id', 'DESC')->paginate(2)->toArray());

//        dump(Post::doesntHave('comments')->first()->toArray());

//        dump(Post::withCount('comments')->get()->toArray());

//        $books = Book::with('author')->get();
//
//        foreach ($books as $book) {
//            echo $book->author->first_name . '<br />';
//        }

//        $comment = new Comment(['ctitle' => 'abd', 'ccontent'=>'dd']);
//        $comment->save();
//        $post = Post::find(1);

//        $post->comments()->save($comment);

//        $book = Book::find(3);
//        $author = Author::find(3);
//
//        $book->author()->associate($author);
//
//        $book->save();

        $user = User::find(1);

        $user->roles()->toggle([1,2,3]);

        return '0';
    }
}
