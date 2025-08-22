<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('attendance', function (Blueprint $table) {
            // Memastikan kolom yang diperlukan ada
            if (!Schema::hasColumn('attendance', 'qr_token_used')) {
                $table->string('qr_token_used')->nullable()->after('photo_path');
            }
            
            if (!Schema::hasColumn('attendance', 'date_only')) {
                $table->date('date_only')->nullable()->after('timestamp');
            }
            
            if (!Schema::hasColumn('attendance', 'synced')) {
                $table->boolean('synced')->default(true)->after('date_only');
            }
            
            // Menambahkan indeks jika belum ada
            if (!Schema::hasIndex('attendance', 'idx_attendance_qr_token')) {
                $table->index('qr_token_used', 'idx_attendance_qr_token');
            }
            
            if (!Schema::hasIndex('attendance', 'idx_attendance_user_date')) {
                $table->index(['user_id', 'date_only'], 'idx_attendance_user_date');
            }
            
            if (!Schema::hasIndex('attendance', 'idx_attendance_timestamp')) {
                $table->index('timestamp', 'idx_attendance_timestamp');
            }
        });
        
        // Membuat trigger untuk mengisi date_only secara otomatis (jika menggunakan MySQL)
        DB::unprepared("
            CREATE TRIGGER IF NOT EXISTS trg_attendance_date_only
            BEFORE INSERT ON attendance
            FOR EACH ROW
            SET NEW.date_only = DATE(NEW.timestamp);
        ");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Menghapus trigger
        DB::unprepared("DROP TRIGGER IF EXISTS trg_attendance_date_only");
        
        Schema::table('attendance', function (Blueprint $table) {
            // Menghapus indeks
            $table->dropIndex(['idx_attendance_qr_token']);
            $table->dropIndex(['idx_attendance_user_date']);
            $table->dropIndex(['idx_attendance_timestamp']);
            
            // Menghapus kolom yang ditambahkan
            $table->dropColumn(['qr_token_used', 'date_only', 'synced']);
        });
    }
};
