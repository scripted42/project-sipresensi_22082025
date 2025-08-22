<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use App\Models\StudentQrCard;

class GenerateStudentQRCodes extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'student-qr:generate {--role-id=1 : Role ID for students (default: 1 for siswa)}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Generate QR codes for all students';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $roleId = $this->option('role-id');
        
        $this->info("Generating QR codes for students with role ID: {$roleId}");
        
        // Get all students
        $students = User::where('role_id', $roleId)->get();
        
        $this->info("Found {$students->count()} students");
        
        $generatedCount = 0;
        $skippedCount = 0;
        
        foreach ($students as $student) {
            // Check if QR code already exists
            $existingQr = StudentQrCard::where('student_id', $student->id)->first();
            
            if ($existingQr) {
                $this->line("Skipping {$student->nisn_nip_nik} - QR code already exists");
                $skippedCount++;
                continue;
            }
            
            // Generate QR code (using student's NISN as the code)
            $qrCode = $student->nisn_nip_nik;
            
            // Create QR card record
            $qrCard = new StudentQrCard();
            $qrCard->student_id = $student->id;
            $qrCard->qr_code = $qrCode;
            $qrCard->is_active = true;
            $qrCard->generated_at = now();
            $qrCard->save();
            
            $this->info("Generated QR code for {$student->nisn_nip_nik} ({$student->name})");
            $generatedCount++;
        }
        
        $this->info("QR code generation completed!");
        $this->info("Generated: {$generatedCount} codes");
        $this->info("Skipped: {$skippedCount} students (already had QR codes)");
        
        return Command::SUCCESS;
    }
}
