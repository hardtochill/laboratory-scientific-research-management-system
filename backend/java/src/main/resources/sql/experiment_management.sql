-- MySQL dump 10.13  Distrib 8.3.0, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: experiment_management
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `submission_plan`
--

DROP TABLE IF EXISTS `submission_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL COMMENT '计划名称',
  `create_user_id` bigint NOT NULL COMMENT '创建用户id',
  `create_user_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户昵称',
  `type` int NOT NULL COMMENT '投稿类型：1.期刊论文, 2.会议论文, 3.发明专利, 4.实用新型专利, 5.软件著作权',
  `journal` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '投稿的期刊名称',
  `status` int NOT NULL DEFAULT '1' COMMENT '投稿状态：待送审、审核中、发表成功、发表失败',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `submission_create_time` datetime DEFAULT NULL COMMENT '投稿创建时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='投稿计划表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_plan`
--

LOCK TABLES `submission_plan` WRITE;
/*!40000 ALTER TABLE `submission_plan` DISABLE KEYS */;
INSERT INTO `submission_plan` VALUES (11,'《联邦学习在隐私保护数据挖掘中的研究进展与应用》的投稿计划',108,'student',1,'',1,'该计划用于跟踪文章《联邦学习在隐私保护数据挖掘中的研究进展与应用》的投稿','2026-01-22 23:18:12','2026-01-22 23:18:12','2026-01-22 23:56:40'),(13,'测试',114,'林琳',1,'',1,'','2026-01-29 19:05:53','2026-01-29 19:05:53','2026-01-29 19:25:40');
/*!40000 ALTER TABLE `submission_plan` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-30 11:56:14
