# API Test Log - SiPresensi

## Initial Setup
- Project: SiPresensi v.1.1
- Backend: Laravel
- Database: MySQL

## Test 1: Database Migration
**Command:** `php artisan migrate`
**Date:** 2025-08-20
**Result:** FAILED
**Error:** 
```
SQLSTATE[42S01]: Base table or view already exists: 1050 Table 'users' already exists
```
**Status:** Database tables already exist, causing migration to fail.

## Test 2: API Login Endpoint
**Endpoint:** POST http://localhost:8000/api/auth/login
**Date:** 2025-08-20
**Request Body:**
```json
{
  "nisn_nip_nik": "1001",
  "password": "admin"
}
```
**Note:** Test was attempted but results were not properly logged. Need to retest with proper logging.

## Next Steps:
1. Reset database with `php artisan migrate:fresh`
2. Retest API endpoints with proper logging
3. Document all test results in this file