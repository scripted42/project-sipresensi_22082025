<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Announcement extends Model
{
    protected $table = 'announcements';
    
    protected $fillable = [
        'title',
        'content',
        'author_id',
        'is_published',
        'published_at',
    ];
    
    protected $casts = [
        'is_published' => 'boolean',
        'published_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
    
    /**
     * Get the author (user) that owns the announcement.
     */
    public function author()
    {
        return $this->belongsTo(User::class, 'author_id');
    }
}