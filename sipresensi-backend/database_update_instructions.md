# Instruksi Update Database untuk Integrasi QR Code

## Langkah-langkah Update Database

1. **Pastikan database sudah dibuat**
   ```sql
   CREATE DATABASE IF NOT EXISTS sipresensi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

2. **Jalankan migration untuk memperbarui tabel attendance**
   ```bash
   cd sipresensi-backend
   php artisan migrate
   ```

3. **Jika ingin mengisi data dummy untuk testing**
   ```sql
   -- Tambahkan beberapa token QR dummy
   INSERT INTO dynamic_qr_tokens (token, expires_at, used) VALUES
   ('DUMMY_TOKEN_1', DATE_ADD(NOW(), INTERVAL 10 SECOND), FALSE),
   ('DUMMY_TOKEN_2', DATE_ADD(NOW(), INTERVAL 10 SECOND), FALSE);
   ```

## Catatan Penting

- Migration ini akan menambahkan kolom yang diperlukan untuk integrasi QR code jika belum ada
- Trigger akan dibuat untuk mengisi kolom `date_only` secara otomatis
- Indeks akan ditambahkan untuk meningkatkan performa query