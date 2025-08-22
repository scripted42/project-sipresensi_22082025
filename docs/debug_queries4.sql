-- Periksa semua data absensi
SELECT a.*, u.name FROM attendance a JOIN users u ON a.user_id = u.id ORDER BY a.timestamp DESC;

| id | user\_id | type     | latitude   | longitude    | accuracy | photo\_path                     | qr\_token\_used | status | timestamp           | date\_only | synced | created\_at         | name         |
| -- | -------- | -------- | ---------- | ------------ | -------- | ------------------------------- | --------------- | ------ | ------------------- | ---------- | ------ | ------------------- | ------------ |
| 7  | 3        | checkin  | -6.1234560 | 106.87654300 | NULL     | NULL                            | 1003            | hadir  | 2025-08-20 18:27:36 | 2025-08-20 | 1      | 2025-08-21 01:27:36 | Citra Dewi   |
| 6  | 2        | checkout | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string  | Z7K3N9Q5R2      | hadir  | 2025-08-20 18:02:54 | 2025-08-20 | 1      | 2025-08-21 01:02:54 | Budi Santoso |
| 5  | 2        | checkin  | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string  | L4M8S1T6U3      | hadir  | 2025-08-20 18:02:28 | 2025-08-21 | 1      | 2025-08-21 01:02:28 | Budi Santoso |
| 4  | 1        | checkout | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string  | L4M8S1T6U3      | hadir  | 2025-08-20 18:00:52 | 2025-08-21 | 1      | 2025-08-21 01:00:52 | Andi Pratama |
| 3  | 1        | checkin  | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string  | L4M8S1T6U3      | hadir  | 2025-08-20 17:58:03 | 2025-08-20 | 1      | 2025-08-21 00:58:03 | Andi Pratama |
| 2  | 2        | checkin  | -6.1234560 | 106.87654300 | 61.1     | attendance/budi\_checkin\_1.jpg | QRX9B2M8P1      | hadir  | 2025-04-05 07:28:12 | 2025-04-05 | 1      | 2025-08-20 23:30:07 | Budi Santoso |
| 1  | 1        | checkin  | -6.1234560 | 106.87654300 | 53.2     | attendance/andi\_checkin\_1.jpg | QRX9B2M8P1      | hadir  | 2025-04-05 07:25:30 | 2025-04-05 | 1      | 2025-08-20 23:30:07 | Andi Pratama |


-- Periksa data absensi untuk tanggal 20 Agustus 2025
SELECT a.*, u.name FROM attendance a JOIN users u ON a.user_id = u.id WHERE DATE(a.timestamp) = '2025-08-20' ORDER BY a.timestamp DESC;

| id | user\_id | type     | latitude   | longitude    | accuracy | photo\_path                    | qr\_token\_used | status | timestamp           | date\_only | synced | created\_at         | name         |
| -- | -------- | -------- | ---------- | ------------ | -------- | ------------------------------ | --------------- | ------ | ------------------- | ---------- | ------ | ------------------- | ------------ |
| 7  | 3        | checkin  | -6.1234560 | 106.87654300 | NULL     | NULL                           | 1003            | hadir  | 2025-08-20 18:27:36 | 2025-08-20 | 1      | 2025-08-21 01:27:36 | Citra Dewi   |
| 6  | 2        | checkout | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string | Z7K3N9Q5R2      | hadir  | 2025-08-20 18:02:54 | 2025-08-20 | 1      | 2025-08-21 01:02:54 | Budi Santoso |
| 5  | 2        | checkin  | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string | L4M8S1T6U3      | hadir  | 2025-08-20 18:02:28 | 2025-08-21 | 1      | 2025-08-21 01:02:28 | Budi Santoso |
| 4  | 1        | checkout | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string | L4M8S1T6U3      | hadir  | 2025-08-20 18:00:52 | 2025-08-21 | 1      | 2025-08-21 01:00:52 | Andi Pratama |
| 3  | 1        | checkin  | -6.1234560 | 106.87654300 | NULL     | base64\_encoded\_image\_string | L4M8S1T6U3      | hadir  | 2025-08-20 17:58:03 | 2025-08-20 | 1      | 2025-08-21 00:58:03 | Andi Pratama |
