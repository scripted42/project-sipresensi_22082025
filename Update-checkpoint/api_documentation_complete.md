# Dokumentasi API Lengkap SiPresensi

## Daftar Isi
1. [Autentikasi](#1-autentikasi)
2. [User & Profil](#2-user--profil)
3. [QR Code](#3-qr-code)
4. [Absensi Pegawai/Guru/Kepsek](#4-absensi-pegawaiguru/kepsek)
5. [Absensi Siswa](#5-absensi-siswa)
6. [Manajemen Izin](#6-manajemen-izin)
7. [Pengumuman](#7-pengumuman)
8. [Manajemen Kelas](#8-manajemen-kelas)
9. [Student QR Cards](#9-student-qr-cards)
10. [Offline Sync](#10-offline-sync)
11. [Settings](#11-settings)
12. [Dashboard](#12-dashboard)
13. [Manajemen Pengguna](#13-manajemen-pengguna)

---

## 1. Autentikasi

### POST /api/auth/login
**Deskripsi:** Login dengan `nisn_nip_nik` dan `password`
**Headers:**
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "string",
  "password": "string"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "user": {
      "id": 8,
      "nisn_nip_nik": "5001",
      "name": "Admin Utama",
      "email": "admin@sekolah.sch.id",
      "phone": "081234567897",
      "role_id": 5,
      "photo_path": "profiles/admin.jpg",
      "is_active": true,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    },
    "token": "18|GYwljnaQN5wdl11RpKDgO08YWJMRSFAxIDsH8bpV66f2ef83"
  }
}
```

**Response Gagal (Kredensial tidak valid):**
```json
{
  "success": false,
  "message": "Kredensial tidak valid"
}
```

### POST /api/auth/logout
**Deskripsi:** Logout (jika menggunakan token berbasis sesi)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Logout berhasil"
}
```

**Response Gagal (Token tidak valid):**
```json
{
  "success": false,
  "message": "Token tidak valid"
}
```

---

## 2. User & Profil

### GET /api/user
**Deskripsi:** Mendapatkan data user yang sedang login
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data user berhasil diambil",
  "data": {
    "user": {
      "id": 8,
      "nisn_nip_nik": "5001",
      "name": "Admin Utama",
      "email": "admin@sekolah.sch.id",
      "phone": "081234567897",
      "role_id": 5,
      "photo_path": "profiles/admin.jpg",
      "is_active": true,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    }
  }
}
```

### GET /api/profile
**Deskripsi:** Mendapatkan profil user
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data profil berhasil diambil",
  "data": {
    "id": 8,
    "nisn_nip_nik": "5001",
    "name": "Admin Utama",
    "email": "admin@sekolah.sch.id",
    "phone": "081234567897",
    "role_id": 5,
    "photo_path": "profiles/admin.jpg",
    "is_active": true,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-21T08:54:57.000000Z"
  }
}
```

### PUT /api/profile
**Deskripsi:** Memperbarui profil
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "name": "string (optional)",
  "email": "string|email (optional)",
  "phone": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Profil berhasil diperbarui",
  "data": {
    "id": 8,
    "nisn_nip_nik": "5001",
    "name": "Admin Utama - Updated",
    "email": "admin.updated@sekolah.sch.id",
    "phone": "081234567898",
    "role_id": 5,
    "photo_path": "profiles/admin.jpg",
    "is_active": true,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-22T15:00:00.000000Z"
  }
}
```

### PUT /api/profile/password
**Deskripsi:** Mengganti password
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "current_password": "string",
  "new_password": "string",
  "new_password_confirmation": "string"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Password berhasil diubah"
}
```

**Response Gagal (Password saat ini salah):**
```json
{
  "success": false,
  "message": "Password saat ini salah"
}
```

---

## 3. QR Code

### GET /api/qrcode/dynamic
**Deskripsi:** Mendapatkan token QR code dinamis untuk absensi
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Token QR dinamis berhasil diambil",
  "data": {
    "token": "46e5f7ecb74314c9f02a121933523548",
    "expires_at": "2025-08-21T10:29:31.000000Z"
  }
}
```

### POST /api/qrcode/verify
**Deskripsi:** Memverifikasi token QR Code dan submit absensi (checkin/checkout)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "user_id": "integer",
  "type": "string (checkin|checkout)",
  "qr_token": "string",
  "latitude": "float",
  "longitude": "float",
  "accuracy": "float (optional)",
  "photo": "string (base64 encoded image)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen masuk berhasil",
  "data": {
    "user_id": 8,
    "type": "checkin",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
    "timestamp": "2025-08-21T10:29:30.000000Z",
    "id": 8
  }
}
```

---

## 4. Absensi Pegawai/Guru/Kepsek

### POST /api/attendance/checkin
**Deskripsi:** Absen masuk pegawai/guru/kepsek
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_token": "string",
  "latitude": "float",
  "longitude": "float",
  "accuracy": "float (optional)",
  "photo": "string (base64 encoded image, optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen masuk berhasil",
  "data": {
    "id": 8,
    "user_id": 8,
    "type": "checkin",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
    "status": "hadir",
    "timestamp": "2025-08-21T10:29:30.000000Z",
    "date_only": "2025-08-21",
    "synced": true,
    "created_at": "2025-08-21T10:29:30.000000Z"
  }
}
```

### POST /api/attendance/checkout
**Deskripsi:** Absen keluar pegawai/guru/kepsek
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_token": "string",
  "latitude": "float",
  "longitude": "float",
  "accuracy": "float (optional)",
  "photo": "string (base64 encoded image, optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen keluar berhasil",
  "data": {
    "id": 9,
    "user_id": 8,
    "type": "checkout",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
    "status": "hadir",
    "timestamp": "2025-08-21T16:30:00.000000Z",
    "date_only": "2025-08-21",
    "synced": true,
    "created_at": "2025-08-21T16:30:00.000000Z"
  }
}
```

### GET /api/attendance/history
**Deskripsi:** Mendapatkan riwayat absensi
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `start_date`: YYYY-MM-DD (optional)
- `end_date`: YYYY-MM-DD (optional)
- `per_page`: integer (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 8,
        "user_id": 8,
        "type": "checkin",
        "latitude": "-6.12345600",
        "longitude": "106.87654300",
        "accuracy": 50,
        "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
        "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
        "status": "hadir",
        "timestamp": "2025-08-21T10:29:30.000000Z",
        "date_only": "2025-08-21",
        "synced": true,
        "created_at": "2025-08-21T10:29:30.000000Z"
      }
    ],
    "first_page_url": "http://127.0.0.1:8000/api/attendance/history?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/attendance/history?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/attendance/history",
    "per_page": 15,
    "prev_page_url": null,
    "to": 1,
    "total": 1
  }
}
```

---

## 5. Absensi Siswa

### POST /api/student-attendance/scan-qr
**Deskripsi:** Scan QR code siswa atau input manual NISN/NIP/NIK untuk absen
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "qr_code": "string (optional*)",
  "nisn_nip_nik": "string (optional*)",
  "class_id": "integer",
  "latitude": "float",
  "longitude": "float",
  "accuracy": "float (optional)",
  "photo": "string (base64 encoded image, optional)"
}
```
*Harus menyediakan salah satu dari `qr_code` atau `nisn_nip_nik`.

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
**Deskripsi:** Absensi massal untuk semua siswa dalam satu kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "class_id": "integer",
  "date": "string (YYYY-MM-DD, optional, default: hari ini)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absensi massal berhasil diproses",
  "data": {
    "class_id": 1,
    "date": "2025-08-22",
    "total_students": 30,
    "already_attended": 5,
    "newly_attended": 25,
    "processed_students": [
      {
        "id": 1,
        "nisn_nip_nik": "1001",
        "name": "Andi Pratama",
        "attended": true
      },
      {
        "id": 2,
        "nisn_nip_nik": "1002",
        "name": "Budi Santoso",
        "attended": false
      }
      // ... daftar semua siswa dalam kelas
    ]
  }
}
```

### GET /api/student-attendance/class-status/{classId}
**Deskripsi:** Mendapatkan status absensi semua siswa dalam kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- date: YYYY-MM-DD (optional, default: hari ini)

**Response Sukses:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "attended": true
    },
    {
      "id": 2,
      "nisn_nip_nik": "1002",
      "name": "Budi Santoso",
      "attended": false
    }
  ]
}
```

---

## 6. Manajemen Izin

### GET /api/leaves
**Deskripsi:** Mendapatkan daftar izin (dengan filter)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `status`: menunggu|disetujui|ditolak (optional)
- `leave_type`: izin|cuti|dinas_luar|sakit (optional)
- `start_date`: YYYY-MM-DD (optional)
- `end_date`: YYYY-MM-DD (optional)
- `per_page`: integer (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengajuan izin berhasil diambil",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "user_id": 1,
        "leave_type": "sakit",
        "start_date": "2025-04-06T00:00:00.000000Z",
        "end_date": "2025-04-06T00:00:00.000000Z",
        "reason": "Demam tinggi, dokter sudah memberi surat.",
        "attachment_path": "leaves/surat_andi.pdf",
        "status": "disetujui",
        "approved_by": 4,
        "approval_comment": null,
        "approved_at": "2025-04-05T10:30:00.000000Z",
        "created_at": "2025-04-05T09:00:00.000000Z",
        "updated_at": "2025-04-05T10:30:00.000000Z"
      }
    ],
    "first_page_url": "http://127.0.0.1:8000/api/leaves?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/leaves?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/leaves",
    "per_page": 15,
    "prev_page_url": null,
    "to": 1,
    "total": 1
  }
}
```

### POST /api/leaves
**Deskripsi:** Mengajukan izin baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "leave_type": "string (izin|cuti|dinas_luar|sakit)",
  "start_date": "string (YYYY-MM-DD)",
  "end_date": "string (YYYY-MM-DD)",
  "reason": "string",
  "attachment_path": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengajuan izin berhasil dibuat",
  "data": {
    "user_id": 8,
    "leave_type": "izin",
    "start_date": "2025-08-22T00:00:00.000000Z",
    "end_date": "2025-08-22T00:00:00.000000Z",
    "reason": "Perlu izin untuk keperluan pribadi",
    "attachment_path": null,
    "status": "menunggu",
    "updated_at": "2025-08-21T10:15:36.000000Z",
    "created_at": "2025-08-21T10:15:36.000000Z",
    "id": 3
  }
}
```

