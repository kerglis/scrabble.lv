CREATE USER 'scrabble_dev'@'localhost' IDENTIFIED BY 'bvAETBM4ayhRG5sJ';
GRANT USAGE ON * . * TO 'scrabble_dev'@'localhost' IDENTIFIED BY 'bvAETBM4ayhRG5sJ' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;
CREATE DATABASE IF NOT EXISTS `scrabble_dev` ;
ALTER DATABASE `scrabble_dev` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON `scrabble_dev` . * TO 'scrabble_dev'@'localhost';

CREATE USER 'scrabble'@'localhost' IDENTIFIED BY 'bvAETBM4ayhRG5sJ';
GRANT USAGE ON * . * TO 'scrabble'@'localhost' IDENTIFIED BY 'bvAETBM4ayhRG5sJ' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;
CREATE DATABASE IF NOT EXISTS `scrabble` ;
ALTER DATABASE `scrabble` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON `scrabble` . * TO 'scrabble'@'localhost';