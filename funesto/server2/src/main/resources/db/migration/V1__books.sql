CREATE TABLE IF NOT EXISTS books


(
    id          BIGINT(19) AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  TIMESTAMP   NULL     DEFAULT NULL,
    UNIQUE KEY (name)
) ENGINE = INNODB;

INSERT INTO books(name) VALUES('Yes, but he was first');
INSERT INTO books(name) VALUES('There is no place like there');
