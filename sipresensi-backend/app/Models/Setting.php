<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    protected $table = 'settings';
    
    protected $fillable = [
        'key_name',
        'value',
        'description'
    ];
    
    protected $hidden = [
        'id',
        'created_at'
    ];
    
    public $timestamps = true;
    const UPDATED_AT = 'updated_at';
    const CREATED_AT = null;
}