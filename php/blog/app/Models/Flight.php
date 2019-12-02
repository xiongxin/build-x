<?php

namespace App\Models;

use App\Scopes\UserScope;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Flight extends Model
{


    protected static function boot()
    {
        parent::boot();

        static::addGlobalScope(new UserScope());
    }

    use SoftDeletes;

    protected $guarded = [
//        'arrived_at',
//        'destination_id'
    ];
}
