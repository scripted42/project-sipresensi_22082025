<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StudentClass extends Model
{
    protected $table = 'student_class';
    
    protected $fillable = [
        'student_id',
        'class_id',
        'academic_year',
    ];
    
    protected $casts = [
        'academic_year' => 'integer',
        'created_at' => 'datetime',
    ];
    
    public $timestamps = true;
    const UPDATED_AT = null;
    
    /**
     * Get the student for the class assignment.
     */
    public function student()
    {
        return $this->belongsTo(User::class, 'student_id');
    }
    
    /**
     * Get the class for the student assignment.
     */
    public function class()
    {
        return $this->belongsTo(Classes::class, 'class_id');
    }
}