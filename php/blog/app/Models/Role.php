<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    /**
     * The users that belong to the role.
     */
    public function users() {
        return $this->belongsToMany(
            User::class,
            null,
            'roles_id',
            'user_id',
            null,
            null
        );
    }
}
