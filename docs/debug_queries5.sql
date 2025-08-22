-- Periksa semua siswa di kelas 2
SELECT u.id, u.nisn_nip_nik, u.name 
FROM users u 
JOIN student_class sc ON u.id = sc.student_id 
WHERE sc.class_id = 2 AND u.role_id = 1;

id  nisn_nip_nik    name
3   1003    Citra Dewi

-- Periksa data absensi untuk kelas 2 tanggal 20 Agustus 2025
SELECT u.id, u.nisn_nip_nik, u.name, a.timestamp
FROM users u 
JOIN student_class sc ON u.id = sc.student_id 
LEFT JOIN attendance a ON u.id = a.user_id AND DATE(a.timestamp) = '2025-08-20' AND a.type = 'checkin'
WHERE sc.class_id = 2 AND u.role_id = 1
ORDER BY u.name;

id  nisn_nip_nik    name    timestamp
3   1003    Citra Dewi  2025-08-20 18:27:36
