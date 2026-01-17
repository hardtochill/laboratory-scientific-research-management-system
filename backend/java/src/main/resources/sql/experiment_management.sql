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
  `user_nick_name` varchar(30) NOT NULL COMMENT '发表用户昵称',
  `receive_user_id` bigint DEFAULT NULL COMMENT '被评论用户id',
  `receive_user_nick_name` varchar(30) DEFAULT NULL COMMENT '被评论用户昵称',
  `comment_content` varchar(500) NOT NULL COMMENT '评论文字内容',
  `comment_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞数',
  `visible_type` int NOT NULL DEFAULT '1' COMMENT '可见类型，1：仅自己可见， 2：所有用户可见',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文献评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
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
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_path` varchar(255) NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='评论文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_file`
--

LOCK TABLES `comment_file` WRITE;
/*!40000 ALTER TABLE `comment_file` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='评论点赞表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_like`
--

LOCK TABLES `comment_like` WRITE;
/*!40000 ALTER TABLE `comment_like` DISABLE KEYS */;
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
  `table_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
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
  `column_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
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
  `keyword_name` varchar(100) NOT NULL COMMENT '关键词名称',
  `description` varchar(500) DEFAULT NULL COMMENT '关键词描述',
  `usage_count` int NOT NULL DEFAULT '0' COMMENT '使用次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `keyword_pk` (`keyword_name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文献关键词表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keyword`
--

LOCK TABLES `keyword` WRITE;
/*!40000 ALTER TABLE `keyword` DISABLE KEYS */;
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
  `title` varchar(255) NOT NULL COMMENT '文献名称',
  `identifier` varchar(500) DEFAULT NULL COMMENT '文献唯一标识',
  `authors` varchar(255) DEFAULT NULL COMMENT '文献作者，多个作者用逗号分隔',
  `journal` varchar(255) DEFAULT NULL COMMENT '期刊/会议名称',
  `publish_time` date DEFAULT NULL COMMENT '发表时间',
  `abstract_text` text COMMENT '文献摘要',
  `download_count` int NOT NULL DEFAULT '0' COMMENT '下载次数',
  `teacher_score_avg` decimal(3,1) DEFAULT '0.0' COMMENT '教师打分均值',
  `teacher_score_count` int DEFAULT '0' COMMENT '参与打分的教师数量',
  `student_score_avg` decimal(3,1) DEFAULT '0.0' COMMENT '学生打分均值',
  `student_score_count` int DEFAULT '0' COMMENT '参与打分的学生数量',
  `final_score` decimal(3,1) DEFAULT '0.0' COMMENT '最终得分',
  `upload_user_id` bigint NOT NULL COMMENT '上传用户id',
  `upload_user_nick_name` varchar(30) NOT NULL COMMENT '上传用户昵称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `literature_pk` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文献表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature`
--

LOCK TABLES `literature` WRITE;
/*!40000 ALTER TABLE `literature` DISABLE KEYS */;
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
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_path` varchar(255) NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `upload_user_id` bigint NOT NULL COMMENT '上柴用户id',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文献文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature_file`
--

LOCK TABLES `literature_file` WRITE;
/*!40000 ALTER TABLE `literature_file` DISABLE KEYS */;
INSERT INTO `literature_file` VALUES (1,54,'西游记','2025/12/29/8ac2c7eff28248679c3c7a3990b0e0d2.pdf','pdf',5818983,1,'2025-12-29 16:45:28','2025-12-29 16:45:28','2025-12-29 19:12:49'),(3,56,'测试空文件','2025/12/29/17ff74224e5848348e14251741b45492.pdf','pdf',1634107,1,'2025-12-29 19:34:05','2025-12-29 19:34:05','2025-12-29 19:34:05'),(4,57,'算力飞天时所有的坚持都有了意义','2025/12/29/84b2e86eb37d4791a87edd3877c6d804.pdf','pdf',1634107,1,'2025-12-29 19:39:41','2025-12-29 19:39:41','2025-12-29 19:39:41'),(5,58,'三大名著','2026/01/13/cf95e1636ac84ab1b48628ad9219855d.pdf','pdf',1634107,1,'2026-01-13 21:10:01','2026-01-13 21:10:01','2026-01-13 21:10:01'),(6,59,'最新著作','2026/01/16/033191cc13d947619b302046133b775c.pdf','pdf',5818983,1,'2026-01-16 21:31:31','2026-01-16 21:31:31','2026-01-16 21:31:31'),(8,55,'两大名著','2026/01/17/495381c229894e06be70207d781f23ce.pdf','pdf',1634107,100,'2026-01-17 21:07:36','2026-01-17 21:07:36','2026-01-17 21:07:36');
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
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文献关键词关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature_keyword`
--

LOCK TABLES `literature_keyword` WRITE;
/*!40000 ALTER TABLE `literature_keyword` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文献打分表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature_score`
--

LOCK TABLES `literature_score` WRITE;
/*!40000 ALTER TABLE `literature_score` DISABLE KEYS */;
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
  `reviewed_user_nick_name` varchar(30) NOT NULL COMMENT '被审核用户昵称',
  `reviewer_user_id` bigint NOT NULL COMMENT '审核用户id',
  `reviewer_user_nick_name` varchar(30) NOT NULL COMMENT '审核用户昵称',
  `status` int NOT NULL DEFAULT '1' COMMENT '审核状态：1待审核、2审核通过、3审核不通过',
  `reviewed_remark` varchar(500) DEFAULT NULL COMMENT '被审核人备注',
  `reviewer_remark` varchar(500) DEFAULT NULL COMMENT '审核人备注',
  `review_create_time` datetime DEFAULT NULL COMMENT '审核发起时间',
  `review_finish_time` datetime DEFAULT NULL COMMENT '审核完成时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='审核表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
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
  `name` varchar(255) NOT NULL COMMENT '计划名称',
  `create_user_id` bigint NOT NULL COMMENT '创建用户id',
  `create_user_nick_name` varchar(30) NOT NULL COMMENT '创建用户昵称',
  `type` int NOT NULL COMMENT '投稿类型：1.期刊论文, 2.会议论文, 3.发明专利, 4.实用新型专利, 5.软件著作权',
  `journal` varchar(255) NOT NULL COMMENT '投稿的期刊名称',
  `status` int NOT NULL DEFAULT '1' COMMENT '投稿状态：待送审、审核中、发表成功、发表失败',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `submission_create_time` datetime DEFAULT NULL COMMENT '投稿创建时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='投稿计划表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_plan`
--

LOCK TABLES `submission_plan` WRITE;
/*!40000 ALTER TABLE `submission_plan` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='投稿计划关联用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_plan_user`
--

