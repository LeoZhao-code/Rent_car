-- MySQL dump 10.13  Distrib 5.5.62, for Linux (x86_64)
--
-- Host: localhost    Database: carrent
-- ------------------------------------------------------
-- Server version	5.5.62-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Cars`
--

DROP TABLE IF EXISTS `Cars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Cars` (
  `car_id` int(11) NOT NULL AUTO_INCREMENT,
  `brand` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `fuel_type` varchar(50) NOT NULL,
  `transmission` varchar(50) NOT NULL,
  `seating_capacity` int(11) NOT NULL,
  `vehicle_type` varchar(50) NOT NULL,
  `rental_price` int(11) NOT NULL,
  `registration_number` varchar(50) NOT NULL,
  `color` varchar(50) NOT NULL,
  `location` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL DEFAULT ' ',
  PRIMARY KEY (`car_id`),
  KEY `location` (`location`),
  CONSTRAINT `Cars_ibfk_1` FOREIGN KEY (`location`) REFERENCES `Location` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cars`
--

LOCK TABLES `Cars` WRITE;
/*!40000 ALTER TABLE `Cars` DISABLE KEYS */;
INSERT INTO `Cars` VALUES (1,'KIA','EV-6',2023,'Electric','Automatic',5,'SUV',120,'10UVH0','Silver',3,'../static/image/slider-ev1.jpg'),(2,'Porsche','718',2023,'Gasoline','Automatic',4,'Convertible',210,'24SY00','White',3,'../static/image/718-spyder.jpg'),(3,'Mercedes-Benz','GLC',2023,'Gasoline','Automatic',5,'SUV',210,'WQ340','Blue',3,'../static/image/benz-GLC.png'),(4,'BMW','iX3',2023,'Electric','Automatic',5,'SUV',200,'12J4A','Black',3,'../static/image/BMW-iX3.png'),(5,'Audi','A8',2023,'Gasoline','Automatic',5,'Sedan',220,'134HG5','Silver',1,'../static/image/Audi-A8.png'),(6,'Chevrolet','Impala',2019,'Gasoline','Automatic',5,'Sedan',293,'7EH48','Black',13,'../static/image/2018-chevrolet-impala.jpg'),(7,'Toyota','Corolla',2012,'Electric','Manual',5,'Sedan',263,'9EG49H','Red',16,'../static/image/2012-Toyota-Corolla.png'),(8,'Nissan','Murano',2014,'Gasoline','Manual',4,'Convertible',157,'5HMRX','Silver',11,'../static/image/2014-Nissan-Murano.png'),(9,'Mercedes-Benz','C-Class',2017,'Gasoline','Manual',4,'Convertible',126,'25EIF1','Silver',14,'../static/image/2017-e-cabriolet.jpg'),(10,'Chevrolet','Camaro',2018,'Electric','Manual',4,'Convertible',262,'8QOPF','Orange',11,'../static/image/camaro22.jpeg'),(11,'Toyota','C-HR',2017,'Gasoline','Manual',5,'SUV',254,'8AYJ4','White',14,'../static/image/2017_Toyota_C-HR.jpg'),(12,'Honda','WR-V',2022,'Electric','Manual',5,'SUV',240,'17DQ8','White',13,'../static/image/Honda_SUV_RS.jpg'),(13,'BMW','X1',2016,'Gasoline','Automatic',5,'SUV',266,'AK866','Black',1,'../static/image/2018_BMW_X1.jpg'),(14,'Chevrolet','Camaro',2016,'Electric','Manual',5,'Convertible',135,'R6841','Blue',2,'../static/image/Chevrolet_Camaro.jpg'),(15,'KIA','Rio',2019,'Gasoline','Manual',5,'Convertible',291,'UIGH5','White',8,'../static/image/2019_Kia_Rio.jpg'),(16,'Chevrolet','Captiva',2011,'Electric','Automatic',5,'SUV',113,'70422','Silver',8,'../static/image/Chevrolet_Captiva.jpg'),(17,'Chevrolet','Cobalt',2017,'Electric','Manual',5,'Sedan',211,'4NY28','White',11,'../static/image/Chevrolet_Cobalt.jpg'),(18,'Honda','Accord',2021,'Gasoline','Automatic',5,'Sedan',142,'7H80Q','White',5,'../static/image/2021_Honda_Accord.jpg'),(19,'BMW','M4',2021,'Electric','Automatic',5,'Convertible',286,'1OH33','Blue',2,'../static/image/BMW_M4_CS.jpg'),(20,'Toyota','Highlander',2019,'Electric','Manual',5,'SUV',205,'GYU36','Silver',8,'../static/image/Toyota_Highlander.jpg');
/*!40000 ALTER TABLE `Cars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Customers` (
  `customer_number` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`customer_number`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Customers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `UserAccounts` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */;