### GET /api/leaves/{id}
**Deskripsi:** Mendapatkan detail izin
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengajuan izin berhasil diambil",
  "data": {
    "id": 1,
    "user_id": 1,
    "leave_type": "sakit",
    "start_date": "2025-04-06T00:00:00.000000Z",
    "end_date": "2025-04-06T00:00:00.000000Z",
    "reason": "Demam tinggi, dokter sudah memberi surat.",
    "attachment_path": "leaves/surat_andi.pdf",
    "status": "disetujui",
    "approved_by": 4,
    "approval_comment": null,
    "approved_at": "2025-04-05T10:30:00.000000Z",
    "created_at": "2025-04-05T09:00:00.000000Z",
    "updated_at": "2025-04-05T10:30:00.000000Z"
  }
}
```

### PUT /api/leaves/{id}
**Deskripsi:** Memperbarui izin (misalnya untuk persetujuan)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "status": "string (disetujui|ditolak)",
  "approval_comment": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Status pengajuan izin berhasil diperbarui",
  "data": {
    "id": 3,
    "user_id": 8,
    "leave_type": "izin",
    "start_date": "2025-08-22T00:00:00.000000Z",
    "end_date": "2025-08-22T00:00:00.000000Z",
    "reason": "Perlu izin untuk keperluan pribadi",
    "attachment_path": null,
    "status": "disetujui",
    "approved_by": 8,
    "approval_comment": "Disetujui",
    "approved_at": "2025-08-21T10:20:00.000000Z",
    "created_at": "2025-08-21T10:15:36.000000Z",
    "updated_at": "2025-08-21T10:20:00.000000Z"
  }
}
```

