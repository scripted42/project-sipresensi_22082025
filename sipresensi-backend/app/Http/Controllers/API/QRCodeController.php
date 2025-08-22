<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\DynamicQRToken;
use App\Models\Attendance;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class QRCodeController extends Controller
{
    /**
     * Get current dynamic QR token
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getDynamicQR(Request $request)
    {
        try {
            // Cari token yang belum digunakan dan belum kadaluarsa
            $qrToken = DynamicQRToken::where('used', false)
                ->where('expires_at', '>', now())
                ->first();
            
            // Jika tidak ada token yang valid, buat token baru
            if (!$qrToken) {
                $qrToken = new DynamicQRToken();
                $qrToken->token = $this->generateQRToken();
                $qrToken->created_at = now();
                $qrToken->expires_at = now()->addSeconds(15); // Token kadaluarsa dalam 15 detik
                $qrToken->used = false;
                $qrToken->save();
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Token QR dinamis berhasil diambil',
                'data' => [
                    'token' => $qrToken->token,
                    'expires_at' => $qrToken->expires_at
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil token QR dinamis',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Verify QR token and submit attendance data
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function verifyQRAndSubmitAttendance(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'qr_token' => 'required|string',
                'user_id' => 'required|exists:users,id',
                'latitude' => 'required|numeric',
                'longitude' => 'required|numeric',
                'photo' => 'required|string',
                'type' => 'required|in:checkin,checkout'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
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
            
            // Verifikasi user
            $user = User::find($request->user_id);
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan'
                ], 404);
            }
            
            // Cek apakah pengguna sudah absen hari ini
            $today = date('Y-m-d');
            
            if ($request->type === 'checkin') {
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
            } else if ($request->type === 'checkout') {
                // Cek apakah pengguna sudah absen masuk hari ini
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
            }
            
            // Simpan data absensi
            $attendance = new Attendance();
            $attendance->user_id = $user->id;
            $attendance->type = $request->type;
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
                'message' => 'Absen ' . ($request->type === 'checkin' ? 'masuk' : 'keluar') . ' berhasil',
                'data' => $attendance
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat melakukan absen',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Generate a random QR token
     *
     * @return string
     */
    private function generateQRToken()
    {
        return bin2hex(random_bytes(16));
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