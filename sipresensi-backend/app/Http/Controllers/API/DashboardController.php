<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Attendance;
use App\Models\Leave;
use App\Models\Announcement;
use App\Models\Classes;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Get dashboard data based on user role
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            $user = Auth::user();
            
            switch ($user->role_id) {
                case 1: // Siswa
                    return $this->getStudentDashboard($user);
                case 2: // Guru
                    return $this->getTeacherDashboard($user);
                case 3: // Pegawai
                    return $this->getStaffDashboard($user);
                case 4: // Kepala Sekolah
                    return $this->getPrincipalDashboard($user);
                case 5: // Admin
                    return $this->getAdminDashboard($user);
                default:
                    return response()->json([
                        'success' => false,
                        'message' => 'Peran pengguna tidak dikenali'
                    ], 400);
            }
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data dashboard: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get dashboard data for student
     *
     * @param  User  $user
     * @return \Illuminate\Http\JsonResponse
     */
    private function getStudentDashboard($user)
    {
        // Get today's attendance status
        $today = Carbon::today();
        $attendance = Attendance::where('user_id', $user->id)
            ->whereDate('timestamp', $today)
            ->where('type', 'checkin')
            ->first();
            
        // Get recent leaves
        $recentLeaves = Leave::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();
            
        // Get recent announcements
        $recentAnnouncements = Announcement::where('is_published', true)
            ->where('published_at', '<=', now())
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user,
                'attendance_status' => $attendance ? $attendance->status : 'belum_absen',
                'recent_leaves' => $recentLeaves,
                'recent_announcements' => $recentAnnouncements
            ]
        ], 200);
    }

    /**
     * Get dashboard data for teacher
     *
     * @param  User  $user
     * @return \Illuminate\Http\JsonResponse
     */
    private function getTeacherDashboard($user)
    {
        // Get today's attendance statistics for teacher's classes
        $today = Carbon::today();
        
        // Get classes taught by this teacher
        $classes = Classes::where('homeroom_teacher_id', $user->id)->get();
        $classIds = $classes->pluck('id')->toArray();
        
        // Get attendance statistics
        $totalStudents = 0;
        $presentStudents = 0;
        $lateStudents = 0;
        $absentStudents = 0;
        
        if (!empty($classIds)) {
            // Get all students in teacher's classes
            $students = User::where('role_id', 1) // Siswa
                ->whereHas('classes', function ($query) use ($classIds) {
                    $query->whereIn('class_id', $classIds);
                })
                ->get();
                
            $totalStudents = $students->count();
            
            // Count attendance status
            foreach ($students as $student) {
                $attendance = Attendance::where('user_id', $student->id)
                    ->whereDate('timestamp', $today)
                    ->where('type', 'checkin')
                    ->first();
                    
                if ($attendance) {
                    if ($attendance->status == 'hadir') {
                        $presentStudents++;
                    } elseif ($attendance->status == 'terlambat') {
                        $lateStudents++;
                    }
                } else {
                    $absentStudents++;
                }
            }
        }
        
        // Get recent leaves (for teacher's students)
        $studentIds = [];
        if (!empty($classIds)) {
            $studentIds = User::where('role_id', 1)
                ->whereHas('classes', function ($query) use ($classIds) {
                    $query->whereIn('class_id', $classIds);
                })
                ->pluck('id')
                ->toArray();
        }
        
        $recentLeaves = Leave::whereIn('user_id', $studentIds)
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();
            
        // Get recent announcements
        $recentAnnouncements = Announcement::where('is_published', true)
            ->where('published_at', '<=', now())
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user,
                'classes' => $classes,
                'attendance_statistics' => [
                    'total_students' => $totalStudents,
                    'present' => $presentStudents,
                    'late' => $lateStudents,
                    'absent' => $absentStudents
                ],
                'recent_leaves' => $recentLeaves,
                'recent_announcements' => $recentAnnouncements
            ]
        ], 200);
    }

    /**
     * Get dashboard data for staff
     *
     * @param  User  $user
     * @return \Illuminate\Http\JsonResponse
     */
    private function getStaffDashboard($user)
    {
        // Get today's attendance status
        $today = Carbon::today();
        $attendance = Attendance::where('user_id', $user->id)
            ->whereDate('timestamp', $today)
            ->where('type', 'checkin')
            ->first();
            
        // Get recent leaves
        $recentLeaves = Leave::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();
            
        // Get recent announcements
        $recentAnnouncements = Announcement::where('is_published', true)
            ->where('published_at', '<=', now())
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user,
                'attendance_status' => $attendance ? $attendance->status : 'belum_absen',
                'recent_leaves' => $recentLeaves,
                'recent_announcements' => $recentAnnouncements
            ]
        ], 200);
    }

    /**
     * Get dashboard data for principal
     *
     * @param  User  $user
     * @return \Illuminate\Http\JsonResponse
     */
    private function getPrincipalDashboard($user)
    {
        // Get today's overall attendance statistics
        $today = Carbon::today();
        
        // Get total users by role
        $totalStudents = User::where('role_id', 1)->count();
        $totalTeachers = User::where('role_id', 2)->count();
        $totalStaff = User::where('role_id', 3)->count();
        
        // Get today's attendance statistics
        $studentAttendances = Attendance::whereHas('user', function ($query) {
                $query->where('role_id', 1);
            })
            ->whereDate('timestamp', $today)
            ->where('type', 'checkin')
            ->get();
            
        $teacherAttendances = Attendance::whereHas('user', function ($query) {
                $query->where('role_id', 2);
            })
            ->whereDate('timestamp', $today)
            ->where('type', 'checkin')
            ->get();
            
        $presentStudents = $studentAttendances->where('status', 'hadir')->count();
        $lateStudents = $studentAttendances->where('status', 'terlambat')->count();
        $presentTeachers = $teacherAttendances->where('status', 'hadir')->count();
        $lateTeachers = $teacherAttendances->where('status', 'terlambat')->count();
        
        // Get pending leaves
        $pendingLeaves = Leave::where('status', 'menunggu')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();
            
        // Get recent announcements
        $recentAnnouncements = Announcement::where('is_published', true)
            ->where('published_at', '<=', now())
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user,
                'user_statistics' => [
                    'total_students' => $totalStudents,
                    'total_teachers' => $totalTeachers,
                    'total_staff' => $totalStaff
                ],
                'attendance_statistics' => [
                    'students' => [
                        'present' => $presentStudents,
                        'late' => $lateStudents,
                        'total' => $totalStudents
                    ],
                    'teachers' => [
                        'present' => $presentTeachers,
                        'late' => $lateTeachers,
                        'total' => $totalTeachers
                    ]
                ],
                'pending_leaves' => $pendingLeaves,
                'recent_announcements' => $recentAnnouncements
            ]
        ], 200);
    }

    /**
     * Get dashboard data for admin
     *
     * @param  User  $user
     * @return \Illuminate\Http\JsonResponse
     */
    private function getAdminDashboard($user)
    {
        // Get system statistics
        $totalUsers = User::count();
        $totalStudents = User::where('role_id', 1)->count();
        $totalTeachers = User::where('role_id', 2)->count();
        $totalStaff = User::where('role_id', 3)->count();
        $totalClasses = Classes::count();
        
        // Get today's attendance statistics
        $today = Carbon::today();
        $presentStudents = Attendance::whereHas('user', function ($query) {
                $query->where('role_id', 1);
            })
            ->whereDate('timestamp', $today)
            ->where('type', 'checkin')
            ->where('status', 'hadir')
            ->count();
            
        $presentTeachers = Attendance::whereHas('user', function ($query) {
                $query->where('role_id', 2);
            })
            ->whereDate('timestamp', $today)
            ->where('type', 'checkin')
            ->where('status', 'hadir')
            ->count();
            
        // Get pending leaves
        $pendingLeaves = Leave::where('status', 'menunggu')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();
            
        // Get recent announcements
        $recentAnnouncements = Announcement::where('is_published', true)
            ->where('published_at', '<=', now())
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user,
                'system_statistics' => [
                    'total_users' => $totalUsers,
                    'total_students' => $totalStudents,
                    'total_teachers' => $totalTeachers,
                    'total_staff' => $totalStaff,
                    'total_classes' => $totalClasses
                ],
                'attendance_statistics' => [
                    'present_students' => $presentStudents,
                    'present_teachers' => $presentTeachers
                ],
                'pending_leaves' => $pendingLeaves,
                'recent_announcements' => $recentAnnouncements
            ]
        ], 200);
    }
}