### DELETE /api/leaves/{id}
**Deskripsi:** Menghapus izin
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengajuan izin berhasil dihapus"
}
```

---

## 7. Pengumuman

### GET /api/announcements
**Deskripsi:** Mendapatkan daftar pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `per_page`: integer (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengumuman berhasil diambil",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "title": "Jadwal Ujian Tengah Semester",
        "content": "UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.",
        "author_id": 4,
        "is_published": true,
        "published_at": "2025-08-21T08:54:58.000000Z",
        "created_at": "2025-08-21T08:54:58.000000Z",
        "updated_at": "2025-08-21T08:54:58.000000Z"
      }
    ],
    "first_page_url": "http://127.0.0.1:8000/api/announcements?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/announcements?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/announcements",
    "per_page": 15,
    "prev_page_url": null,
    "to": 1,
    "total": 1
  }
}
```

### POST /api/announcements
**Deskripsi:** Membuat pengumuman baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "title": "string",
  "content": "string",
  "is_published": "boolean (optional, default: true)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil dibuat",
  "data": {
    "title": "Pengumuman Tes",
    "content": "Ini adalah pengumuman tes untuk pengujian sistem",
    "author_id": 8,
    "is_published": true,
    "published_at": null,
    "updated_at": "2025-08-21T10:15:43.000000Z",
    "created_at": "2025-08-21T10:15:43.000000Z",
    "id": 3
  }
}
```

### GET /api/announcements/{id}
**Deskripsi:** Mendapatkan detail pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengumuman berhasil diambil",
  "data": {
    "id": 1,
    "title": "Jadwal Ujian Tengah Semester",
    "content": "UTS akan dilaksanakan mulai Senin, 14 April 2025. Jadwal lengkap terlampir.",
    "author_id": 4,
    "is_published": true,
    "published_at": "2025-08-21T08:54:58.000000Z",
    "created_at": "2025-08-21T08:54:58.000000Z",
    "updated_at": "2025-08-21T08:54:58.000000Z"
  }
}
```

