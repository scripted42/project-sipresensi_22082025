<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Models\Leave;

class LeaveController extends Controller
{
    /**
     * Get all leaves for authenticated user
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        try {
            $user = Auth::user();
            
            // Get query parameters
            $status = $request->query('status');
            $startDate = $request->query('start_date');
            $endDate = $request->query('end_date');
            
            // Build query
            $query = Leave::where('user_id', $user->id);
            
            if ($status) {
                $query->where('status', $status);
            }
            
            if ($startDate && $endDate) {
                $query->whereBetween('start_date', [$startDate, $endDate]);
            }
            
            $leaves = $query->orderBy('created_at', 'desc')->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data pengajuan izin berhasil diambil',
                'data' => $leaves
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengajuan izin',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Create a new leave request
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'leave_type' => 'required|in:izin,cuti,dinas_luar,sakit',
                'start_date' => 'required|date',
                'end_date' => 'required|date|after_or_equal:start_date',
                'reason' => 'required|string',
                'attachment_path' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            // Buat pengajuan izin baru
            $leave = new Leave();
            $leave->user_id = $user->id;
            $leave->leave_type = $request->leave_type;
            $leave->start_date = $request->start_date;
            $leave->end_date = $request->end_date;
            $leave->reason = $request->reason;
            $leave->attachment_path = $request->attachment_path;
            $leave->status = 'menunggu';
            $leave->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengajuan izin berhasil dibuat',
                'data' => $leave
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat membuat pengajuan izin',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a specific leave by ID
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        try {
            $user = Auth::user();
            
            $leave = Leave::where('user_id', $user->id)->where('id', $id)->first();
            
            if (!$leave) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan izin tidak ditemukan'
                ], 404);
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Data pengajuan izin berhasil diambil',
                'data' => $leave
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengajuan izin',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update a specific leave by ID
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'leave_type' => 'required|in:izin,cuti,dinas_luar,sakit',
                'start_date' => 'required|date',
                'end_date' => 'required|date|after_or_equal:start_date',
                'reason' => 'required|string',
                'attachment_path' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            $leave = Leave::where('user_id', $user->id)->where('id', $id)->first();
            
            if (!$leave) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan izin tidak ditemukan'
                ], 404);
            }
            
            // Cek status, hanya izin dengan status 'menunggu' yang bisa diubah
            if ($leave->status !== 'menunggu') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan izin tidak dapat diubah karena sudah diproses'
                ], 400);
            }
            
            // Update pengajuan izin
            $leave->leave_type = $request->leave_type;
            $leave->start_date = $request->start_date;
            $leave->end_date = $request->end_date;
            $leave->reason = $request->reason;
            $leave->attachment_path = $request->attachment_path;
            $leave->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengajuan izin berhasil diubah',
                'data' => $leave
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengubah pengajuan izin',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete a specific leave by ID
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        try {
            $user = Auth::user();
            
            $leave = Leave::where('user_id', $user->id)->where('id', $id)->first();
            
            if (!$leave) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan izin tidak ditemukan'
                ], 404);
            }
            
            // Cek status, hanya izin dengan status 'menunggu' yang bisa dihapus
            if ($leave->status !== 'menunggu') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengajuan izin tidak dapat dihapus karena sudah diproses'
                ], 400);
            }
            
            // Hapus pengajuan izin
            $leave->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengajuan izin berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menghapus pengajuan izin',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}