INSERT INTO `Customers` VALUES (6,8,'Emily','Johnson','2023-08-01','Lincoln','0200000000'),(10,18,'Liam','Anderson','2023-07-31','Hornby','0200000000'),(11,19,'Olivia','Williams','2023-07-31','Yaldhurst','0200000000'),(12,20,'Noah','Martinez','2023-06-27','West Melton','0200000000'),(13,21,'Ava','Thompson','2023-06-09','Lyttelton','0200000000');
/*!40000 ALTER TABLE `Customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Location`
--

DROP TABLE IF EXISTS `Location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Location` (
  `location_id` int(11) NOT NULL AUTO_INCREMENT,
  `city` varchar(50) NOT NULL,
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Location`
--

LOCK TABLES `Location` WRITE;
/*!40000 ALTER TABLE `Location` DISABLE KEYS */;
INSERT INTO `Location` VALUES (1,'Auckland'),(2,'Wellington'),(3,'Christchurch'),(4,'Hamilton'),(5,'Tauranga'),(6,'Dunedin'),(7,'Hastings'),(8,'Palmerston North'),(9,'Napier'),(10,'Gisborne'),(11,'Rotorua'),(12,'New Plymouth'),(13,'Nelson'),(14,'Taupo'),(15,'Blenheim'),(16,'Port Vila');
/*!40000 ALTER TABLE `Location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Staff`
--

DROP TABLE IF EXISTS `Staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Staff` (
  `staff_number` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`staff_number`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Staff_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `UserAccounts` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Staff`
--

LOCK TABLES `Staff` WRITE;
/*!40000 ALTER TABLE `Staff` DISABLE KEYS */;
INSERT INTO `Staff` VALUES (1,7,'Ethan','Davis','2023-08-03','Rolleston','0200000000'),(6,16,'Mia','Clark','2023-07-31','Lincoln','0200000000'),(7,17,'Oliver','Wilson','2023-08-03','Prebbleton','0200000000');
/*!40000 ALTER TABLE `Staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserAccounts`
--

DROP TABLE IF EXISTS `UserAccounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserAccounts` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_staff` tinyint(1) NOT NULL DEFAULT '0',
  `is_superuser` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserAccounts`
--

LOCK TABLES `UserAccounts` WRITE;
/*!40000 ALTER TABLE `UserAccounts` DISABLE KEYS */;
INSERT INTO `UserAccounts` VALUES (1,'root','root@sample.com','$2b$12$dXgwZxXxSUvTNCUpZiYcjeWSl9VssJ5twq0K8o.XpwSYR/MWD3Ire',0,1),(7,'staff1','staff1@sample.com','$2b$12$i4.By/Wxkh1m50/yhwnMOe.IydbXE7bXo2SyhCXTQTJTjrKtqbqpG',1,0),(8,'customer1','customer1@sample.com','$2b$12$wdXmsr/QRlrORe7JX3o8reUSO8bioOqpDdnbwtM69G/xFhTsjHqNe',0,0),(16,'staff2','staff2@sample.com','$2b$12$lb3cditBsI55XN789H0s1eQyj8g50J3JrS5PxD288NoBzjU.MFr3O',1,0),(17,'staff3','staff3@sample.com','$2b$12$aMKH5ROQProYjhaUAXwv6uUP/cupJv6VBgDf2jTMkVs0AWChgnP6m',1,0),(18,'customer2','customer2@sample.com','$2b$12$QGl9VMGNCHScIhHwDRZ/6.Qzed2IT4Ml0rYMdKKQ2ibMWr6uEsbNO',0,0),(19,'customer3','customer3@sample.com','$2b$12$qFeL8NbZ9ypTDZ98.lqWDOAO9k3ZVysGqurJTv5ZnujqcghYgohmK',0,0),(20,'customer4','customer4@sample.com','$2b$12$Fn04kY4pDR6Sd8i7nQk3LeD/gACTxriwRpCIrUWgfMuuInkoj0O/i',0,0),(21,'customer5','customer5@sample.com','$2b$12$RyMsroENCEjjsDGof1TG6uUKT8ZNhPiklFW2IFHrOFgjwx/bzft3C',0,0);
/*!40000 ALTER TABLE `UserAccounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'carrent'
--

--
-- Dumping routines for database 'carrent'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-08 12:14:45