### PUT /api/announcements/{id}
**Deskripsi:** Memperbarui pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "title": "string (optional)",
  "content": "string (optional)",
  "is_published": "boolean (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil diperbarui",
  "data": {
    "id": 3,
    "title": "Pengumuman Tes - Updated",
    "content": "Ini adalah pengumuman tes untuk pengujian sistem - Updated",
    "author_id": 8,
    "is_published": true,
    "published_at": null,
    "updated_at": "2025-08-21T10:20:00.000000Z",
    "created_at": "2025-08-21T10:15:43.000000Z"
  }
}
```

### DELETE /api/announcements/{id}
**Deskripsi:** Menghapus pengumuman
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil dihapus"
}
```

---

## 8. Manajemen Kelas

### GET /api/classes
**Deskripsi:** Mendapatkan semua kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z",
      "homeroom_teacher": {
        "id": 2,
        "nisn_nip_nik": "1002",
        "name": "Budi Santoso",
        "email": "budi@siswa.sch.id",
        "phone": "081234567891",
        "role_id": 1,
        "photo_path": "profiles/budi.jpg",
        "is_active": true,
        "created_at": "2025-08-21T08:54:57.000000Z",
        "updated_at": "2025-08-21T08:54:57.000000Z"
      }
    }
    // ... data kelas lainnya
  ]
}
```

### GET /api/classes/{id}
**Deskripsi:** Mendapatkan kelas berdasarkan ID
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "X IPA 1",
    "homeroom_teacher_id": 2,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-21T08:54:57.000000Z",
    "homeroom_teacher": {
      "id": 2,
      "nisn_nip_nik": "1002",
      "name": "Budi Santoso",
      "email": "budi@siswa.sch.id",
      "phone": "081234567891",
      "role_id": 1,
      "photo_path": "profiles/budi.jpg",
      "is_active": true,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    }
  }
}
```

