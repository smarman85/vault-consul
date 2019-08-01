CREATE DATABASE test_db;
USE test_db;

CREATE TABLE Welcome (
  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  Language VARCHAR(30) NOT NULL,
  Greeting VARCHAR(30) NOT NULL
);

INSERT INTO test_db.Welcome 
  (Language, Greeting)
VALUES 
  ('english', 'Hello'),
  ('german', "Hallo"),
  ('french', 'Bonjour');


CREATE USER 'vaultUser'@'%' IDENTIFIED BY 'S3cretPass';
GRANT SELECT, CREATE USER ON *.* TO 'vaultUser'@'%' WITH GRANT OPTION;
