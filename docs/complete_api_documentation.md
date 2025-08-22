# Dokumentasi API SiPresensi - Endpoint Lengkap

## 1. Auth Endpoints

### POST /api/auth/login
**Deskripsi:** Login pengguna ke sistem
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
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "email": "andi@siswa.sch.id",
      "phone": "081234567890",
      "role_id": 1,
      "photo_path": "profiles/andi.jpg",
      "is_active": 1,
      "created_at": "2025-08-20T23:30:07.000000Z",
      "updated_at": "2025-08-20T23:30:07.000000Z"
    },
    "token": "1|umK7zuVmRiDQV7DoWvoB4bwmyPWV7v05MJE2H4lm2cd7c5e1"
  }
}
```

**Response Gagal:**
```json
{
  "success": false,
  "message": "Kredensial tidak valid"
}
```

### POST /api/auth/logout
**Deskripsi:** Logout pengguna dari sistem
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

## 2. User Endpoints

### GET /api/user
**Deskripsi:** Mendapatkan data pengguna yang sedang login
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
      "id": 1,
      "nisn_nip_nik": "1001",
      "name": "Andi Pratama",
      "email": "andi@siswa.sch.id",
      "phone": "081234567890",
      "role_id": 1,
      "photo_path": "profiles/andi.jpg",
      "is_active": 1,
      "created_at": "2025-08-20T23:30:07.000000Z",
      "updated_at": "2025-08-20T23:30:07.000000Z"
    }
  }
}
```

## 3. Attendance Endpoints

### POST /api/attendance/checkin
**Deskripsi:** Melakukan absen masuk
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "latitude": -6.123456,
  "longitude": 106.876543,
  "photo": "base64_encoded_image_string",
  "qr_token": "QR_TOKEN_FROM_DYNAMIC_QR"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen masuk berhasil",
  "data": {
    "id": 1,
    "user_id": 1,
    "type": "checkin",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": null,
    "photo_path": "base64_encoded_image_string",
    "qr_token_used": "QR_TOKEN_FROM_DYNAMIC_QR",
    "status": "hadir",
    "timestamp": "2025-08-20T23:30:07.000000Z",
    "date_only": "2025-08-20",
    "synced": 1,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:30:07.000000Z"
  }
}
```

### POST /api/attendance/checkout
**Deskripsi:** Melakukan absen keluar
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "latitude": -6.123456,
  "longitude": 106.876543,
  "photo": "base64_encoded_image_string",
  "qr_token": "QR_TOKEN_FROM_DYNAMIC_QR"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Absen keluar berhasil",
  "data": {
    "id": 2,
    "user_id": 1,
    "type": "checkout",
    "latitude": -6.123456,
    "longitude": 106.876543,
    "accuracy": null,
    "photo_path": "base64_encoded_image_string",
    "qr_token_used": "QR_TOKEN_FROM_DYNAMIC_QR",
    "status": "hadir",
    "timestamp": "2025-08-20T23:30:07.000000Z",
    "date_only": "2025-08-20",
    "synced": 1,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:30:07.000000Z"
  }
}
```

### GET /api/attendance/history
**Deskripsi:** Mendapatkan riwayat absensi pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- start_date (optional): Tanggal mulai (format: YYYY-MM-DD)
- end_date (optional): Tanggal akhir (format: YYYY-MM-DD)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data riwayat absensi berhasil diambil",
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "type": "checkin",
      "latitude": -6.123456,
      "longitude": 106.876543,
      "accuracy": null,
      "photo_path": "base64_encoded_image_string",
      "qr_token_used": "QR_TOKEN_FROM_DYNAMIC_QR",
      "status": "hadir",
      "timestamp": "2025-08-20T07:30:07.000000Z",
      "date_only": "2025-08-20",
      "synced": 1,
      "created_at": "2025-08-20T07:30:07.000000Z",
      "updated_at": "2025-08-20T07:30:07.000000Z"
    },
    {
      "id": 2,
      "user_id": 1,
      "type": "checkout",
      "latitude": -6.123456,
      "longitude": 106.876543,
      "accuracy": null,
      "photo_path": "base64_encoded_image_string",
      "qr_token_used": "QR_TOKEN_FROM_DYNAMIC_QR",
      "status": "hadir",
      "timestamp": "2025-08-20T15:30:07.000000Z",
      "date_only": "2025-08-20",
      "synced": 1,
      "created_at": "2025-08-20T15:30:07.000000Z",
      "updated_at": "2025-08-20T15:30:07.000000Z"
    }
  ]
}
```

## 4. Leave Endpoints

### GET /api/leaves
**Deskripsi:** Mendapatkan daftar pengajuan izin pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- status (optional): Filter berdasarkan status (menunggu, disetujui, ditolak)
- start_date (optional): Tanggal mulai (format: YYYY-MM-DD)
- end_date (optional): Tanggal akhir (format: YYYY-MM-DD)

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data pengajuan izin berhasil diambil",
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "leave_type": "sakit",
      "start_date": "2025-08-21",
      "end_date": "2025-08-21",
      "reason": "Demam tinggi",
      "attachment_path": "leaves/surat_andi.pdf",
      "status": "disetujui",
      "approved_by": 4,
      "approval_comment": null,
      "approved_at": "2025-08-20T10:30:00.000000Z",
      "created_at": "2025-08-20T09:30:07.000000Z",
      "updated_at": "2025-08-20T10:30:00.000000Z"
    }
  ]
}
```

