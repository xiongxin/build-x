<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    /**
     * Get the comments for the blog post.
     */
    public function comments() {
        return $this->hasMany(Comment::class, 'post_id', 'id');
    }
}