### POST /api/classes
**Deskripsi:** Membuat kelas baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "name": "string",
  "homeroom_teacher_id": "integer (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Kelas berhasil dibuat",
  "data": {
    "id": 4,
    "name": "XI IPS 1",
    "homeroom_teacher_id": 3,
    "created_at": "2025-08-21T12:00:00.000000Z",
    "updated_at": "2025-08-21T12:00:00.000000Z",
    "homeroom_teacher": {
      "id": 3,
      "nisn_nip_nik": "1003",
      "name": "Citra Dewi",
      "email": "citra@siswa.sch.id",
      "phone": "081234567892",
      "role_id": 1,
      "photo_path": "profiles/citra.jpg",
      "is_active": true,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    }
  }
}
```

### PUT /api/classes/{id}
**Deskripsi:** Memperbarui kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "name": "string (optional)",
  "homeroom_teacher_id": "integer (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Kelas berhasil diperbarui",
  "data": {
    "id": 1,
    "name": "X IPA 1 - Updated",
    "homeroom_teacher_id": 3,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-21T12:05:00.000000Z",
    "homeroom_teacher": {
      "id": 3,
      "nisn_nip_nik": "1003",
      "name": "Citra Dewi",
      "email": "citra@siswa.sch.id",
      "phone": "081234567892",
      "role_id": 1,
      "photo_path": "profiles/citra.jpg",
      "is_active": true,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    }
  }
}
```

### DELETE /api/classes/{id}
**Deskripsi:** Menghapus kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Kelas berhasil dihapus"
}
```

### GET /api/classes/{id}/students
**Deskripsi:** Mendapatkan semua siswa dalam kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "class": {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    },
    "students": [
      {
        "id": 1,
        "nisn_nip_nik": "1001",
        "name": "Andi Pratama",
        "email": "andi@siswa.sch.id",
        "phone": "081234567890",
        "role_id": 1,
        "photo_path": "profiles/andi.jpg",
        "is_active": true,
        "created_at": "2025-08-21T08:54:57.000000Z",
        "updated_at": "2025-08-21T08:54:57.000000Z",
        "student_classes": [
          {
            "id": 1,
            "student_id": 1,
            "class_id": 1,
            "academic_year": 2025,
            "created_at": "2025-08-21T08:54:57.000000Z"
          }
        ]
      }
      // ... data siswa lainnya
    ]
  }
}
```

### POST /api/classes/{id}/assign-students
**Deskripsi:** Menetapkan siswa ke kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "student_ids": [
    "integer"
  ],
  "academic_year": "integer"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "2 siswa berhasil ditetapkan ke kelas",
  "data": {
    "class": {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z",
      "homeroom_teacher": {
        "id": 2,
        "nisn_nip_nik": "1002",
        "name": "Budi Santoso",
        "email": "budi@siswa.sch.id",
        "phone": "081234567891",
        "role_id": 1,
        "photo_path": "profiles/budi.jpg",
        "is_active": true,
        "created_at": "2025-08-21T08:54:57.000000Z",
        "updated_at": "2025-08-21T08:54:57.000000Z"
      }
    },
    "assigned_students": [
      {
        "id": 4,
        "student_id": 4,
        "class_id": 1,
        "academic_year": 2025,
        "created_at": "2025-08-21T12:10:00.000000Z"
      },
      {
        "id": 5,
        "student_id": 5,
        "class_id": 1,
        "academic_year": 2025,
        "created_at": "2025-08-21T12:10:00.000000Z"
      }
    ]
  }
}
```

### POST /api/classes/{id}/remove-students
**Deskripsi:** Menghapus siswa dari kelas
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "student_ids": [
    "integer"
  ],
  "academic_year": "integer"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "2 siswa berhasil dihapus dari kelas",
  "data": {
    "class": {
      "id": 1,
      "name": "X IPA 1",
      "homeroom_teacher_id": 2,
      "created_at": "2025-08-21T08:54:57.000000Z",
      "updated_at": "2025-08-21T08:54:57.000000Z"
    },
    "removed_count": 2
  }
}
```

