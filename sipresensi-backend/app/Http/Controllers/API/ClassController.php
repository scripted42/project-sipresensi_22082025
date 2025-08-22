<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Classes;
use App\Models\StudentClass;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class ClassController extends Controller
{
    /**
     * Get all classes
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            // Cek apakah user adalah admin, kepala sekolah, atau guru
            $user = Auth::user();
            if (!in_array($user->role_id, [5, 4, 2])) { // 5=admin, 4=kepala sekolah, 2=guru
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin, kepala sekolah, atau guru yang dapat mengakses data kelas'
                ], 403);
            }
            
            $classes = Classes::with('homeroomTeacher')->get();
            
            return response()->json([
                'success' => true,
                'data' => $classes
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data kelas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a specific class by ID
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        try {
            // Cek apakah user adalah admin, kepala sekolah, atau guru
            $user = Auth::user();
            if (!in_array($user->role_id, [5, 4, 2])) { // 5=admin, 4=kepala sekolah, 2=guru
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin, kepala sekolah, atau guru yang dapat mengakses data kelas'
                ], 403);
            }
            
            $class = Classes::with('homeroomTeacher')->find($id);
            
            if (!$class) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            return response()->json([
                'success' => true,
                'data' => $class
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data kelas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Create a new class
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5=admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat membuat kelas baru'
                ], 403);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:50',
                'homeroom_teacher_id' => 'nullable|exists:users,id',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            // Cek apakah homeroom teacher adalah guru
            if ($request->homeroom_teacher_id) {
                $teacher = User::find($request->homeroom_teacher_id);
                if ($teacher->role_id != 2) { // 2=guru
                    return response()->json([
                        'success' => false,
                        'message' => 'Homeroom teacher harus merupakan seorang guru'
                    ], 400);
                }
            }
            
            // Buat kelas baru
            $class = new Classes();
            $class->name = $request->name;
            $class->homeroom_teacher_id = $request->homeroom_teacher_id;
            $class->save();
            
            // Load relasi
            $class->load('homeroomTeacher');
            
            return response()->json([
                'success' => true,
                'message' => 'Kelas berhasil dibuat',
                'data' => $class
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat membuat kelas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update a class
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5=admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat memperbarui kelas'
                ], 403);
            }
            
            $class = Classes::find($id);
            
            if (!$class) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'name' => 'sometimes|required|string|max:50',
                'homeroom_teacher_id' => 'nullable|exists:users,id',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            // Cek apakah homeroom teacher adalah guru
            if ($request->homeroom_teacher_id) {
                $teacher = User::find($request->homeroom_teacher_id);
                if ($teacher->role_id != 2) { // 2=guru
                    return response()->json([
                        'success' => false,
                        'message' => 'Homeroom teacher harus merupakan seorang guru'
                    ], 400);
                }
            }
            
            // Update kelas
            if ($request->has('name')) {
                $class->name = $request->name;
            }
            
            if ($request->has('homeroom_teacher_id')) {
                $class->homeroom_teacher_id = $request->homeroom_teacher_id;
            }
            
            $class->save();
            
            // Load relasi
            $class->load('homeroomTeacher');
            
            return response()->json([
                'success' => true,
                'message' => 'Kelas berhasil diperbarui',
                'data' => $class
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat memperbarui kelas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete a class
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5=admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat menghapus kelas'
                ], 403);
            }
            
            $class = Classes::find($id);
            
            if (!$class) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            // Cek apakah kelas memiliki siswa
            $studentCount = StudentClass::where('class_id', $id)->count();
            
            if ($studentCount > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tidak dapat menghapus kelas yang masih memiliki siswa. Silakan hapus siswa dari kelas terlebih dahulu.'
                ], 400);
            }
            
            // Hapus kelas
            $class->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Kelas berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menghapus kelas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get students in a class
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function getStudents($id)
    {
        try {
            // Cek apakah user adalah admin, kepala sekolah, atau guru
            $user = Auth::user();
            if (!in_array($user->role_id, [5, 4, 2])) { // 5=admin, 4=kepala sekolah, 2=guru
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin, kepala sekolah, atau guru yang dapat mengakses data siswa dalam kelas'
                ], 403);
            }
            
            $class = Classes::find($id);
            
            if (!$class) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            // Get students in class
            $students = User::where('role_id', 1) // 1=siswa
                ->whereHas('classes', function ($query) use ($id) {
                    $query->where('class_id', $id);
                })
                ->with('studentClasses')
                ->get();
            
            return response()->json([
                'success' => true,
                'data' => [
                    'class' => $class,
                    'students' => $students
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mengambil data siswa dalam kelas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Assign students to a class
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function assignStudents(Request $request, $id)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5=admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat menetapkan siswa ke kelas'
                ], 403);
            }
            
            $class = Classes::find($id);
            
            if (!$class) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'student_ids' => 'required|array',
                'student_ids.*' => 'exists:users,id',
                'academic_year' => 'required|integer'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            // Cek apakah semua student_ids adalah siswa
            $students = User::whereIn('id', $request->student_ids)->get();
            foreach ($students as $student) {
                if ($student->role_id != 1) { // 1=siswa
                    return response()->json([
                        'success' => false,
                        'message' => 'ID ' . $student->id . ' bukan milik seorang siswa'
                    ], 400);
                }
            }
            
            // Assign students to class
            $assignedStudents = [];
            foreach ($request->student_ids as $studentId) {
                // Cek apakah siswa sudah ada di kelas untuk tahun akademik yang sama
                $existingAssignment = StudentClass::where('student_id', $studentId)
                    ->where('class_id', $id)
                    ->where('academic_year', $request->academic_year)
                    ->first();
                
                if (!$existingAssignment) {
                    $studentClass = new StudentClass();
                    $studentClass->student_id = $studentId;
                    $studentClass->class_id = $id;
                    $studentClass->academic_year = $request->academic_year;
                    $studentClass->save();
                    
                    $assignedStudents[] = $studentClass;
                }
            }
            
            // Load relasi
            $class->load('homeroomTeacher');
            
            return response()->json([
                'success' => true,
                'message' => count($assignedStudents) . ' siswa berhasil ditetapkan ke kelas',
                'data' => [
                    'class' => $class,
                    'assigned_students' => $assignedStudents
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menetapkan siswa ke kelas: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove students from a class
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function removeStudents(Request $request, $id)
    {
        try {
            // Cek apakah user adalah admin
            $user = Auth::user();
            if ($user->role_id != 5) { // 5=admin
                return response()->json([
                    'success' => false,
                    'message' => 'Hanya admin yang dapat menghapus siswa dari kelas'
                ], 403);
            }
            
            $class = Classes::find($id);
            
            if (!$class) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas dengan ID tersebut tidak ditemukan'
                ], 404);
            }
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'student_ids' => 'required|array',
                'student_ids.*' => 'exists:users,id',
                'academic_year' => 'required|integer'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }
            
            // Remove students from class
            $removedCount = StudentClass::where('class_id', $id)
                ->where('academic_year', $request->academic_year)
                ->whereIn('student_id', $request->student_ids)
                ->delete();
            
            return response()->json([
                'success' => true,
                'message' => $removedCount . ' siswa berhasil dihapus dari kelas',
                'data' => [
                    'class' => $class,
                    'removed_count' => $removedCount
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menghapus siswa dari kelas: ' . $e->getMessage()
            ], 500);
        }
    }
}