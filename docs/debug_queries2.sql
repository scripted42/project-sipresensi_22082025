-- Periksa data absensi untuk Citra Dewi (user_id = 3) hari ini
SELECT * FROM attendance WHERE user_id = 3 AND DATE(timestamp) = '2025-08-21';

Kosong

-- Periksa semua data absensi hari ini
SELECT a.*, u.name FROM attendance a JOIN users u ON a.user_id = u.id WHERE DATE(a.timestamp) = '2025-08-21';

Kosong

-- Periksa data absensi terbaru untuk Citra Dewi
SELECT * FROM attendance WHERE user_id = 3 ORDER BY timestamp DESC LIMIT 5;
id	user_id	type	latitude	longitude	accuracy	photo_path	qr_token_used	status	timestamp	date_only	synced	created_at

7	3	checkin	-6.12345600	106.87654300	NULL	NULL	1003	hadir	2025-08-20 18:27:36	2025-08-20	1	2025-08-21 01:27:36
