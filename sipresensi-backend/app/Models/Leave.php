<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Leave extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'leaves';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id',
        'leave_type',
        'start_date',
        'end_date',
        'reason',
        'attachment_path',
        'status',
        'approved_by',
        'approval_comment',
        'approved_at',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
        'approved_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Get the user who requested the leave.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the user who approved the leave.
     */
    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }
}