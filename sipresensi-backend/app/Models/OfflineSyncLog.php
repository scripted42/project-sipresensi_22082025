<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OfflineSyncLog extends Model
{
    protected $table = 'offline_sync_log';
    
    protected $fillable = [
        'user_id',
        'action_type',
        'data',
        'status',
        'error_message'
    ];
    
    protected $casts = [
        'data' => 'array', // Cast JSON data to PHP array
        'synced_at' => 'datetime',
    ];
    
    protected $hidden = [
        'id'
    ];
    
    public $timestamps = true;
    const CREATED_AT = 'synced_at';
    const UPDATED_AT = null;
    
    /**
     * Get the user that owns the sync log.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}