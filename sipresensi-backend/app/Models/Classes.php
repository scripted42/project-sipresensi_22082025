<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Classes extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'classes';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'homeroom_teacher_id',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'homeroom_teacher_id' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Get the homeroom teacher for the class.
     */
    public function homeroomTeacher()
    {
        return $this->belongsTo(User::class, 'homeroom_teacher_id');
    }

    /**
     * Get the students for the class.
     */
    public function students()
    {
        return $this->belongsToMany(User::class, 'student_class', 'class_id', 'student_id');
    }
}