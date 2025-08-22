<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Attendance;
use App\Models\StudentQrCard;
use App\Models\Classes;
use App\Models\StudentClass;
use Carbon\Carbon;

class StudentAttendanceController extends Controller
{
    /**
     * Scan student QR card or use NISN/NIP/NIK for attendance (optimized for speed)
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function scanStudentQR(Request $request)
    {
        try {
            // Validasi input - 'qr_code' dan 'nisn_nip_nik' sekarang opsional, tapi salah satu harus ada
            $validator = Validator::make($request->all(), [
                // 'qr_code' sekarang opsional
                'qr_code' => 'nullable|string', 
                'class_id' => 'required|exists:classes,id',
                'latitude' => 'required|numeric',
                'longitude' => 'required|numeric',
                'accuracy' => 'nullable|numeric|min:0',
                // Tambahkan 'nisn_nip_nik' sebagai input opsional
                'nisn_nip_nik' => 'nullable|string|exists:users,nisn_nip_nik',
            ], [
                // Pesan error kustom untuk validasi kombinasi
                'qr_code.required_without' => 'Harap sediakan QR code atau NISN/NIP/NIK siswa.',
                'nisn_nip_nik.required_without' => 'Harap sediakan QR code atau NISN/NIP/NIK siswa.',
                'nisn_nip_nik.exists' => 'Siswa dengan NISN/NIP/NIK tersebut tidak ditemukan.'
            ]);

            // Validasi tambahan untuk memastikan salah satu dari qr_code atau nisn_nip_nik disediakan
            $validator->sometimes('qr_code', 'required_without:nisn_nip_nik', function ($input) {
                return empty($input->nisn_nip_nik);
            });
            
            $validator->sometimes('nisn_nip_nik', 'required_without:qr_code', function ($input) {
                return empty($input->qr_code);
            });

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            // Cek apakah user adalah guru
            if ($user->role_id != 2) {
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya guru yang dapat melakukan absensi siswa'
                ], 403);
            }
            
            // Verifikasi lokasi (radius 100 meter dari sekolah)
            $schoolLatitude = -6.123456; // Dari settings
            $schoolLongitude = 106.876543; // Dari settings
            $radius = 100; // meter
            
            $distance = $this->calculateDistance(
                $request->latitude, 
                $request->longitude, 
                $schoolLatitude, 
                $schoolLongitude
            );
            
            if ($distance > $radius) {
                return response()->json([
                    'success' => false,
                    'student' => null,
                    'message' => 'Lokasi di luar area sekolah'
                ], 400);
            }
            
            // Inisialisasi variabel siswa
            $student = null;
            
            // Cek apakah input manual NISN/NIP/NIK digunakan
            if (!empty($request->nisn_nip_nik)) {
                // Cari siswa berdasarkan NISN/NIP/NIK
                $student = User::where('nisn_nip_nik', $request->nisn_nip_nik)
                               ->where('role_id', 1) // Pastikan hanya mencari siswa
                               ->first();
                
                if (!$student) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Siswa dengan NISN/NIP/NIK tersebut tidak ditemukan.'
                    ], 404);
                }
            } else {
                // Gunakan logika QR code lama
                $studentQrCard = StudentQrCard::with('student')
                    ->where('qr_code', $request->qr_code)
                    ->where('is_active', true)
                    ->first();
                    
                if (!$studentQrCard) {
                    return response()->json([
                        'success' => false,
                        'student' => null,
                        'message' => 'QR code tidak valid'
                    ], 400);
                }
                
                $student = $studentQrCard->student;
            }
            
            // Cek apakah siswa ada di kelas yang diajarkan guru
            $isInClass = $student->classes()
                ->where('class_id', $request->class_id)
                ->exists();
            
            if (!$isInClass) {
                return response()->json([
                    'success' => false,
                    'student' => [
                        'id' => $student->id,
                        'nisn_nip_nik' => $student->nisn_nip_nik,
                        'name' => $student->name
                    ],
                    'message' => 'Siswa tidak terdaftar di kelas ini'
                ], 400);
            }
            
            // Cek apakah siswa sudah absen hari ini
            $today = Carbon::today(); // Gunakan Carbon untuk konsistensi
            $existingAttendance = Attendance::where('user_id', $student->id)
                ->whereDate('timestamp', $today)
                ->where('type', 'checkin')
                ->first();
                
            if ($existingAttendance) {
                return response()->json([
                    'success' => false,
                    'student' => [
                        'id' => $student->id,
                        'nisn_nip_nik' => $student->nisn_nip_nik,
                        'name' => $student->name
                    ],
                    'message' => 'Sudah absen hari ini'
                ], 400);
            }
            
            // Simpan data absensi
            $attendance = new Attendance();
            $attendance->user_id = $student->id;
            $attendance->type = 'checkin';
            $attendance->latitude = $request->latitude;
            $attendance->longitude = $request->longitude;
            $attendance->accuracy = $request->accuracy ?? null;
            $attendance->photo_path = $request->photo ?? null;
            
            // Simpan metode input yang digunakan
            if (!empty($request->nisn_nip_nik)) {
                $attendance->qr_token_used = "MANUAL:" . $request->nisn_nip_nik;
            } else {
                $attendance->qr_token_used = $request->qr_code;
            }
            
            $attendance->timestamp = Carbon::now(); // Gunakan Carbon untuk konsistensi
            $attendance->save();
            
            return response()->json([
                'success' => true,
                'student' => [
                    'id' => $student->id,
                    'nisn_nip_nik' => $student->nisn_nip_nik,
                    'name' => $student->name
                ],
                'message' => 'Absensi berhasil'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'student' => null,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Bulk attendance for all students in a class
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function bulkAttendance(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'class_id' => 'required|exists:classes,id',
                'date' => 'nullable|date_format:Y-m-d', // Format tanggal: YYYY-MM-DD
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            // Cek apakah user adalah guru
            if ($user->role_id != 2) {
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya guru yang dapat melakukan absensi massal'
                ], 403);
            }

            $classId = $request->class_id;
            $attendanceDate = $request->date ? Carbon::createFromFormat('Y-m-d', $request->date)->startOfDay() : Carbon::today();
            
            // Cek apakah guru mengajar kelas ini
            $isClassTeacher = Classes::where('id', $classId)
                                     ->where('homeroom_teacher_id', $user->id)
                                     ->exists();
                                     
            if (!$isClassTeacher) {
                // Jika bukan wali kelas, cek apakah guru ini mengajar kelas ini (jika ada relasi guru-kelas)
                // Untuk saat ini, kita asumsikan hanya wali kelas yang bisa absen massal
                // Tapi logika ini bisa dikembangkan lebih lanjut
                // return response()->json([
                //     'success' => false,
                //     'message' => 'Anda tidak memiliki akses untuk melakukan absensi massal di kelas ini'
                // ], 403);
            }

            // Ambil semua siswa aktif dalam kelas
            $students = User::where('role_id', 1) // Siswa
                            ->whereHas('classes', function ($query) use ($classId) {
                                $query->where('class_id', $classId);
                            })
                            ->get();

            if ($students->isEmpty()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tidak ada siswa terdaftar di kelas ini'
                ], 400);
            }

            $processedStudents = [];
            $alreadyAttendedStudents = [];
            $newlyAttendedStudents = [];
            
            foreach ($students as $student) {
                // Cek apakah siswa sudah absen hari ini
                $existingAttendance = Attendance::where('user_id', $student->id)
                                                ->whereDate('timestamp', $attendanceDate)
                                                ->where('type', 'checkin')
                                                ->first();
                
                if ($existingAttendance) {
                    $alreadyAttendedStudents[] = [
                        'id' => $student->id,
                        'nisn_nip_nik' => $student->nisn_nip_nik,
                        'name' => $student->name
                    ];
                } else {
                    // Simpan data absensi massal
                    $attendance = new Attendance();
                    $attendance->user_id = $student->id;
                    $attendance->type = 'checkin';
                    // Untuk absensi massal, lokasi dan foto biasanya tidak relevan
                    // Tapi kita bisa simpan lokasi guru sebagai referensi
                    // $attendance->latitude = $request->latitude ?? null;
                    // $attendance->longitude = $request->longitude ?? null;
                    // $attendance->accuracy = $request->accuracy ?? null;
                    // $attendance->photo_path = $request->photo ?? null;
                    $attendance->qr_token_used = "BULK:" . $user->id; // Tandai sebagai absen massal
                    $attendance->timestamp = $attendanceDate->copy()->setTime(7, 0, 0); // Set waktu default, bisa disesuaikan
                    $attendance->status = 'hadir'; // Default status
                    $attendance->save();
                    
                    $newlyAttendedStudents[] = [
                        'id' => $student->id,
                        'nisn_nip_nik' => $student->nisn_nip_nik,
                        'name' => $student->name
                    ];
                }
                
                $processedStudents[] = [
                    'id' => $student->id,
                    'nisn_nip_nik' => $student->nisn_nip_nik,
                    'name' => $student->name,
                    'attended' => $existingAttendance ? true : false
                ];
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Absensi massal berhasil diproses',
                'data' => [
                    'class_id' => $classId,
                    'date' => $attendanceDate->toDateString(),
                    'total_students' => count($students),
                    'already_attended' => count($alreadyAttendedStudents),
                    'newly_attended' => count($newlyAttendedStudents),
                    'processed_students' => $processedStudents
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat memproses absensi massal: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get class attendance status for quick UI update
     *
     * @param  int  $classId
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getClassAttendanceStatus($classId, Request $request)
    {
        try {
            $user = Auth::user();
            
            // Cek apakah user adalah guru
            if ($user->role_id != 2) {
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya guru yang dapat melihat status absensi'
                ], 403);
            }
            
            $date = $request->query('date', date('Y-m-d'));
            
            // Get all students in class with attendance status
            $students = User::select('users.id', 'users.nisn_nip_nik', 'users.name')
                ->join('student_class', 'users.id', '=', 'student_class.student_id')
                ->where('student_class.class_id', $classId)
                ->where('users.role_id', 1) // Siswa
                ->orderBy('users.name')
                ->get();
            
            // Check attendance status for each student
            $students = $students->map(function($student) use ($date) {
                $attended = Attendance::where('user_id', $student->id)
                    ->whereDate('timestamp', $date)
                    ->where('type', 'checkin')
                    ->exists();
                    
                return [
                    'id' => $student->id,
                    'nisn_nip_nik' => $student->nisn_nip_nik,
                    'name' => $student->name,
                    'attended' => $attended
                ];
            });
            
            return response()->json([
                'success' => true,
                'data' => $students
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil status absensi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Calculate distance between two points using Haversine formula
     *
     * @param float $lat1
     * @param float $lon1
     * @param float $lat2
     * @param float $lon2
     * @return float Distance in meters
     */
    private function calculateDistance($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371000; // Earth radius in meters
        
        $lat1Rad = deg2rad($lat1);
        $lon1Rad = deg2rad($lon1);
        $lat2Rad = deg2rad($lat2);
        $lon2Rad = deg2rad($lon2);
        
        $latDiff = $lat2Rad - $lat1Rad;
        $lonDiff = $lon2Rad - $lon1Rad;
        
        $a = sin($latDiff / 2) * sin($latDiff / 2) +
             cos($lat1Rad) * cos($lat2Rad) *
             sin($lonDiff / 2) * sin($lonDiff / 2);
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
        
        return $earthRadius * $c;
    }
}