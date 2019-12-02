<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    /**
     * Get the post for the comment
     */
    public function post() {
        return $this->belongsTo(Post::class,'post_id', 'id');
    }
}
