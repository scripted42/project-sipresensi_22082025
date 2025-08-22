<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\OfflineSyncLog;
use App\Models\Attendance;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class OfflineSyncController extends Controller
{
    /**
     * Get all offline sync logs
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        try {
            // Cek apakah user adalah admin atau kepala sekolah
            $user = Auth::user();
            if ($user->role_id != 5 && $user->role_id != 4) { // 5 adalah id untuk admin, 4 untuk kepala sekolah
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin atau kepala sekolah yang dapat mengakses log sinkronisasi'
                ], 403);
            }
            
            // Filter berdasarkan parameter
            $query = OfflineSyncLog::with('user');
            
            if ($request->has('user_id')) {
                $query->where('user_id', $request->user_id);
            }
            
            if ($request->has('status')) {
                $query->where('status', $request->status);
            }
            
            if ($request->has('action_type')) {
                $query->where('action_type', $request->action_type);
            }
            
            // Pagination
            $perPage = $request->get('per_page', 15);
            $logs = $query->orderBy('synced_at', 'desc')->paginate($perPage);
            
            return response()->json([
                'success' => true,
                'data' => $logs
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data log sinkronisasi: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a specific offline sync log by ID
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        try {
            // Cek apakah user adalah admin atau kepala sekolah
            $user = Auth::user();
            if ($user->role_id != 5 && $user->role_id != 4) { // 5 adalah id untuk admin, 4 untuk kepala sekolah
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin atau kepala sekolah yang dapat mengakses log sinkronisasi'
                ], 403);
            }
            
            $log = OfflineSyncLog::with('user')->find($id);
            
            if (!$log) {
                return response()->json([
                    'success' => false,
                    'message' => 'Log sinkronisasi dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            return response()->json([
                'success' => true,
                'data' => $log
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data log sinkronisasi: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Process offline attendance data
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function processAttendance(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'attendances' => 'required|array',
                'attendances.*.user_id' => 'required|exists:users,id',
                'attendances.*.type' => 'required|in:checkin,checkout',
                'attendances.*.timestamp' => 'required|date_format:Y-m-d H:i:s',
                'attendances.*.latitude' => 'nullable|numeric',
                'attendances.*.longitude' => 'nullable|numeric',
                'attendances.*.accuracy' => 'nullable|numeric|min:0',
                'attendances.*.photo_path' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            $processedAttendances = [];
            $failedAttendances = [];
            
            // Proses setiap data absensi
            foreach ($request->attendances as $attendanceData) {
                try {
                    // Cek apakah user adalah siswa, guru, pegawai, atau kepala sekolah
                    $user = \App\Models\User::find($attendanceData['user_id']);
                    if (!in_array($user->role_id, [1, 2, 3, 4])) { // 1=siswa, 2=guru, 3=pegawai, 4=kepala sekolah
                        $failedAttendances[] = [
                            'data' => $attendanceData,
                            'error' => 'User tidak memiliki peran yang valid untuk absensi'
                        ];
                        continue;
                    }
                    
                    // Cek apakah sudah ada absensi dengan timestamp yang sama
                    $existingAttendance = Attendance::where('user_id', $attendanceData['user_id'])
                        ->where('timestamp', $attendanceData['timestamp'])
                        ->where('type', $attendanceData['type'])
                        ->first();
                        
                    if ($existingAttendance) {
                        $failedAttendances[] = [
                            'data' => $attendanceData,
                            'error' => 'Absensi dengan timestamp yang sama sudah ada'
                        ];
                        continue;
                    }
                    
                    // Simpan data absensi
                    $attendance = new Attendance();
                    $attendance->user_id = $attendanceData['user_id'];
                    $attendance->type = $attendanceData['type'];
                    $attendance->timestamp = $attendanceData['timestamp'];
                    $attendance->latitude = $attendanceData['latitude'] ?? null;
                    $attendance->longitude = $attendanceData['longitude'] ?? null;
                    $attendance->accuracy = $attendanceData['accuracy'] ?? null;
                    $attendance->photo_path = $attendanceData['photo_path'] ?? null;
                    $attendance->qr_token_used = "OFFLINE";
                    $attendance->status = 'hadir';
                    $attendance->synced = true;
                    $attendance->save();
                    
                    $processedAttendances[] = $attendance;
                    
                    // Buat log sinkronisasi untuk data yang berhasil
                    $syncLog = new OfflineSyncLog();
                    $syncLog->user_id = $attendanceData['user_id'];
                    $syncLog->action_type = 'attendance';
                    $syncLog->data = $attendanceData;
                    $syncLog->status = 'success';
                    $syncLog->synced_at = now();
                    $syncLog->save();
                } catch (\Exception $e) {
                    // Buat log sinkronisasi untuk data yang gagal
                    $syncLog = new OfflineSyncLog();
                    $syncLog->user_id = $attendanceData['user_id'] ?? null;
                    $syncLog->action_type = 'attendance';
                    $syncLog->data = $attendanceData;
                    $syncLog->status = 'failed';
                    $syncLog->error_message = $e->getMessage();
                    $syncLog->synced_at = now();
                    $syncLog->save();
                    
                    $failedAttendances[] = [
                        'data' => $attendanceData,
                        'error' => $e->getMessage()
                    ];
                }
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Proses sinkronisasi data absensi selesai',
                'data' => [
                    'processed' => $processedAttendances,
                    'failed' => $failedAttendances,
                    'processed_count' => count($processedAttendances),
                    'failed_count' => count($failedAttendances)
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat memproses data absensi offline: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Retry failed sync log
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function retry($id)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5 adalah id untuk admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat mencoba ulang sinkronisasi'
                ], 403);
            }
            
            $syncLog = OfflineSyncLog::find($id);
            
            if (!$syncLog) {
                return response()->json([
                    'success' => false,
                    'message' => 'Log sinkronisasi dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            if ($syncLog->status != 'failed') {
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya log dengan status failed yang dapat dicoba ulang'
                ], 400);
            }
            
            // Coba proses ulang berdasarkan tipe action
            if ($syncLog->action_type == 'attendance') {
                try {
                    $data = $syncLog->data;
                    
                    // Cek apakah user adalah siswa, guru, pegawai, atau kepala sekolah
                    $user = \App\Models\User::find($data['user_id']);
                    if (!in_array($user->role_id, [1, 2, 3, 4])) { // 1=siswa, 2=guru, 3=pegawai, 4=kepala sekolah
                        throw new \Exception('User tidak memiliki peran yang valid untuk absensi');
                    }
                    
                    // Cek apakah sudah ada absensi dengan timestamp yang sama
                    $existingAttendance = Attendance::where('user_id', $data['user_id'])
                        ->where('timestamp', $data['timestamp'])
                        ->where('type', $data['type'])
                        ->first();
                        
                    if ($existingAttendance) {
                        throw new \Exception('Absensi dengan timestamp yang sama sudah ada');
                    }
                    
                    // Simpan data absensi
                    $attendance = new Attendance();
                    $attendance->user_id = $data['user_id'];
                    $attendance->type = $data['type'];
                    $attendance->timestamp = $data['timestamp'];
                    $attendance->latitude = $data['latitude'] ?? null;
                    $attendance->longitude = $data['longitude'] ?? null;
                    $attendance->accuracy = $data['accuracy'] ?? null;
                    $attendance->photo_path = $data['photo_path'] ?? null;
                    $attendance->qr_token_used = "OFFLINE_RETRY";
                    $attendance->status = 'hadir';
                    $attendance->synced = true;
                    $attendance->save();
                    
                    // Update log sinkronisasi
                    $syncLog->status = 'success';
                    $syncLog->error_message = null;
                    $syncLog->synced_at = now();
                    $syncLog->save();
                    
                    return response()->json([
                        'success' => true,
                        'message' => 'Sinkronisasi berhasil diulang',
                        'data' => $attendance
                    ], 200);
                } catch (\Exception $e) {
                    // Update log sinkronisasi dengan error baru
                    $syncLog->error_message = $e->getMessage();
                    $syncLog->synced_at = now();
                    $syncLog->save();
                    
                    return response()->json([
                        'success' => false,
                        'message' => 'Sinkronisasi gagal saat diulang: ' . $e->getMessage()
                    ], 500);
                }
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Tipe action tidak didukung untuk diulang'
                ], 400);
            }
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mencoba ulang sinkronisasi: ' . $e->getMessage()
            ], 500);
        }
    }
}