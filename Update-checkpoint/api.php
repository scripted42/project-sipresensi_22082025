<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\AttendanceController;
use App\Http\Controllers\API\LeaveController;
use App\Http\Controllers\API\AnnouncementController;
use App\Http\Controllers\API\ProfileController;
use App\Http\Controllers\API\QRCodeController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\StudentAttendanceController;
use App\Http\Controllers\API\ClassController;
use App\Http\Controllers\API\StudentQrCardController;
use App\Http\Controllers\API\OfflineSyncController;
use App\Http\Controllers\API\SettingController;
use App\Http\Controllers\API\DashboardController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and assigned to the "api" group.
|
*/

// Route untuk autentikasi tanpa middleware
Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
});

// Route yang memerlukan autentikasi
Route::middleware('auth:sanctum')->group(function () {
    // User routes
    Route::get('/user', [AuthController::class, 'user']);
    
    // Dashboard route
    Route::get('/dashboard', [DashboardController::class, 'index']);
    
    // Attendance routes
    Route::prefix('attendance')->group(function () {
        Route::post('/checkin', [AttendanceController::class, 'checkin']);
        Route::post('/checkout', [AttendanceController::class, 'checkout']);
        Route::get('/history', [AttendanceController::class, 'history']);
    });
    
    // Student Attendance routes (for teachers)
    Route::prefix('student-attendance')->group(function () {
        Route::post('/scan-qr', [StudentAttendanceController::class, 'scanStudentQR']);
        Route::post('/bulk', [StudentAttendanceController::class, 'bulkAttendance']);
        Route::get('/class-status/{classId}', [StudentAttendanceController::class, 'getClassAttendanceStatus']);
    });
    
    // Leave routes
    Route::prefix('leaves')->group(function () {
        Route::get('/', [LeaveController::class, 'index']);
        Route::post('/', [LeaveController::class, 'store']);
        Route::get('/{id}', [LeaveController::class, 'show']);
        Route::put('/{id}', [LeaveController::class, 'update']);
        Route::delete('/{id}', [LeaveController::class, 'destroy']);
    });
    
    // Announcement routes
    Route::prefix('announcements')->group(function () {
        Route::get('/', [AnnouncementController::class, 'index']);
        Route::get('/{id}', [AnnouncementController::class, 'show']);
        Route::post('/', [AnnouncementController::class, 'store']);
        Route::put('/{id}', [AnnouncementController::class, 'update']);
        Route::delete('/{id}', [AnnouncementController::class, 'destroy']);
    });
    
    // Profile routes
    Route::prefix('profile')->group(function () {
        Route::get('/', [ProfileController::class, 'show']);
        Route::put('/', [ProfileController::class, 'update']);
        Route::put('/password', [ProfileController::class, 'updatePassword']);
    });
    
    // QR Code routes
    Route::prefix('qrcode')->group(function () {
        Route::get('/dynamic', [QRCodeController::class, 'getDynamicQR']);
        Route::post('/verify', [QRCodeController::class, 'verifyQRAndSubmitAttendance']);
    });
    
    // Class management routes (admin, kepala sekolah, and teachers)
    Route::prefix('classes')->group(function () {
        Route::get('/', [ClassController::class, 'index']); // Get all classes
        Route::get('/{id}', [ClassController::class, 'show']); // Get class by ID
        Route::post('/', [ClassController::class, 'store']); // Create new class (admin only)
        Route::put('/{id}', [ClassController::class, 'update']); // Update class (admin only)
        Route::delete('/{id}', [ClassController::class, 'destroy']); // Delete class (admin only)
        Route::get('/{id}/students', [ClassController::class, 'getStudents']); // Get students in class
        Route::post('/{id}/assign-students', [ClassController::class, 'assignStudents']); // Assign students to class (admin only)
        Route::post('/{id}/remove-students', [ClassController::class, 'removeStudents']); // Remove students from class (admin only)
    });
    
    // Student QR Card routes (admin and kepala sekolah)
    Route::prefix('student-qr-cards')->group(function () {
        Route::get('/', [StudentQrCardController::class, 'index']); // Get all student QR cards
        Route::get('/{id}', [StudentQrCardController::class, 'show']); // Get student QR card by ID
        Route::post('/generate', [StudentQrCardController::class, 'generate']); // Generate new QR code for student
        Route::put('/{id}/status', [StudentQrCardController::class, 'updateStatus']); // Update status of QR card
    });
    
    // Offline Sync routes (admin and kepala sekolah)
    Route::prefix('offline-sync')->group(function () {
        Route::get('/', [OfflineSyncController::class, 'index']); // Get all sync logs
        Route::get('/{id}', [OfflineSyncController::class, 'show']); // Get sync log by ID
        Route::post('/process-attendance', [OfflineSyncController::class, 'processAttendance']); // Process offline attendance data
        Route::post('/{id}/retry', [OfflineSyncController::class, 'retry']); // Retry failed sync
    });
    
    // Settings routes (admin only)
    Route::prefix('settings')->group(function () {
        Route::get('/', [SettingController::class, 'index']); // Get all settings
        Route::get('/{key}', [SettingController::class, 'show']); // Get setting by key
        Route::put('/{key}', [SettingController::class, 'update']); // Update setting by key
        Route::put('/bulk-update', [SettingController::class, 'bulkUpdate']); // Bulk update settings
    });
    
    // User management routes (admin only)
    Route::prefix('users')->group(function () {
        Route::get('/', [UserController::class, 'index']);
        Route::post('/', [UserController::class, 'store']);
        Route::get('/{id}', [UserController::class, 'show']);
        Route::put('/{id}', [UserController::class, 'update']);
        Route::delete('/{id}', [UserController::class, 'destroy']);
    });
});