---

## 9. Student QR Cards

### GET /api/student-qr-cards
**Deskripsi:** Mendapatkan semua QR card siswa
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "student_id": 1,
      "qr_code": "ABC123XYZ",
      "is_active": true,
      "generated_at": "2025-08-21T09:07:31.000000Z",
      "created_at": "2025-08-21T09:07:31.000000Z",
      "updated_at": "2025-08-21T09:07:31.000000Z",
      "student": {
        "id": 1,
        "nisn_nip_nik": "1001",
        "name": "Andi Pratama",
        // ... data siswa lainnya
      }
    }
    // ... daftar QR card lainnya
  ]
}
```

### GET /api/student-qr-cards/{id}
**Deskripsi:** Mendapatkan QR card siswa berdasarkan ID
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "student_id": 1,
    "qr_code": "ABC123XYZ",
    "is_active": true,
    "generated_at": "2025-08-21T09:07:31.000000Z",
    "created_at": "2025-08-21T09:07:31.000000Z",
    "updated_at": "2025-08-21T09:07:31.000000Z",
    "student": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data siswa lainnya
    }
  }
}
```

### POST /api/student-qr-cards/generate
**Deskripsi:** Mengenerate QR code baru untuk seorang siswa
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "student_id": "integer"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "QR card baru berhasil di-generate",
  "data": {
    "id": 2,
    "student_id": 1,
    "qr_code": "XYZ789ABC",
    "is_active": true,
    "generated_at": "2025-08-21T11:00:00.000000Z",
    "created_at": "2025-08-21T11:00:00.000000Z",
    "updated_at": "2025-08-21T11:00:00.000000Z",
    "student": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data siswa lainnya
    }
  }
}
```

### PUT /api/student-qr-cards/{id}/status
**Deskripsi:** Memperbarui status QR card (aktif/tidak aktif)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "is_active": "boolean"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Status QR card berhasil diperbarui",
  "data": {
    "id": 1,
    "student_id": 1,
    "qr_code": "ABC123XYZ",
    "is_active": false,
    "generated_at": "2025-08-21T09:07:31.000000Z",
    "created_at": "2025-08-21T09:07:31.000000Z",
    "updated_at": "2025-08-21T11:15:00.000000Z",
    "student": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data siswa lainnya
    }
  }
}
```

---

## 10. Offline Sync

### GET /api/offline-sync
**Deskripsi:** Mendapatkan semua log sinkronisasi offline dengan filter dan pagination
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `user_id`: Filter berdasarkan ID user
- `status`: Filter berdasarkan status ('pending', 'success', 'failed')
- `action_type`: Filter berdasarkan tipe action
- `per_page`: Jumlah data per halaman (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 1,
        "user_id": 1,
        "action_type": "attendance",
        "data": {
          "type": "checkin",
          "timestamp": "2025-04-05 07:25:00"
        },
        "synced_at": "2025-04-05 07:25:00",
        "status": "success",
        "error_message": null,
        "user": {
          "id": 1,
          "nisn_nip_nik": "1001",
          "name": "Andi Pratama",
          // ... data user lainnya
        }
      }
      // ... data log lainnya
    ],
    "first_page_url": "http://127.0.0.1:8000/api/offline-sync?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/offline-sync?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/offline-sync",
    "per_page": 15,
    "prev_page_url": null,
    "to": 1,
    "total": 1
  }
}
```

### GET /api/offline-sync/{id}
**Deskripsi:** Mendapatkan log sinkronisasi offline berdasarkan ID
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "user_id": 1,
    "action_type": "attendance",
    "data": {
      "type": "checkin",
      "timestamp": "2025-04-05 07:25:00"
    },
    "synced_at": "2025-04-05 07:25:00",
    "status": "success",
    "error_message": null,
    "user": {
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      // ... data user lainnya
    }
  }
}
```

