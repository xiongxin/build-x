<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

/**
 * App\Models\Phone
 *
 * @property int $id
 * @property string|null $phone_number
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property int|null $deleted_at
 * @property int|null $user_id
 * @property-read \App\User|null $user
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone whereDeletedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone wherePhoneNumber($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone whereUpdatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Phone whereUserId($value)
 * @mixin \Eloquent
 */
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
