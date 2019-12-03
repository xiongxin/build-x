<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

/**
 * App\Models\Supplier
 *
 * @property int $id
 * @property string|null $name
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \App\Models\History $userHistory
 * @property-read \Illuminate\Database\Eloquent\Collection|\App\Models\Post[] $userPosts
 * @property-read int|null $user_posts_count
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Supplier newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Supplier newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Supplier query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Supplier whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Supplier whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Supplier whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Supplier whereUpdatedAt($value)
 * @mixin \Eloquent
 */
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