### POST /api/leaves
**Deskripsi:** Membuat pengajuan izin baru
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "leave_type": "izin",
  "start_date": "2025-08-25",
  "end_date": "2025-08-25",
  "reason": "Acara keluarga",
  "attachment_path": "leaves/acara_keluarga.jpg"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengajuan izin berhasil dibuat",
  "data": {
    "id": 2,
    "user_id": 1,
    "leave_type": "izin",
    "start_date": "2025-08-25",
    "end_date": "2025-08-25",
    "reason": "Acara keluarga",
    "attachment_path": "leaves/acara_keluarga.jpg",
    "status": "menunggu",
    "approved_by": null,
    "approval_comment": null,
    "approved_at": null,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:30:07.000000Z"
  }
}
```

### GET /api/leaves/{id}
**Deskripsi:** Mendapatkan detail pengajuan izin berdasarkan ID
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
    "start_date": "2025-08-21",
    "end_date": "2025-08-21",
    "reason": "Demam tinggi",
    "attachment_path": "leaves/surat_andi.pdf",
    "status": "disetujui",
    "approved_by": 4,
    "approval_comment": null,
    "approved_at": "2025-08-20T10:30:00.000000Z",
    "created_at": "2025-08-20T09:30:07.000000Z",
    "updated_at": "2025-08-20T10:30:00.000000Z"
  }
}
```

### PUT /api/leaves/{id}
**Deskripsi:** Mengubah pengajuan izin berdasarkan ID
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "leave_type": "izin",
  "start_date": "2025-08-25",
  "end_date": "2025-08-25",
  "reason": "Acara keluarga yang penting",
  "attachment_path": "leaves/acara_keluarga.jpg"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengajuan izin berhasil diubah",
  "data": {
    "id": 2,
    "user_id": 1,
    "leave_type": "izin",
    "start_date": "2025-08-25",
    "end_date": "2025-08-25",
    "reason": "Acara keluarga yang penting",
    "attachment_path": "leaves/acara_keluarga.jpg",
    "status": "menunggu",
    "approved_by": null,
    "approval_comment": null,
    "approved_at": null,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:35:07.000000Z"
  }
}
```

### DELETE /api/leaves/{id}
**Deskripsi:** Menghapus pengajuan izin berdasarkan ID
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

## 5. Announcement Endpoints

### GET /api/announcements
**Deskripsi:** Mendapatkan daftar pengumuman
**Headers:**
- Content-Type: application/json

**Query Parameters:**
- limit (optional): Jumlah data per halaman (default: 10)
- offset (optional): Offset data (default: 0)

**Response Sukses:**
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
      "is_published": 1,
      "published_at": "2025-08-20T09:30:07.000000Z",
      "created_at": "2025-08-20T09:30:07.000000Z",
      "updated_at": "2025-08-20T09:30:07.000000Z"
    }
  ]
}
```

### GET /api/announcements/{id}
**Deskripsi:** Mendapatkan detail pengumuman berdasarkan ID
**Headers:**
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
    "is_published": 1,
    "published_at": "2025-08-20T09:30:07.000000Z",
    "created_at": "2025-08-20T09:30:07.000000Z",
    "updated_at": "2025-08-20T09:30:07.000000Z"
  }
}
```

### POST /api/announcements
**Deskripsi:** Membuat pengumuman baru (hanya untuk admin/kepala sekolah)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "title": "Libur Hari Raya Idul Fitri",
  "content": "Diberitahukan kepada seluruh siswa dan staff bahwa sekolah akan libur selama 1 minggu terhitung mulai tanggal 10 April 2025.",
  "is_published": true
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil dibuat",
  "data": {
    "id": 2,
    "title": "Libur Hari Raya Idul Fitri",
    "content": "Diberitahukan kepada seluruh siswa dan staff bahwa sekolah akan libur selama 1 minggu terhitung mulai tanggal 10 April 2025.",
    "author_id": 5,
    "is_published": 1,
    "published_at": "2025-08-20T23:30:07.000000Z",
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:30:07.000000Z"
  }
}
```

