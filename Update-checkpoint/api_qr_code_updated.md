# Dokumentasi API QR Code (Diperbarui)

## QR Code Endpoints

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
    "expires_at": "2025-08-21 10:29:31"
  }
}
```

**Response Gagal:**
```json
{
  "success": false,
  "message": "Terjadi kesalahan saat mengambil token QR dinamis",
  "error": "Detail error"
}
```

### POST /api/qrcode/verify
**Deskripsi:** Memverifikasi token QR Code dan mencatat absensi pengguna dengan verifikasi lokasi dan foto
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
    "id": 8,
    "user_id": 8,
    "type": "checkin",
    "latitude": "-6.12345600",
    "longitude": "106.87654300",
    "accuracy": 50,
    "photo_path": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "qr_token_used": "46e5f7ecb74314c9f02a121933523548",
    "timestamp": "2025-08-21 10:29:30",
    "created_at": "2025-08-21T10:29:30.000000Z",
    "updated_at": "2025-08-21T10:29:30.000000Z"
  }
}
```

**Response Gagal (Validasi):**
```json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": {
    // Detail error validasi
  }
}
```

**Response Gagal (Token tidak valid):**
```json
{
  "success": false,
  "message": "QR token tidak valid atau sudah kadaluarsa"
}
```

**Response Gagal (Lokasi di luar area):**
```json
{
  "success": false,
  "message": "Anda berada di luar area sekolah"
}
```

**Response Gagal (Sudah absen):**
```json
{
  "success": false,
  "message": "Anda sudah melakukan absen masuk hari ini"
}
```

## Catatan Penting

1. **Durasi Token:** Token QR Code hanya berlaku selama 15 detik setelah dihasilkan.
2. **Verifikasi Lokasi:** Pengguna harus berada dalam radius 100 meter dari lokasi sekolah.
3. **Foto Selfie:** Foto harus dalam format base64.
4. **User ID:** Parameter `user_id` wajib diisi dan harus sesuai dengan ID pengguna yang melakukan absensi.
5. **Tipe Absensi:** Parameter `type` harus diisi dengan nilai "checkin" atau "checkout".