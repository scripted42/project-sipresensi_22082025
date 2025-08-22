<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\DynamicQRToken;

class GenerateDynamicQRToken extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'qrcode:generate-token';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Generate a new dynamic QR token for attendance';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        try {
            // Bersihkan token yang sudah kadaluarsa
            DynamicQRToken::expired()->delete();
            
            // Buat token baru
            $qrToken = new DynamicQRToken();
            $qrToken->token = bin2hex(random_bytes(16));
            $qrToken->created_at = now();
            $qrToken->expires_at = now()->addSeconds(10); // Token kadaluarsa dalam 10 detik
            $qrToken->used = false;
            $qrToken->save();
            
            $this->info('New QR token generated: ' . $qrToken->token);
            $this->info('Expires at: ' . $qrToken->expires_at);
            
            return Command::SUCCESS;
        } catch (\Exception $e) {
            $this->error('Failed to generate QR token: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}
