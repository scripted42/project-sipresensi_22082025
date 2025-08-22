-- Periksa data absensi untuk Citra Dewi (user_id = 3) hari ini
SELECT * FROM attendance WHERE user_id = 3 AND DATE(timestamp) = '2025-08-21';

Kosong

-- Periksa semua data absensi hari ini
SELECT a.*, u.name FROM attendance a JOIN users u ON a.user_id = u.id WHERE DATE(a.timestamp) = '2025-08-21';

Kosong

-- Periksa relasi siswa dan kelas untuk Citra Dewi
SELECT u.name, c.name as class_name FROM users u 
JOIN student_class sc ON u.id = sc.student_id 
JOIN classes c ON sc.class_id = c.id 
WHERE u.id = 3;

name	class_name
Citra Dewi	X IPS 2

-- Periksa data QR card untuk Citra Dewi
SELECT * FROM student_qr_cards WHERE student_id = 3;

id	student_id	qr_code	is_active	generated_at	created_at	updated_at	
3	3	1003	1	2025-08-20 18:26:38	2025-08-20 18:26:38	2025-08-20 18:26:38
