# Database Configuration Issues

## Problems Found:

1. **Duplicate DB_CONNECTION entries:**
   ```
   DB_CONNECTION=sqlite
   DB_CONNECTION=mysql 
   ```
   Harusnya hanya ada satu:
   ```
   DB_CONNECTION=mysql
   ```

2. **Incorrect database name:**
   ```
   DB_DATABASE=sipresensi_db
   ```
   Should be:
   ```
   DB_DATABASE=sipresensi
   ```

3. **Missing personal_access_tokens table:**
   Laravel Sanctum requires a `personal_access_tokens` table for API authentication, but it's not present in the database schema.

## Recommendations:

1. **Fix .env configuration:**
   ```
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=sipresensi
   DB_USERNAME=root
   DB_PASSWORD=
   ```

2. **Create personal_access_tokens table:**
   Run this SQL to add the required table:
   ```sql
   CREATE TABLE personal_access_tokens (
       id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
       tokenable_type VARCHAR(255) NOT NULL,
       tokenable_id BIGINT UNSIGNED NOT NULL,
       name VARCHAR(255) NOT NULL,
       token VARCHAR(64) NOT NULL,
       abilities TEXT,
       last_used_at TIMESTAMP NULL,
       expires_at TIMESTAMP NULL,
       created_at TIMESTAMP NULL,
       updated_at TIMESTAMP NULL,
       INDEX personal_access_tokens_tokenable_index (tokenable_type, tokenable_id),
       UNIQUE KEY personal_access_tokens_token_unique (token)
   );
   ```

3. **After fixing configuration:**
   Run `php artisan config:cache` to refresh the configuration cache.