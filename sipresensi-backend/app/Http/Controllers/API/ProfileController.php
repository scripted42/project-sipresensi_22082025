<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class ProfileController extends Controller
{
    /**
     * Get authenticated user profile
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function show(Request $request)
    {
        try {
            $user = Auth::user();
            
            // Sembunyikan password sebelum mengirim response
            $user->makeHidden(['password']);
            
            return response()->json([
                'success' => true,
                'message' => 'Data profil berhasil diambil',
                'data' => $user
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data profil',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update authenticated user profile
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:100',
                'email' => 'required|email|unique:users,email,' . Auth::id(),
                'phone' => 'nullable|string|max:20',
                'photo_path' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            // Update profil pengguna
            $user->name = $request->name;
            $user->email = $request->email;
            $user->phone = $request->phone;
            $user->photo_path = $request->photo_path;
            $user->save();
            
            // Sembunyikan password sebelum mengirim response
            $user->makeHidden(['password']);
            
            return response()->json([
                'success' => true,
                'message' => 'Profil berhasil diubah',
                'data' => $user
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengubah profil',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update authenticated user password
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function updatePassword(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'current_password' => 'required|string',
                'new_password' => 'required|string|min:8|confirmed'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            // Cek apakah password saat ini benar
            if (!Hash::check($request->current_password, $user->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Password saat ini tidak benar'
                ], 400);
            }
            
            // Update password
            $user->password = Hash::make($request->new_password);
            $user->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Password berhasil diubah'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengubah password',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}