<?php

namespace App\Models;

use Laravel\Sanctum\PersonalAccessToken as SanctumPersonalAccessToken;

class PersonalAccessToken extends SanctumPersonalAccessToken
{
    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'abilities' => 'json',
        'last_used_at' => 'datetime',
        'last_activity_at' => 'datetime',
        'expires_at' => 'datetime',
    ];

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'token',
        'abilities',
        'last_used_at',
        'last_activity_at',
        'expires_at',
    ];
}