-- -----------------------------------------------------
-- Database: sipresensi
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS sipresensi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sipresensi;

-- -----------------------------------------------------
-- Tabel: migrations
-- Tabel yang diperlukan oleh Laravel untuk tracking migrasi
-- -----------------------------------------------------
CREATE TABLE migrations (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    migration VARCHAR(255) NOT NULL,
    batch INT NOT NULL
);

-- -----------------------------------------------------
-- Tabel: roles
-- Menyimpan peran pengguna
-- -----------------------------------------------------
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO roles (name, description) VALUES
('siswa', 'Siswa aktif di sekolah'),
('guru', 'Guru pengajar'),
('pegawai', 'Staf administrasi atau non-pengajar'),
('kepala_sekolah', 'Kepala Sekolah'),
('admin', 'Administrator sistem');

-- -----------------------------------------------------
-- Tabel: users
-- Data pengguna dengan password di-hash
-- -----------------------------------------------------
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nisn_nip_nik VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    photo_path VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT
);

-- Password: 'password' -> bcrypt hash (dihasilkan Laravel)
INSERT INTO users (nisn_nip_nik, name, email, phone, password, role_id, photo_path) VALUES
-- Siswa
('1001', 'Andi Pratama', 'andi@siswa.sch.id', '081234567890', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'profiles/andi.jpg'),
('1002', 'Budi Santoso', 'budi@siswa.sch.id', '081234567891', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'profiles/budi.jpg'),
('1003', 'Citra Dewi', 'citra@siswa.sch.id', '081234567892', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 'profiles/citra.jpg'),
-- Guru
('2001', 'Drs. Eko Wijaya', 'eko@sekolah.sch.id', '081234567893', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, 'profiles/eko.jpg'),
('2002', 'Siti Rahayu, S.Pd', 'siti@sekolah.sch.id', '081234567894', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, 'profiles/siti.jpg'),
-- Pegawai
('3001', 'Agus Setiawan', 'agus@sekolah.sch.id', '081234567895', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, 'profiles/agus.jpg'),
-- Kepala Sekolah
('4001', 'Dr. Haryanto, M.Pd', 'haryanto@sekolah.sch.id', '081234567896', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 4, 'profiles/haryanto.jpg'),
-- Admin
('5001', 'Admin Utama', 'admin@sekolah.sch.id', '081234567897', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 5, 'profiles/admin.jpg');

-- -----------------------------------------------------
-- Tabel: classes
-- Kelas sekolah
-- -----------------------------------------------------
CREATE TABLE classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    homeroom_teacher_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (homeroom_teacher_id) REFERENCES users(id) ON DELETE SET NULL
);

INSERT INTO classes (name, homeroom_teacher_id) VALUES
('X IPA 1', 2),
('X IPS 2', 3),
('XI Bahasa', 2);

