# Dokumentasi API SiPresensi - Berdasarkan Pengujian 22 Agustus 2025

## 1. Autentikasi

### POST /api/auth/login
Digunakan untuk login ke sistem dengan NISN/NIP/NIK dan password.

**Request:**
```bash
curl -X POST http://127.0.0.1:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"nisn_nip_nik": "2001", "password": "password"}'
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "user": {
      "id": 4,
      "nisn_nip_nik": "2001",
      "name": "Drs. Eko Wijaya",
      "email": "eko@sekolah.sch.id",
      "phone": "081234567893",
      "role_id": 2,
      "photo_path": "profiles/eko.jpg",
      "is_active": true,
      "created_at": "2025-08-22T18:50:35.000000Z",
      "updated_at": "2025-08-22T18:50:35.000000Z"
    },
    "token": "1|GxQ1uaUaz2BV4mweDoPvvQXuTwyDhRXvrmSwjY7l0bae28c7"
  }
}
```

### POST /api/auth/logout
Digunakan untuk logout dari sistem.

**Request:**
```bash
curl -X POST http://127.0.0.1:8000/api/auth/logout \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json"
```

## 2. Dashboard

### GET /api/dashboard
Mendapatkan data dashboard sesuai dengan role pengguna.

**Untuk Guru:**
```bash
curl -X GET http://127.0.0.1:8000/api/dashboard \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 4,
      "nisn_nip_nik": "2001",
      "name": "Drs. Eko Wijaya",
      "email": "eko@sekolah.sch.id",
      "phone": "081234567893",
      "role_id": 2,
      "photo_path": "profiles/eko.jpg",
      "is_active": true,
      "created_at": "2025-08-22T18:50:35.000000Z",
      "updated_at": "2025-08-22T18:50:35.000000Z"
    },
    "classes": [],
    "attendance_statistics": {
      "total_students": 0,
      "present": 0,
      "late": 0,
      "absent": 0
    },
    "recent_leaves": [],
    "recent_announcements": []
  }
}
```

## 3. Manajemen Kelas

### GET /api/classes
Mendapatkan daftar semua kelas.

**Request:**
```bash
curl -X GET http://127.0.0.1:8000/api/classes \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-22T18:50:35.000000Z",
      "updated_at": "2025-08-22T18:50:35.000000Z",
      "homeroom_teacher": {
        "id": 2,
        "nisn_nip_nik": "1002",
        "name": "Budi Santoso",
        "email": "budi@siswa.sch.id",
        "phone": "081234567891",
        "role_id": 1,
        "photo_path": "profiles/budi.jpg",
        "is_active": true,
        "created_at": "2025-08-22T18:50:35.000000Z",
        "updated_at": "2025-08-22T18:50:35.000000Z"
      }
    }
  ]
}
```

## 4. Absensi Siswa

### POST /api/student-attendance/scan-qr
Melakukan absensi siswa dengan scan QR atau input manual NISN.

**Dengan Input Manual NISN:**
```bash
curl -X POST http://127.0.0.1:8000/api/student-attendance/scan-qr \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json" \
  -d '{
    "nisn_nip_nik": "1001",
    "class_id": 1,
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": 50
  }'
```

**Response Sukses:**
```json
{
  "success": true,
  "student": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama"
  },
  "message": "Absensi berhasil"
}
```

### POST /api/student-attendance/bulk
Melakukan absensi massal untuk semua siswa dalam satu kelas.

**Request:**
```bash
curl -X POST http://127.0.0.1:8000/api/student-attendance/bulk \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json" \
  -d '{
    "class_id": 2
  }'
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absensi massal berhasil diproses",
  "data": {
    "class_id": 2,
    "date": "2025-08-22",
    "total_students": 1,
    "already_attended": 0,
    "newly_attended": 1,
    "processed_students": [
      {
        "id": 3,
        "nisn_nip_nik": "1003",
        "name": "Citra Dewi",
        "attended": false
      }
    ]
  }
}
```

### GET /api/student-attendance/class-status/{classId}
Mendapatkan status absensi semua siswa dalam kelas.

**Request:**
```bash
curl -X GET "http://127.0.0.1:8000/api/student-attendance/class-status/2?date=2025-08-22" \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 3,
      "nisn_nip_nik": "1003",
      "name": "Citra Dewi",
      "attended": false
    }
  ]
}
```

## 5. Absensi Pegawai/Guru/Kepsek

### GET /api/qrcode/dynamic
Mendapatkan token QR code dinamis untuk absensi.

**Request:**
```bash
curl -X GET http://127.0.0.1:8000/api/qrcode/dynamic \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Token QR dinamis berhasil diambil",
  "data": {
    "token": "L4M8S1T6U3",
    "expires_at": "2025-08-22T18:50:41.000000Z"
  }
}
```

### POST /api/qrcode/verify
Memverifikasi token QR Code dan submit absensi (checkin).

