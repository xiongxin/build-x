<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class Phone extends Model
{
    protected $guarded = [
    ];

    /**
     * Get the user that owns the phone.
     */
    public function user() {
        return $this->belongsTo(
            User::class,
            'user_id',
            'id'
        );
    }
}
