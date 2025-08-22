<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Attendance;
use App\Models\DynamicQRToken;

class AttendanceController extends Controller
{
    /**
     * Handle user check-in
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function checkin(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'latitude' => 'required|numeric',
                'longitude' => 'required|numeric',
                'photo' => 'required|string',
                'qr_token' => 'required|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
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
                    'message' => 'Anda berada di luar area sekolah'
                ], 400);
            }
            
            // Verifikasi QR token
            $qrToken = DynamicQRToken::where('token', $request->qr_token)
                ->where('used', false)
                ->where('expires_at', '>', now())
                ->first();
                
            if (!$qrToken) {
                return response()->json([
                    'success' => false,
                    'message' => 'QR token tidak valid atau sudah kadaluarsa'
                ], 400);
            }
            
            // Cek apakah pengguna sudah absen hari ini
            $today = date('Y-m-d');
            $existingAttendance = Attendance::where('user_id', $user->id)
                ->whereDate('timestamp', $today)
                ->where('type', 'checkin')
                ->first();
                
            if ($existingAttendance) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda sudah melakukan absen masuk hari ini'
                ], 400);
            }
            
            // Simpan data absensi
            $attendance = new Attendance();
            $attendance->user_id = $user->id;
            $attendance->type = 'checkin';
            $attendance->latitude = $request->latitude;
            $attendance->longitude = $request->longitude;
            $attendance->accuracy = $request->accuracy ?? null;
            $attendance->photo_path = $request->photo;
            $attendance->qr_token_used = $request->qr_token;
            $attendance->timestamp = now();
            $attendance->save();
            
            // Tandai QR token sebagai sudah digunakan
            $qrToken->used = true;
            $qrToken->used_by = $user->id;
            $qrToken->used_at = now();
            $qrToken->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Absen masuk berhasil',
                'data' => $attendance
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat melakukan absen masuk',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Handle user check-out
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function checkout(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'latitude' => 'required|numeric',
                'longitude' => 'required|numeric',
                'photo' => 'required|string',
                'qr_token' => 'required|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
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
                    'message' => 'Anda berada di luar area sekolah'
                ], 400);
            }
            
            // Verifikasi QR token
            $qrToken = DynamicQRToken::where('token', $request->qr_token)
                ->where('used', false)
                ->where('expires_at', '>', now())
                ->first();
                
            if (!$qrToken) {
                return response()->json([
                    'success' => false,
                    'message' => 'QR token tidak valid atau sudah kadaluarsa'
                ], 400);
            }
            
            // Cek apakah pengguna sudah absen masuk hari ini
            $today = date('Y-m-d');
            $checkin = Attendance::where('user_id', $user->id)
                ->whereDate('timestamp', $today)
                ->where('type', 'checkin')
                ->first();
                
            if (!$checkin) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda belum melakukan absen masuk hari ini'
                ], 400);
            }
            
            // Cek apakah pengguna sudah absen keluar hari ini
            $existingAttendance = Attendance::where('user_id', $user->id)
                ->whereDate('timestamp', $today)
                ->where('type', 'checkout')
                ->first();
                
            if ($existingAttendance) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda sudah melakukan absen keluar hari ini'
                ], 400);
            }
            
            // Simpan data absensi
            $attendance = new Attendance();
            $attendance->user_id = $user->id;
            $attendance->type = 'checkout';
            $attendance->latitude = $request->latitude;
            $attendance->longitude = $request->longitude;
            $attendance->accuracy = $request->accuracy ?? null;
            $attendance->photo_path = $request->photo;
            $attendance->qr_token_used = $request->qr_token;
            $attendance->timestamp = now();
            $attendance->save();
            
            // Tandai QR token sebagai sudah digunakan
            $qrToken->used = true;
            $qrToken->used_by = $user->id;
            $qrToken->used_at = now();
            $qrToken->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Absen keluar berhasil',
                'data' => $attendance
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat melakukan absen keluar',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get attendance history for authenticated user
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function history(Request $request)
    {
        try {
            $user = Auth::user();
            
            // Get query parameters
            $startDate = $request->query('start_date', date('Y-m-01'));
            $endDate = $request->query('end_date', date('Y-m-t'));
            
            // Get attendance history
            $attendance = Attendance::where('user_id', $user->id)
                ->whereBetween('timestamp', [$startDate, $endDate])
                ->orderBy('timestamp', 'desc')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data riwayat absensi berhasil diambil',
                'data' => $attendance
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data riwayat absensi',
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