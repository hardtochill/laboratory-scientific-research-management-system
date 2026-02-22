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
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父评论id，一级评论为0',
  `literature_id` bigint NOT NULL COMMENT '所属文献id',
  `user_id` bigint NOT NULL COMMENT '发表用户id',
  `user_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '发表用户昵称',
  `receive_user_id` bigint DEFAULT NULL COMMENT '被评论用户id',
  `receive_user_nick_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '被评论用户昵称',
  `comment_content` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论文字内容',
  `comment_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞数',
  `visible_type` int NOT NULL DEFAULT '1' COMMENT '可见类型，1：仅自己可见， 2：所有用户可见',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='文献评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (159,0,64,1,'admin',NULL,NULL,'心得请见文件','2026-01-22 22:40:52',1,2,'2026-01-22 22:40:52','2026-01-22 22:50:40'),(160,159,64,107,'梁齐哲',1,'admin','心得写的非常详细，逻辑严谨。这是我对你的心得的补充观点','2026-01-22 22:50:10',0,2,'2026-01-22 22:50:10','2026-01-22 22:50:10'),(161,0,64,107,'梁齐哲',NULL,NULL,'我的心得','2026-01-22 22:50:22',0,1,'2026-01-22 22:50:22','2026-01-29 13:15:24'),(163,0,64,108,'student',NULL,NULL,'我的心得','2026-01-22 23:02:24',0,2,'2026-01-22 23:02:24','2026-01-29 14:55:14'),(171,0,64,111,'陈胜',NULL,NULL,'测试','2026-01-29 17:56:37',0,1,'2026-01-29 17:56:37','2026-01-29 17:56:37'),(173,163,64,112,'李四',108,'student','1','2026-01-29 17:57:22',0,2,'2026-01-29 17:57:22','2026-01-29 17:57:22'),(174,159,64,114,'林琳',1,'admin','1','2026-01-29 17:59:30',0,2,'2026-01-29 17:59:30','2026-01-29 17:59:30'),(175,0,64,114,'林琳',NULL,NULL,'1','2026-01-29 17:59:41',0,1,'2026-01-29 17:59:41','2026-01-29 17:59:41');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_file`
--

DROP TABLE IF EXISTS `comment_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `comment_id` bigint NOT NULL COMMENT '评论id',
  `file_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `file_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='评论文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_file`
--

