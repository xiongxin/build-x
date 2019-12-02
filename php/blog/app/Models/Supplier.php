<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class Supplier extends Model
{
    /**
     * Get the user's history
     */
    public function userHistory() {
        return $this->hasOneThrough(
            History::class,
            User::class
        );
    }

    /**
     * 获取当前供应商下面所有用户的帖子
     */
    public function userPosts() {
        return $this->hasManyThrough(
            Post::class,
            User::class
        );
    }
}
