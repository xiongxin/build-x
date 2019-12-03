<?php

namespace App\Models;

use App\Scopes\UserScope;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * App\Models\Flight
 *
 * @property int $id
 * @property int|null $destination_id
 * @property int|null $arrived_at
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property \Illuminate\Support\Carbon|null $deleted_at
 * @method static bool|null forceDelete()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight newQuery()
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Flight onlyTrashed()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight query()
 * @method static bool|null restore()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight whereArrivedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight whereDeletedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight whereDestinationId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Flight whereUpdatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Flight withTrashed()
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Flight withoutTrashed()
 * @mixin \Eloquent
 */
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
