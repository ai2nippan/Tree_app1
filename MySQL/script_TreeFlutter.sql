-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               4.1.12a-nt - Official MySQL binary
-- Server OS:                    Win32
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table treeflutter.plant
CREATE TABLE IF NOT EXISTS `plant` (
  `id` int(11) NOT NULL auto_increment,
  `idPlanter` text,
  `namePlanter` text,
  `name` text,
  `place` text,
  `lat` text,
  `lng` text,
  `avatar` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=tis620;

-- Dumping data for table treeflutter.plant: 3 rows
/*!40000 ALTER TABLE `plant` DISABLE KEYS */;
INSERT INTO `plant` (`id`, `idPlanter`, `namePlanter`, `name`, `place`, `lat`, `lng`, `avatar`) VALUES
	(1, '5', 'อรวรรณ', 'mac', 'book', '13.7093356', '100.5287512', '/Mobile/Flutter2/Train/TreeTest1/php/plant/plant52453.jpg'),
	(2, '5', 'อรวรรณ', 'bbb', 'eee', '13.7093383', '100.5287549', '/Mobile/Flutter2/Train/TreeTest1/php/plant/plant17934.jpg'),
	(3, '5', 'อรวรรณ', 'iii', 'ppp', '13.70934', '100.5287543', '/Mobile/Flutter2/Train/TreeTest1/php/plant/plant11150.jpg'),
	(4, '5', 'อรวรรณ', 'Sara', 'Good', '13.6757752', '100.6593484', '/Mobile/Flutter2/Train/TreeTest1/php/plant/plant5202.jpg');
/*!40000 ALTER TABLE `plant` ENABLE KEYS */;

-- Dumping structure for table treeflutter.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL auto_increment,
  `name` text,
  `usertype` text,
  `occupation` text,
  `sex` text,
  `age` text,
  `email` text,
  `phone` text,
  `user` text,
  `password` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=tis620;

-- Dumping data for table treeflutter.user: 5 rows
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id`, `name`, `usertype`, `occupation`, `sex`, `age`, `email`, `phone`, `user`, `password`) VALUES
	(1, 'Admin', 'ADMIN', 'Official', NULL, NULL, NULL, NULL, 'admin', 'password'),
	(2, 'null', 'USER', 'employee', 'M', 'GT25-60', 'null', 'null', 'null', 'null'),
	(3, 'null', 'USER', 'owner', 'M', 'GT25-60', 'null', 'null', 'null', 'null'),
	(4, 'null', 'USER', 'student', 'F', 'LT18', 'null', 'null', 'null', 'null'),
	(5, 'อรวรรณ', 'USER', 'government', 'F', 'GT18-25', 'orawan@hotmail.com', '0891824488', 'ora', '123456');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