-- -----------------------------------------------------
-- Tabel: student_class
-- Relasi siswa-kelas
-- -----------------------------------------------------
CREATE TABLE student_class (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    class_id INT NOT NULL,
    academic_year YEAR NOT NULL DEFAULT 2025,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_student_class (student_id, class_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
);

INSERT INTO student_class (student_id, class_id, academic_year) VALUES
(1, 1, 2025),
(2, 1, 2025),
(3, 2, 2025);

-- -----------------------------------------------------
-- Tabel: student_qr_cards
-- QR Code statis untuk siswa
-- -----------------------------------------------------
CREATE TABLE student_qr_cards (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    qr_code VARCHAR(255) NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_student_id (student_id),
    INDEX idx_qr_code (qr_code),
    INDEX idx_is_active (is_active),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Data Dummy: student_qr_cards
INSERT INTO student_qr_cards (student_id, qr_code) VALUES
(1, '1001'), -- QR card untuk Andi Pratama
(2, '1002'), -- QR card untuk Budi Santoso
(3, '1003'); -- QR card untuk Citra Dewi

-- -----------------------------------------------------
-- Tabel: attendance
-- Catatan absensi
-- -----------------------------------------------------
CREATE TABLE attendance (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    type ENUM('checkin', 'checkout') NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    accuracy FLOAT,
    photo_path VARCHAR(255),
    qr_token_used VARCHAR(255),
    status ENUM('hadir', 'terlambat', 'izin', 'sakit', 'alpha') DEFAULT 'hadir',
    timestamp DATETIME NOT NULL,
    date_only DATE, -- Kolom baru untuk indeks
    synced BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Isi date_only dari timestamp
UPDATE attendance SET date_only = DATE(timestamp);

-- Buat indeks pada user_id dan date_only
CREATE INDEX idx_attendance_user_date ON attendance (user_id, date_only);
CREATE INDEX idx_attendance_timestamp ON attendance (timestamp);
CREATE INDEX idx_attendance_qr_token ON attendance (qr_token_used);

-- Trigger: Isi date_only otomatis saat INSERT
DELIMITER $$
CREATE TRIGGER trg_attendance_date_only
    BEFORE INSERT ON attendance
    FOR EACH ROW
BEGIN
    SET NEW.date_only = DATE(NEW.timestamp);
END$$
DELIMITER ;

-- Data Dummy: attendance
INSERT INTO attendance (user_id, type, latitude, longitude, accuracy, photo_path, qr_token_used, timestamp) VALUES
(1, 'checkin', -6.123456, 106.876543, 5.2, 'attendance/andi_checkin_1.jpg', 'QRX9B2M8P1', '2025-04-05 07:25:30'),
(2, 'checkin', -6.123456, 106.876543, 6.1, 'attendance/budi_checkin_1.jpg', 'QRX9B2M8P1', '2025-04-05 07:28:12');

-- -----------------------------------------------------
-- Tabel: dynamic_qr_tokens
-- QR Code dinamis berganti tiap 10 detik
-- -----------------------------------------------------
CREATE TABLE dynamic_qr_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(255) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    used_by BIGINT,
    used_at DATETIME,
    INDEX idx_token (token),
    INDEX idx_expires (expires_at),
    FOREIGN KEY (used_by) REFERENCES users(id) ON DELETE SET NULL
);

INSERT INTO dynamic_qr_tokens (token, expires_at, used) VALUES
('QRX9B2M8P1', DATE_ADD(NOW(), INTERVAL 10 SECOND), TRUE),
('Z7K3N9Q5R2', DATE_ADD(NOW(), INTERVAL 10 SECOND), FALSE),
('L4M8S1T6U3', DATE_ADD(NOW(), INTERVAL 5 SECOND), FALSE);

-- -----------------------------------------------------
-- Tabel: leaves
-- Pengajuan izin
-- -----------------------------------------------------
CREATE TABLE leaves (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    leave_type ENUM('izin', 'cuti', 'dinas_luar', 'sakit') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    attachment_path VARCHAR(255),
    status ENUM('menunggu', 'disetujui', 'ditolak') DEFAULT 'menunggu',
    approved_by BIGINT,
    approval_comment TEXT,
    approved_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_leaves_user_status ON leaves (user_id, status);
CREATE INDEX idx_leaves_date ON leaves (start_date, end_date);

INSERT INTO leaves (user_id, leave_type, start_date, end_date, reason, attachment_path, status, approved_by, approved_at) VALUES
(1, 'sakit', '2025-04-06', '2025-04-06', 'Demam tinggi, dokter sudah memberi surat.', 'leaves/surat_andi.pdf', 'disetujui', 4, '2025-04-05 10:30:00'),
(2, 'izin', '2025-04-07', '2025-04-07', 'Acara keluarga.', NULL, 'menunggu', NULL, NULL);

-- -----------------------------------------------------
-- Tabel: announcements
-- Pengumuman
-- -----------------------------------------------------
CREATE TABLE announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id BIGINT NOT NULL,
    is_published BOOLEAN DEFAULT TRUE,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_announcements_published ON announcements (is_published, published_at);

INSERT INTO announcements (title, content, author_id) VALUES
('Jadwal Ujian Tengah Semester', 'UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.', 4),
('Libur Hari Raya', 'Sekolah libur mulai 1 Mei 2025 hingga 5 Mei 2025.', 5);

-- -----------------------------------------------------
-- Tabel: settings
-- Konfigurasi sistem
-- -----------------------------------------------------
CREATE TABLE settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    key_name VARCHAR(100) NOT NULL UNIQUE,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO settings (key_name, value, description) VALUES
('attendance_radius', '100', 'Radius absensi dalam meter'),
('school_latitude', '-6.123456', 'Koordinat latitude sekolah'),
('school_longitude', '106.876543', 'Koordinat longitude sekolah'),
('checkin_start', '06:30:00', 'Waktu mulai check-in'),
('checkin_end', '07:30:00', 'Batas waktu check-in'),
('qr_refresh_interval', '15', 'Interval pergantian QR Code dinamis dalam detik'),
('app_name', 'Sipresensi', 'Nama aplikasi'),
('school_name', 'SMAN 1 Kota Edukasi', 'Nama sekolah');

-- -----------------------------------------------------
-- Tabel: offline_sync_log
-- Log sinkronisasi offline
-- -----------------------------------------------------
CREATE TABLE offline_sync_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    data JSON NOT NULL,
    synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'success', 'failed') DEFAULT 'pending',
    error_message TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO offline_sync_log (user_id, action_type, data, status) VALUES
(1, 'attendance', '{"type": "checkin", "timestamp": "2025-04-05 07:25:00"}', 'success');

-- -----------------------------------------------------
-- Tabel: personal_access_tokens
-- Tabel yang diperlukan oleh Laravel Sanctum untuk autentikasi API
-- -----------------------------------------------------
CREATE TABLE personal_access_tokens (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tokenable_type VARCHAR(255) NOT NULL,
    tokenable_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    token VARCHAR(64) NOT NULL,
    abilities TEXT,
    last_used_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    INDEX personal_access_tokens_tokenable_index (tokenable_type, tokenable_id),
    UNIQUE KEY personal_access_tokens_token_unique (token)
);

-- -----------------------------------------------------
-- Tabel: cache
-- Tabel yang diperlukan oleh Laravel untuk caching
-- -----------------------------------------------------
CREATE TABLE cache (
    `key` VARCHAR(255) NOT NULL,
    `value` TEXT NOT NULL,
    `expiration` INT NOT NULL,
    PRIMARY KEY (`key`)
);

-- -----------------------------------------------------
-- Tabel: cache_locks
-- Tabel yang diperlukan oleh Laravel untuk caching
-- -----------------------------------------------------
CREATE TABLE cache_locks (
    `key` VARCHAR(255) NOT NULL,
    `owner` VARCHAR(255) NOT NULL,
    `expiration` INT NOT NULL,
    PRIMARY KEY (`key`)
);

-- -----------------------------------------------------
-- Tabel: jobs
-- Tabel yang diperlukan oleh Laravel untuk queue jobs
-- -----------------------------------------------------
CREATE TABLE jobs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    queue VARCHAR(255) NOT NULL,
    payload LONGTEXT NOT NULL,
    attempts TINYINT UNSIGNED NOT NULL,
    reserved_at INT UNSIGNED,
    available_at INT UNSIGNED NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX jobs_queue_index (queue)
);

-- -----------------------------------------------------
-- Tabel: job_batches
-- Tabel yang diperlukan oleh Laravel untuk batch jobs
-- -----------------------------------------------------
CREATE TABLE job_batches (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    total_jobs INT NOT NULL,
    pending_jobs INT NOT NULL,
    failed_jobs INT NOT NULL,
    failed_job_ids LONGTEXT NOT NULL,
    options MEDIUMTEXT,
    cancelled_at INT,
    created_at INT NOT NULL,
    finished_at INT,
    PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- Tabel: failed_jobs
-- Tabel yang diperlukan oleh Laravel untuk failed jobs
-- -----------------------------------------------------
CREATE TABLE failed_jobs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid VARCHAR(255) NOT NULL UNIQUE,
    connection TEXT NOT NULL,
    queue TEXT NOT NULL,
    payload LONGTEXT NOT NULL,
    exception LONGTEXT NOT NULL,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Tabel: sessions
-- Tabel yang diperlukan oleh Laravel untuk session management
-- -----------------------------------------------------
CREATE TABLE sessions (
    id VARCHAR(255) NOT NULL,
    user_id BIGINT UNSIGNED,
    ip_address VARCHAR(45),
    user_agent TEXT,
    payload LONGTEXT NOT NULL,
    last_activity INT NOT NULL,
    PRIMARY KEY (id),
    INDEX sessions_user_id_index (user_id),
    INDEX sessions_last_activity_index (last_activity)
);

-- -----------------------------------------------------
-- Insert data ke tabel migrations untuk menandai migrasi sudah dilakukan
-- -----------------------------------------------------
INSERT INTO migrations (migration, batch) VALUES
('0001_01_01_000000_create_users_table', 1),
('0001_01_01_000001_create_cache_table', 1),
('0001_01_01_000002_create_jobs_table', 1),
('2025_08_20_150235_create_personal_access_tokens_table', 1);