### POST /api/offline-sync/process-attendance
**Deskripsi:** Memproses data absensi offline
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "attendances": [
    {
      "user_id": "integer",
      "type": "string (checkin|checkout)",
      "timestamp": "string (YYYY-MM-DD HH:MM:SS)",
      "latitude": "float (optional)",
      "longitude": "float (optional)",
      "accuracy": "float (optional)",
      "photo_path": "string (optional)"
    }
  ]
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Proses sinkronisasi data absensi selesai",
  "data": {
    "processed": [
      {
        "id": 2,
        "user_id": 1,
        "type": "checkin",
        "latitude": -6.123456,
        "longitude": 106.876543,
        "accuracy": 5.2,
        "photo_path": "attendance/andi_checkin_2.jpg",
        "qr_token_used": "OFFLINE",
        "status": "hadir",
        "timestamp": "2025-04-06 07:25:30",
        "date_only": "2025-04-06",
        "synced": true,
        "created_at": "2025-08-21T11:30:00.000000Z"
      }
    ],
    "failed": [
      {
        "data": {
          "user_id": 2,
          "type": "checkin",
          "timestamp": "2025-04-06 07:25:30"
        },
        "error": "Absensi dengan timestamp yang sama sudah ada"
      }
    ],
    "processed_count": 1,
    "failed_count": 1
  }
}
```

### POST /api/offline-sync/{id}/retry
**Deskripsi:** Mencoba ulang sinkronisasi log yang gagal
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Sinkronisasi berhasil diulang",
  "data": {
    "id": 2,
    "user_id": 1,
    "type": "checkin",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": 5.2,
    "photo_path": "attendance/andi_checkin_2.jpg",
    "qr_token_used": "OFFLINE_RETRY",
    "status": "hadir",
    "timestamp": "2025-04-06 07:25:30",
    "date_only": "2025-04-06",
    "synced": true,
    "created_at": "2025-08-21T11:35:00.000000Z"
  }
}
```

---

## 11. Settings

### GET /api/settings
**Deskripsi:** Mendapatkan semua pengaturan sistem
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": [
    {
      "key_name": "attendance_radius",
      "value": "100",
      "description": "Radius absensi dalam meter",
      "updated_at": "2025-08-21T10:30:00.000000Z"
    },
    {
      "key_name": "school_latitude",
      "value": "-6.123456",
      "description": "Koordinat latitude sekolah",
      "updated_at": "2025-08-21T10:30:00.000000Z"
    }
    // ... daftar semua pengaturan
  ]
}
```

### GET /api/settings/{key}
**Deskripsi:** Mendapatkan pengaturan sistem berdasarkan key
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "data": {
    "key_name": "attendance_radius",
    "value": "100",
    "description": "Radius absensi dalam meter",
    "updated_at": "2025-08-21T10:30:00.000000Z"
  }
}
```

