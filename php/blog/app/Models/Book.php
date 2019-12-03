<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * App\Models\Book
 *
 * @property int $id
 * @property int $author_id
 * @property int $title
 * @property \Illuminate\Support\Carbon $created_at
 * @property \Illuminate\Support\Carbon $updated_at
 * @property string $deleted_at
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book whereAuthorId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book whereDeletedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book whereTitle($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Book whereUpdatedAt($value)
 * @mixin \Eloquent
 * @property-read \App\Models\Author $author
 */
class Book extends Model
{
    /**
     * Get Book's author
     */
    public function author() {
        return $this->belongsTo(Author::class);
    }
}
