<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\StudentQrCard;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class StudentQrCardController extends Controller
{
    /**
     * Get all student QR cards
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            // Cek apakah user adalah admin atau kepala sekolah
            $user = Auth::user();
            if ($user->role_id != 5 && $user->role_id != 4) { // 5 adalah id untuk admin, 4 untuk kepala sekolah
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin atau kepala sekolah yang dapat mengakses data QR card siswa'
                ], 403);
            }
            
            $qrCards = StudentQrCard::with('student')->get();
            
            return response()->json([
                'success' => true,
                'data' => $qrCards
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data QR card: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a specific student QR card by ID
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
                    'message' => 'Hanya admin atau kepala sekolah yang dapat mengakses data QR card siswa'
                ], 403);
            }
            
            $qrCard = StudentQrCard::with('student')->find($id);
            
            if (!$qrCard) {
                return response()->json([
                    'success' => false,
                    'message' => 'QR card dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            return response()->json([
                'success' => true,
                'data' => $qrCard
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data QR card: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Generate new QR code for a student
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function generate(Request $request)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5 adalah id untuk admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat mengenerate QR card baru'
                ], 403);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'student_id' => 'required|exists:users,id',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            // Cek apakah student_id adalah siswa
            $student = User::find($request->student_id);
            if ($student->role_id != 1) { // 1 adalah id untuk siswa
                return response()->json([
                    'success' => false,
                    'message' => 'ID yang diberikan bukan milik seorang siswa'
                ], 400);
            }
            
            // Cek apakah siswa sudah memiliki QR card aktif
            $existingQrCard = StudentQrCard::where('student_id', $request->student_id)
                ->where('is_active', true)
                ->first();
                
            if ($existingQrCard) {
                // Nonaktifkan QR card yang sudah ada
                $existingQrCard->is_active = false;
                $existingQrCard->save();
            }
            
            // Generate QR code baru
            $newQrCode = strtoupper(Str::random(10)); // Generate 10 karakter acak
            
            // Buat QR card baru
            $qrCard = new StudentQrCard();
            $qrCard->student_id = $request->student_id;
            $qrCard->qr_code = $newQrCode;
            $qrCard->is_active = true;
            $qrCard->generated_at = now();
            $qrCard->save();
            
            // Load relasi student
            $qrCard->load('student');
            
            return response()->json([
                'success' => true,
                'message' => 'QR card baru berhasil di-generate',
                'data' => $qrCard
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengenerate QR card: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update status of a student QR card
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function updateStatus(Request $request, $id)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5 adalah id untuk admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat memperbarui status QR card'
                ], 403);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'is_active' => 'required|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            $qrCard = StudentQrCard::find($id);
            
            if (!$qrCard) {
                return response()->json([
                    'success' => false,
                    'message' => 'QR card dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            // Jika mengaktifkan QR card, nonaktifkan QR card lain milik siswa yang sama
            if ($request->is_active == true) {
                StudentQrCard::where('student_id', $qrCard->student_id)
                    ->where('id', '!=', $id)
                    ->update(['is_active' => false]);
            }
            
            // Update status QR card
            $qrCard->is_active = $request->is_active;
            $qrCard->save();
            
            // Load relasi student
            $qrCard->load('student');
            
            return response()->json([
                'success' => true,
                'message' => 'Status QR card berhasil diperbarui',
                'data' => $qrCard
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat memperbarui status QR card: ' . $e->getMessage()
            ], 500);
        }
    }
}