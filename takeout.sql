-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: gdpu_order_db
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `address_book`
--

DROP TABLE IF EXISTS `address_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address_book` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `consignee` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收货人',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `province_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省级区划编号',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省级名称',
  `city_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '市级区划编号',
  `city_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '市级名称',
  `district_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '区级区划编号',
  `district_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '区级名称',
  `detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '详细地址',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '默认 0 否 1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='地址簿';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address_book`
--

LOCK TABLES `address_book` WRITE;
/*!40000 ALTER TABLE `address_book` DISABLE KEYS */;
INSERT INTO `address_book` VALUES (2,4,'格温','1','19537602118','44','广东省','4453','云浮市','445303','云安区','310','1',1);
/*!40000 ALTER TABLE `address_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` int DEFAULT NULL COMMENT '类型   1 菜品分类 2 套餐分类',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '顺序',
  `status` int DEFAULT NULL COMMENT '分类状态 0:禁用，1:启用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_category_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='菜品及套餐分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (11,1,'酒水饮料',5,1,'2025-11-09 22:09:18','2025-11-24 02:44:33',1,1),(12,1,'传统主食',2,1,'2025-11-09 22:09:32','2025-11-24 02:44:10',1,1),(13,2,'单人套餐',6,1,'2025-11-09 22:11:38','2025-11-24 02:44:40',1,1),(16,1,'小炒',1,1,'2025-11-09 22:15:37','2025-11-24 14:18:13',1,1),(19,1,'新鲜时蔬',3,1,'2025-11-09 22:18:12','2025-11-24 02:44:23',1,1),(21,1,'汤类',4,1,'2025-11-10 10:51:47','2025-11-24 02:44:28',1,1);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_sessions`
--

DROP TABLE IF EXISTS `chat_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_sessions` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `admin_id` bigint NOT NULL COMMENT '管理员ID',
  `memory_id` bigint NOT NULL COMMENT '会话记忆ID',
  `session_title` varchar(255) DEFAULT '新对话' COMMENT '会话标题',
  `last_message` text COMMENT '最后一条消息',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  PRIMARY KEY (`id`),
  KEY `idx_admin_id` (`admin_id`),
  KEY `idx_memory_id` (`memory_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_sessions`
--

LOCK TABLES `chat_sessions` WRITE;
/*!40000 ALTER TABLE `chat_sessions` DISABLE KEYS */;
INSERT INTO `chat_sessions` VALUES (1,1,45145692,'新对话','今天是 2025-11-24，星期一。新的一周开始啦！??\n\n我是校园小智，智慧校园外卖管理平台的智能助手，随时为您提供专业的运营管理支持！?','2025-11-24 01:58:38','2025-11-24 01:58:42',0),(2,1,84091101,'新对话','您好，我是校园小智，智慧校园外卖管理平台的智能助手。很高兴为您服务！?\n\n今天是2025年11月24日，星期一。新的一周开始啦，建议您检查本周的运营数据和商家接单情况，及时优化配送调度哦！??\n\n如果需要查看今日订单趋势或商家表现，请随时告诉我，我可以为您提供分析建议！?','2025-11-24 02:02:32','2025-11-24 02:34:31',0),(3,1,19735040,'新对话','? **所有员工信息**\n\n| ID | 姓名 | 用户名 | 手机号 | 状态 |\n|----|------|--------|--------|------|\n| 1 | 管理员 | admin | 13812312312 | 启用 |\n| 2 | 张三 | zhangsan | 19537662228 | 启用 |\n| 3 | 李四 | lisi | 13544866777 | 启用 |\n| 6 | 王五 | wangwu | 13525356772 | 启用 |\n\n✅ 当前共 **4** 名员工，全部为启用状态。\n\n需要查看某位员工的详细信息吗？可以告诉我员工ID哦。','2025-11-24 02:34:40','2025-11-24 14:19:10',0),(4,1,41072459,'新对话','抱歉，这个问题超出了我的服务范围。我是外卖平台管理助手，可以帮您处理员工管理、菜品管理、订单查询和运营优化等工作。\n\n请问是否需要查看今天的订单情况或营业额数据？','2025-11-24 14:53:07','2025-11-24 14:57:43',0);
/*!40000 ALTER TABLE `chat_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dish`
--

DROP TABLE IF EXISTS `dish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dish` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '菜品名称',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `price` decimal(10,2) DEFAULT NULL COMMENT '菜品价格',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '描述信息',
  `status` int DEFAULT '1' COMMENT '0 停售 1 起售',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_dish_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='菜品';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish`
--

LOCK TABLES `dish` WRITE;
/*!40000 ALTER TABLE `dish` DISABLE KEYS */;
INSERT INTO `dish` VALUES (46,'王老吉',11,6.00,'http://localhost:8081/upload/64d3bc3a-29ef-42d2-a77a-23c9773ad293.png','',1,'2025-11-09 22:40:47','2025-11-23 14:19:53',1,1),(47,'北冰洋',11,4.00,'http://localhost:8081/upload/f8b9ef8e-eafd-41ae-9143-654fd7a8de40.png','还是小时候的味道',1,'2025-11-10 09:18:49','2025-11-23 14:19:22',1,1),(48,'雪花啤酒',11,4.00,'http://localhost:8081/upload/05f6e70f-86ff-46d6-8ae3-ab6ca9d66b49.png','',1,'2025-11-10 09:22:54','2025-11-23 14:18:49',1,1),(49,'米饭',12,2.00,'http://localhost:8081/upload/88b8ad51-ad06-4d5a-87ba-1f29a0ddb008.png','精选五常大米',1,'2025-11-10 09:30:17','2025-11-23 14:20:08',1,1),(50,'馒头',12,1.00,'http://localhost:8081/upload/a7bd282f-8877-44a0-b968-b1b65df75a25.png','优质面粉',1,'2025-11-10 09:34:28','2025-11-23 14:21:05',1,1),(54,'炒西兰花',19,18.00,'http://localhost:8081/upload/ba3907ed-1ab0-4418-97c2-6e511e1d853e.jpg','原料：西兰花',1,'2025-11-10 09:51:46','2025-11-23 16:09:59',1,1),(55,'炒油麦菜',19,18.00,'http://localhost:8081/upload/013cc37e-cc46-4906-a158-82679dcc7396.jpg','原料：油麦菜',1,'2025-11-10 09:53:37','2025-11-23 16:09:33',1,1),(56,'炒菜心',19,18.00,'http://localhost:8081/upload/f2dafc2a-1269-44e3-87a8-48ab8f8254a2.jpg','原料：菜心',1,'2025-11-10 09:55:44','2025-11-23 16:07:46',1,1),(57,'炒圆白菜',19,18.00,'http://localhost:8081/upload/a9f7fe11-69f3-47a1-951c-f70ad9ec47dc.jpg','圆白菜',1,'2025-11-10 09:58:35','2025-11-23 16:07:14',1,1),(58,'炒鱿鱼',16,55.00,'http://localhost:8081/upload/063487b0-7172-4d23-af0a-8b87883c014f.jpg','原料：鱿鱼',1,'2025-11-10 10:12:28','2025-11-23 16:21:20',1,1),(59,'黑椒牛肉',16,55.00,'http://localhost:8081/upload/0c9e7cba-df54-4dad-af3c-1216731116fa.jpg','原料：牛肉',1,'2025-11-10 10:24:03','2025-11-23 16:20:51',1,1),(60,'辣子鸡',16,45.00,'http://localhost:8081/upload/01aae7a3-b593-4a73-b32c-35c34da0527e.jpg','原料：鸡肉',1,'2025-11-10 10:26:03','2025-11-23 16:20:10',1,1),(61,'宫保鸡丁',16,45.00,'http://localhost:8081/upload/7f303daf-59b0-4149-b043-95b986e7bb1d.jpg','原料：鸡肉',1,'2025-11-10 10:28:54','2025-11-23 16:19:21',1,1),(65,'红烧肉',16,40.00,'http://localhost:8081/upload/c97d375e-acdd-4062-a2c9-44d327308165.jpg','原料：肉',1,'2025-11-10 10:41:08','2025-11-23 16:18:17',1,1),(66,'金针肥牛',16,45.00,'http://localhost:8081/upload/b4f861cd-918b-4a0d-878f-7c091646affa.jpg','配料：牛肉，金针菇',1,'2025-11-10 10:42:42','2025-11-23 16:17:28',1,1),(67,'酸辣土豆丝',16,20.00,'http://localhost:8081/upload/0e580b55-9375-4fa1-aeac-86e7bbf9bf36.jpg','原料：土豆',1,'2025-11-10 10:43:56','2025-11-23 16:16:43',1,1),(68,'西红柿鸡蛋汤',21,20.00,'http://localhost:8081/upload/7971972f-bf53-463d-bfea-b7303a0954f1.jpg','配料：鸡蛋，西红柿',1,'2025-11-10 10:54:25','2025-11-24 14:55:00',1,1),(69,'虫草花炖鸡汤',21,30.00,'http://localhost:8081/upload/f5355d6c-7bd9-47a0-91b3-34f913cb94b7.jpg','配料：鸡肉、虫草花',1,'2025-11-10 10:55:02','2025-11-23 14:37:07',1,1),(70,'萝卜排骨汤',21,22.00,'http://localhost:8081/upload/591f9784-8abd-4d6c-91a4-7985b5958a77.jpg','萝卜、排骨',1,'2025-11-23 16:23:50','2025-11-23 16:25:37',1,1),(71,'红烧豆腐',16,22.00,'http://localhost:8081/upload/0eb66533-cca7-4884-8e9e-f41720ac2d04.jpg','',1,'2025-11-23 16:24:21','2025-11-24 14:17:58',1,1),(72,'紫菜蛋花汤',21,25.00,'http://localhost:8081/upload/4f42bc04-c1d8-493e-9356-cb99e7a3e822.jpg','',1,'2025-11-23 16:24:39','2025-11-23 16:25:33',1,1),(73,'农家小炒肉',16,30.00,'http://localhost:8081/upload/b4ef98bf-910d-48ee-9bff-c42315ecba59.jpg','',1,'2025-11-23 16:25:07','2025-11-24 14:55:48',1,1);
/*!40000 ALTER TABLE `dish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dish_flavor`
--

DROP TABLE IF EXISTS `dish_flavor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dish_flavor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dish_id` bigint NOT NULL COMMENT '菜品',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味名称',
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味数据list',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='菜品口味关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish_flavor`
--

LOCK TABLES `dish_flavor` WRITE;
/*!40000 ALTER TABLE `dish_flavor` DISABLE KEYS */;
INSERT INTO `dish_flavor` VALUES (40,10,'甜味','[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]'),(41,7,'忌口','[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]'),(42,7,'温度','[\"热饮\",\"常温\",\"去冰\",\"少冰\",\"多冰\"]'),(45,6,'忌口','[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]'),(46,6,'辣度','[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]'),(47,5,'辣度','[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]'),(48,5,'甜味','[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]'),(49,2,'甜味','[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]'),(50,4,'甜味','[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]'),(51,3,'甜味','[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]'),(52,3,'忌口','[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]'),(107,49,'','[]'),(109,57,'忌口','[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]'),(110,56,'忌口','[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]'),(111,54,'忌口','[\"不要葱\",\"不要蒜\",\"不要香菜\"]'),(112,67,'辣度','[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]'),(113,66,'辣度','[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]'),(114,61,'辣度','[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]'),(117,60,'忌口','[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]'),(118,60,'辣度','[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]'),(120,73,'辣度','[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
/*!40000 ALTER TABLE `dish_flavor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '姓名',
  `username` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '密码',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '身份证号',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 0:禁用，1:启用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='员工信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'管理员','admin','e10adc3949ba59abbe56e057f20f883e','13812312312','1','110101199001010047',1,'2025-11-20 10:00:00','2025-11-20 10:00:00',10,1),(2,'张三','zhangsan','e10adc3949ba59abbe56e057f20f883e','19537662228','男','111122233333',1,'2025-11-12 17:46:07','2025-11-12 17:46:07',10,10),(3,'李四','lisi','e10adc3949ba59abbe56e057f20f883e','13544866777','1','123456789123456789',1,'2025-11-12 17:50:21','2025-11-13 20:16:40',10,1),(6,'王五','wangwu','e10adc3949ba59abbe56e057f20f883e','13525356772','1','123456789109876543',1,'2025-11-12 19:53:04','2025-11-15 15:43:33',1,1);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '名字',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `order_id` bigint NOT NULL COMMENT '订单id',
  `dish_id` bigint DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT '1' COMMENT '数量',
  `amount` decimal(10,2) NOT NULL COMMENT '金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='订单明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (5,'酸辣土豆丝','http://localhost:8081/upload/0e580b55-9375-4fa1-aeac-86e7bbf9bf36.jpg',4,67,NULL,'不辣',1,20.00),(6,'农家小炒肉','http://localhost:8081/upload/b4ef98bf-910d-48ee-9bff-c42315ecba59.jpg',5,73,NULL,'中辣',1,30.00),(7,'酸辣土豆丝','http://localhost:8081/upload/0e580b55-9375-4fa1-aeac-86e7bbf9bf36.jpg',6,67,NULL,'中辣',1,20.00),(8,'宫保鸡丁','http://localhost:8081/upload/7f303daf-59b0-4149-b043-95b986e7bb1d.jpg',6,61,NULL,'不辣',1,45.00),(9,'农家小炒肉','http://localhost:8081/upload/b4ef98bf-910d-48ee-9bff-c42315ecba59.jpg',7,73,NULL,'中辣',1,30.00),(10,'红烧豆腐','http://localhost:8081/upload/0eb66533-cca7-4884-8e9e-f41720ac2d04.jpg',8,71,NULL,NULL,1,22.00),(11,'酸辣土豆丝','http://localhost:8081/upload/0e580b55-9375-4fa1-aeac-86e7bbf9bf36.jpg',8,67,NULL,'中辣',1,20.00),(12,'辣子鸡','http://localhost:8081/upload/01aae7a3-b593-4a73-b32c-35c34da0527e.jpg',8,60,NULL,'不要葱,中辣',1,45.00),(13,'农家小炒肉','http://localhost:8081/upload/b4ef98bf-910d-48ee-9bff-c42315ecba59.jpg',9,73,NULL,'不辣',1,30.00),(14,'农家小炒肉','http://localhost:8081/upload/b4ef98bf-910d-48ee-9bff-c42315ecba59.jpg',10,73,NULL,'微辣',1,30.00);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单号',
  `status` int NOT NULL DEFAULT '1' COMMENT '订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消 7退款',
  `user_id` bigint NOT NULL COMMENT '下单用户',
  `address_book_id` bigint NOT NULL COMMENT '地址id',
  `order_time` datetime NOT NULL COMMENT '下单时间',
  `checkout_time` datetime DEFAULT NULL COMMENT '结账时间',
  `pay_method` int NOT NULL DEFAULT '1' COMMENT '支付方式 1微信,2支付宝',
  `pay_status` tinyint NOT NULL DEFAULT '0' COMMENT '支付状态 0未支付 1已支付 2退款',
  `amount` decimal(10,2) NOT NULL COMMENT '实收金额',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '地址',
  `user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户名称',
  `consignee` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收货人',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单取消原因',
  `rejection_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单拒绝原因',
  `cancel_time` datetime DEFAULT NULL COMMENT '订单取消时间',
  `estimated_delivery_time` datetime DEFAULT NULL COMMENT '预计送达时间',
  `delivery_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '配送状态  1立即送出  0选择具体时间',
  `delivery_time` datetime DEFAULT NULL COMMENT '送达时间',
  `pack_amount` int DEFAULT NULL COMMENT '打包费',
  `tableware_number` int DEFAULT NULL COMMENT '餐具数量',
  `tableware_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '餐具数量状态  1按餐量提供  0选择具体数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (4,'1763909689383',5,4,2,'2025-11-23 22:54:49','2025-11-23 22:54:55',1,1,27.00,'','19537602118',NULL,NULL,'格温',NULL,NULL,NULL,'2025-11-23 23:54:00',0,'2025-11-23 22:55:52',1,0,0),(5,'1763917657515',5,4,2,'2025-11-24 01:07:38','2025-11-24 01:07:39',1,1,37.00,'','19537602118',NULL,NULL,'格温',NULL,NULL,NULL,'2025-11-24 02:07:00',0,'2025-11-24 01:07:58',1,0,0),(6,'1763922914656',5,4,2,'2025-11-24 02:35:15','2025-11-24 02:35:18',1,1,73.00,'','19537602118',NULL,NULL,'格温',NULL,NULL,NULL,'2025-11-24 03:35:00',0,'2025-11-24 02:35:40',2,0,0),(7,'1763965218139',5,4,2,'2025-11-24 14:20:18','2025-11-24 14:20:25',1,1,37.00,'不要葱','19537602118',NULL,NULL,'格温',NULL,NULL,NULL,'2025-11-25 15:20:00',0,'2025-11-24 14:20:44',1,1,0),(8,'1763965301710',5,4,2,'2025-11-24 14:21:42','2025-11-24 14:21:43',1,1,96.00,'','19537602118',NULL,NULL,'格温',NULL,NULL,NULL,'2025-11-24 15:21:00',0,'2025-11-24 14:56:11',3,1,0),(9,'1763965524677',5,4,2,'2025-11-24 14:25:25','2025-11-24 14:25:26',1,1,37.00,'','19537602118',NULL,NULL,'格温',NULL,NULL,NULL,'2025-11-24 15:25:00',0,'2025-11-24 14:56:10',1,0,0),(10,'1766397751858',5,4,2,'2025-12-22 18:02:32','2025-12-22 18:02:43',1,1,37.00,'','19537602118',NULL,NULL,'格温',NULL,NULL,NULL,'2025-12-22 19:02:00',0,'2025-12-22 18:03:14',1,0,0);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setmeal`
--

DROP TABLE IF EXISTS `setmeal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setmeal` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '套餐名称',
  `price` decimal(10,2) NOT NULL COMMENT '套餐价格',
  `status` int DEFAULT '1' COMMENT '售卖状态 0:停售 1:起售',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '描述信息',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_setmeal_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='套餐';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setmeal`
--

LOCK TABLES `setmeal` WRITE;
/*!40000 ALTER TABLE `setmeal` DISABLE KEYS */;
INSERT INTO `setmeal` VALUES (32,13,'单人餐1',30.00,1,'','http://localhost:8081/upload/0dde8897-b11a-4688-9b4f-7ff1664ba7d3.jpg','2025-11-23 16:22:36','2025-11-23 16:22:36',1,1),(36,13,'单人餐2',18.00,1,'','http://localhost:8081/upload/dfb474c2-a5ff-4435-9892-4793f5e2da4e.jpg','2025-11-23 18:40:21','2025-11-23 18:49:10',1,1),(37,13,'单人餐3',30.00,1,'','http://localhost:8081/upload/eca5d522-2cc7-4d94-bfa3-823eb51c6a0f.jpg','2025-11-23 18:40:44','2025-11-24 16:00:03',1,1);
/*!40000 ALTER TABLE `setmeal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setmeal_dish`
--

DROP TABLE IF EXISTS `setmeal_dish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setmeal_dish` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `setmeal_id` bigint DEFAULT NULL COMMENT '套餐id',
  `dish_id` bigint DEFAULT NULL COMMENT '菜品id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '菜品名称 （冗余字段）',
  `price` decimal(10,2) DEFAULT NULL COMMENT '菜品单价（冗余字段）',
  `copies` int DEFAULT NULL COMMENT '菜品份数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='套餐菜品关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setmeal_dish`
--

LOCK TABLES `setmeal_dish` WRITE;
/*!40000 ALTER TABLE `setmeal_dish` DISABLE KEYS */;
INSERT INTO `setmeal_dish` VALUES (47,32,67,'酸辣土豆丝',20.00,1),(48,32,66,'金针肥牛',45.00,1),(53,36,67,'酸辣土豆丝',20.00,1),(54,36,73,'农家小炒肉',30.00,1),(59,37,61,'宫保鸡丁',45.00,1),(60,37,71,'红烧豆腐',22.00,1);
/*!40000 ALTER TABLE `setmeal_dish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `user_id` bigint NOT NULL COMMENT '主键',
  `dish_id` bigint DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT '1' COMMENT '数量',
  `amount` decimal(10,2) NOT NULL COMMENT '金额',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='购物车';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_cart`
--

LOCK TABLES `shopping_cart` WRITE;
/*!40000 ALTER TABLE `shopping_cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `openid` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '微信用户唯一标识',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证号',
  `avatar` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '头像',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='用户信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (4,'oY11T19R6ryAed9CeiAqc_HOvkMo',NULL,NULL,NULL,NULL,NULL,'2025-11-23 12:42:06');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-24 19:36:09
