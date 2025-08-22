<?php

namespace App\Http\Controllers\API\Dashboard;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Attendance;
use App\Models\Leave;
use App\Models\Announcement;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Get dashboard data based on user role
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        try {
            $user = Auth::user();
            $data = [];
            
            // Get date filter from request, default to today
            $date = $request->query('date', Carbon::today()->toDateString());
            $dateCarbon = Carbon::createFromFormat('Y-m-d', $date)->startOfDay();
            
            switch ($user->role_id) {
                case 1: // Siswa
                    $data = $this->getStudentDashboardData($user, $dateCarbon);
                    break;
                case 2: // Guru
                    $data = $this->getTeacherDashboardData($user, $dateCarbon);
                    break;
                case 3: // Pegawai
                    $data = $this->getStaffDashboardData($user, $dateCarbon);
                    break;
                case 4: // Kepala Sekolah
                    $data = $this->getPrincipalDashboardData($user, $dateCarbon);
                    break;
                case 5: // Admin
                    $data = $this->getAdminDashboardData($user, $dateCarbon);
                    break;
                default:
                    return response()->json([
                        'success' => false,
                        'message' => 'Peran pengguna tidak dikenali'
                    ], 400);
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Data dashboard berhasil diambil',
                'data' => $data
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data dashboard',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Get dashboard data for students
     *
     * @param  User  $user
     * @param  Carbon  $date
     * @return array
     */
    private function getStudentDashboardData(User $user, Carbon $date)
    {
        // Check attendance status for the date
        $attendance = Attendance::where('user_id', $user->id)
            ->whereDate('timestamp', $date)
            ->first();
            
        // Get upcoming leaves
        $upcomingLeaves = Leave::where('user_id', $user->id)
            ->where('start_date', '>=', Carbon::today())
            ->where('status', 'disetujui')
            ->orderBy('start_date')
            ->limit(3)
            ->get();
            
        // Get recent announcements
        $announcements = Announcement::where('is_published', true)
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return [
            'user' => $user->makeHidden(['password']),
            'role' => 'siswa',
            'attendance_status' => $attendance ? $attendance->type : 'belum_absen',
            'upcoming_leaves' => $upcomingLeaves,
            'recent_announcements' => $announcements,
            'date' => $date->toDateString()
        ];
    }
    
    /**
     * Get dashboard data for teachers
     *
     * @param  User  $user
     * @param  Carbon  $date
     * @return array
     */
    private function getTeacherDashboardData(User $user, Carbon $date)
    {
        // Get classes taught by the teacher
        $classes = $user->taughtClasses; // Using the relationship defined in User model
        
        // Get attendance summary for each class
        $classAttendanceSummary = [];
        foreach ($classes as $class) {
            $totalStudents = $class->students()->count(); // Using the relationship defined in Classes model
            $attendedStudents = Attendance::join('users', 'attendance.user_id', '=', 'users.id')
                ->join('student_class', 'users.id', '=', 'student_class.student_id')
                ->where('student_class.class_id', $class->id)
                ->whereDate('attendance.timestamp', $date)
                ->where('attendance.type', 'checkin')
                ->count();
                
            $classAttendanceSummary[] = [
                'class_id' => $class->id,
                'class_name' => $class->name,
                'total_students' => $totalStudents,
                'attended_students' => $attendedStudents,
                'absent_students' => $totalStudents - $attendedStudents
            ];
        }
        
        // Get recent announcements
        $announcements = Announcement::where('is_published', true)
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return [
            'user' => $user->makeHidden(['password']),
            'role' => 'guru',
            'classes' => $classes,
            'class_attendance_summary' => $classAttendanceSummary,
            'recent_announcements' => $announcements,
            'date' => $date->toDateString()
        ];
    }
    
    /**
     * Get dashboard data for staff
     *
     * @param  User  $user
     * @param  Carbon  $date
     * @return array
     */
    private function getStaffDashboardData(User $user, Carbon $date)
    {
        // Check attendance status for the date
        $attendance = Attendance::where('user_id', $user->id)
            ->whereDate('timestamp', $date)
            ->first();
            
        // Get upcoming leaves
        $upcomingLeaves = Leave::where('user_id', $user->id)
            ->where('start_date', '>=', Carbon::today())
            ->where('status', 'disetujui')
            ->orderBy('start_date')
            ->limit(3)
            ->get();
            
        // Get recent announcements
        $announcements = Announcement::where('is_published', true)
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return [
            'user' => $user->makeHidden(['password']),
            'role' => 'pegawai',
            'attendance_status' => $attendance ? $attendance->type : 'belum_absen',
            'upcoming_leaves' => $upcomingLeaves,
            'recent_announcements' => $announcements,
            'date' => $date->toDateString()
        ];
    }
    
    /**
     * Get dashboard data for principal
     *
     * @param  User  $user
     * @param  Carbon  $date
     * @return array
     */
    private function getPrincipalDashboardData(User $user, Carbon $date)
    {
        // Get overall attendance statistics
        $totalUsers = User::where('is_active', true)->count();
        $attendedUsers = Attendance::whereDate('timestamp', $date)
            ->where('type', 'checkin')
            ->distinct('user_id')
            ->count('user_id');
            
        // Get pending leaves
        $pendingLeaves = Leave::where('status', 'menunggu')
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();
            
        // Get recent announcements
        $announcements = Announcement::where('is_published', true)
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return [
            'user' => $user->makeHidden(['password']),
            'role' => 'kepala_sekolah',
            'attendance_rate' => $totalUsers > 0 ? ($attendedUsers / $totalUsers) * 100 : 0,
            'pending_leaves' => $pendingLeaves,
            'recent_announcements' => $announcements,
            'date' => $date->toDateString()
        ];
    }
    
    /**
     * Get dashboard data for admin
     *
     * @param  User  $user
     * @param  Carbon  $date
     * @return array
     */
    private function getAdminDashboardData(User $user, Carbon $date)
    {
        // Get user statistics
        $totalUsers = User::count();
        $activeUsers = User::where('is_active', true)->count();
        
        // Get recent activities (this is a simplified example)
        // In a real application, you might have an activity log table
        $recentActivities = [
            // Example activities
            // ['type' => 'user_created', 'description' => 'User baru ditambahkan', 'timestamp' => Carbon::now()->subHour(1)],
            // ['type' => 'announcement_published', 'description' => 'Pengumuman baru diterbitkan', 'timestamp' => Carbon::now()->subHours(2)]
        ];
        
        // Get recent announcements
        $announcements = Announcement::where('is_published', true)
            ->orderBy('published_at', 'desc')
            ->limit(5)
            ->get();
            
        return [
            'user' => $user->makeHidden(['password']),
            'role' => 'admin',
            'total_users' => $totalUsers,
            'active_users' => $activeUsers,
            'recent_activities' => $recentActivities,
            'recent_announcements' => $announcements,
            'date' => $date->toDateString()
        ];
    }
}