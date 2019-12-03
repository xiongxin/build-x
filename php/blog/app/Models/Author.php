<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * App\Models\Author
 *
 * @property int $id
 * @property string $first_name
 * @property string $last_name
 * @property \Illuminate\Support\Carbon $created_at
 * @property \Illuminate\Support\Carbon $updated_at
 * @property int $deleted_at
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author whereDeletedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author whereFirstName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author whereLastName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Author whereUpdatedAt($value)
 * @mixin \Eloquent
 */
class Author extends Model
{
    //
}
