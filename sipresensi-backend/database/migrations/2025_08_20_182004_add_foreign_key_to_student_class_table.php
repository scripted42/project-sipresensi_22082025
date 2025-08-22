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
        Schema::table('student_class', function (Blueprint $table) {
            // Menambahkan foreign key constraints jika belum ada
            if (!Schema::hasColumn('student_class', 'created_at')) {
                $table->timestamps();
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('student_class', function (Blueprint $table) {
            if (Schema::hasColumn('student_class', 'created_at')) {
                $table->dropTimestamps();
            }
        });
    }
};
