# Endpoint API SiPresensi Berdasarkan PRD

Berdasarkan PRD System Architecture SiPresensi, berikut adalah endpoint API utama yang perlu diuji:

## Auth Endpoints:
- POST /api/auth/login
- POST /api/auth/logout

## Attendance Endpoints:
- POST /api/attendance/checkin
- POST /api/attendance/scan-qr
- GET /api/attendance/history

## Leaves Endpoints:
- GET /api/leaves
- POST /api/leaves
- PUT /api/leaves/{id}
- DELETE /api/leaves/{id}

## Announcements Endpoints:
- GET /api/announcements
- POST /api/announcements
- PUT /api/announcements/{id}
- DELETE /api/announcements/{id}

## Users Endpoints:
- GET /api/users
- GET /api/users/{id}
- POST /api/users
- PUT /api/users/{id}
- DELETE /api/users/{id}

## QR Code Endpoints:
- GET /api/qrcode/dynamic

## Profile Endpoints:
- GET /api/profile
- PUT /api/profile
- PUT /api/profile/password