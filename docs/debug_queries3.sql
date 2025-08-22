-- Periksa data absensi untuk Andi Pratama (user_id = 1) hari ini
SELECT * FROM attendance WHERE user_id = 1 AND DATE(timestamp) = '2025-08-21';
Kosong

-- Periksa data absensi terbaru untuk Andi Pratama
SELECT * FROM attendance WHERE user_id = 1 ORDER BY timestamp DESC LIMIT 5;
id	user_id	type	latitude	longitude	accuracy	photo_path	qr_token_used	status	timestamp	date_only	synced	created_at

4	1	checkout	-6.12345600	106.87654300	NULL	base64_encoded_image_string	L4M8S1T6U3	hadir	2025-08-20 18:00:52	2025-08-20	1	2025-08-21 01:00:52

3	1	checkin	-6.12345600	106.87654300	NULL	base64_encoded_image_string	L4M8S1T6U3	hadir	2025-08-20 17:58:03	2025-08-20	1	2025-08-21 00:58:03

1	1	checkin	-6.12345600	106.87654300	5.2	attendance/andi_checkin_1.jpg	QRX9B2M8P1	hadir	2025-04-05 07:25:30	2025-04-05	1	2025-08-20 23:30:07
