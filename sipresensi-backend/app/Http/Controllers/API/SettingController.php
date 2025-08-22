<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Setting;
use Illuminate\Support\Facades\Auth;

class SettingController extends Controller
{
    /**
     * Get all settings
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5 adalah id untuk admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat mengakses pengaturan sistem'
                ], 403);
            }
            
            $settings = Setting::all();
            
            return response()->json([
                'success' => true,
                'data' => $settings
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengaturan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a specific setting by key
     *
     * @param  string  $key
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($key)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5 adalah id untuk admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat mengakses pengaturan sistem'
                ], 403);
            }
            
            $setting = Setting::where('key_name', $key)->first();
            
            if (!$setting) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengaturan dengan key tersebut tidak ditemukan'
                ], 404);
            }
            
            return response()->json([
                'success' => true,
                'data' => $setting
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengaturan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update a specific setting
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  string  $key
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $key)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5 adalah id untuk admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat memperbarui pengaturan sistem'
                ], 403);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'value' => 'required|string',
                'description' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            $setting = Setting::where('key_name', $key)->first();
            
            if (!$setting) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengaturan dengan key tersebut tidak ditemukan'
                ], 404);
            }
            
            // Update setting
            $setting->value = $request->value;
            if ($request->has('description')) {
                $setting->description = $request->description;
            }
            $setting->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengaturan berhasil diperbarui',
                'data' => $setting
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat memperbarui pengaturan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Bulk update settings
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function bulkUpdate(Request $request)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5 adalah id untuk admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat memperbarui pengaturan sistem'
                ], 403);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'settings' => 'required|array',
                'settings.*.key' => 'required|string',
                'settings.*.value' => 'required|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            $updatedSettings = [];
            
            // Update settings
            foreach ($request->settings as $settingData) {
                $setting = Setting::where('key_name', $settingData['key'])->first();
                
                if ($setting) {
                    $setting->value = $settingData['value'];
                    $setting->save();
                    $updatedSettings[] = $setting;
                }
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Pengaturan berhasil diperbarui',
                'data' => $updatedSettings
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat memperbarui pengaturan: ' . $e->getMessage()
            ], 500);
        }
    }
}