**Request:**
```bash
curl -X POST http://127.0.0.1:8000/api/qrcode/verify \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 4,
    "type": "checkin",
    "qr_token": "L4M8S1T6U3",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": 50,
    "photo": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
  }'
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen masuk berhasil",
  "data": {
    "user_id": 4,
    "type": "checkin",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "L4M8S1T6U3",
    "timestamp": "2025-08-22T12:07:55.000000Z",
    "id": 5
  }
}
```

### POST /api/attendance/checkout
Absen keluar pegawai/guru/kepsek.

**Request:**
```bash
curl -X POST http://127.0.0.1:8000/api/attendance/checkout \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json" \
  -d '{
    "qr_token": "Z7K3N9Q5R2",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": 50,
    "photo": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
  }'
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen keluar berhasil",
  "data": {
    "user_id": 4,
    "type": "checkout",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "Z7K3N9Q5R2",
    "timestamp": "2025-08-22T12:08:52.000000Z",
    "id": 6
  }
}
```

### GET /api/attendance/history
Mendapatkan riwayat absensi.

**Request:**
```bash
curl -X GET http://127.0.0.1:8000/api/attendance/history \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "success": true,
  "message": "Data riwayat absensi berhasil diambil",
  "data": [
    {
      "id": 6,
      "user_id": 4,
      "type": "checkout",
      "latitude": "-6.12345600",
      "longitude": "106.87654300",
      "accuracy": 50,
      "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
      "qr_token_used": "Z7K3N9Q5R2",
      "status": "hadir",
      "timestamp": "2025-08-22T12:08:52.000000Z",
      "date_only": "2025-08-22T00:00:00.000000Z",
      "synced": true,
      "created_at": "2025-08-22T19:08:52.000000Z"
    }
  ]
}
```

## 6. Manajemen Izin

### POST /api/leaves
Mengajukan izin baru.

**Request:**
```bash
curl -X POST http://127.0.0.1:8000/api/leaves \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json" \
  -d '{
    "leave_type": "sakit",
    "start_date": "2025-08-23",
    "end_date": "2025-08-23",
    "reason": "Sakit flu"
  }'
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengajuan izin berhasil dibuat",
  "data": {
    "user_id": 4,
    "leave_type": "sakit",
    "start_date": "2025-08-23T00:00:00.000000Z",
    "end_date": "2025-08-23T00:00:00.000000Z",
    "reason": "Sakit flu",
    "attachment_path": null,
    "status": "menunggu",
    "updated_at": "2025-08-22T12:09:22.000000Z",
    "created_at": "2025-08-22T12:09:22.000000Z",
    "id": 3
  }
}
```

### GET /api/leaves
Mendapatkan daftar izin.

**Request:**
```bash
curl -X GET http://127.0.0.1:8000/api/leaves \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

## 7. Pengumuman

### GET /api/announcements
Mendapatkan daftar pengumuman.

**Request:**
```bash
curl -X GET http://127.0.0.1:8000/api/announcements \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "success": true,
  "message": "Data pengumuman berhasil diambil",
  "data": [
    {
      "id": 1,
      "title": "Jadwal Ujian Tengah Semester",
      "content": "UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.",
      "author_id": 4,
      "is_published": true,
      "published_at": "2025-08-22T18:50:36.000000Z",
      "created_at": "2025-08-22T18:50:36.000000Z",
      "updated_at": "2025-08-22T18:50:36.000000Z"
    }
  ]
}
```

## 8. Profil Pengguna

### GET /api/profile
Mendapatkan profil user.

**Request:**
```bash
curl -X GET http://127.0.0.1:8000/api/profile \
  -H "Authorization: Bearer TOKEN_GURU" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "success": true,
  "message": "Data profil berhasil diambil",
  "data": {
    "id": 4,
    "nisn_nip_nik": "2001",
    "name": "Drs. Eko Wijaya",
    "email": "eko@sekolah.sch.id",
    "phone": "081234567893",
    "role_id": 2,
    "photo_path": "profiles/eko.jpg",
    "is_active": true,
    "created_at": "2025-08-22T18:50:35.000000Z",
    "updated_at": "2025-08-22T18:50:35.000000Z"
  }
}
```

## 9. Manajemen Pengguna (Admin Only)

### GET /api/users
Mendapatkan daftar pengguna (hanya untuk admin).

**Request:**
```bash
curl -X GET http://127.0.0.1:8000/api/users \
  -H "Authorization: Bearer TOKEN_ADMIN" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "success": true,
  "message": "Data pengguna berhasil diambil",
  "data": [
    {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "email": "andi@siswa.sch.id",
      "phone": "081234567890",
      "role_id": 1,
      "photo_path": "profiles/andi.jpg",
      "is_active": true,
      "created_at": "2025-08-22T18:50:35.000000Z",
      "updated_at": "2025-08-22T18:50:35.000000Z"
    }
  ]
}
```