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
        Schema::create('student_qr_cards', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('student_id');
            $table->string('qr_code')->unique();
            $table->boolean('is_active')->default(true);
            $table->timestamp('generated_at')->useCurrent();
            $table->timestamps();
            
            // Menambahkan index sebelum foreign key
            $table->index('student_id');
            $table->index('qr_code');
            $table->index('is_active');
            
            // Menambahkan foreign key constraint
            $table->foreign('student_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('student_qr_cards');
    }
};
