<?php


namespace App\Scopes;


use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Scope;
use Illuminate\Support\Facades\Auth;

class UserScope implements Scope
{

    /**
     * 全局作用域获取当前用户数据
     *
     * @inheritDoc
     */
    public function apply(Builder $builder, Model $model)
    {
        $user = 1;//Auth::user();

        if (!is_null($user)) {
            $builder->where('user_id', $user->id);
        }

    }
}
