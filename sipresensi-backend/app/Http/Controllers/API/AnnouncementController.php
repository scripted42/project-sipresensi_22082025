<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Models\Announcement;

class AnnouncementController extends Controller
{
    /**
     * Get all published announcements
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        try {
            // Get query parameters
            $limit = $request->query('limit', 10);
            $offset = $request->query('offset', 0);
            
            // Get published announcements
            $announcements = Announcement::where('is_published', true)
                ->orderBy('published_at', 'desc')
                ->skip($offset)
                ->take($limit)
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data pengumuman berhasil diambil',
                'data' => $announcements
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get announcements for dashboard carousel
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function carousel(Request $request)
    {
        try {
            // Get the latest 5 published announcements for the carousel
            $announcements = Announcement::where('is_published', true)
                ->orderBy('published_at', 'desc')
                ->limit(5)
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data carousel pengumuman berhasil diambil',
                'data' => $announcements
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data carousel pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a specific announcement by ID
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        try {
            $announcement = Announcement::where('id', $id)
                ->where('is_published', true)
                ->first();
            
            if (!$announcement) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengumuman tidak ditemukan'
                ], 404);
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Data pengumuman berhasil diambil',
                'data' => $announcement
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Create a new announcement (admin/kepala sekolah only)
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        try {
            // Validasi input
            $validator = Validator::make($request->all(), [
                'title' => 'required|string|max:255',
                'content' => 'required|string',
                'is_published' => 'boolean'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            // Cek apakah user adalah admin atau kepala sekolah
            if ($user->role_id != 4 && $user->role_id != 5) { // 4 = kepala_sekolah, 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk membuat pengumuman'
                ], 403);
            }
            
            // Buat pengumuman baru
            $announcement = new Announcement();
            $announcement->title = $request->title;
            $announcement->content = $request->content;
            $announcement->author_id = $user->id;
            $announcement->is_published = $request->is_published ?? true;
            $announcement->published_at = $request->is_published ? now() : null;
            $announcement->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengumuman berhasil dibuat',
                'data' => $announcement
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat membuat pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update a specific announcement by ID (admin/kepala sekolah only)
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
                'title' => 'required|string|max:255',
                'content' => 'required|string',
                'is_published' => 'boolean'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user = Auth::user();
            
            // Cek apakah user adalah admin atau kepala sekolah
            if ($user->role_id != 4 && $user->role_id != 5) { // 4 = kepala_sekolah, 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk mengubah pengumuman'
                ], 403);
            }
            
            $announcement = Announcement::where('id', $id)->first();
            
            if (!$announcement) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengumuman tidak ditemukan'
                ], 404);
            }
            
            // Update pengumuman
            $announcement->title = $request->title;
            $announcement->content = $request->content;
            $announcement->is_published = $request->is_published ?? $announcement->is_published;
            $announcement->published_at = $request->is_published ? ($announcement->published_at ?? now()) : null;
            $announcement->save();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengumuman berhasil diubah',
                'data' => $announcement
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengubah pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete a specific announcement by ID (admin/kepala sekolah only)
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        try {
            $user = Auth::user();
            
            // Cek apakah user adalah admin atau kepala sekolah
            if ($user->role_id != 4 && $user->role_id != 5) { // 4 = kepala_sekolah, 5 = admin
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki izin untuk menghapus pengumuman'
                ], 403);
            }
            
            $announcement = Announcement::where('id', $id)->first();
            
            if (!$announcement) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengumuman tidak ditemukan'
                ], 404);
            }
            
            // Hapus pengumuman
            $announcement->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengumuman berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menghapus pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}