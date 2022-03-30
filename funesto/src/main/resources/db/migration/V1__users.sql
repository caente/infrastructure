CREATE TABLE IF NOT EXISTS users


(
    id          BIGINT(19) AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  TIMESTAMP   NULL     DEFAULT NULL,
    UNIQUE KEY (name)
) ENGINE = INNODB;

INSERT INTO users(name) VALUES('Bajopeso');
INSERT INTO users(name) VALUES('Abandonado');
INSERT INTO users(name) VALUES('Catastrofe');