### PUT /api/settings/{key}
**Deskripsi:** Memperbarui pengaturan sistem berdasarkan key
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "value": "string",
  "description": "string (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengaturan berhasil diperbarui",
  "data": {
    "key_name": "attendance_radius",
    "value": "150",
    "description": "Radius absensi dalam meter",
    "updated_at": "2025-08-21T11:00:00.000000Z"
  }
}
```

### PUT /api/settings/bulk-update
**Deskripsi:** Memperbarui banyak pengaturan sekaligus
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "settings": [
    {
      "key": "string",
      "value": "string"
    },
    {
      "key": "string",
      "value": "string"
    }
  ]
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengaturan berhasil diperbarui",
  "data": [
    {
      "key_name": "attendance_radius",
      "value": "150",
      "description": "Radius absensi dalam meter",
      "updated_at": "2025-08-21T11:00:00.000000Z"
    },
    {
      "key_name": "checkin_end",
      "value": "08:00:00",
      "description": "Batas waktu check-in",
      "updated_at": "2025-08-21T11:00:00.000000Z"
    }
  ]
}
```

---

## 12. Dashboard

### GET /api/dashboard
**Deskripsi:** Mendapatkan data dashboard berdasarkan peran pengguna yang sedang login
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Berdasarkan Peran:**
*(Lihat dokumentasi lengkap di `api_dashboard.md`)*

---

## 13. Manajemen Pengguna

### GET /api/users
**Deskripsi:** Mendapatkan daftar pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- `role_id`: Filter berdasarkan role
- `is_active`: Filter berdasarkan status aktif (1/0)
- `per_page`: Jumlah data per halaman (default: 15)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengguna berhasil diambil",
  "data": {
    "current_page": 1,
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
        "created_at": "2025-08-21T08:54:57.000000Z",
        "updated_at": "2025-08-21T08:54:57.000000Z"
      }
      // ... data pengguna lainnya
    ],
    "first_page_url": "http://127.0.0.1:8000/api/users?page=1",
    "from": 1,
    "last_page": 1,
    "last_page_url": "http://127.0.0.1:8000/api/users?page=1",
    "next_page_url": null,
    "path": "http://127.0.0.1:8000/api/users",
    "per_page": 15,
    "prev_page_url": null,
    "to": 2,
    "total": 2
  }
}
```

### POST /api/users
**Deskripsi:** Menambah pengguna baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "string",
  "name": "string",
  "email": "string|email (optional)",
  "phone": "string (optional)",
  "password": "string",
  "role_id": "integer",
  "photo_path": "string (optional)",
  "is_active": "boolean (optional, default: true)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengguna berhasil ditambahkan",
  "data": {
    "nisn_nip_nik": "1005",
    "name": "Eka Putri",
    "email": "eka@siswa.sch.id",
    "phone": "081234567899",
    "role_id": 1,
    "photo_path": "profiles/eka.jpg",
    "is_active": true,
    "updated_at": "2025-08-21T12:30:00.000000Z",
    "created_at": "2025-08-21T12:30:00.000000Z",
    "id": 10
  }
}
```

### GET /api/users/{id}
**Deskripsi:** Mendapatkan detail pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengguna berhasil diambil",
  "data": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama",
    "email": "andi@siswa.sch.id",
    "phone": "081234567890",
    "role_id": 1,
    "photo_path": "profiles/andi.jpg",
    "is_active": true,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-21T08:54:57.000000Z"
  }
}
```

### PUT /api/users/{id}
**Deskripsi:** Memperbarui pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "string (optional)",
  "name": "string (optional)",
  "email": "string|email (optional)",
  "phone": "string (optional)",
  "password": "string (optional)",
  "role_id": "integer (optional)",
  "photo_path": "string (optional)",
  "is_active": "boolean (optional)"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengguna berhasil diperbarui",
  "data": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama - Updated",
    "email": "andi.updated@siswa.sch.id",
    "phone": "081234567800",
    "role_id": 1,
    "photo_path": "profiles/andi.jpg",
    "is_active": true,
    "created_at": "2025-08-21T08:54:57.000000Z",
    "updated_at": "2025-08-21T12:35:00.000000Z"
  }
}
```

### DELETE /api/users/{id}
**Deskripsi:** Menghapus pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengguna berhasil dihapus"
}
```