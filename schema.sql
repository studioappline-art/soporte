-- MyUtahSpot: tablas para cuentas de usuario.
-- Ejecutar UNA vez en phpMyAdmin (Hostinger) sobre la misma base de datos del sitio.

CREATE TABLE IF NOT EXISTS account_users (
  id                INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  email             VARCHAR(190) NOT NULL,
  password_hash     VARCHAR(255) NOT NULL,          -- bcrypt; la contraseña real nunca se guarda
  phone             CHAR(10) NULL,                  -- solo dígitos (EE. UU.)
  terms_version     VARCHAR(20) NOT NULL,
  terms_accepted_at DATETIME NOT NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_account_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS account_sessions (
  token_hash CHAR(64) NOT NULL PRIMARY KEY,         -- SHA-256 del token que vive en la cookie
  user_id    INT UNSIGNED NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_sessions_user (user_id),
  KEY idx_sessions_expires (expires_at),
  CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES account_users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS account_photos (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id    INT UNSIGNED NOT NULL,
  filename   VARCHAR(60) NOT NULL,
  bytes      INT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_photos_user (user_id),
  CONSTRAINT fk_photos_user FOREIGN KEY (user_id) REFERENCES account_users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS account_attempts (       -- límite de intentos de login y registro
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  kind       VARCHAR(10) NOT NULL,                  -- 'login' | 'register'
  ip         VARBINARY(16) NOT NULL,
  email_hash CHAR(64) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_attempts_ip (kind, ip, created_at),
  KEY idx_attempts_email (kind, email_hash, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