LOCK TABLES `comment_file` WRITE;
/*!40000 ALTER TABLE `comment_file` DISABLE KEYS */;
INSERT INTO `comment_file` VALUES (69,159,'心得','2026/01/22/f35e6f35a38d4d0c8c225e7a74f19367.docx','docx',4113566,'2026-01-22 22:40:52','2026-01-22 22:40:52'),(70,160,'补充观点','2026/01/22/95ccafd0286e4765b81048d9df65c971.txt','txt',0,'2026-01-22 22:50:10','2026-01-22 22:50:10'),(71,161,'心得','2026/01/22/643120321e894374bd5b2010ec696f19.docx','docx',4113566,'2026-01-22 22:50:22','2026-01-22 22:50:22'),(72,163,'补充观点','2026/01/22/74b607142fbc4e2b813ff73b0e76f30d.txt','txt',0,'2026-01-22 23:02:24','2026-01-22 23:02:24'),(73,167,'计算机网络-郑老师-第1章','2026/01/29/5387e6e0d8ae4b16bf8834f270d11980.pdf','pdf',5818983,'2026-01-29 15:38:14','2026-01-29 15:38:14'),(74,168,'计算机网络-郑老师-第1章','2026/01/29/dff3235a7c94439e915392430b95f3d8.pdf','pdf',5818983,'2026-01-29 16:59:36','2026-01-29 16:59:36'),(75,169,'计算机网络-郑老师-第1章','2026/01/29/17f1d6b6751e4ed3a74c219be17ca5b0.pdf','pdf',5818983,'2026-01-29 17:03:46','2026-01-29 17:03:46'),(76,170,'计算机网络-郑老师-第1章','2026/01/29/9c7cb5c9568a4dfe9d464437407006d4.pdf','pdf',5818983,'2026-01-29 17:05:56','2026-01-29 17:05:56'),(77,171,'计算机网络-郑老师-第1章','2026/01/29/1d9c21af727742f6a33b8a5f3e254a39.pdf','pdf',5818983,'2026-01-29 17:56:37','2026-01-29 17:56:37'),(78,172,'计算机网络-郑老师-第1章','2026/01/29/5841b9cc124f49fe9a7815084c42ceab.pdf','pdf',5818983,'2026-01-29 17:57:14','2026-01-29 17:57:14'),(79,175,'计算机网络-郑老师-第1章','2026/01/29/6bdbf93de1a04e32a6ff4f15fbda2c13.pdf','pdf',5818983,'2026-01-29 17:59:41','2026-01-29 17:59:41'),(80,176,'计算机网络-郑老师-第1章','2026/01/29/06ad7bd242984dfa8e725e67a0ad6976.pdf','pdf',5818983,'2026-01-29 18:31:16','2026-01-29 18:31:16'),(81,177,'计算机网络-郑老师-第1章','2026/01/30/e22d7acd2540471e8eeec8cdbbdd4455.pdf','pdf',5818983,'2026-01-30 10:34:53','2026-01-30 10:34:53'),(82,178,'计算机网络-郑老师-第1章','2026/01/30/f5c7f220161145758f7fc974a78e4286.pdf','pdf',5818983,'2026-01-30 10:56:12','2026-01-30 10:56:12'),(83,179,'计算机网络-郑老师-第1章','2026/01/30/29ab7865e5b64208b9b9c566582ffab0.pdf','pdf',5818983,'2026-01-30 10:58:45','2026-01-30 10:58:45');
/*!40000 ALTER TABLE `comment_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_like`
--

DROP TABLE IF EXISTS `comment_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_like` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `comment_id` bigint NOT NULL COMMENT '评论id',
  `user_id` bigint NOT NULL COMMENT '点赞用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='评论点赞表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_like`
--

LOCK TABLES `comment_like` WRITE;
/*!40000 ALTER TABLE `comment_like` DISABLE KEYS */;
INSERT INTO `comment_like` VALUES (46,159,107,'2026-01-22 22:50:40','2026-01-22 22:50:40');
/*!40000 ALTER TABLE `comment_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keyword`
--

DROP TABLE IF EXISTS `keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keyword` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `keyword_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '关键词名称',
  `description` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关键词描述',
  `usage_count` int NOT NULL DEFAULT '0' COMMENT '使用次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyword_pk` (`keyword_name`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='文献关键词表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keyword`
--

LOCK TABLES `keyword` WRITE;
/*!40000 ALTER TABLE `keyword` DISABLE KEYS */;
INSERT INTO `keyword` VALUES (18,'深度学习',NULL,1,'2026-01-22 22:57:07','2026-01-31 22:24:07'),(19,'图像语义分割',NULL,1,'2026-01-22 22:57:17','2026-01-31 22:24:07'),(20,'卷积神经网络',NULL,1,'2026-01-22 22:57:23','2026-01-31 22:24:07'),(21,'人工智能',NULL,1,'2026-01-31 22:23:26','2026-01-31 22:24:07');
/*!40000 ALTER TABLE `keyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `literature`
--

DROP TABLE IF EXISTS `literature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literature` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文献id',
  `title` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文献名称',
  `identifier` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文献唯一标识',
  `authors` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文献作者，多个作者用逗号分隔',
  `journal` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '期刊/会议名称',
  `doi` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文献doi',
  `publish_time` date DEFAULT NULL COMMENT '发表时间',
  `abstract_text` text COLLATE utf8mb4_general_ci COMMENT '文献摘要',
  `download_count` int NOT NULL DEFAULT '0' COMMENT '下载次数',
  `teacher_score_avg` decimal(3,1) DEFAULT '0.0' COMMENT '教师打分均值',
  `teacher_score_count` int DEFAULT '0' COMMENT '参与打分的教师数量',
  `student_score_avg` decimal(3,1) DEFAULT '0.0' COMMENT '学生打分均值',
  `student_score_count` int DEFAULT '0' COMMENT '参与打分的学生数量',
  `final_score` decimal(3,1) DEFAULT '0.0' COMMENT '最终得分',
  `upload_user_id` bigint NOT NULL COMMENT '上传用户id',
  `upload_user_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '上传用户昵称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `literature_pk` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='文献表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature`
--

LOCK TABLES `literature` WRITE;
/*!40000 ALTER TABLE `literature` DISABLE KEYS */;
INSERT INTO `literature` VALUES (64,'Quantitive HAZOP and D-S evidence theory-fault tree analysis approach to predict fire and explosion risk in inert gas system on-board tanker ship','QUANTITIVEHAZOPANDDSEVIDENCETHEORYFAULTTREEANALYSISAPPROACHTOPREDICTFIREANDEXPLOSIONRISKININERTGASSYSTEMONBOARDTANKERSHIP','王小明, 李华, 张伟','计算机工程与应用','11','2023-01-01','图像语义分割是计算机视觉领域的重要研究方向，旨在对图像中的每个像素点进行类别划分，从而实现对场景的精细理解。近年来，深度学习技术在图像语义分割任务中取得了显著进展，特别是基于全卷积神经网络（FCN）的方法，已经成为该领域的主流技术。本文首先介绍了图像语义分割的基本概念和任务定义，然后详细综述了基于深度学习的语义分割方法的发展历程，包括全卷积网络、编码器-解码器结构、空洞卷积、注意力机制等关键技术的原理和应用。接着，本文对常用的公开数据集和评估指标进行了总结，并对比分析了不同方法的性能。最后，对当前研究面临的挑战和未来发展方向进行了展望，为相关领域的研究者提供参考。',4,0.0,0,8.6,5,8.9,1,'admin','2026-01-22 22:40:52','2026-01-22 22:40:52','2026-01-31 22:24:07');
/*!40000 ALTER TABLE `literature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `literature_file`
--

DROP TABLE IF EXISTS `literature_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literature_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `literature_id` bigint NOT NULL COMMENT '任务id',
  `file_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `file_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `upload_user_id` bigint NOT NULL COMMENT '上柴用户id',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='文献文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature_file`
--

LOCK TABLES `literature_file` WRITE;
/*!40000 ALTER TABLE `literature_file` DISABLE KEYS */;
INSERT INTO `literature_file` VALUES (13,64,'基于深度学习的图像语义分割研究综述','2026/01/22/2b96ac12aabc4d8d8c65d2c3acbacecf.pdf','pdf',5818983,1,'2026-01-22 22:40:52','2026-01-22 22:40:52','2026-01-22 22:40:52');
/*!40000 ALTER TABLE `literature_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `literature_keyword`
--

DROP TABLE IF EXISTS `literature_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literature_keyword` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `literature_id` bigint NOT NULL COMMENT '文献id',
  `keyword_id` bigint NOT NULL COMMENT '关键词id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='文献关键词关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature_keyword`
--

LOCK TABLES `literature_keyword` WRITE;
/*!40000 ALTER TABLE `literature_keyword` DISABLE KEYS */;
INSERT INTO `literature_keyword` VALUES (103,64,21,'2026-01-31 22:24:07','2026-01-31 22:24:07'),(104,64,20,'2026-01-31 22:24:07','2026-01-31 22:24:07'),(105,64,19,'2026-01-31 22:24:07','2026-01-31 22:24:07'),(106,64,18,'2026-01-31 22:24:07','2026-01-31 22:24:07');
/*!40000 ALTER TABLE `literature_keyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `literature_score`
--

DROP TABLE IF EXISTS `literature_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literature_score` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文献打分id',
  `literature_id` bigint NOT NULL COMMENT '文献id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `score` int NOT NULL COMMENT '打分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `literature_id_user_id_unique` (`literature_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='文献打分表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature_score`
--

LOCK TABLES `literature_score` WRITE;
/*!40000 ALTER TABLE `literature_score` DISABLE KEYS */;
INSERT INTO `literature_score` VALUES (13,64,1,9,'2026-01-22 22:41:33','2026-01-22 22:41:33'),(14,64,107,10,'2026-01-22 22:58:10','2026-01-22 22:58:11'),(15,64,108,5,'2026-01-22 23:00:29','2026-01-22 23:00:29'),(16,64,114,6,'2026-01-29 18:18:20','2026-01-29 18:18:20');
/*!40000 ALTER TABLE `literature_score` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `plan_id` bigint NOT NULL COMMENT '所属的投稿计划id',
  `process_id` bigint NOT NULL COMMENT '所属的投稿流程id',
  `reviewed_user_id` bigint NOT NULL COMMENT '被审核用户id',
  `reviewed_user_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '被审核用户昵称',
  `reviewer_user_id` bigint NOT NULL COMMENT '审核用户id',
  `reviewer_user_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '审核用户昵称',
  `status` int NOT NULL DEFAULT '1' COMMENT '审核状态：1待审核、2审核通过、3审核不通过',
  `reviewed_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '被审核人备注',
  `reviewer_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核人备注',
  `review_create_time` datetime DEFAULT NULL COMMENT '审核发起时间',
  `review_finish_time` datetime DEFAULT NULL COMMENT '审核完成时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='审核表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (9,11,19,108,'student',107,'梁齐哲',3,'',NULL,'2026-01-22 23:33:50','2026-01-22 23:37:45','2026-01-22 23:33:50','2026-01-22 23:37:45'),(10,11,19,108,'student',107,'梁齐哲',3,'',NULL,'2026-01-22 23:40:04','2026-01-22 23:41:19','2026-01-22 23:40:04','2026-01-22 23:41:19'),(11,11,19,107,'梁齐哲',107,'梁齐哲',3,'',NULL,'2026-01-22 23:41:23','2026-01-22 23:41:26','2026-01-22 23:41:23','2026-01-22 23:41:26'),(12,11,21,107,'梁齐哲',1,'admin',1,'',NULL,'2026-01-22 23:56:11',NULL,'2026-01-22 23:56:11','2026-01-22 23:56:11');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `submission_plan_user`
--

DROP TABLE IF EXISTS `submission_plan_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission_plan_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `plan_id` bigint NOT NULL COMMENT '计划id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='投稿计划关联用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_plan_user`
--

LOCK TABLES `submission_plan_user` WRITE;
/*!40000 ALTER TABLE `submission_plan_user` DISABLE KEYS */;
INSERT INTO `submission_plan_user` VALUES (34,11,107,'2026-01-22 23:56:39','2026-01-22 23:56:39'),(35,11,1,'2026-01-22 23:56:39','2026-01-22 23:56:39'),(38,13,114,'2026-01-29 19:25:39','2026-01-29 19:25:39');
/*!40000 ALTER TABLE `submission_plan_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission_process`
--

DROP TABLE IF EXISTS `submission_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission_process` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `plan_id` bigint NOT NULL COMMENT '所属的投稿计划id',
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程名称，例如：一审、、二审等',
  `reviewer_user_id` bigint DEFAULT NULL COMMENT '审核用户id',
  `reviewer_user_nick_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核用户昵称',
  `status` int NOT NULL DEFAULT '1' COMMENT '流程状态：1待发起内部审核、2内部审核中、3内部审核通过、4内部审核不通过',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核备注',
  `process_create_time` datetime DEFAULT NULL COMMENT '流程创建时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='投稿流程表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_process`
--

LOCK TABLES `submission_process` WRITE;
/*!40000 ALTER TABLE `submission_process` DISABLE KEYS */;
INSERT INTO `submission_process` VALUES (19,11,'一审',107,'梁齐哲',4,NULL,'2026-01-22 23:18:12','2026-01-22 23:18:12','2026-01-22 23:41:26'),(22,11,'校稿',107,'梁齐哲',1,'','2026-01-22 23:57:09','2026-01-22 23:57:09','2026-01-22 23:57:14'),(24,13,'一审',NULL,NULL,1,NULL,'2026-01-29 19:05:53','2026-01-29 19:05:53','2026-01-29 19:05:53');
/*!40000 ALTER TABLE `submission_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission_process_file`
--

DROP TABLE IF EXISTS `submission_process_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission_process_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `process_id` bigint NOT NULL COMMENT '所属的投稿流程id',
  `tag` int DEFAULT NULL COMMENT '文件标签：提交给期刊的文件，原始数据与程序，审稿意见，补充数据，最终稿',
  `file_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `file_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='投稿流程文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_process_file`
--

LOCK TABLES `submission_process_file` WRITE;
/*!40000 ALTER TABLE `submission_process_file` DISABLE KEYS */;
INSERT INTO `submission_process_file` VALUES (50,19,1,'联邦学习在隐私保护数据挖掘中的研究进展与应用','2026/01/22/2b6ed85797dd4fecadf989809285ba46.pdf','pdf',5818983,'2026-01-22 23:31:24','2026-01-22 23:31:24','2026-01-22 23:31:24'),(51,19,2,'程序','2026/01/22/358cfcd4941e40fca53b14b1edc00181.zip','zip',0,'2026-01-22 23:32:35','2026-01-22 23:32:35','2026-01-22 23:32:35'),(52,19,2,'数据','2026/01/22/22fcd21c14234f42b541cabec5ec27ed.zip','zip',0,'2026-01-22 23:32:35','2026-01-22 23:32:35','2026-01-22 23:32:35');
/*!40000 ALTER TABLE `submission_process_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2025-06-26 22:53:04','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2025-06-26 22:53:04','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2025-06-26 22:53:04','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2025-06-26 22:53:04','admin','2026-01-17 16:00:49','是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','N','admin','2025-06-26 22:53:04','admin','2025-12-01 21:27:27','是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2025-06-26 22:53:04','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2025-06-26 22:53:04','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2025-06-26 22:53:04','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2025-06-26 22:53:04','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2025-06-26 22:53:04','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2025-06-26 22:53:04','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2025-06-26 22:53:04','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2025-06-26 22:53:04','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2025-06-26 22:53:04','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2025-06-26 22:53:04','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2025-06-26 22:53:04','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2025-06-26 22:53:04','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2025-06-26 22:53:04','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2025-06-26 22:53:04','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2025-06-26 22:53:04','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2025-06-26 22:53:04','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2025-06-26 22:53:04','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2025-06-26 22:53:04','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2025-06-26 22:53:04','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2025-06-26 22:53:04','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2025-06-26 22:53:04','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2025-06-26 22:53:04','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2025-06-26 22:53:04','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2025-06-26 22:53:04','',NULL,'停用状态');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2025-06-26 22:53:03','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2025-06-26 22:53:03','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2025-06-26 22:53:03','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2025-06-26 22:53:03','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2025-06-26 22:53:03','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2025-06-26 22:53:03','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2025-06-26 22:53:03','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2025-06-26 22:53:03','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2025-06-26 22:53:03','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2025-06-26 22:53:03','',NULL,'登录状态列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2025-06-26 22:53:04','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2025-06-26 22:53:04','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2025-06-26 22:53:04','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=695 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (493,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:50:40'),(494,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:50:49'),(495,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:50:53'),(496,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-01-17 21:53:30'),(497,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-17 21:53:35'),(498,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:53:38'),(499,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:54:43'),(500,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:54:53'),(501,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:55:00'),(502,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:55:08'),(503,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:55:32'),(504,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:55:41'),(505,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:55:47'),(506,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:55:56'),(507,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:56:30'),(508,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:56:43'),(509,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 22:21:58'),(510,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 22:22:20'),(511,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 22:22:33'),(512,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 22:22:42'),(513,'2022010101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 22:23:01'),(514,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 22:23:10'),(515,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-18 10:57:29'),(516,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-18 17:06:47'),(517,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:08:36'),(518,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 21:11:19'),(519,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:11:38'),(520,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 21:11:56'),(521,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:12:49'),(522,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 21:23:58'),(523,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-22 21:24:06'),(524,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:24:11'),(525,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 21:24:38'),(526,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-22 21:24:50'),(527,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-22 21:24:59'),(528,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-22 21:25:05'),(529,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:25:10'),(530,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 21:25:17'),(531,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:25:27'),(532,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 21:25:48'),(533,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-22 21:25:58'),(534,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-22 21:25:58'),(535,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:26:06'),(536,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 21:31:58'),(537,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 21:32:10'),(538,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 22:04:52'),(539,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 22:05:01'),(540,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 22:09:02'),(541,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 22:09:11'),(542,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 22:48:31'),(543,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 22:48:48'),(544,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 22:59:41'),(545,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-22 22:59:51'),(546,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 22:59:54'),(547,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 23:07:47'),(548,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 23:07:57'),(549,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 23:09:01'),(550,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 23:09:11'),(551,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 23:35:19'),(552,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 23:35:31'),(553,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 23:37:49'),(554,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 23:37:54'),(555,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 23:39:31'),(556,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 23:39:58'),(557,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-22 23:40:07'),(558,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-22 23:40:15'),(559,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-28 22:09:14'),(560,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-28 22:09:19'),(561,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-28 22:09:22'),(562,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-28 22:09:27'),(563,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-28 22:09:35'),(564,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-28 22:09:42'),(565,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-28 22:09:47'),(566,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-28 22:09:59'),(567,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-28 22:52:06'),(568,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-28 22:52:09'),(569,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-28 23:00:59'),(570,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-28 23:01:05'),(571,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-28 23:01:16'),(572,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-28 23:01:24'),(573,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 12:52:28'),(574,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 14:51:03'),(575,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 14:51:11'),(576,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 14:51:32'),(577,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-29 14:51:40'),(578,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 14:51:47'),(579,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 14:52:33'),(580,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 14:52:48'),(581,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 14:54:06'),(582,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 14:54:31'),(583,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 14:54:57'),(584,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 14:55:04'),(585,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 14:55:26'),(586,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 14:55:33'),(587,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 17:56:49'),(588,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-29 17:56:54'),(589,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 17:56:56'),(590,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 17:58:50'),(591,'2022040245','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-29 17:58:59'),(592,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 17:59:09'),(593,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 20:02:56'),(594,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 20:03:06'),(595,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 20:06:20'),(596,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-29 20:06:31'),(597,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-29 20:06:33'),(598,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 20:06:41'),(599,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 20:37:26'),(600,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 20:37:32'),(601,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-29 20:37:41'),(602,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-29 20:37:47'),(603,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-29 20:37:50'),(604,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-30 10:34:24'),(605,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-31 18:56:04'),(606,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-01 00:12:37'),(607,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 17:09:04'),(608,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-09 17:35:47'),(609,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 17:35:56'),(610,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-09 17:36:40'),(611,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 17:36:46'),(612,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-09 17:57:32'),(613,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 17:57:40'),(614,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-09 17:59:02'),(615,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 17:59:08'),(616,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-09 17:59:34'),(617,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 17:59:39'),(618,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-09 18:00:50'),(619,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 18:00:56'),(620,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-09 18:02:00'),(621,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 18:02:06'),(622,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-09 22:55:02'),(623,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-10 00:25:29'),(624,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-10 00:25:40'),(625,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-10 00:25:48'),(626,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-10 00:25:56'),(627,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-11 12:41:36'),(628,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-11 13:16:51'),(629,'2022666666','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-02-11 13:16:58'),(630,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-11 13:17:10'),(631,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-11 14:19:03'),(632,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-11 14:19:13'),(633,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-11 14:19:58'),(634,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-11 14:20:04'),(635,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-11 14:20:21'),(636,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-11 14:20:28'),(637,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-11 14:20:52'),(638,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-02-11 14:26:14'),(639,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-11 14:26:20'),(640,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 21:00:34'),(641,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:42:04'),(642,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:42:16'),(643,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:50:11'),(644,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:50:18'),(645,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:50:45'),(646,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:50:52'),(647,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:51:41'),(648,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:51:44'),(649,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:52:46'),(650,'2022666666','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-02-12 23:52:54'),(651,'2022666666','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-02-12 23:53:03'),(652,'2022066666','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-02-12 23:53:15'),(653,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:53:25'),(654,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:53:38'),(655,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:53:42'),(656,'2000666666','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:54:08'),(657,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:54:16'),(658,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:54:44'),(659,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:54:50'),(660,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:57:00'),(661,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:57:05'),(662,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:57:21'),(663,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:57:30'),(664,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:58:14'),(665,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-02-12 23:58:19'),(666,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:58:21'),(667,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:58:52'),(668,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:58:58'),(669,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-12 23:59:21'),(670,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-12 23:59:29'),(671,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-20 16:56:05'),(672,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 16:19:15'),(673,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 16:49:59'),(674,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 16:50:03'),(675,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 16:50:51'),(676,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 16:50:58'),(677,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 16:56:30'),(678,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 16:56:35'),(679,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 17:14:17'),(680,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 17:14:22'),(681,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 17:18:52'),(682,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 17:18:57'),(683,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 17:19:24'),(684,'202204021','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-02-22 17:19:30'),(685,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-02-22 17:19:38'),(686,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 17:19:41'),(687,'2022040241','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 17:26:41'),(688,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 17:26:47'),(689,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 17:28:07'),(690,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 17:28:13'),(691,'2022040242','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 17:29:16'),(692,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 17:29:21'),(693,'2022040243','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-02-22 17:29:58'),(694,'student','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-02-22 17:30:04');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2020 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,99,'system',NULL,'','',1,0,'M','0','0','','system','admin','2025-06-26 22:53:03','admin','2025-07-15 01:23:18','系统管理目录'),(2,'系统监控',0,97,'monitor',NULL,'','',1,0,'M','0','1','','monitor','admin','2025-06-26 22:53:03','admin','2025-12-03 21:32:08','系统监控目录'),(3,'系统工具',0,98,'tool',NULL,'','',1,0,'M','1','1','','tool','admin','2025-06-26 22:53:03','admin','2025-12-03 21:20:45','系统工具目录'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2025-06-26 22:53:03','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2025-06-26 22:53:03','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2025-06-26 22:53:03','',NULL,'菜单管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2025-06-26 22:53:03','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2025-06-26 22:53:03','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2025-06-26 22:53:03','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2025-06-26 22:53:03','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2025-06-26 22:53:03','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','1','1','monitor:job:list','job','admin','2025-06-26 22:53:03','admin','2025-12-03 21:21:09','定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2025-06-26 22:53:03','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2025-06-26 22:53:03','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2025-06-26 22:53:03','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2025-06-26 22:53:03','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2025-06-26 22:53:03','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2025-06-26 22:53:03','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2025-06-26 22:53:03','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2025-06-26 22:53:03','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2025-06-26 22:53:03','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2025-06-26 22:53:03','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2025-06-26 22:53:03','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2025-06-26 22:53:03','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2025-06-26 22:53:03','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2025-06-26 22:53:03','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2025-06-26 22:53:03','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2025-06-26 22:53:03','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2025-06-26 22:53:03','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2025-06-26 22:53:03','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2025-06-26 22:53:03','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2025-06-26 22:53:03','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2025-06-26 22:53:03','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2025-06-26 22:53:03','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2025-06-26 22:53:03','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2025-06-26 22:53:03','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2025-06-26 22:53:03','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2025-06-26 22:53:03','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2025-06-26 22:53:03','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2025-06-26 22:53:03','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2025-06-26 22:53:03','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2025-06-26 22:53:03','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2025-06-26 22:53:03','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2025-06-26 22:53:03','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2025-06-26 22:53:03','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2025-06-26 22:53:03','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2025-06-26 22:53:03','',NULL,''),(2009,'任务管理',0,1,'task','task/TaskManagement',NULL,'',1,0,'C','0','0','','task','admin','2025-12-08 23:29:31','admin','2026-01-08 17:20:32',''),(2010,'文献管理',0,2,'literature','',NULL,'',1,0,'M','0','0','','excel','admin','2025-12-18 23:05:31','admin','2026-01-08 17:05:12',''),(2011,'文献资源',2010,1,'resource','literature/LiteratureManagement',NULL,'',1,0,'C','0','0','','library','admin','2025-12-28 20:12:53','admin','2026-01-14 14:51:49',''),(2012,'关键词管理',2010,2,'keyword','keyword/KeywordManagement',NULL,'',1,0,'C','0','0','','keyword','admin','2025-12-28 20:14:34','admin','2026-01-08 17:12:23',''),(2015,'文献统计',2010,3,'statistic','literature/LiteratureStatistic',NULL,'',1,0,'C','0','0','','chart','admin','2026-01-05 21:58:35','admin','2026-01-05 22:01:49',''),(2016,'投稿管理',0,3,'submission',NULL,NULL,'',1,0,'M','0','0','','guide','admin','2026-01-08 17:08:12','admin','2026-01-08 17:08:26',''),(2017,'投稿计划',2016,1,'plan','submission/SubmissionManagement',NULL,'',1,0,'C','0','0',NULL,'tab','admin','2026-01-08 17:17:53','',NULL,''),(2018,'审核流程',2016,2,'review','review/ReviewManagement',NULL,'',1,0,'C','0','0',NULL,'eye-open','admin','2026-01-08 17:19:08','',NULL,''),(2019,'我的阅读',2010,4,'read','literature/LiteratureRead',NULL,'',1,0,'C','0','0','','education','admin','2026-01-14 14:51:17','admin','2026-01-14 14:52:35','');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2025-06-26 22:53:04','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2025-06-26 22:53:04','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=343 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/4','127.0.0.1','内网IP','4','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-07-09 10:25:50',16),(101,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-09 10:26:01',68),(102,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/4','127.0.0.1','内网IP','4','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-09 10:26:15',31),(103,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/radarInfo/index\",\"createBy\":\"admin\",\"icon\":\"international\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"雷达光电联动监控\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"radarLinkage\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-09 11:08:07',36),(104,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:22:59',75),(105,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:23:01',37),(106,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":99,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:23:18',46),(107,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/threat_level\",\"createBy\":\"admin\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"威胁等级管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"ThreatLevel\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:24:59',34),(108,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/radarInfo/index\",\"createTime\":\"2025-07-09 11:08:07\",\"icon\":\"international\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"雷达光电联动监控\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"radarLinkage\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:26:47',34),(109,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/threat_level\",\"createTime\":\"2025-07-15 01:24:59\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"威胁等级管理\",\"menuType\":\"C\",\"orderNum\":66,\"params\":{},\"parentId\":0,\"path\":\"ThreatLevel\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:27:09',33),(110,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/birdInfo\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情历史记录\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"birdInfo\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:28:11',30),(111,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":97,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:28:30',34),(112,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:28:35',31),(113,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_info\",\"createTime\":\"2025-07-15 01:28:11\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"鸟情历史记录\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"birdInfo\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:29:00',22),(114,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"bird_report\",\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情报表\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"BirdReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:38:29',24),(115,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_info\",\"createTime\":\"2025-07-15 01:28:11\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"鸟情历史记录\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"BirdInfo\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:38:35',19),(116,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"鸟情报表\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"BirdReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:39:16',22),(117,'字典类型',1,'com.ruoyi.project.system.controller.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"威胁等级\",\"dictType\":\"threat_level\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:21:04',13),(118,'字典类型',2,'com.ruoyi.project.system.controller.SysDictTypeController.edit()','PUT',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:21:04\",\"dictId\":100,\"dictName\":\"威胁等级\",\"dictType\":\"threat_level\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:36:15',29),(119,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅰ级\",\"dictSort\":1,\"dictType\":\"threat_level\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:36:34',22),(120,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅱ级\",\"dictSort\":2,\"dictType\":\"threat_level\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:37:43',22),(121,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:36:34\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"Ⅰ级\",\"dictSort\":1,\"dictType\":\"threat_level\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:37:49',26),(122,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:37:43\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"Ⅱ级\",\"dictSort\":2,\"dictType\":\"threat_level\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:37:55',23),(123,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"‌Ⅲ级\",\"dictSort\":3,\"dictType\":\"threat_level\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:39:24',21),(124,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:39:23\",\"default\":false,\"dictCode\":102,\"dictLabel\":\"‌Ⅲ级\",\"dictSort\":3,\"dictType\":\"threat_level\",\"dictValue\":\"3\",\"isDefault\":\"N\",\"listClass\":\"info\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:17',23),(125,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:39:23\",\"default\":false,\"dictCode\":102,\"dictLabel\":\"‌Ⅲ级\",\"dictSort\":3,\"dictType\":\"threat_level\",\"dictValue\":\"3\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:27',23),(126,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:37:43\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"Ⅱ级\",\"dictSort\":2,\"dictType\":\"threat_level\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:30',23),(127,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅳ级\",\"dictSort\":4,\"dictType\":\"threat_level\",\"dictValue\":\"4\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:41',23),(128,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:41:41\",\"default\":false,\"dictCode\":103,\"dictLabel\":\"Ⅳ级\",\"dictSort\":4,\"dictType\":\"threat_level\",\"dictValue\":\"4\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:46',23),(129,'字典类型',1,'com.ruoyi.project.system.controller.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"目标类型\",\"dictType\":\"target_level\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:58:27',37),(130,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"类型识别未完成\",\"dictSort\":0,\"dictType\":\"target_level\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:01:05',184),(131,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"cssClass\":\"\",\"default\":false,\"dictLabel\":\"人\",\"dictSort\":1,\"dictType\":\"target_level\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:01:18',32),(132,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"cssClass\":\"\",\"default\":false,\"dictLabel\":\"车\",\"dictSort\":2,\"dictType\":\"target_level\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:13',30),(133,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"无人机\",\"dictSort\":3,\"dictType\":\"target_level\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:20',30),(134,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"飞鸟\",\"dictSort\":5,\"dictType\":\"target_level\",\"dictValue\":\"5\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:31',30),(135,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-16 00:02:31\",\"default\":false,\"dictCode\":108,\"dictLabel\":\"飞鸟\",\"dictSort\":4,\"dictType\":\"target_level\",\"dictValue\":\"4\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:39',19),(136,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未识别出目标类型\",\"dictSort\":5,\"dictType\":\"target_level\",\"dictValue\":\"5\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:48',30),(137,'字典类型',2,'com.ruoyi.project.system.controller.SysDictTypeController.edit()','PUT',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:58:27\",\"dictId\":101,\"dictName\":\"目标类型\",\"dictType\":\"target_type\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 11:09:16',19),(138,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情报表\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"report\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"新增菜单\'鸟情报表\'失败，菜单名称已存在\",\"code\":500}',0,NULL,'2025-07-18 22:53:23',6),(139,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情报表1\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"report\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:53:27',16),(140,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"周报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2004,\"path\":\"BirdReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:53:49',27),(141,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-07-18 22:53:27\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"鸟情报表\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"report\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:53:54',21),(142,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_weekly_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"周报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2004,\"path\":\"BirdReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:57:54',25),(143,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_monthly_report\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"月报\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2004,\"path\":\"BirdMonthlyReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:59:32',24),(144,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_weekly_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"周报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2004,\"path\":\"BirdWeeklyReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:59:42',24),(145,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_quarterly_report\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"季度报\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2004,\"path\":\"BirdQuarterlyReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 23:01:20',21),(146,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird annual report\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"年报\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2004,\"path\":\"BirdAnnualReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 23:02:16',21),(147,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_annual_report\",\"createTime\":\"2025-07-18 23:02:16\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2007,\"menuName\":\"年报\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2004,\"path\":\"BirdAnnualReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 23:02:51',23),(148,'用户管理',5,'com.ruoyi.project.system.controller.SysUserController.export()','POST',1,'admin','研发部门','/system/user/export','127.0.0.1','内网IP','{\"pageSize\":\"10\",\"pageNum\":\"1\"}',NULL,0,NULL,'2025-08-04 09:32:25',907),(149,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"mapTest/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"地图测试\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"mapTest\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-09 20:51:03',13),(150,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2000','127.0.0.1','内网IP','2000','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:30',94),(151,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2002','127.0.0.1','内网IP','2002','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:32',23),(152,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2004','127.0.0.1','内网IP','2004','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:41:35',3),(153,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2003','127.0.0.1','内网IP','2003','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:46',65),(154,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2005','127.0.0.1','内网IP','2005','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:49',32),(155,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2006','127.0.0.1','内网IP','2006','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:51',19),(156,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2007','127.0.0.1','内网IP','2007','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:54',36),(157,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2004','127.0.0.1','内网IP','2004','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:57',35),(158,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2008','127.0.0.1','内网IP','2008','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:42:01',30),(159,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2001','127.0.0.1','内网IP','2001','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:42:05',36),(160,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/103','127.0.0.1','内网IP','103','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:57:54',9),(161,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1016','127.0.0.1','内网IP','1016','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:58:00',9),(162,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1019','127.0.0.1','内网IP','1019','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:58:21',6),(163,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1017,\"menuName\":\"部门新增\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:add\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:58:32',544),(164,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1017','127.0.0.1','内网IP','1017','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:58:35',7),(165,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1017,\"menuName\":\"部门新增\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:add\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:58:45',46),(166,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1020','127.0.0.1','内网IP','1020','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:59:03',7),(167,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/3','127.0.0.1','内网IP','3','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 21:24:59',8),(168,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/115','127.0.0.1','内网IP','115','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 21:25:07',6),(169,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:25:24',55),(170,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:04',85),(171,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:24',71),(172,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:36',36),(173,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:50',534),(174,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:27:04',66),(175,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin','研发部门','/system/config','127.0.0.1','内网IP','{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"N\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:27:28',34),(176,'参数管理',5,'com.ruoyi.project.system.controller.SysConfigController.export()','POST',1,'admin','研发部门','/system/config/export','127.0.0.1','内网IP','{\"pageSize\":\"10\",\"pageNum\":\"1\"}',NULL,0,NULL,'2025-12-01 21:27:42',1507),(177,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/100,101','127.0.0.1','内网IP','[100,101]',NULL,1,'威胁等级已分配,不能删除','2025-12-02 14:22:38',16),(178,'字典类型',3,'com.ruoyi.project.system.controller.SysDictDataController.remove()','DELETE',1,'admin','研发部门','/system/dict/data/100,101,102,103','127.0.0.1','内网IP','[100,101,102,103]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:22:51',128),(179,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/100','127.0.0.1','内网IP','[100]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:22:57',31),(180,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/101','127.0.0.1','内网IP','[101]',NULL,1,'目标类型已分配,不能删除','2025-12-02 14:23:02',6),(181,'字典类型',3,'com.ruoyi.project.system.controller.SysDictDataController.remove()','DELETE',1,'admin','研发部门','/system/dict/data/104,105,106,107,108,109','127.0.0.1','内网IP','[104,105,106,107,108,109]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:23:10',218),(182,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/101','127.0.0.1','内网IP','[101]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:23:16',533),(183,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1016','127.0.0.1','内网IP','1016','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-02 14:23:36',7),(184,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1019,\"menuName\":\"部门删除\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:remove\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:23:50',450),(185,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1019','127.0.0.1','内网IP','1019','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-02 14:23:55',6),(186,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1019,\"menuName\":\"部门删除\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:remove\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:24:05',1081),(187,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":97,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:01:05',95),(188,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:01:16',24),(189,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:07:28',72),(190,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:07:36',39),(191,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:20:46',49),(192,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/job/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":110,\"menuName\":\"定时任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2,\"path\":\"job\",\"perms\":\"monitor:job:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:20:53',36),(193,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/job/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":110,\"menuName\":\"定时任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2,\"path\":\"job\",\"perms\":\"monitor:job:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:21:10',553),(194,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"test\",\"params\":{},\"postIds\":[],\"roleIds\":[2],\"status\":\"0\",\"userId\":100,\"userName\":\"测试用户\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:23:55',191),(195,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:28:44',77),(196,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:28:50',36),(197,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":true,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045],\"params\":{},\"remark\":\"超级管理员\",\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}',NULL,1,'不允许操作超级管理员角色','2025-12-03 21:28:58',3),(198,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:29:10',45),(199,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":97,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:32:09',576),(200,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:37:20',73),(201,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:19:36',76),(202,'角色管理',1,'com.ruoyi.project.system.controller.SysRoleController.add()','POST',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":0,\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:19:53',68),(203,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":true,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"超级管理员\",\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":0,\"status\":\"0\"}',NULL,1,'不允许操作超级管理员角色','2025-12-03 22:20:06',2),(204,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:20:16',82),(205,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:20:23',34),(206,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:20:29',45),(207,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin','研发部门','/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"1,2,100\",\"userId\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 00:12:10',105),(208,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin','研发部门','/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"1\",\"userId\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 00:35:24',100),(209,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 23:22:16',44),(210,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 23:22:53',70),(211,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createBy\":\"admin\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 23:29:31',66),(212,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createBy\":\"admin\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-18 23:05:31',54),(213,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/103','127.0.0.1','内网IP','103','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-25 20:17:48',11),(214,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1016','127.0.0.1','内网IP','1016','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:17:56',109),(215,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1017','127.0.0.1','内网IP','1017','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:17:59',42),(216,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1018','127.0.0.1','内网IP','1018','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:02',35),(217,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1019','127.0.0.1','内网IP','1019','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:05',30),(218,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/103','127.0.0.1','内网IP','103','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:07',38),(219,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1020','127.0.0.1','内网IP','1020','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:12',40),(220,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1022','127.0.0.1','内网IP','1022','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:16',24),(221,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1021','127.0.0.1','内网IP','1021','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:19',32),(222,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1023','127.0.0.1','内网IP','1023','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:22',28),(223,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1024','127.0.0.1','内网IP','1024','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:24',30),(224,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/104','127.0.0.1','内网IP','104','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:27',43),(225,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"测试用户02\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":101,\"userName\":\"测试用户02\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:31:02',211),(226,'用户头像',2,'com.ruoyi.project.system.controller.SysProfileController.avatar()','POST',1,'admin',NULL,'/system/user/profile/avatar','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/12/25/4decdb917c05482d944f625210ff5077.jpg\",\"code\":200}',0,NULL,'2025-12-25 20:38:32',132),(227,'用户头像',2,'com.ruoyi.project.system.controller.SysProfileController.avatar()','POST',1,'admin',NULL,'/system/user/profile/avatar','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/12/25/1c21f40eaf2e4c3dadef5c4b4e3bd56e.png\",\"code\":200}',0,NULL,'2025-12-25 20:43:13',54033),(228,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2025-12-25 20:31:02\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":2,\"loginIp\":\"\",\"nickName\":\"测试用户02\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"测试用户02\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:26:20',85),(229,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/101','127.0.0.1','内网IP','[101]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:26:31',75),(230,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"graduateFlag\":2,\"nickName\":\"测试毕业\",\"params\":{},\"roleIds\":[],\"status\":\"0\",\"userId\":102,\"userName\":\"hih\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:26:42',190),(231,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/102','127.0.0.1','内网IP','[102]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:27:02',70),(232,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"100\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 20:16:32',36),(233,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.resetPwd()','PUT',1,'admin',NULL,'/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":true,\"params\":{},\"userId\":1}',NULL,1,'不允许操作超级管理员用户','2025-12-26 20:16:53',5),(234,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 20:19:29',47),(235,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 20:19:33',35),(236,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"1,2\",\"userId\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 21:17:26',398),(237,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createBy\":\"admin\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"literature\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:12:53',76),(238,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:14:34',30),(239,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:15:20',44),(240,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010,2011,2012],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:16:36',99),(241,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literatureManagement\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:19:18',57),(242,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literatureManagement\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:19:25',59),(243,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:40:43',72),(244,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:41:14',26),(245,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2009,2011],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:49:33',79),(246,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureDetail\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献详情\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"detail\",\"status\":\"0\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:53:26',69),(247,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureDetail\",\"createTime\":\"2025-12-28 20:53:26\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2013,\"menuName\":\"文献详情\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"detail\",\"perms\":\"\",\"query\":\"path: \':id\'\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:55:39',56),(248,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2013','127.0.0.1','内网IP','2013','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 21:00:27',53),(249,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureDetail\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献详情\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"detail\",\"query\":\":id\",\"status\":\"0\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 21:13:20',80),(250,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2014','127.0.0.1','内网IP','2014','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 21:20:15',63),(251,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"job\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:48:50',74),(252,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:48:59',27),(253,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createTime\":\"2025-12-28 20:14:34\",\"icon\":\"build\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:02',22),(254,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:26',66),(255,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:30',38),(256,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createTime\":\"2025-12-28 20:14:34\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:36',34),(257,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"Literature/LiteratureStatistic\",\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献统计\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"statistic\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-05 21:58:35',77),(258,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010,2011,2012,2015],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-05 22:00:06',112),(259,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureStatistic\",\"createTime\":\"2026-01-05 21:58:35\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2015,\"menuName\":\"文献统计\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"statistic\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-05 22:01:50',75),(260,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:04:35',45),(261,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"excel\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:05:12',37),(262,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:06:39',86),(263,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"投稿管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"submission\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:08:12',32),(264,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-01-08 17:08:12\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2016,\"menuName\":\"投稿管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"submission\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:08:26',67),(265,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createTime\":\"2025-12-28 20:14:34\",\"icon\":\"keyword\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:12:24',80),(266,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"submission/SubmissionManagement\",\"createBy\":\"admin\",\"icon\":\"tab\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"投稿计划\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2016,\"path\":\"plan\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:17:53',28),(267,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"review/ReviewManagement\",\"createBy\":\"admin\",\"icon\":\"eye-open\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"审核流程\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2016,\"path\":\"review\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:19:08',58),(268,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"task\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:20:32',66),(269,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2009,2011,2016,2017,2018],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-13 15:18:20',118),(270,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"102\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-13 16:46:46',82),(271,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"101\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-13 16:46:50',32),(272,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献资源\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:39:35',92),(273,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"library\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献资源\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:42:36',76),(274,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/Literaturereading\",\"createBy\":\"admin\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"我的阅读\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2010,\"path\":\"reading\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:51:17',72),(275,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"library\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献资源\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"resource\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:51:49',36),(276,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureRead\",\"createTime\":\"2026-01-14 14:51:17\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"我的阅读\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:52:35',32),(277,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2009,2011,2019,2016,2017,2018],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:12:23',111),(278,'个人信息',2,'com.ruoyi.project.system.controller.SysProfileController.updatePwd()','PUT',1,'test03',NULL,'/system/user/profile/updatePwd','127.0.0.1','内网IP','{}','{\"msg\":\"新密码不能与旧密码相同\",\"code\":500}',0,NULL,'2026-01-17 15:14:56',256),(279,'个人信息',2,'com.ruoyi.project.system.controller.SysProfileController.updatePwd()','PUT',1,'test03',NULL,'/system/user/profile/updatePwd','127.0.0.1','内网IP','{}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:48:08',386),(280,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"N\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:57:40',102),(281,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"Y\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 15:57:40\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:59:30',838),(282,'参数管理',9,'com.ruoyi.project.system.controller.SysConfigController.refreshCache()','DELETE',1,'admin',NULL,'/system/config/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:59:32',21),(283,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"N\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 15:59:29\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:01',82),(284,'参数管理',9,'com.ruoyi.project.system.controller.SysConfigController.refreshCache()','DELETE',1,'admin',NULL,'/system/config/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:02',9),(285,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"N\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 16:00:01\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:16',35),(286,'参数管理',9,'com.ruoyi.project.system.controller.SysConfigController.refreshCache()','DELETE',1,'admin',NULL,'/system/config/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:18',7),(287,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 16:00:16\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:49',63),(288,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/2','127.0.0.1','内网IP','[2]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:42:35',70),(289,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/100','127.0.0.1','内网IP','[100]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:42:38',51),(290,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/101','127.0.0.1','内网IP','[101]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:42:40',29),(291,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/102','127.0.0.1','内网IP','[102]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:42:41',39),(292,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":true,\"avatar\":\"/profile/avatar/2025/12/25/1c21f40eaf2e4c3dadef5c4b4e3bd56e.png\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"email\":\"ry@163.com\",\"graduateFlag\":1,\"loginDate\":\"2026-01-17 21:37:47\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"admin\",\"params\":{},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2025-06-26 22:53:03\",\"remark\":\"管理员\",\"roleIds\":[1,2],\"roles\":[{\"admin\":true,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"},{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}',NULL,1,'不允许操作超级管理员用户','2026-01-17 21:43:01',21),(293,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":true,\"avatar\":\"/profile/avatar/2025/12/25/1c21f40eaf2e4c3dadef5c4b4e3bd56e.png\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"email\":\"ry@163.com\",\"graduateFlag\":1,\"loginDate\":\"2026-01-17 21:37:47\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"测试用户01\",\"params\":{},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2025-06-26 22:53:03\",\"remark\":\"管理员\",\"roleIds\":[1],\"roles\":[{\"admin\":true,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"},{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}',NULL,1,'不允许操作超级管理员用户','2026-01-17 21:43:18',1),(294,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":true,\"avatar\":\"/profile/avatar/2025/12/25/1c21f40eaf2e4c3dadef5c4b4e3bd56e.png\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"email\":\"ry@163.com\",\"graduateFlag\":1,\"loginDate\":\"2026-01-17 21:37:47\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"测试用户01\",\"params\":{},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2025-06-26 22:53:03\",\"remark\":\"管理员\",\"roleIds\":[1,2],\"roles\":[{\"admin\":true,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"},{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}',NULL,1,'不允许操作超级管理员用户','2026-01-17 21:43:58',22),(295,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"张三\",\"params\":{},\"roleIds\":[],\"status\":\"0\",\"userId\":103,\"userName\":\"2022010101\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:54:39',171),(296,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"103\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:55:18',32),(297,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"2\",\"userId\":\"103\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:55:29',1063),(298,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010,2011,2012,2015,2019,2016,2017,2018],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 21:56:16',858),(299,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"103\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 22:22:31',95),(300,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"test01\",\"params\":{},\"roleIds\":[2,3],\"status\":\"0\",\"userId\":104,\"userName\":\"test01\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 10:57:57',187),(301,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"李四\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":105,\"userName\":\"sss\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 10:58:07',169),(302,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-18 10:58:07\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginIp\":\"\",\"nickName\":\"老师1\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":105,\"userName\":\"sss\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 10:58:22',91),(303,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"学生1\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":106,\"userName\":\"学生1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 10:58:30',151),(304,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/104,105,106','127.0.0.1','内网IP','[104,105,106]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 10:58:36',54),(305,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/104,105,106','127.0.0.1','内网IP','[104,105,106]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 11:04:07',115),(306,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-17 21:54:39\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-17 22:22:43\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"张三\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2,3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":103,\"userName\":\"2022010101\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 12:27:00',68),(307,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/103','127.0.0.1','内网IP','[103]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 12:27:12',48),(308,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"graduateFlag\":1,\"nickName\":\"梁齐哲\",\"params\":{},\"roleIds\":[2,3],\"status\":\"0\",\"userId\":107,\"userName\":\"2022040241\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-18 12:27:37',185),(309,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"graduateFlag\":1,\"nickName\":\"student\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-22 21:24:34',188),(310,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-18 12:27:37\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:40:16\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"梁齐哲\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"},{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":107,\"userName\":\"2022040241\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:11:19',143),(311,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":true,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"email\":\"ry@163.com\",\"graduateFlag\":1,\"loginDate\":\"2026-01-28 22:09:59\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"admin\",\"params\":{},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2025-06-26 22:53:03\",\"remark\":\"管理员\",\"roleIds\":[1],\"roles\":[{\"admin\":true,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"},{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}',NULL,1,'不允许操作超级管理员用户','2026-01-28 22:11:25',4),(312,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":true,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010,2011,2012,2015,2019,2016,2017,2018,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045],\"params\":{},\"remark\":\"超级管理员\",\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}',NULL,1,'不允许操作超级管理员角色','2026-01-28 22:12:15',2),(313,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":true,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"email\":\"ry@163.com\",\"graduateFlag\":1,\"loginDate\":\"2026-01-28 22:09:59\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"admin\",\"params\":{},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2025-06-26 22:53:03\",\"remark\":\"管理员\",\"roleIds\":[1],\"roles\":[{\"admin\":true,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}',NULL,1,'不允许操作超级管理员用户','2026-01-28 22:21:49',2),(314,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:23:21',76),(315,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:23:24',38),(316,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:28:02',528),(317,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:28:07',368),(318,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:28:23',50),(319,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:29:38',67),(320,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:32:07',93),(321,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"student\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:32:10',46),(322,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"nickName\":\"ceshi\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userName\":\"2022040241\"}','{\"msg\":\"新增用户\'2022040241\'失败，登录账号已存在\",\"code\":500}',0,NULL,'2026-01-28 22:32:25',3),(323,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"ceshi\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":109,\"userName\":\"2022040241=2\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:32:29',162),(324,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-28 22:32:29\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginIp\":\"\",\"nickName\":\"ceshi\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":109,\"userName\":\"2022040241=2\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:32:36',77),(325,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/109','127.0.0.1','内网IP','[109]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:32:37',35),(326,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"1\",\"userId\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:46:54',72),(327,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"2\",\"userId\":\"108\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:55:56',89),(328,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"108\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 22:56:11',73),(329,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"107\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:00:25',61),(330,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"2\",\"userId\":\"107\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:00:29',35),(331,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"ceshi\",\"params\":{},\"roleIds\":[2],\"status\":\"0\",\"userId\":110,\"userName\":\"2022040242\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:00:41',169),(332,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"110\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:00:46',40),(333,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-28 23:00:41\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-28 23:01:06\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"ceshi\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":110,\"userName\":\"2022040242\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:01:30',55),(334,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"110\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:01:34',45),(335,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-28 23:00:41\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-28 23:01:06\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"ceshi\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":110,\"userName\":\"2022040242\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:01:39',76),(336,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/110','127.0.0.1','内网IP','[110]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-28 23:02:15',70),(337,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 21:24:34\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":1,\"loginDate\":\"2026-01-22 23:39:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"张三\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":108,\"userName\":\"student\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-29 14:26:13',145),(338,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"陈胜\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":111,\"userName\":\"2022040242\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-29 14:26:32',210),(339,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"李四\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":112,\"userName\":\"2022040243\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-29 14:26:45',155),(340,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"nickName\":\"吴广\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userName\":\"2022040243\"}','{\"msg\":\"新增用户\'2022040243\'失败，登录账号已存在\",\"code\":500}',0,NULL,'2026-01-29 14:27:00',3),(341,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"吴广\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":113,\"userName\":\"2022040244\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-29 14:27:03',181),(342,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"林琳\",\"params\":{},\"roleIds\":[2],\"status\":\"0\",\"userId\":114,\"userName\":\"2000666666\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-29 14:27:29',183);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2025-06-26 22:53:03','',NULL,'超级管理员'),(2,'教师','teacher',2,'2',1,1,'0','0','admin','2025-06-26 22:53:03','admin','2026-01-17 21:56:15','教师'),(3,'学生','student',3,'1',1,1,'0','0','admin','2025-12-03 22:19:53','admin','2026-01-17 15:12:23','学生');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,2009),(2,2010),(2,2011),(2,2012),(2,2015),(2,2016),(2,2017),(2,2018),(2,2019),(3,2009),(3,2010),(3,2011),(3,2016),(3,2017),(3,2018),(3,2019);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `graduate_flag` tinyint NOT NULL DEFAULT '1' COMMENT '是否毕业, 1:未毕业, 2:已毕业',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','admin','00',1,'ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-02-11 13:17:10','2025-06-26 22:53:03','admin','2025-06-26 22:53:03','','2026-02-11 13:17:10','管理员'),(107,'2022040241','梁齐哲','00',1,'','','0','','$2a$10$r.6T/qAwDK8yOsRAscDFeeH5gY/m.BHsyNBea7u/xAmiiNVKGGVnm','0','0','127.0.0.1','2026-02-22 17:19:41',NULL,'admin','2026-01-18 12:27:37','admin','2026-02-22 17:19:41',NULL),(108,'student','张三','00',1,'','','0','','$2a$10$4hFgiwRToMtuBRtuP71sde1zcRU2gkM2AZ4iEPfCKlf1xH2P8BmkW','0','0','127.0.0.1','2026-02-22 17:30:05',NULL,'admin','2026-01-22 21:24:34','admin','2026-02-22 17:30:04',NULL),(111,'2022040242','陈胜','00',1,'','','0','','$2a$10$6RdAUcPyIPihfDKraa/mTOsGrN7eBhiaAZ/ommhzrI6.1RS5XCDFG','0','0','127.0.0.1','2026-02-22 17:28:14',NULL,'admin','2026-01-29 14:26:32','','2026-02-22 17:28:13',NULL),(112,'2022040243','李四','00',1,'','','0','','$2a$10$EgCbCp3sTaASCauiVYoVouBmz6fxgVq5DP0w5bHsKOp5LVFUwC8x.','0','0','127.0.0.1','2026-02-22 17:29:22',NULL,'admin','2026-01-29 14:26:45','','2026-02-22 17:29:21',NULL),(113,'2022040244','吴广','00',1,'','','0','','$2a$10$XY7vlKQHMOPJ8k6Ov.6AHe9/1Jw0/VAFBFDCEYE9n6oE6ToOtCRuW','0','0','',NULL,NULL,'admin','2026-01-29 14:27:03','',NULL,NULL),(114,'2000666666','林琳','00',1,'','','0','','$2a$10$/hEmWxR7S1JvU1SWEbgjQuRQtzji1bpMNH3EwyPucL8xhHr15jhm2','0','0','127.0.0.1','2026-02-12 23:53:43',NULL,'admin','2026-01-29 14:27:29','','2026-02-12 23:53:42',NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(107,2),(108,3),(111,3),(112,3),(113,3),(114,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `task_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `parent_task_id` bigint NOT NULL DEFAULT '0' COMMENT '父任务id，0表示无父任务',
  `task_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `task_description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务描述',
  `task_remark` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务备注',
  `task_order` tinyint NOT NULL COMMENT '任务排序',
  `task_depth` tinyint NOT NULL COMMENT '任务深度',
  `task_status` tinyint NOT NULL DEFAULT '1' COMMENT '任务状态,1:未开始,2:进行中,3:已完成4:已跳过',
  `create_user_id` bigint NOT NULL COMMENT '创建用户id',
  `create_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户昵称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `expected_finish_time` datetime DEFAULT NULL COMMENT '预期完成时间',
  `actual_finish_time` datetime DEFAULT NULL COMMENT '实际完成时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (86,0,'1.20-1.22差旅报销','该任务用于1.20-1.22的差旅报销','如有不明确事项请先与老师沟通',1,1,2,107,'梁齐哲','2026-01-22 21:17:55','2026-01-23 00:00:00',NULL,'2026-02-12 22:59:36'),(87,86,'票据整理与保管','','',1,2,4,107,'梁齐哲','2026-01-22 21:38:56',NULL,NULL,'2026-02-12 21:02:42'),(88,86,'报销单填写与提交','','',2,2,1,107,'梁齐哲','2026-01-22 21:39:21',NULL,NULL,'2026-02-12 21:02:31'),(89,86,'审批、打款与归款','','',3,2,3,107,'梁齐哲','2026-01-22 21:39:38',NULL,NULL,'2026-01-22 21:51:08'),(91,87,'查验','','',2,3,3,107,'梁齐哲','2026-01-22 21:40:15',NULL,NULL,'2026-02-12 23:00:02'),(92,88,'填写基本信息','','',1,3,3,107,'梁齐哲','2026-01-22 21:40:46',NULL,NULL,'2026-01-22 21:51:15'),(93,88,'录入费用与明细','','',2,3,3,107,'梁齐哲','2026-01-22 21:40:55',NULL,NULL,'2026-01-22 21:51:38'),(120,92,'1','','',1,4,2,107,'梁齐哲','2026-02-09 23:41:12',NULL,NULL,'2026-02-09 23:41:12'),(135,0,'测试权限','','',1,1,2,107,'梁齐哲','2026-02-12 23:41:03',NULL,NULL,'2026-02-22 17:26:24'),(136,135,'张三的任务','','',1,2,2,107,'梁齐哲','2026-02-12 23:41:15',NULL,NULL,'2026-02-12 23:51:04'),(137,135,'陈胜的任务','','',2,2,3,107,'梁齐哲','2026-02-12 23:41:32',NULL,NULL,'2026-02-22 17:13:54'),(138,135,'陈琳的任务','','',3,2,1,107,'梁齐哲','2026-02-12 23:41:53',NULL,NULL,'2026-02-12 23:41:53'),(140,136,'张三交给陈胜的任务','','',1,3,3,108,'张三','2026-02-12 23:51:36',NULL,NULL,'2026-02-12 23:52:31'),(141,140,'陈胜交给李四的任务','','',1,4,3,111,'陈胜','2026-02-12 23:56:41',NULL,NULL,'2026-02-12 23:59:11');
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_executor`
--

DROP TABLE IF EXISTS `task_executor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_executor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `task_id` bigint NOT NULL COMMENT '任务id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='任务执行用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_executor`
--

LOCK TABLES `task_executor` WRITE;
/*!40000 ALTER TABLE `task_executor` DISABLE KEYS */;
INSERT INTO `task_executor` VALUES (1,86,107,'2026-02-12 22:59:36','2026-02-12 22:59:36'),(2,91,107,'2026-02-12 23:00:02','2026-02-12 23:00:02'),(5,135,107,'2026-02-12 23:41:03','2026-02-12 23:41:03'),(6,136,108,'2026-02-12 23:41:15','2026-02-12 23:41:15'),(7,137,111,'2026-02-12 23:41:32','2026-02-12 23:41:32'),(8,138,114,'2026-02-12 23:41:53','2026-02-12 23:41:53'),(10,140,111,'2026-02-12 23:51:36','2026-02-12 23:51:36'),(11,141,112,'2026-02-12 23:56:41','2026-02-12 23:56:41');
/*!40000 ALTER TABLE `task_executor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_file`
--

DROP TABLE IF EXISTS `task_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `file_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `file_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `task_id` bigint NOT NULL COMMENT '任务id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `user_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='任务文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_file`
--

LOCK TABLES `task_file` WRITE;
/*!40000 ALTER TABLE `task_file` DISABLE KEYS */;
INSERT INTO `task_file` VALUES (36,'打车发票','2026/01/22/c1ae59ca2bc249c08b196c154d194a66.png','png',4875836,86,107,'梁齐哲','2026-01-22 22:03:32','2026-01-22 22:03:32','2026-01-22 22:03:32'),(37,'酒店发票','2026/01/22/17142a62a4a34e558b30e8b1326a16ce.png','png',4875836,86,107,'梁齐哲','2026-01-22 22:03:33','2026-01-22 22:03:33','2026-01-22 22:03:33');
/*!40000 ALTER TABLE `task_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_report`
--

DROP TABLE IF EXISTS `task_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `task_id` bigint NOT NULL COMMENT '任务id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `user_nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `report_content` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '汇报内容',
  `report_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '汇报时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='任务汇报表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_report`
--

LOCK TABLES `task_report` WRITE;
/*!40000 ALTER TABLE `task_report` DISABLE KEYS */;
INSERT INTO `task_report` VALUES (2,86,107,'梁齐哲','第二条','2026-02-20 17:48:51','2026-02-20 17:48:51','2026-02-20 17:48:51'),(3,86,107,'梁齐哲','第三条TIP\n\n文字按钮在现在有了全新的设计样式。 \n2.2.0 如果您想要使用老版样式的按钮，可以考虑使用 Link 组件。\n\nAPI也已更新，由于 type 属性会同时控制按钮的样式， 因此我们通过一个新的 API text: boolean 来控制文字按钮。','2026-02-20 17:49:09','2026-02-20 17:49:09','2026-02-20 17:49:09'),(4,86,107,'梁齐哲','测试','2026-02-22 16:21:36','2026-02-22 16:21:36','2026-02-22 16:21:36'),(20,136,108,'张三','张三的任务-第一次汇报','2026-02-22 17:27:26','2026-02-22 17:27:26','2026-02-22 17:27:26'),(21,140,108,'张三','张三交给陈胜的任务-第一次汇报','2026-02-22 17:27:50','2026-02-22 17:27:50','2026-02-22 17:27:50'),(23,140,111,'陈胜','张三交给陈胜的任务-第三次汇报','2026-02-22 17:28:49','2026-02-22 17:28:49','2026-02-22 17:28:49'),(24,137,111,'陈胜','陈胜的任务-第一次汇报','2026-02-22 17:29:04','2026-02-22 17:29:04','2026-02-22 17:29:04'),(25,141,112,'李四','陈胜交给李四的任务-第一次汇报','2026-02-22 17:29:53','2026-02-22 17:29:53','2026-02-22 17:29:53');
/*!40000 ALTER TABLE `task_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_user`
--

DROP TABLE IF EXISTS `task_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `task_id` bigint NOT NULL COMMENT '任务id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=473 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='任务关联用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_user`
--

LOCK TABLES `task_user` WRITE;
/*!40000 ALTER TABLE `task_user` DISABLE KEYS */;
INSERT INTO `task_user` VALUES (213,89,1,'2026-01-22 21:39:38','2026-01-22 21:39:38'),(214,89,108,'2026-01-22 21:39:38','2026-01-22 21:39:38'),(215,89,107,'2026-01-22 21:39:38','2026-01-22 21:39:38'),(219,91,1,'2026-01-22 21:40:15','2026-01-22 21:40:15'),(220,91,107,'2026-01-22 21:40:15','2026-01-22 21:40:15'),(221,91,108,'2026-01-22 21:40:15','2026-01-22 21:40:15'),(222,92,1,'2026-01-22 21:40:45','2026-01-22 21:40:45'),(223,92,107,'2026-01-22 21:40:45','2026-01-22 21:40:45'),(224,92,108,'2026-01-22 21:40:45','2026-01-22 21:40:45'),(225,93,1,'2026-01-22 21:40:55','2026-01-22 21:40:55'),(226,93,107,'2026-01-22 21:40:55','2026-01-22 21:40:55'),(227,93,108,'2026-01-22 21:40:55','2026-01-22 21:40:55'),(245,86,1,'2026-01-29 14:51:55','2026-01-29 14:51:55'),(246,86,108,'2026-01-29 14:51:55','2026-01-29 14:51:55'),(247,86,111,'2026-01-29 14:51:55','2026-01-29 14:51:55'),(350,120,1,'2026-02-09 23:41:12','2026-02-09 23:41:12'),(351,120,107,'2026-02-09 23:41:12','2026-02-09 23:41:12'),(352,120,108,'2026-02-09 23:41:12','2026-02-09 23:41:12'),(353,86,107,'2026-02-09 23:41:12','2026-02-09 23:41:12'),(410,88,1,'2026-02-12 21:02:31','2026-02-12 21:02:31'),(411,88,107,'2026-02-12 21:02:31','2026-02-12 21:02:31'),(412,88,108,'2026-02-12 21:02:31','2026-02-12 21:02:31'),(413,88,111,'2026-02-12 21:02:31','2026-02-12 21:02:31'),(414,87,1,'2026-02-12 21:02:42','2026-02-12 21:02:42'),(415,87,107,'2026-02-12 21:02:42','2026-02-12 21:02:42'),(416,87,108,'2026-02-12 21:02:42','2026-02-12 21:02:42'),(417,87,111,'2026-02-12 21:02:42','2026-02-12 21:02:42'),(418,87,112,'2026-02-12 21:02:42','2026-02-12 21:02:42'),(419,87,113,'2026-02-12 21:02:42','2026-02-12 21:02:42'),(420,87,114,'2026-02-12 21:02:42','2026-02-12 21:02:42'),(442,135,107,'2026-02-12 23:41:02','2026-02-12 23:41:02'),(445,135,108,'2026-02-12 23:41:15','2026-02-12 23:41:15'),(448,135,111,'2026-02-12 23:41:32','2026-02-12 23:41:32'),(449,138,114,'2026-02-12 23:41:52','2026-02-12 23:41:52'),(450,138,107,'2026-02-12 23:41:52','2026-02-12 23:41:52'),(451,135,114,'2026-02-12 23:41:52','2026-02-12 23:41:52'),(454,136,107,'2026-02-12 23:51:04','2026-02-12 23:51:04'),(455,136,108,'2026-02-12 23:51:04','2026-02-12 23:51:04'),(456,136,111,'2026-02-12 23:51:04','2026-02-12 23:51:04'),(460,140,108,'2026-02-12 23:52:30','2026-02-12 23:52:30'),(461,140,111,'2026-02-12 23:52:30','2026-02-12 23:52:30'),(464,135,112,'2026-02-12 23:56:40','2026-02-12 23:56:40'),(465,136,112,'2026-02-12 23:56:40','2026-02-12 23:56:40'),(466,140,112,'2026-02-12 23:56:40','2026-02-12 23:56:40'),(467,141,111,'2026-02-12 23:57:51','2026-02-12 23:57:51'),(468,141,112,'2026-02-12 23:57:51','2026-02-12 23:57:51'),(469,141,108,'2026-02-12 23:57:51','2026-02-12 23:57:51'),(470,137,107,'2026-02-12 23:58:12','2026-02-12 23:58:12'),(471,137,111,'2026-02-12 23:58:12','2026-02-12 23:58:12'),(472,137,108,'2026-02-12 23:58:12','2026-02-12 23:58:12');
/*!40000 ALTER TABLE `task_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-22 17:31:43
