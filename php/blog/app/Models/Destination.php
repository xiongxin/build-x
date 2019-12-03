<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * App\Models\Destination
 *
 * @property int $id
 * @property int|null $last_flight
 * @property string|null $name
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination whereLastFlight($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Destination whereUpdatedAt($value)
 * @mixin \Eloquent
 */
class Destination extends Model
{
    //
}
