CREATE DATABASE IF NOT EXISTS panel;
CREATE USER IF NOT EXISTS 'pterodactyl'@'%' IDENTIFIED BY 'change_this_securely';
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'%';
FLUSH PRIVILEGES;
