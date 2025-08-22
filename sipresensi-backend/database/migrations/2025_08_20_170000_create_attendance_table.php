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
        Schema::create('attendance', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('type'); // 'checkin' or 'checkout'
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->integer('accuracy')->nullable();
            $table->string('photo_path')->nullable();
            $table->string('qr_token_used')->nullable();
            $table->string('status')->default('present'); // 'present', 'late', 'absent'
            $table->timestamp('timestamp')->nullable();
            $table->date('date_only')->nullable();
            $table->boolean('synced')->default(false);
            $table->timestamps();
            
            // Foreign key constraint
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            
            // Indexes
            $table->index('user_id');
            $table->index('type');
            $table->index('status');
            $table->index('date_only');
            $table->index('timestamp');
            $table->index('qr_token_used');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('attendance');
    }
};