<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class UserController extends Controller
{
    /**
     * Get all users (admin only)
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        try {
            $user = Auth::user();
            
            // Cek apakah user adalah admin
            if ($user->role_id != 5) { // 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk mengakses data pengguna'
                ], 403);
            }
            
            // Get query parameters
            $limit = $request->query('limit', 10);
            $offset = $request->query('offset', 0);
            $role = $request->query('role');
            
            // Build query
            $query = User::where('is_active', true);
            
            if ($role) {
                $query->where('role_id', $role);
            }
            
            $users = $query->skip($offset)
                ->take($limit)
                ->get();
            
            // Sembunyikan password sebelum mengirim response
            foreach ($users as $u) {
                $u->makeHidden(['password']);
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Data pengguna berhasil diambil',
                'data' => $users
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a specific user by ID (admin only)
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        try {
            $currentUser = Auth::user();
            
            // Cek apakah user adalah admin
            if ($currentUser->role_id != 5) { // 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk mengakses data pengguna'
                ], 403);
            }
            
            $user = User::where('id', $id)->where('is_active', true)->first();
            
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengguna tidak ditemukan'
                ], 404);
            }
            
            // Sembunyikan password sebelum mengirim response
            $user->makeHidden(['password']);
            
            return response()->json([
                'success' => true,
                'message' => 'Data pengguna berhasil diambil',
                'data' => $user
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Create a new user (admin only)
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'nisn_nip_nik' => 'required|string|unique:users,nisn_nip_nik',
                'name' => 'required|string|max:100',
                'email' => 'required|email|unique:users,email',
                'phone' => 'nullable|string|max:20',
                'password' => 'required|string|min:8',
                'role_id' => 'required|integer|exists:roles,id',
                'photo_path' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $currentUser = Auth::user();
            
            // Cek apakah user adalah admin
            if ($currentUser->role_id != 5) { // 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk membuat pengguna'
                ], 403);
            }
            
            // Buat pengguna baru
            $user = new User();
            $user->nisn_nip_nik = $request->nisn_nip_nik;
            $user->name = $request->name;
            $user->email = $request->email;
            $user->phone = $request->phone;
            $user->password = Hash::make($request->password);
            $user->role_id = $request->role_id;
            $user->photo_path = $request->photo_path;
            $user->is_active = true;
            $user->save();
            
            // Sembunyikan password sebelum mengirim response
            $user->makeHidden(['password']);
            
            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil dibuat',
                'data' => $user
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat membuat pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update a specific user by ID (admin only)
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
                'nisn_nip_nik' => 'required|string|unique:users,nisn_nip_nik,' . $id,
                'name' => 'required|string|max:100',
                'email' => 'required|email|unique:users,email,' . $id,
                'phone' => 'nullable|string|max:20',
                'role_id' => 'required|integer|exists:roles,id',
                'photo_path' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $currentUser = Auth::user();
            
            // Cek apakah user adalah admin
            if ($currentUser->role_id != 5) { // 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk mengubah pengguna'
                ], 403);
            }
            
            $user = User::where('id', $id)->where('is_active', true)->first();
            
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengguna tidak ditemukan'
                ], 404);
            }
            
            // Update pengguna
            $user->nisn_nip_nik = $request->nisn_nip_nik;
            $user->name = $request->name;
            $user->email = $request->email;
            $user->phone = $request->phone;
            $user->role_id = $request->role_id;
            $user->photo_path = $request->photo_path;
            $user->save();
            
            // Sembunyikan password sebelum mengirim response
            $user->makeHidden(['password']);
            
            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil diubah',
                'data' => $user
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengubah pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete a specific user by ID (admin only)
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        try {
            $currentUser = Auth::user();
            
            // Cek apakah user adalah admin
            if ($currentUser->role_id != 5) { // 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk menghapus pengguna'
                ], 403);
            }
            
            $user = User::where('id', $id)->where('is_active', true)->first();
            
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengguna tidak ditemukan'
                ], 404);
            }
            
            // Nonaktifkan pengguna (soft delete)
            $user->is_active = false;
            $user->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil dinonaktifkan'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menghapus pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}