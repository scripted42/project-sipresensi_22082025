<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Laravel\Sanctum\PersonalAccessToken;

class CheckActivityTimeout
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        // Cek apakah pengguna terautentikasi dengan Sanctum
        if (Auth::check()) {
            $user = Auth::user();
            
            // Dapatkan token saat ini
            $token = $user->currentAccessToken();
            
            // Periksa apakah token ada dan memiliki timestamp aktivitas terakhir
            if ($token && $token->last_activity_at) {
                // Hitung selisih waktu dalam menit
                $minutesSinceLastActivity = now()->diffInMinutes($token->last_activity_at);
                
                // Jika lebih dari 15 menit, logout paksa
                if ($minutesSinceLastActivity > 15) {
                    // Hapus token
                    $token->delete();
                    
                    // Kembalikan response unauthorized
                    return response()->json([
                        'success' => false,
                        'message' => 'Sesi Anda telah kedaluwarsa karena tidak ada aktivitas selama 15 menit. Silakan login kembali.',
                        'code' => 'SESSION_TIMEOUT'
                    ], 401);
                }
            }
            
            // Perbarui timestamp aktivitas terakhir
            if ($token) {
                $token->forceFill([
                    'last_activity_at' => now()
                ])->save();
            }
        }

        return $next($request);
    }
}