### PUT /api/announcements/{id}
**Deskripsi:** Mengubah pengumuman berdasarkan ID (hanya untuk admin/kepala sekolah)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "title": "Libur Hari Raya Idul Fitri - Perubahan Jadwal",
  "content": "Diberitahukan kepada seluruh siswa dan staff bahwa sekolah akan libur selama 1 minggu terhitung mulai tanggal 12 April 2025.",
  "is_published": true
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengumuman berhasil diubah",
  "data": {
    "id": 2,
    "title": "Libur Hari Raya Idul Fitri - Perubahan Jadwal",
    "content": "Diberitahukan kepada seluruh siswa dan staff bahwa sekolah akan libur selama 1 minggu terhitung mulai tanggal 12 April 2025.",
    "author_id": 5,
    "is_published": 1,
    "published_at": "2025-08-20T23:30:07.000000Z",
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:35:07.000000Z"
  }
}
```

### DELETE /api/announcements/{id}
**Deskripsi:** Menghapus pengumuman berdasarkan ID (hanya untuk admin/kepala sekolah)
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

## 6. Profile Endpoints

### GET /api/profile
**Deskripsi:** Mendapatkan data profil pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Data profil berhasil diambil",
  "data": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama",
    "email": "andi@siswa.sch.id",
    "phone": "081234567890",
    "role_id": 1,
    "photo_path": "profiles/andi.jpg",
    "is_active": 1,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:30:07.000000Z"
  }
}
```

### PUT /api/profile
**Deskripsi:** Mengubah data profil pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "name": "Andi Pratama",
  "email": "andi.pratama@siswa.sch.id",
  "phone": "081298765432",
  "photo_path": "profiles/andi_updated.jpg"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Profil berhasil diubah",
  "data": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama",
    "email": "andi.pratama@siswa.sch.id",
    "phone": "081298765432",
    "role_id": 1,
    "photo_path": "profiles/andi_updated.jpg",
    "is_active": 1,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:35:07.000000Z"
  }
}
```

### PUT /api/profile/password
**Deskripsi:** Mengubah password pengguna
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "current_password": "password",
  "new_password": "newpassword123",
  "new_password_confirmation": "newpassword123"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Password berhasil diubah"
}
```

## 7. QR Code Endpoints

### GET /api/qrcode/dynamic
**Deskripsi:** Mendapatkan token QR Code dinamis
**Headers:**
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Token QR dinamis berhasil diambil",
  "data": {
    "token": "a1b2c3d4e5f67890",
    "expires_at": "2025-08-20T23:30:17.000000Z"
  }
}
```

## 8. User Management Endpoints (Admin Only)

### GET /api/users
**Deskripsi:** Mendapatkan daftar pengguna (hanya untuk admin)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Query Parameters:**
- limit (optional): Jumlah data per halaman (default: 10)
- offset (optional): Offset data (default: 0)
- role (optional): Filter berdasarkan role ID

**Response Sukses:**
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
      "is_active": 1,
      "created_at": "2025-08-20T23:30:07.000000Z",
      "updated_at": "2025-08-20T23:30:07.000000Z"
    }
  ]
}
```

### POST /api/users
**Deskripsi:** Membuat pengguna baru (hanya untuk admin)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "1004",
  "name": "Dewi Lestari",
  "email": "dewi@siswa.sch.id",
  "phone": "081234567893",
  "password": "password123",
  "role_id": 1,
  "photo_path": "profiles/dewi.jpg"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengguna berhasil dibuat",
  "data": {
    "id": 4,
    "nisn_nip_nik": "1004",
    "name": "Dewi Lestari",
    "email": "dewi@siswa.sch.id",
    "phone": "081234567893",
    "role_id": 1,
    "photo_path": "profiles/dewi.jpg",
    "is_active": 1,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:30:07.000000Z"
  }
}
```

### GET /api/users/{id}
**Deskripsi:** Mendapatkan detail pengguna berdasarkan ID (hanya untuk admin)
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
    "is_active": 1,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:30:07.000000Z"
  }
}
```

### PUT /api/users/{id}
**Deskripsi:** Mengubah pengguna berdasarkan ID (hanya untuk admin)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Request Body:**
```json
{
  "nisn_nip_nik": "1001",
  "name": "Andi Pratama",
  "email": "andi.pratama@siswa.sch.id",
  "phone": "081298765432",
  "role_id": 1,
  "photo_path": "profiles/andi_updated.jpg"
}
```

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengguna berhasil diubah",
  "data": {
    "id": 1,
    "nisn_nip_nik": "1001",
    "name": "Andi Pratama",
    "email": "andi.pratama@siswa.sch.id",
    "phone": "081298765432",
    "role_id": 1,
    "photo_path": "profiles/andi_updated.jpg",
    "is_active": 1,
    "created_at": "2025-08-20T23:30:07.000000Z",
    "updated_at": "2025-08-20T23:35:07.000000Z"
  }
}
```

### DELETE /api/users/{id}
**Deskripsi:** Menghapus pengguna berdasarkan ID (hanya untuk admin)
**Headers:**
- Authorization: Bearer {token}
- Content-Type: application/json

**Response Sukses:**
```json
{
  "success": true,
  "message": "Pengguna berhasil dinonaktifkan"
}
```

## Catatan Penting:
1. Semua endpoint auth (kecuali login) memerlukan token autentikasi di header Authorization
2. Token didapatkan setelah login berhasil dan harus disimpan untuk digunakan dalam request selanjutnya
3. Setelah logout, token tidak lagi valid dan pengguna harus login ulang untuk mendapatkan token baru
4. Beberapa endpoint hanya dapat diakses oleh pengguna dengan role tertentu (admin, kepala sekolah)