LOCK TABLES `submission_plan_user` WRITE;
/*!40000 ALTER TABLE `submission_plan_user` DISABLE KEYS */;
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
  `name` varchar(255) NOT NULL COMMENT '流程名称，例如：一审、、二审等',
  `reviewer_user_id` bigint DEFAULT NULL COMMENT '审核用户id',
  `reviewer_user_nick_name` varchar(30) DEFAULT NULL COMMENT '审核用户昵称',
  `status` int NOT NULL DEFAULT '1' COMMENT '流程状态：1待发起内部审核、2内部审核中、3内部审核通过、4内部审核不通过',
  `remark` varchar(500) DEFAULT NULL COMMENT '审核备注',
  `process_create_time` datetime DEFAULT NULL COMMENT '流程创建时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='投稿流程表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_process`
--

LOCK TABLES `submission_process` WRITE;
/*!40000 ALTER TABLE `submission_process` DISABLE KEYS */;
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
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_path` varchar(255) NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='投稿流程文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_process_file`
--

LOCK TABLES `submission_process_file` WRITE;
/*!40000 ALTER TABLE `submission_process_file` DISABLE KEYS */;
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
  `config_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='参数配置表';
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
  `dict_label` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='字典数据表';
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
  `dict_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='字典类型表';
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
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='定时任务调度表';
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
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='定时任务调度日志表';
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
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=491 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','* 必须填写','2025-07-09 09:44:47'),(101,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-07-09 09:44:54'),(102,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 09:45:02'),(103,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-09 10:24:14'),(104,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 10:24:20'),(105,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 11:02:33'),(106,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 13:52:22'),(107,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 15:51:47'),(108,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 23:02:56'),(109,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-09 23:02:57'),(110,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 23:03:07'),(111,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-09 23:03:10'),(112,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-09 23:11:27'),(113,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 23:11:30'),(114,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-09 23:11:35'),(115,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-09 23:11:39'),(116,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-12 13:59:44'),(117,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-13 13:37:41'),(118,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-13 15:40:17'),(119,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-13 15:40:21'),(120,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-13 16:41:04'),(121,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-15 01:20:10'),(122,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-15 10:31:52'),(123,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-15 23:10:09'),(124,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-16 09:56:26'),(125,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-16 11:02:14'),(126,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-16 11:02:17'),(127,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','退出成功','2025-07-16 11:45:35'),(128,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-16 11:46:19'),(129,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-16 11:46:19'),(130,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','退出成功','2025-07-16 11:46:57'),(131,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-16 13:58:49'),(132,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-16 13:58:56'),(133,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-16 15:15:08'),(134,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','退出成功','2025-07-16 15:31:24'),(135,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-16 15:31:45'),(136,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-16 15:31:49'),(137,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-16 22:35:23'),(138,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-18 22:31:04'),(139,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-18 22:31:07'),(140,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-20 20:29:27'),(141,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-20 20:29:33'),(142,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-20 20:29:37'),(143,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-21 22:32:05'),(144,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-22 00:32:07'),(145,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-22 09:48:35'),(146,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-22 23:00:36'),(147,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-23 09:12:23'),(148,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-23 09:12:28'),(149,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','退出成功','2025-07-23 09:30:12'),(150,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-23 09:30:45'),(151,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-23 11:45:21'),(152,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-23 14:34:07'),(153,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-23 21:20:43'),(154,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-23 21:20:47'),(155,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-24 10:07:06'),(156,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-24 23:15:47'),(157,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-07-27 13:15:15'),(158,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-27 13:15:20'),(159,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-27 14:54:46'),(160,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-27 17:50:07'),(161,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-28 09:35:38'),(162,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-28 15:55:53'),(163,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-07-28 21:41:56'),(164,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-28 21:41:58'),(165,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-30 10:07:37'),(166,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-30 14:08:41'),(167,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-30 21:24:15'),(168,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-07-31 17:28:39'),(169,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-01 11:25:11'),(170,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-02 13:37:06'),(171,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-02 14:22:18'),(172,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-08-02 19:05:55'),(173,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-02 19:06:05'),(174,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-03 15:08:34'),(175,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-03 22:38:15'),(176,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-04 09:26:14'),(177,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-04 11:01:17'),(178,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-08-04 15:04:04'),(179,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-04 15:04:08'),(180,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-04 15:57:23'),(181,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-04 20:22:07'),(182,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-04 21:36:09'),(183,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-07 11:21:35'),(184,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-07 11:35:11'),(185,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-26 21:28:07'),(186,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-26 21:41:36'),(187,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-27 22:33:57'),(188,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-28 21:54:39'),(189,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-08-29 06:49:36'),(190,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-02 21:29:45'),(191,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-03 09:13:15'),(192,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-03 21:01:19'),(193,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-04 11:39:13'),(194,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-07 05:24:52'),(195,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-09 01:41:05'),(196,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-09-09 20:24:16'),(197,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-09 20:24:19'),(198,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-10 13:49:53'),(199,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-10 22:43:56'),(200,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-11 07:49:48'),(201,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-11 11:47:04'),(202,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-12 10:00:03'),(203,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-09-12 21:57:20'),(204,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-09-12 21:57:22'),(205,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-13 10:11:30'),(206,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-13 14:17:17'),(207,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-09-13 20:47:41'),(208,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-13 20:47:45'),(209,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-09-14 06:39:19'),(210,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-14 06:39:23'),(211,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-14 20:39:42'),(212,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-16 20:24:43'),(213,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-09-25 19:12:10'),(214,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-25 19:12:15'),(215,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-26 11:06:59'),(216,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-20 19:58:27'),(217,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-11-21 09:23:21'),(218,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-11-21 09:23:21'),(219,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-11-21 16:24:50'),(220,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-11-21 16:25:41'),(221,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-11-21 16:27:44'),(222,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-11-21 16:27:47'),(223,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-01 20:37:45'),(224,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-01 21:28:56'),(225,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-01 21:37:26'),(226,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-01 21:37:29'),(227,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-01 21:37:34'),(228,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-02 14:21:31'),(229,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-03 21:13:59'),(230,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-03 21:22:14'),(231,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2025-12-03 21:22:33'),(232,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2025-12-03 21:22:57'),(233,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-03 21:23:30'),(234,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-03 21:24:06'),(235,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-03 21:24:17'),(236,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-03 21:27:43'),(237,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-03 21:27:49'),(238,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-03 21:30:16'),(239,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-03 21:30:27'),(240,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-03 21:30:29'),(241,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-03 21:30:32'),(242,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-03 21:31:51'),(243,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-03 21:31:53'),(244,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-07 23:56:59'),(245,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-08 00:03:46'),(246,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-08 00:03:57'),(247,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-08 00:04:00'),(248,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-08 00:25:15'),(249,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-08 00:25:25'),(250,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-08 00:26:33'),(251,'测试用户','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-08 00:26:33'),(252,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-08 00:26:54'),(253,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-08 00:26:54'),(254,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-08 21:13:46'),(255,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-08 23:50:16'),(256,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-08 23:50:25'),(257,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-09 13:43:22'),(258,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-09 13:43:22'),(259,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-10 19:43:13'),(260,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-11 21:31:03'),(261,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-11 21:31:07'),(262,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-12 15:24:19'),(263,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-13 20:38:10'),(264,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-13 20:38:10'),(265,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-14 20:21:41'),(266,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-14 20:21:44'),(267,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-14 20:52:22'),(268,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-12-14 22:05:28'),(269,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-12-14 22:05:31'),(270,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-15 11:49:45'),(271,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-15 11:49:48'),(272,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-17 23:47:25'),(273,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-18 23:03:53'),(274,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-19 21:38:46'),(275,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-19 21:38:46'),(276,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-20 20:54:19'),(277,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-22 10:41:07'),(278,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-24 20:27:34'),(279,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-25 14:23:38'),(280,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-25 20:40:33'),(281,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-25 20:40:37'),(282,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-25 21:22:40'),(283,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-26 15:00:03'),(284,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 15:00:07'),(285,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 20:17:39'),(286,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2025-12-26 20:17:47'),(287,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-26 20:18:08'),(288,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 20:18:13'),(289,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 20:18:22'),(290,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 20:18:25'),(291,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 20:19:36'),(292,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 20:19:44'),(293,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 21:16:52'),(294,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 21:16:56'),(295,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 21:18:33'),(296,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 21:18:37'),(297,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 21:20:14'),(298,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 21:22:07'),(299,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-26 21:22:14'),(300,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 21:22:21'),(301,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 21:24:11'),(302,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-12-26 21:25:01'),(303,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 21:25:05'),(304,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 21:26:38'),(305,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 21:26:46'),(306,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-26 21:28:19'),(307,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-26 21:28:24'),(308,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 14:40:29'),(309,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 14:58:20'),(310,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 14:58:28'),(311,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 14:58:37'),(312,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 14:58:42'),(313,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:27:55'),(314,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-27 21:28:03'),(315,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:28:12'),(316,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:28:54'),(317,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:28:58'),(318,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:37:48'),(319,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-27 21:37:52'),(320,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:37:55'),(321,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:45:37'),(322,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:45:45'),(323,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:46:31'),(324,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-27 21:46:35'),(325,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-27 21:46:38'),(326,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:46:43'),(327,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:49:54'),(328,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:50:03'),(329,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:50:18'),(330,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-27 21:50:21'),(331,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:50:24'),(332,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:50:56'),(333,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:51:06'),(334,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-27 21:51:20'),(335,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-27 21:51:23'),(336,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-28 14:17:10'),(337,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 14:17:14'),(338,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 20:04:42'),(339,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 20:14:45'),(340,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-28 20:14:50'),(341,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 20:14:54'),(342,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 20:48:39'),(343,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-28 20:48:48'),(344,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 20:48:51'),(345,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 20:49:04'),(346,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 20:49:07'),(347,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 20:49:37'),(348,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 20:49:45'),(349,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 20:51:37'),(350,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 20:51:40'),(351,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 21:02:37'),(352,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 21:02:40'),(353,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 21:05:57'),(354,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-28 21:08:45'),(355,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 21:08:49'),(356,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 21:10:05'),(357,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 21:10:13'),(358,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 21:11:35'),(359,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 21:11:37'),(360,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 21:23:03'),(361,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 21:23:10'),(362,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-28 21:23:19'),(363,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-28 21:23:23'),(364,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-28 21:23:27'),(365,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-29 15:24:30'),(366,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-29 18:58:45'),(367,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-29 20:53:45'),(368,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-29 20:53:53'),(369,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2025-12-29 20:54:33'),(370,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-29 20:54:36'),(371,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-12-30 14:15:50'),(372,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-30 14:15:52'),(373,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-12-30 19:34:41'),(374,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-02 21:41:45'),(375,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-03 20:54:59'),(376,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-04 15:03:44'),(377,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-04 19:33:21'),(378,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-04 22:00:18'),(379,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-04 22:00:25'),(380,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-04 22:00:58'),(381,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-04 22:01:01'),(382,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-04 22:01:04'),(383,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-04 22:01:37'),(384,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-04 22:01:42'),(385,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-04 22:07:53'),(386,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-04 22:07:56'),(387,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-05 15:01:00'),(388,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-05 16:02:22'),(389,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-05 16:02:25'),(390,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-05 20:46:41'),(391,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-05 20:47:14'),(392,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-05 20:47:22'),(393,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-05 20:56:09'),(394,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-05 20:56:15'),(395,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-06 21:37:05'),(396,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-07 14:18:47'),(397,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-07 19:57:00'),(398,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-08 17:02:52'),(399,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-09 19:37:09'),(400,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-10 19:44:17'),(401,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-11 21:04:07'),(402,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-11 21:04:09'),(403,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-11 21:04:12'),(404,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-12 16:33:58'),(405,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-12 19:26:46'),(406,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-13 14:30:01'),(407,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-01-13 14:30:02'),(408,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-13 15:08:52'),(409,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-13 15:09:03'),(410,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-13 15:17:55'),(411,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-13 15:17:59'),(412,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-13 15:18:27'),(413,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-13 15:18:36'),(414,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-13 15:18:39'),(415,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-13 15:22:05'),(416,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-13 15:22:09'),(417,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-13 15:49:19'),(418,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-13 19:18:47'),(419,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-14 14:33:31'),(420,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-15 20:05:39'),(421,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-16 15:03:08'),(422,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-16 15:03:10'),(423,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-16 16:09:11'),(424,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-16 16:09:18'),(425,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-16 16:09:20'),(426,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-16 16:09:23'),(427,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-16 16:09:29'),(428,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-16 16:09:32'),(429,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-16 16:09:46'),(430,'test02','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-16 16:09:56'),(431,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-16 16:10:05'),(432,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-16 16:10:47'),(433,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-16 16:10:55'),(434,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-16 16:11:14'),(435,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-16 16:11:17'),(436,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-16 19:32:32'),(437,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-17 15:11:56'),(438,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-17 15:11:58'),(439,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:12:01'),(440,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:12:28'),(441,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:12:37'),(442,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:14:08'),(443,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:14:11'),(444,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:14:39'),(445,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:14:46'),(446,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:15:25'),(447,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:15:28'),(448,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:47:46'),(449,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-17 15:47:53'),(450,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:47:55'),(451,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:56:52'),(452,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:57:26'),(453,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:59:00'),(454,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:59:06'),(455,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 15:59:39'),(456,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 15:59:46'),(457,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 16:00:05'),(458,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:00:07'),(459,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 16:00:20'),(460,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:00:23'),(461,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 16:01:05'),(462,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:03:47'),(463,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 16:03:51'),(464,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:03:58'),(465,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 16:04:02'),(466,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2026-01-17 16:04:05'),(467,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:04:09'),(468,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 16:05:55'),(469,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:07:06'),(470,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:27:37'),(471,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 16:28:09'),(472,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 16:28:21'),(473,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 19:53:55'),(474,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-01-17 19:53:55'),(475,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 20:03:27'),(476,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 20:04:11'),(477,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 20:35:32'),(478,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 20:42:04'),(479,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 20:42:13'),(480,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-01-17 20:53:45'),(481,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 20:53:52'),(482,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 20:54:21'),(483,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 20:55:02'),(484,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 20:55:09'),(485,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-17 20:55:17'),(486,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-17 20:55:45'),(487,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2026-01-17 20:55:56'),(488,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 20:56:02'),(489,'test03','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-01-17 21:37:38'),(490,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-01-17 21:37:47');
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
  `menu_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2020 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';
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
  `notice_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='通知公告表';
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
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=288 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/4','127.0.0.1','内网IP','4','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-07-09 10:25:50',16),(101,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-09 10:26:01',68),(102,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/4','127.0.0.1','内网IP','4','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-09 10:26:15',31),(103,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/radarInfo/index\",\"createBy\":\"admin\",\"icon\":\"international\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"雷达光电联动监控\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"radarLinkage\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-09 11:08:07',36),(104,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:22:59',75),(105,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:23:01',37),(106,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":99,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:23:18',46),(107,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/threat_level\",\"createBy\":\"admin\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"威胁等级管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"ThreatLevel\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:24:59',34),(108,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/radarInfo/index\",\"createTime\":\"2025-07-09 11:08:07\",\"icon\":\"international\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"雷达光电联动监控\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"radarLinkage\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:26:47',34),(109,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/threat_level\",\"createTime\":\"2025-07-15 01:24:59\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"威胁等级管理\",\"menuType\":\"C\",\"orderNum\":66,\"params\":{},\"parentId\":0,\"path\":\"ThreatLevel\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:27:09',33),(110,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/birdInfo\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情历史记录\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"birdInfo\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:28:11',30),(111,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":97,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:28:30',34),(112,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:28:35',31),(113,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_info\",\"createTime\":\"2025-07-15 01:28:11\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"鸟情历史记录\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"birdInfo\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:29:00',22),(114,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"bird_report\",\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情报表\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"BirdReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:38:29',24),(115,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_info\",\"createTime\":\"2025-07-15 01:28:11\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"鸟情历史记录\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"BirdInfo\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:38:35',19),(116,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"鸟情报表\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"BirdReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 01:39:16',22),(117,'字典类型',1,'com.ruoyi.project.system.controller.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"威胁等级\",\"dictType\":\"threat_level\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:21:04',13),(118,'字典类型',2,'com.ruoyi.project.system.controller.SysDictTypeController.edit()','PUT',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:21:04\",\"dictId\":100,\"dictName\":\"威胁等级\",\"dictType\":\"threat_level\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:36:15',29),(119,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅰ级\",\"dictSort\":1,\"dictType\":\"threat_level\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:36:34',22),(120,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅱ级\",\"dictSort\":2,\"dictType\":\"threat_level\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:37:43',22),(121,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:36:34\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"Ⅰ级\",\"dictSort\":1,\"dictType\":\"threat_level\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:37:49',26),(122,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:37:43\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"Ⅱ级\",\"dictSort\":2,\"dictType\":\"threat_level\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:37:55',23),(123,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"‌Ⅲ级\",\"dictSort\":3,\"dictType\":\"threat_level\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:39:24',21),(124,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:39:23\",\"default\":false,\"dictCode\":102,\"dictLabel\":\"‌Ⅲ级\",\"dictSort\":3,\"dictType\":\"threat_level\",\"dictValue\":\"3\",\"isDefault\":\"N\",\"listClass\":\"info\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:17',23),(125,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:39:23\",\"default\":false,\"dictCode\":102,\"dictLabel\":\"‌Ⅲ级\",\"dictSort\":3,\"dictType\":\"threat_level\",\"dictValue\":\"3\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:27',23),(126,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:37:43\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"Ⅱ级\",\"dictSort\":2,\"dictType\":\"threat_level\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:30',23),(127,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅳ级\",\"dictSort\":4,\"dictType\":\"threat_level\",\"dictValue\":\"4\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:41',23),(128,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:41:41\",\"default\":false,\"dictCode\":103,\"dictLabel\":\"Ⅳ级\",\"dictSort\":4,\"dictType\":\"threat_level\",\"dictValue\":\"4\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:41:46',23),(129,'字典类型',1,'com.ruoyi.project.system.controller.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"目标类型\",\"dictType\":\"target_level\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-15 23:58:27',37),(130,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"类型识别未完成\",\"dictSort\":0,\"dictType\":\"target_level\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:01:05',184),(131,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"cssClass\":\"\",\"default\":false,\"dictLabel\":\"人\",\"dictSort\":1,\"dictType\":\"target_level\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:01:18',32),(132,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"cssClass\":\"\",\"default\":false,\"dictLabel\":\"车\",\"dictSort\":2,\"dictType\":\"target_level\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:13',30),(133,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"无人机\",\"dictSort\":3,\"dictType\":\"target_level\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:20',30),(134,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"飞鸟\",\"dictSort\":5,\"dictType\":\"target_level\",\"dictValue\":\"5\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:31',30),(135,'字典数据',2,'com.ruoyi.project.system.controller.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-16 00:02:31\",\"default\":false,\"dictCode\":108,\"dictLabel\":\"飞鸟\",\"dictSort\":4,\"dictType\":\"target_level\",\"dictValue\":\"4\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:39',19),(136,'字典数据',1,'com.ruoyi.project.system.controller.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未识别出目标类型\",\"dictSort\":5,\"dictType\":\"target_level\",\"dictValue\":\"5\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 00:02:48',30),(137,'字典类型',2,'com.ruoyi.project.system.controller.SysDictTypeController.edit()','PUT',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-07-15 23:58:27\",\"dictId\":101,\"dictName\":\"目标类型\",\"dictType\":\"target_type\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-16 11:09:16',19),(138,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情报表\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"report\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"新增菜单\'鸟情报表\'失败，菜单名称已存在\",\"code\":500}',0,NULL,'2025-07-18 22:53:23',6),(139,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"鸟情报表1\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"report\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:53:27',16),(140,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/bird_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"周报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2004,\"path\":\"BirdReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:53:49',27),(141,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-07-18 22:53:27\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"鸟情报表\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"report\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:53:54',21),(142,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_weekly_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"周报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2004,\"path\":\"BirdReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:57:54',25),(143,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_monthly_report\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"月报\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2004,\"path\":\"BirdMonthlyReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:59:32',24),(144,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_weekly_report\",\"createTime\":\"2025-07-15 01:38:29\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"周报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2004,\"path\":\"BirdWeeklyReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 22:59:42',24),(145,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_quarterly_report\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"季度报\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2004,\"path\":\"BirdQuarterlyReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 23:01:20',21),(146,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird annual report\",\"createBy\":\"admin\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"年报\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2004,\"path\":\"BirdAnnualReport\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 23:02:16',21),(147,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"radar/report/bird_annual_report\",\"createTime\":\"2025-07-18 23:02:16\",\"icon\":\"date\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2007,\"menuName\":\"年报\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2004,\"path\":\"BirdAnnualReport\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-07-18 23:02:51',23),(148,'用户管理',5,'com.ruoyi.project.system.controller.SysUserController.export()','POST',1,'admin','研发部门','/system/user/export','127.0.0.1','内网IP','{\"pageSize\":\"10\",\"pageNum\":\"1\"}',NULL,0,NULL,'2025-08-04 09:32:25',907),(149,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"mapTest/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"地图测试\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"mapTest\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-09 20:51:03',13),(150,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2000','127.0.0.1','内网IP','2000','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:30',94),(151,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2002','127.0.0.1','内网IP','2002','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:32',23),(152,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2004','127.0.0.1','内网IP','2004','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:41:35',3),(153,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2003','127.0.0.1','内网IP','2003','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:46',65),(154,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2005','127.0.0.1','内网IP','2005','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:49',32),(155,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2006','127.0.0.1','内网IP','2006','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:51',19),(156,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2007','127.0.0.1','内网IP','2007','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:54',36),(157,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2004','127.0.0.1','内网IP','2004','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:41:57',35),(158,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2008','127.0.0.1','内网IP','2008','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:42:01',30),(159,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/2001','127.0.0.1','内网IP','2001','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:42:05',36),(160,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/103','127.0.0.1','内网IP','103','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:57:54',9),(161,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1016','127.0.0.1','内网IP','1016','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:58:00',9),(162,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1019','127.0.0.1','内网IP','1019','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:58:21',6),(163,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1017,\"menuName\":\"部门新增\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:add\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:58:32',544),(164,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1017','127.0.0.1','内网IP','1017','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:58:35',7),(165,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1017,\"menuName\":\"部门新增\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:add\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 20:58:45',46),(166,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1020','127.0.0.1','内网IP','1020','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 20:59:03',7),(167,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/3','127.0.0.1','内网IP','3','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 21:24:59',8),(168,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/115','127.0.0.1','内网IP','115','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-01 21:25:07',6),(169,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:25:24',55),(170,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:04',85),(171,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:24',71),(172,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:36',36),(173,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:26:50',534),(174,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:27:04',66),(175,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin','研发部门','/system/config','127.0.0.1','内网IP','{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"N\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-01 21:27:28',34),(176,'参数管理',5,'com.ruoyi.project.system.controller.SysConfigController.export()','POST',1,'admin','研发部门','/system/config/export','127.0.0.1','内网IP','{\"pageSize\":\"10\",\"pageNum\":\"1\"}',NULL,0,NULL,'2025-12-01 21:27:42',1507),(177,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/100,101','127.0.0.1','内网IP','[100,101]',NULL,1,'威胁等级已分配,不能删除','2025-12-02 14:22:38',16),(178,'字典类型',3,'com.ruoyi.project.system.controller.SysDictDataController.remove()','DELETE',1,'admin','研发部门','/system/dict/data/100,101,102,103','127.0.0.1','内网IP','[100,101,102,103]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:22:51',128),(179,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/100','127.0.0.1','内网IP','[100]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:22:57',31),(180,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/101','127.0.0.1','内网IP','[101]',NULL,1,'目标类型已分配,不能删除','2025-12-02 14:23:02',6),(181,'字典类型',3,'com.ruoyi.project.system.controller.SysDictDataController.remove()','DELETE',1,'admin','研发部门','/system/dict/data/104,105,106,107,108,109','127.0.0.1','内网IP','[104,105,106,107,108,109]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:23:10',218),(182,'字典类型',3,'com.ruoyi.project.system.controller.SysDictTypeController.remove()','DELETE',1,'admin','研发部门','/system/dict/type/101','127.0.0.1','内网IP','[101]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:23:16',533),(183,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1016','127.0.0.1','内网IP','1016','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-02 14:23:36',7),(184,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1019,\"menuName\":\"部门删除\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:remove\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:23:50',450),(185,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/1019','127.0.0.1','内网IP','1019','{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}',0,NULL,'2025-12-02 14:23:55',6),(186,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1019,\"menuName\":\"部门删除\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":103,\"path\":\"\",\"perms\":\"system:dept:remove\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 14:24:05',1081),(187,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":97,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:01:05',95),(188,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:01:16',24),(189,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:07:28',72),(190,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-02 21:07:36',39),(191,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":98,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:20:46',49),(192,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/job/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":110,\"menuName\":\"定时任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2,\"path\":\"job\",\"perms\":\"monitor:job:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:20:53',36),(193,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/job/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":110,\"menuName\":\"定时任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2,\"path\":\"job\",\"perms\":\"monitor:job:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:21:10',553),(194,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"test\",\"params\":{},\"postIds\":[],\"roleIds\":[2],\"status\":\"0\",\"userId\":100,\"userName\":\"测试用户\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:23:55',191),(195,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:28:44',77),(196,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:28:50',36),(197,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":true,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045],\"params\":{},\"remark\":\"超级管理员\",\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}',NULL,1,'不允许操作超级管理员角色','2025-12-03 21:28:58',3),(198,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:29:10',45),(199,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":97,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:32:09',576),(200,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 21:37:20',73),(201,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:19:36',76),(202,'角色管理',1,'com.ruoyi.project.system.controller.SysRoleController.add()','POST',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":0,\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:19:53',68),(203,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":true,\"createTime\":\"2025-06-26 22:53:03\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"超级管理员\",\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":0,\"status\":\"0\"}',NULL,1,'不允许操作超级管理员角色','2025-12-03 22:20:06',2),(204,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:20:16',82),(205,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:20:23',34),(206,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"学生\",\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-03 22:20:29',45),(207,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin','研发部门','/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"1,2,100\",\"userId\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 00:12:10',105),(208,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin','研发部门','/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"1\",\"userId\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 00:35:24',100),(209,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 23:22:16',44),(210,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-06-26 22:53:03\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 23:22:53',70),(211,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createBy\":\"admin\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-08 23:29:31',66),(212,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createBy\":\"admin\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-18 23:05:31',54),(213,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/103','127.0.0.1','内网IP','103','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2025-12-25 20:17:48',11),(214,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1016','127.0.0.1','内网IP','1016','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:17:56',109),(215,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1017','127.0.0.1','内网IP','1017','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:17:59',42),(216,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1018','127.0.0.1','内网IP','1018','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:02',35),(217,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1019','127.0.0.1','内网IP','1019','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:05',30),(218,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/103','127.0.0.1','内网IP','103','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:07',38),(219,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1020','127.0.0.1','内网IP','1020','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:12',40),(220,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1022','127.0.0.1','内网IP','1022','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:16',24),(221,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1021','127.0.0.1','内网IP','1021','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:19',32),(222,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1023','127.0.0.1','内网IP','1023','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:22',28),(223,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/1024','127.0.0.1','内网IP','1024','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:24',30),(224,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/104','127.0.0.1','内网IP','104','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:18:27',43),(225,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"测试用户02\",\"params\":{},\"roleIds\":[3],\"status\":\"0\",\"userId\":101,\"userName\":\"测试用户02\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 20:31:02',211),(226,'用户头像',2,'com.ruoyi.project.system.controller.SysProfileController.avatar()','POST',1,'admin',NULL,'/system/user/profile/avatar','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/12/25/4decdb917c05482d944f625210ff5077.jpg\",\"code\":200}',0,NULL,'2025-12-25 20:38:32',132),(227,'用户头像',2,'com.ruoyi.project.system.controller.SysProfileController.avatar()','POST',1,'admin',NULL,'/system/user/profile/avatar','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/12/25/1c21f40eaf2e4c3dadef5c4b4e3bd56e.png\",\"code\":200}',0,NULL,'2025-12-25 20:43:13',54033),(228,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.edit()','PUT',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2025-12-25 20:31:02\",\"delFlag\":\"0\",\"email\":\"\",\"graduateFlag\":2,\"loginIp\":\"\",\"nickName\":\"测试用户02\",\"params\":{},\"phonenumber\":\"\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"测试用户02\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:26:20',85),(229,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/101','127.0.0.1','内网IP','[101]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:26:31',75),(230,'用户管理',1,'com.ruoyi.project.system.controller.SysUserController.add()','POST',1,'admin',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"graduateFlag\":2,\"nickName\":\"测试毕业\",\"params\":{},\"roleIds\":[],\"status\":\"0\",\"userId\":102,\"userName\":\"hih\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:26:42',190),(231,'用户管理',3,'com.ruoyi.project.system.controller.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/102','127.0.0.1','内网IP','[102]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-25 21:27:02',70),(232,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"100\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 20:16:32',36),(233,'用户管理',2,'com.ruoyi.project.system.controller.SysUserController.resetPwd()','PUT',1,'admin',NULL,'/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":true,\"params\":{},\"userId\":1}',NULL,1,'不允许操作超级管理员用户','2025-12-26 20:16:53',5),(234,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 20:19:29',47),(235,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 20:19:33',35),(236,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"1,2\",\"userId\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-26 21:17:26',398),(237,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createBy\":\"admin\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"literature\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:12:53',76),(238,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:14:34',30),(239,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:15:20',44),(240,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010,2011,2012],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:16:36',99),(241,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literatureManagement\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:19:18',57),(242,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literatureManagement\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:19:25',59),(243,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:40:43',72),(244,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:41:14',26),(245,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2009,2011],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:49:33',79),(246,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureDetail\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献详情\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"detail\",\"status\":\"0\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:53:26',69),(247,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureDetail\",\"createTime\":\"2025-12-28 20:53:26\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2013,\"menuName\":\"文献详情\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"detail\",\"perms\":\"\",\"query\":\"path: \':id\'\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 20:55:39',56),(248,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2013','127.0.0.1','内网IP','2013','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 21:00:27',53),(249,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureDetail\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献详情\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"detail\",\"query\":\":id\",\"status\":\"0\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 21:13:20',80),(250,'菜单管理',3,'com.ruoyi.project.system.controller.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2014','127.0.0.1','内网IP','2014','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-28 21:20:15',63),(251,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"job\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:48:50',74),(252,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:48:59',27),(253,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createTime\":\"2025-12-28 20:14:34\",\"icon\":\"build\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:02',22),(254,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:26',66),(255,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献阅读\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:30',38),(256,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createTime\":\"2025-12-28 20:14:34\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-02 21:49:36',34),(257,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"Literature/LiteratureStatistic\",\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"文献统计\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"statistic\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-05 21:58:35',77),(258,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-06-26 22:53:03\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2009,2010,2011,2012,2015],\"params\":{},\"remark\":\"教师\",\"roleId\":2,\"roleKey\":\"teacher\",\"roleName\":\"教师\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-05 22:00:06',112),(259,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureStatistic\",\"createTime\":\"2026-01-05 21:58:35\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2015,\"menuName\":\"文献统计\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2010,\"path\":\"statistic\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-05 22:01:50',75),(260,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:04:35',45),(261,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-12-18 23:05:31\",\"icon\":\"excel\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"文献管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"literature\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:05:12',37),(262,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:06:39',86),(263,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"投稿管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"submission\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:08:12',32),(264,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-01-08 17:08:12\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2016,\"menuName\":\"投稿管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"submission\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:08:26',67),(265,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"keyword/KeywordManagement\",\"createTime\":\"2025-12-28 20:14:34\",\"icon\":\"keyword\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"关键词管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2010,\"path\":\"keyword\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:12:24',80),(266,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"submission/SubmissionManagement\",\"createBy\":\"admin\",\"icon\":\"tab\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"投稿计划\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2016,\"path\":\"plan\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:17:53',28),(267,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"review/ReviewManagement\",\"createBy\":\"admin\",\"icon\":\"eye-open\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"审核流程\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2016,\"path\":\"review\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:19:08',58),(268,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"task/TaskManagement\",\"createTime\":\"2025-12-08 23:29:31\",\"icon\":\"task\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"任务管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"task\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-08 17:20:32',66),(269,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2009,2011,2016,2017,2018],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-13 15:18:20',118),(270,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"102\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-13 16:46:46',82),(271,'用户管理',4,'com.ruoyi.project.system.controller.SysUserController.insertAuthRole()','PUT',1,'admin',NULL,'/system/user/authRole','127.0.0.1','内网IP','{\"roleIds\":\"3\",\"userId\":\"101\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-13 16:46:50',32),(272,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献资源\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:39:35',92),(273,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"library\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献资源\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:42:36',76),(274,'菜单管理',1,'com.ruoyi.project.system.controller.SysMenuController.add()','POST',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/Literaturereading\",\"createBy\":\"admin\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"我的阅读\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2010,\"path\":\"reading\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:51:17',72),(275,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureManagement\",\"createTime\":\"2025-12-28 20:12:53\",\"icon\":\"library\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2011,\"menuName\":\"文献资源\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2010,\"path\":\"resource\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:51:49',36),(276,'菜单管理',2,'com.ruoyi.project.system.controller.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"literature/LiteratureRead\",\"createTime\":\"2026-01-14 14:51:17\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"我的阅读\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2010,\"path\":\"read\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-14 14:52:35',32),(277,'角色管理',2,'com.ruoyi.project.system.controller.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-12-03 22:19:53\",\"delFlag\":\"0\",\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2010,2009,2011,2019,2016,2017,2018],\"params\":{},\"remark\":\"学生\",\"roleId\":3,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:12:23',111),(278,'个人信息',2,'com.ruoyi.project.system.controller.SysProfileController.updatePwd()','PUT',1,'test03',NULL,'/system/user/profile/updatePwd','127.0.0.1','内网IP','{}','{\"msg\":\"新密码不能与旧密码相同\",\"code\":500}',0,NULL,'2026-01-17 15:14:56',256),(279,'个人信息',2,'com.ruoyi.project.system.controller.SysProfileController.updatePwd()','PUT',1,'test03',NULL,'/system/user/profile/updatePwd','127.0.0.1','内网IP','{}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:48:08',386),(280,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"N\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:57:40',102),(281,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"Y\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 15:57:40\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:59:30',838),(282,'参数管理',9,'com.ruoyi.project.system.controller.SysConfigController.refreshCache()','DELETE',1,'admin',NULL,'/system/config/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 15:59:32',21),(283,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"N\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 15:59:29\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:01',82),(284,'参数管理',9,'com.ruoyi.project.system.controller.SysConfigController.refreshCache()','DELETE',1,'admin',NULL,'/system/config/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:02',9),(285,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"N\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 16:00:01\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:16',35),(286,'参数管理',9,'com.ruoyi.project.system.controller.SysConfigController.refreshCache()','DELETE',1,'admin',NULL,'/system/config/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:18',7),(287,'参数管理',2,'com.ruoyi.project.system.controller.SysConfigController.edit()','PUT',1,'admin',NULL,'/system/config','127.0.0.1','内网IP','{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2025-06-26 22:53:04\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-17 16:00:16\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-01-17 16:00:49',63);
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
  `role_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2025-06-26 22:53:03','',NULL,'超级管理员'),(2,'教师','teacher',2,'2',1,1,'0','0','admin','2025-06-26 22:53:03','admin','2026-01-05 22:00:06','教师'),(3,'学生','student',3,'1',1,1,'0','0','admin','2025-12-03 22:19:53','admin','2026-01-17 15:12:23','学生');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,2009),(2,2010),(2,2011),(2,2012),(2,2015),(3,2009),(3,2010),(3,2011),(3,2016),(3,2017),(3,2018),(3,2019);
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
  `user_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `graduate_flag` tinyint NOT NULL DEFAULT '1' COMMENT '是否毕业, 1:未毕业, 2:已毕业',
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','测试用户01','00',1,'ry@163.com','15888888888','1','/profile/avatar/2025/12/25/1c21f40eaf2e4c3dadef5c4b4e3bd56e.png','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-01-17 21:37:47','2025-06-26 22:53:03','admin','2025-06-26 22:53:03','','2026-01-17 21:37:47','管理员'),(2,'test02','测试用户02','00',1,'ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2025-06-26 22:53:03','2025-06-26 22:53:03','admin','2025-06-26 22:53:03','',NULL,'测试员'),(100,'test03','测试用户03','00',1,'','','0','','$2a$10$92.OpGiHyPqf44p4gBUhquhhEff2hth9vBawm9nWNeD2ttRDGOOki','0','0','127.0.0.1','2026-01-17 20:56:02','2026-01-17 15:48:08','admin','2025-12-03 21:23:55','','2026-01-17 20:56:02',NULL),(101,'test04','测试用户04','00',1,'','','0','','$2a$10$oVdA4RhzGq3yIg5qsDvEnebNQHISn46PXfICU0EnZsjqNnYoSu.sK','0','0','',NULL,NULL,'admin','2025-12-25 20:31:02','admin','2025-12-25 21:26:20',NULL),(102,'test05','测试用户05','00',2,'','','0','','$2a$10$pqYNiGP0PnpYYXGGYuf7yOhGOQ1rYYF0Dic5k7hF.tFz3a6hl9e9q','0','0','',NULL,NULL,'admin','2025-12-25 21:26:41','',NULL,NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(1,2),(2,2),(100,3),(101,3),(102,3);
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
  `task_name` varchar(50) NOT NULL COMMENT '任务名称',
  `task_description` varchar(255) DEFAULT NULL COMMENT '任务描述',
  `task_remark` varchar(255) DEFAULT NULL COMMENT '任务备注',
  `task_order` tinyint NOT NULL COMMENT '任务排序',
  `task_depth` tinyint NOT NULL COMMENT '任务深度',
  `task_status` tinyint NOT NULL DEFAULT '1' COMMENT '任务状态,1:未开始,2:进行中,3:已完成4:已跳过',
  `create_user_id` bigint NOT NULL COMMENT '创建用户id',
  `create_nick_name` varchar(30) NOT NULL COMMENT '创建用户昵称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `expected_finish_time` datetime DEFAULT NULL COMMENT '预期完成时间',
  `actual_finish_time` datetime DEFAULT NULL COMMENT '实际完成时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (60,0,'测试任务C','','',1,1,4,1,'测试用户01','2025-12-27 14:44:56',NULL,NULL,'2025-12-27 14:45:12');
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_file`
--

DROP TABLE IF EXISTS `task_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_path` varchar(255) NOT NULL COMMENT '文件路径',
  `file_type` varchar(20) NOT NULL COMMENT '文件类型',
  `file_size` int NOT NULL COMMENT '文件大小，单位是B',
  `task_id` bigint NOT NULL COMMENT '任务id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `user_nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='任务文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_file`
--

LOCK TABLES `task_file` WRITE;
/*!40000 ALTER TABLE `task_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_file` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='任务关联用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_user`
--

LOCK TABLES `task_user` WRITE;
/*!40000 ALTER TABLE `task_user` DISABLE KEYS */;
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

-- Dump completed on 2026-01-17 21:42:23
