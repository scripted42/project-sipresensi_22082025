<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'nisn_nip_nik',
        'name',
        'email',
        'phone',
        'password',
        'role_id',
        'photo_path',
        'is_active',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_active' => 'boolean',
            'created_at' => 'datetime',
            'updated_at' => 'datetime',
        ];
    }
    
    /**
     * Get the classes for the student.
     */
    public function classes()
    {
        return $this->belongsToMany(Classes::class, 'student_class', 'student_id', 'class_id');
    }
    
    /**
     * Get the student class records.
     */
    public function studentClasses()
    {
        return $this->hasMany(StudentClass::class, 'student_id');
    }
    
    /**
     * Get the role for the user.
     */
    public function role()
    {
        return $this->belongsTo(Role::class);
    }
    
    /**
     * Get the classes taught by the teacher.
     */
    public function taughtClasses()
    {
        return $this->hasMany(Classes::class, 'homeroom_teacher_id');
    }
    
    /**
     * Get the attendance records for the user.
     */
    public function attendance()
    {
        return $this->hasMany(Attendance::class);
    }
    
    /**
     * Get the leave requests for the user.
     */
    public function leaves()
    {
        return $this->hasMany(Leave::class);
    }
    
    /**
     * Get the announcements created by the user (for kepala sekolah and admin).
     */
    public function announcements()
    {
        return $this->hasMany(Announcement::class, 'author_id');
    }
}