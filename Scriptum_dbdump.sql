CREATE DATABASE  IF NOT EXISTS `bookdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bookdb`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bookdb
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `active_users_view`
--

DROP TABLE IF EXISTS `active_users_view`;
/*!50001 DROP VIEW IF EXISTS `active_users_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `active_users_view` AS SELECT 
 1 AS `username`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author` (
  `author_name` varchar(45) NOT NULL,
  `birth_date` date NOT NULL,
  `author_id` int DEFAULT NULL,
  `biography` text,
  PRIMARY KEY (`author_name`,`birth_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES ('Φιόντορ Ντοστογιέφσκι','1821-11-11',267,'Ρώσος μυθιστοριογράφος που εμβάθυνε στην ανθρώπινη ψυχολογία και τα υπαρξιακά διλήμματα, δημιουργώντας κλασικά έργα όπως οι Αδελφοί Καραμαζόφ.'),('Χούλιο Κορτάσαρ','1914-08-26',202,'Αργεντινός συγγραφέας του μαγικού ρεαλισμού, γνωστός για την πειραματική του γραφή και το εμβληματικό μυθιστόρημα Κουτσό.');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `isbn` char(13) NOT NULL,
  `book_id` int DEFAULT NULL,
  `book_title` varchar(100) DEFAULT NULL,
  `page_count` int DEFAULT NULL,
  `publication_year` int DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `language` varchar(45) DEFAULT NULL,
  `genre` varchar(15) DEFAULT NULL,
  `publisher_id` int NOT NULL,
  `author_name` varchar(45) NOT NULL,
  `author_birth_date` date NOT NULL,
  PRIMARY KEY (`isbn`),
  KEY `fk_Book_Publisher` (`publisher_id`),
  KEY `fk_Book_Author` (`author_name`,`author_birth_date`),
  CONSTRAINT `fk_Book_Author` FOREIGN KEY (`author_name`, `author_birth_date`) REFERENCES `author` (`author_name`, `birth_date`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Book_Publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('9789602962763',52,'Ο Μέγας Ιεροεξεταστής',NULL,2019,NULL,NULL,'fiction',518,'Φιόντορ Ντοστογιέφσκι','1821-11-11'),('9789608397934',24,'Το κουτσό',NULL,2018,NULL,NULL,'fiction',503,'Χούλιο Κορτάσαρ','1914-08-26');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booklist`
--

DROP TABLE IF EXISTS `booklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booklist` (
  `booklist_id` int NOT NULL,
  `booklist_name` varchar(50) DEFAULT NULL,
  `book_count` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`booklist_id`),
  KEY `fk_Booklist_User` (`user_id`),
  CONSTRAINT `fk_Booklist_User` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booklist`
--

LOCK TABLES `booklist` WRITE;
/*!40000 ALTER TABLE `booklist` DISABLE KEYS */;
INSERT INTO `booklist` VALUES (456,'To Read',58,101),(478,'Goated Books',13,102);
/*!40000 ALTER TABLE `booklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booklist_contains_book`
--

DROP TABLE IF EXISTS `booklist_contains_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booklist_contains_book` (
  `booklist_id` int NOT NULL,
  `isbn` char(13) NOT NULL,
  `reading_status` enum('want-to-read','currently-reading','read') DEFAULT NULL,
  PRIMARY KEY (`booklist_id`,`isbn`),
  KEY `fk_Contains_Book` (`isbn`),
  CONSTRAINT `fk_Contains_Book` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`) ON DELETE CASCADE,
  CONSTRAINT `fk_Contains_Booklist` FOREIGN KEY (`booklist_id`) REFERENCES `booklist` (`booklist_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booklist_contains_book`
--

LOCK TABLES `booklist_contains_book` WRITE;
/*!40000 ALTER TABLE `booklist_contains_book` DISABLE KEYS */;
INSERT INTO `booklist_contains_book` VALUES (456,'9789608397934','read'),(478,'9789602962763','currently-reading');
/*!40000 ALTER TABLE `booklist_contains_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `publisher_id` int NOT NULL,
  `founded_date` date DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `address` varchar(25) DEFAULT NULL,
  `phone` bigint DEFAULT NULL,
  PRIMARY KEY (`publisher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (503,'1982-02-18','kaktos@publishing.com','Athens, Greece',NULL),(518,'1897-06-19','classicpub@mail.com','Thessaloniki, Greece',NULL);
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reading_challenge`
--

DROP TABLE IF EXISTS `reading_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reading_challenge` (
  `challenge_id` int NOT NULL,
  `challenge_name` varchar(30) DEFAULT NULL,
  `challenge_year` int DEFAULT NULL,
  `challenge_type` varchar(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`challenge_id`),
  KEY `fk_Challenge_User` (`user_id`),
  CONSTRAINT `fk_Challenge_User` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reading_challenge`
--

LOCK TABLES `reading_challenge` WRITE;
/*!40000 ALTER TABLE `reading_challenge` DISABLE KEYS */;
INSERT INTO `reading_challenge` VALUES (903,'classic month',NULL,NULL,'2025-01-01','2025-01-31',102),(918,'year of history',NULL,NULL,'2024-01-01','2024-12-31',103);
/*!40000 ALTER TABLE `reading_challenge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL,
  `username` varchar(45) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `join_date` date DEFAULT NULL,
  `bio` text,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (101,'AlexandrosS','alex@mail.com','2022-04-25',NULL),(102,'ReadingBeast','jorge@mail.com','2020-01-17',NULL),(103,'ElenaBooks','elena@mail.com','2019-12-12',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_follows_user`
--

DROP TABLE IF EXISTS `user_follows_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_follows_user` (
  `follower_user_id` int NOT NULL,
  `followed_user_id` int NOT NULL,
  PRIMARY KEY (`follower_user_id`,`followed_user_id`),
  KEY `fk_Followed` (`followed_user_id`),
  CONSTRAINT `fk_Followed` FOREIGN KEY (`followed_user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_Follower` FOREIGN KEY (`follower_user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_follows_user`
--

LOCK TABLES `user_follows_user` WRITE;
/*!40000 ALTER TABLE `user_follows_user` DISABLE KEYS */;
INSERT INTO `user_follows_user` VALUES (101,102),(102,103);
/*!40000 ALTER TABLE `user_follows_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_participates_reading_challenge`
--

DROP TABLE IF EXISTS `user_participates_reading_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_participates_reading_challenge` (
  `user_id` int NOT NULL,
  `challenge_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`challenge_id`),
  KEY `fk_Participates_Challenge` (`challenge_id`),
  CONSTRAINT `fk_Participates_Challenge` FOREIGN KEY (`challenge_id`) REFERENCES `reading_challenge` (`challenge_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_Participates_User` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_participates_reading_challenge`
--

LOCK TABLES `user_participates_reading_challenge` WRITE;
/*!40000 ALTER TABLE `user_participates_reading_challenge` DISABLE KEYS */;
INSERT INTO `user_participates_reading_challenge` VALUES (102,903),(103,918);
/*!40000 ALTER TABLE `user_participates_reading_challenge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_rates_book`
--

DROP TABLE IF EXISTS `user_rates_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_rates_book` (
  `user_id` int NOT NULL,
  `isbn` char(13) NOT NULL,
  `rating_value` tinyint NOT NULL,
  PRIMARY KEY (`user_id`,`isbn`),
  KEY `fk_Rate_Book` (`isbn`),
  CONSTRAINT `fk_Rate_Book` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`) ON DELETE CASCADE,
  CONSTRAINT `fk_Rate_User` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_rates_book`
--

LOCK TABLES `user_rates_book` WRITE;
/*!40000 ALTER TABLE `user_rates_book` DISABLE KEYS */;
INSERT INTO `user_rates_book` VALUES (102,'9789608397934',5),(103,'9789602962763',5);
/*!40000 ALTER TABLE `user_rates_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_reviews_book`
--

DROP TABLE IF EXISTS `user_reviews_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_reviews_book` (
  `user_id` int NOT NULL,
  `isbn` char(13) NOT NULL,
  `review_id` int DEFAULT NULL,
  `review_text` text,
  `likes_count` int DEFAULT '0',
  `review_date` date DEFAULT NULL,
  PRIMARY KEY (`user_id`,`isbn`),
  KEY `fk_Review_Book` (`isbn`),
  CONSTRAINT `fk_Review_Book` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`) ON DELETE CASCADE,
  CONSTRAINT `fk_Review_User` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_reviews_book`
--

LOCK TABLES `user_reviews_book` WRITE;
/*!40000 ALTER TABLE `user_reviews_book` DISABLE KEYS */;
INSERT INTO `user_reviews_book` VALUES (102,'9789602962763',720,'Το σπουδαιότερο λογοτέχνημα που γράφτηκε ποτέ',25,'2025-11-17'),(102,'9789608397934',708,'Ένα αντιμυθιστόρημα που όμοιο του δεν έχει γραφτεί ποτέ.',13,'2022-07-22');
/*!40000 ALTER TABLE `user_reviews_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `user_reviews_view`
--

DROP TABLE IF EXISTS `user_reviews_view`;
/*!50001 DROP VIEW IF EXISTS `user_reviews_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_reviews_view` AS SELECT 
 1 AS `username`,
 1 AS `book_title`,
 1 AS `review_text`,
 1 AS `review_date`,
 1 AS `likes_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `active_users_view`
--

/*!50001 DROP VIEW IF EXISTS `active_users_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `active_users_view` AS select distinct `u`.`username` AS `username` from (`user` `u` join `user_reviews_book` `ur` on((`u`.`user_id` = `ur`.`user_id`))) where (`ur`.`review_date` > '2025-01-01') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_reviews_view`
--

/*!50001 DROP VIEW IF EXISTS `user_reviews_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_reviews_view` AS select `u`.`username` AS `username`,`b`.`book_title` AS `book_title`,`ur`.`review_text` AS `review_text`,`ur`.`review_date` AS `review_date`,`ur`.`likes_count` AS `likes_count` from ((`user_reviews_book` `ur` join `book` `b` on((`ur`.`isbn` = `b`.`isbn`))) join `user` `u` on((`ur`.`user_id` = `u`.`user_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-19 21:17:47
