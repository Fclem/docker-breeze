CREATE DATABASE  IF NOT EXISTS `breezedb` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `breezedb`;
-- MySQL dump 10.13  Distrib 5.7.16, for Linux (x86_64)
--
-- Host: localhost    Database: breezedb
-- ------------------------------------------------------
-- Server version	5.7.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_bda51c3c` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `group_id_refs_id_3cea63fe` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `permission_id_refs_id_a7792de1` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_728de91f` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_fbfc09f1` (`user_id`),
  KEY `auth_user_groups_bda51c3c` (`group_id`),
  CONSTRAINT `group_id_refs_id_f0ee9890` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `user_id_refs_id_831107f1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_fbfc09f1` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `user_id_refs_id_f2045483` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_cartinfo`
--

DROP TABLE IF EXISTS `breeze_cartinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_cartinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `script_buyer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `type_app` tinyint(1) NOT NULL,
  `date_created` date NOT NULL,
  `date_updated` date NOT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `breeze_cartinfo_f299c687` (`script_buyer_id`),
  KEY `breeze_cartinfo_bb420c12` (`product_id`),
  CONSTRAINT `product_id_refs_id_e1f330597da468f` FOREIGN KEY (`product_id`) REFERENCES `breeze_rscripts` (`id`),
  CONSTRAINT `script_buyer_id_refs_id_4adf869b3c84a81f` FOREIGN KEY (`script_buyer_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_computeclass`
--

DROP TABLE IF EXISTS `breeze_computeclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_computeclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(32) NOT NULL,
  `class_type` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_computeresource`
--

DROP TABLE IF EXISTS `breeze_computeresource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_computeresource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `compute_class_id` int(11) NOT NULL,
  `institute_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `institute_id_refs_id_a5c9de79` (`institute_id`),
  KEY `compute_class_id_refs_id_467850b4` (`compute_class_id`),
  CONSTRAINT `compute_class_id_refs_id_467850b4` FOREIGN KEY (`compute_class_id`) REFERENCES `breeze_computeclass` (`id`),
  CONSTRAINT `institute_id_refs_id_a5c9de79` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_computetarget`
--

DROP TABLE IF EXISTS `breeze_computetarget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_computetarget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `label` varchar(64) NOT NULL,
  `config` varchar(100) NOT NULL,
  `institute_id` int(11) NOT NULL DEFAULT '1',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `institute_id_refs_id_d18a48d0` (`institute_id`),
  CONSTRAINT `institute_id_refs_id_d18a48d0` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_dataset`
--

DROP TABLE IF EXISTS `breeze_dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_dataset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  `description` varchar(350) NOT NULL,
  `author_id` int(11) NOT NULL,
  `rdata` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `breeze_dataset_cc846901` (`author_id`),
  CONSTRAINT `author_id_refs_id_7205e44fca036592` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_engineclass`
--

DROP TABLE IF EXISTS `breeze_engineclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_engineclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `engine_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_engineconfig`
--

DROP TABLE IF EXISTS `breeze_engineconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_engineconfig` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `label` varchar(64) NOT NULL,
  `institute_id` int(11) NOT NULL,
  `config` varchar(100) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `institute_id_refs_id_e855b9a9` (`institute_id`),
  CONSTRAINT `institute_id_refs_id_e855b9a9` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_execconfig`
--

DROP TABLE IF EXISTS `breeze_execconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_execconfig` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `label` varchar(64) NOT NULL,
  `institute_id` int(11) NOT NULL,
  `config` varchar(100) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `institute_id_refs_id_119307e8` (`institute_id`),
  CONSTRAINT `institute_id_refs_id_119307e8` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_group`
--

DROP TABLE IF EXISTS `breeze_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `author_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `breeze_group_cc846901` (`author_id`),
  CONSTRAINT `author_id_refs_id_731e9cc017519c57` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_group_team`
--

DROP TABLE IF EXISTS `breeze_group_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_group_team` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breeze_group_team_group_id_2569a601a0eeeb21_uniq` (`group_id`,`user_id`),
  KEY `breeze_group_team_bda51c3c` (`group_id`),
  KEY `breeze_group_team_fbfc09f1` (`user_id`),
  CONSTRAINT `group_id_refs_id_753e28b0f8d2f0e6` FOREIGN KEY (`group_id`) REFERENCES `breeze_group` (`id`),
  CONSTRAINT `user_id_refs_id_1beb75369b8510be` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_inputtemplate`
--

DROP TABLE IF EXISTS `breeze_inputtemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_inputtemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  `description` varchar(350) NOT NULL,
  `author_id` int(11) NOT NULL,
  `file` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `breeze_inputtemplate_cc846901` (`author_id`),
  CONSTRAINT `author_id_refs_id_9f5365085938d36` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_institute`
--

DROP TABLE IF EXISTS `breeze_institute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_institute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `institute` varchar(32) NOT NULL,
  `url` varchar(64) NOT NULL,
  `domain` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `institute_UNIQUE` (`institute`),
  UNIQUE KEY `url_UNIQUE` (`url`),
  UNIQUE KEY `domain_UNIQUE` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_jobs`
--

DROP TABLE IF EXISTS `breeze_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jname` varchar(55) NOT NULL,
  `jdetails` varchar(4900) NOT NULL,
  `juser_id` int(11) NOT NULL,
  `script_id` int(11) NOT NULL,
  `status` varchar(15) NOT NULL,
  `staged` datetime NOT NULL,
  `progress` int(11) NOT NULL,
  `docxml` varchar(100) NOT NULL,
  `rexecut` varchar(100) NOT NULL,
  `sgeid` varchar(15) NOT NULL,
  `mailing` varchar(3) NOT NULL,
  `email` varchar(75) NOT NULL,
  `breeze_stat` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `breeze_jobs_7d914542` (`juser_id`),
  KEY `breeze_jobs_c0ece17f` (`script_id`),
  CONSTRAINT `juser_id_refs_id_5e53213adde2df5b` FOREIGN KEY (`juser_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `script_id_refs_id_5136fc96e04a4f35` FOREIGN KEY (`script_id`) REFERENCES `breeze_rscripts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_offsiteuser`
--

DROP TABLE IF EXISTS `breeze_offsiteuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_offsiteuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(32) NOT NULL,
  `last_name` varchar(32) NOT NULL,
  `institute` varchar(32) DEFAULT NULL,
  `role` varchar(32) DEFAULT NULL,
  `email` varchar(64) NOT NULL,
  `user_key` varchar(32) NOT NULL,
  `added_by_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `user_key` (`user_key`),
  KEY `added_by_id_refs_id_e7974e53` (`added_by_id`),
  CONSTRAINT `added_by_id_refs_id_e7974e53` FOREIGN KEY (`added_by_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_offsiteuser_belongs_to`
--

DROP TABLE IF EXISTS `breeze_offsiteuser_belongs_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_offsiteuser_belongs_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `offsiteuser_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `offsiteuser_id` (`offsiteuser_id`,`user_id`),
  KEY `user_id_refs_id_7bf47d69` (`user_id`),
  CONSTRAINT `offsiteuser_id_refs_id_5b6f38c9` FOREIGN KEY (`offsiteuser_id`) REFERENCES `breeze_offsiteuser` (`id`),
  CONSTRAINT `user_id_refs_id_7bf47d69` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_offsiteuser_shiny_access`
--

DROP TABLE IF EXISTS `breeze_offsiteuser_shiny_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_offsiteuser_shiny_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `offsiteuser_id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `offsiteuser_id` (`offsiteuser_id`,`report_id`),
  KEY `report_id_refs_id_8d5df4cb` (`report_id`),
  CONSTRAINT `offsiteuser_id_refs_id_b72e45dd` FOREIGN KEY (`offsiteuser_id`) REFERENCES `breeze_offsiteuser` (`id`),
  CONSTRAINT `report_id_refs_id_8d5df4cb` FOREIGN KEY (`report_id`) REFERENCES `breeze_report` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_post`
--

DROP TABLE IF EXISTS `breeze_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` varchar(3500) NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `breeze_post_cc846901` (`author_id`),
  CONSTRAINT `author_id_refs_id_123a0bf611045a41` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_project`
--

DROP TABLE IF EXISTS `breeze_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `manager` varchar(50) NOT NULL,
  `pi` varchar(50) NOT NULL,
  `collaborative` tinyint(1) NOT NULL,
  `wbs` varchar(50) NOT NULL,
  `external_id` varchar(50) NOT NULL,
  `description` varchar(1100) NOT NULL,
  `author_id` int(11) NOT NULL,
  `institute_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `breeze_project_cc846901` (`author_id`),
  KEY `breeze_project_da5f2290` (`institute_id`),
  CONSTRAINT `author_id_refs_id_289c997f31e3bfcd` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `institute_id_refs_id_7a3b0470f37ac5a5` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_report`
--

DROP TABLE IF EXISTS `breeze_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) NOT NULL,
  `name` varchar(55) NOT NULL,
  `description` varchar(350) NOT NULL,
  `author_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `rexec` varchar(100) NOT NULL,
  `dochtml` varchar(100) NOT NULL,
  `status` varchar(15) NOT NULL,
  `sgeid` varchar(15) NOT NULL,
  `progress` tinyint(3) unsigned NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `institute_id` int(11) NOT NULL,
  `conf_params` blob,
  `conf_files` blob,
  `shiny_key` varchar(64) DEFAULT NULL,
  `rora_id` int(10) unsigned NOT NULL DEFAULT '0',
  `breeze_stat` varchar(16) DEFAULT NULL,
  `shiny_report_id` int(11) NOT NULL DEFAULT '0' COMMENT 'ALTER TABLE `breeze_report_shared` ADD CONSTRAINT `report_id_refs_id_1e60dfd0` FOREIGN KEY (`report_id`) REFERENCES `breeze_report` (`id`);\n',
  `fm_flag` tinyint(1) NOT NULL DEFAULT '0',
  `target_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shiny_key_UNIQUE` (`shiny_key`),
  KEY `breeze_report_777d41c8` (`type_id`),
  KEY `breeze_report_cc846901` (`author_id`),
  KEY `breeze_report_b6620684` (`project_id`),
  KEY `breeze_report_da5f2290` (`institute_id`),
  CONSTRAINT `author_id_refs_id_37417cb628cb3493` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `institute_id_refs_id_26c9b9e5c39c9995` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`),
  CONSTRAINT `project_id_refs_id_76b6af59e871ccad` FOREIGN KEY (`project_id`) REFERENCES `breeze_project` (`id`),
  CONSTRAINT `type_id_refs_id_4ff079d67a90ceef` FOREIGN KEY (`type_id`) REFERENCES `breeze_reporttype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_report_shared`
--

DROP TABLE IF EXISTS `breeze_report_shared`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_report_shared` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breeze_report_shared_report_id_5301f7bdf9b8d8a5_uniq` (`report_id`,`user_id`),
  KEY `breeze_report_shared_29fa1030` (`report_id`),
  KEY `breeze_report_shared_fbfc09f1` (`user_id`),
  CONSTRAINT `report_id_refs_id_60293b4b1e60dfd0` FOREIGN KEY (`report_id`) REFERENCES `breeze_report` (`id`),
  CONSTRAINT `user_id_refs_id_47cd941fcdcc97fe` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_reporttype`
--

DROP TABLE IF EXISTS `breeze_reporttype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_reporttype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(17) NOT NULL,
  `description` varchar(5500) NOT NULL,
  `search` tinyint(1) NOT NULL,
  `config` varchar(100) DEFAULT NULL,
  `manual` varchar(100) DEFAULT NULL,
  `created` date NOT NULL,
  `author_id` int(11) NOT NULL,
  `institute_id` int(11) NOT NULL,
  `shiny_report_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breeze_reporttype_type_66d923f67b0b6950_uniq` (`type`),
  KEY `breeze_reporttype_cc846901` (`author_id`),
  KEY `breeze_reporttype_da5f2290` (`institute_id`),
  CONSTRAINT `author_id_refs_id_28c40c9178414c19` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `institute_id_refs_id_6751322f0246a641` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_reporttype_access`
--

DROP TABLE IF EXISTS `breeze_reporttype_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_reporttype_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reporttype_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breeze_reporttype_access_reporttype_id_6348637a868672d8_uniq` (`reporttype_id`,`user_id`),
  KEY `breeze_reporttype_access_d00d86a4` (`reporttype_id`),
  KEY `breeze_reporttype_access_fbfc09f1` (`user_id`),
  CONSTRAINT `reporttype_id_refs_id_17aafbaaab719b15` FOREIGN KEY (`reporttype_id`) REFERENCES `breeze_reporttype` (`id`),
  CONSTRAINT `user_id_refs_id_40fbbd5aede380bf` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_reporttype_targets`
--

DROP TABLE IF EXISTS `breeze_reporttype_targets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_reporttype_targets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reporttype_id` int(11) NOT NULL,
  `computetarget_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reporttype_id` (`reporttype_id`,`computetarget_id`),
  KEY `computetarget_id_refs_id_2754d9db` (`computetarget_id`),
  CONSTRAINT `computetarget_id_refs_id_2754d9db` FOREIGN KEY (`computetarget_id`) REFERENCES `breeze_computetarget` (`id`),
  CONSTRAINT `reporttype_id_refs_id_bb178b4e` FOREIGN KEY (`reporttype_id`) REFERENCES `breeze_reporttype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_rscripts`
--

DROP TABLE IF EXISTS `breeze_rscripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_rscripts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(35) NOT NULL,
  `inln` varchar(150) NOT NULL,
  `details` varchar(5500) NOT NULL,
  `category_id` varchar(55) NOT NULL,
  `author_id` int(11) NOT NULL,
  `creation_date` date NOT NULL,
  `draft` tinyint(1) NOT NULL,
  `docxml` varchar(100) NOT NULL,
  `code` varchar(100) NOT NULL,
  `header` varchar(100) NOT NULL,
  `logo` varchar(100) NOT NULL,
  `istag` tinyint(1) NOT NULL,
  `must` tinyint(1) NOT NULL,
  `order` decimal(3,1) NOT NULL,
  `price` decimal(19,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `breeze_rscripts_cc846901` (`author_id`),
  CONSTRAINT `author_id_refs_id_5c0414386020a003` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_rscripts_access`
--

DROP TABLE IF EXISTS `breeze_rscripts_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_rscripts_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rscripts_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breeze_rscripts_access_rscripts_id_795e272c80690740_uniq` (`rscripts_id`,`user_id`),
  KEY `breeze_rscripts_access_1742600e` (`rscripts_id`),
  KEY `breeze_rscripts_access_fbfc09f1` (`user_id`),
  CONSTRAINT `rscripts_id_refs_id_e98e9e2ec9e7575` FOREIGN KEY (`rscripts_id`) REFERENCES `breeze_rscripts` (`id`),
  CONSTRAINT `user_id_refs_id_3e18da01eb89d2db` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_rscripts_install_date`
--

DROP TABLE IF EXISTS `breeze_rscripts_install_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_rscripts_install_date` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rscripts_id` int(11) NOT NULL,
  `user_date_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breeze_rscripts_install_date_rscripts_id_6d85cb12a95305d4_uniq` (`rscripts_id`,`user_date_id`),
  KEY `breeze_rscripts_install_date_1742600e` (`rscripts_id`),
  KEY `breeze_rscripts_install_date_e702ba9f` (`user_date_id`),
  CONSTRAINT `rscripts_id_refs_id_3e640fdecf07916b` FOREIGN KEY (`rscripts_id`) REFERENCES `breeze_rscripts` (`id`),
  CONSTRAINT `user_date_id_refs_id_3e6f00ce0b2975aa` FOREIGN KEY (`user_date_id`) REFERENCES `breeze_user_date` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_rscripts_report_type`
--

DROP TABLE IF EXISTS `breeze_rscripts_report_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_rscripts_report_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rscripts_id` int(11) NOT NULL,
  `reporttype_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breeze_rscripts_report_type_rscripts_id_37c0f1f210173fa1_uniq` (`rscripts_id`,`reporttype_id`),
  KEY `breeze_rscripts_report_type_1742600e` (`rscripts_id`),
  KEY `breeze_rscripts_report_type_d00d86a4` (`reporttype_id`),
  CONSTRAINT `reporttype_id_refs_id_157267ac5bb028d5` FOREIGN KEY (`reporttype_id`) REFERENCES `breeze_reporttype` (`id`),
  CONSTRAINT `rscripts_id_refs_id_2c1561ef1ef62d9` FOREIGN KEY (`rscripts_id`) REFERENCES `breeze_rscripts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_script_categories`
--

DROP TABLE IF EXISTS `breeze_script_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_script_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_user_date`
--

DROP TABLE IF EXISTS `breeze_user_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_user_date` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `install_date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `breeze_user_date_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_5e89260983fdc5e8` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `breeze_userprofile`
--

DROP TABLE IF EXISTS `breeze_userprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breeze_userprofile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `fimm_group` varchar(75) NOT NULL,
  `logo` varchar(100) NOT NULL,
  `institute_info_id` int(11) NOT NULL,
  `db_agreement` tinyint(1) NOT NULL,
  `last_active` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `breeze_userprofile_30b79ea6` (`institute_info_id`),
  CONSTRAINT `institute_info_id_refs_id_2af96cc28720b8fa` FOREIGN KEY (`institute_info_id`) REFERENCES `breeze_institute` (`id`),
  CONSTRAINT `user_id_refs_id_5c2e4c902790e52e` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_fbfc09f1` (`user_id`),
  KEY `django_admin_log_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_288599e6` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `user_id_refs_id_c8665aa` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_c25c2c28` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiny_shinyreport`
--

DROP TABLE IF EXISTS `shiny_shinyreport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiny_shinyreport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(55) NOT NULL,
  `description` varchar(350) NOT NULL,
  `author_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `institute_id` int(11) NOT NULL,
  `custom_header` longtext,
  `custom_loader` longtext,
  `custom_files` longtext,
  `enabled` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title_UNIQUE` (`title`),
  KEY `institute_id_refs_id_26616b47` (`institute_id`),
  KEY `author_id_refs_id_dd40ef9f` (`author_id`),
  CONSTRAINT `author_id_refs_id_dd40ef9f` FOREIGN KEY (`author_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `institute_id_refs_id_26616b47` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiny_shinytag`
--

DROP TABLE IF EXISTS `shiny_shinytag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiny_shinytag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  `label` varchar(32) NOT NULL,
  `description` varchar(350) NOT NULL,
  `author_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `institute_id` int(11) NOT NULL,
  `order` int(10) unsigned NOT NULL,
  `menu_entry` varchar(255) NOT NULL,
  `zip_file` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `institute_id_refs_id_db2eb8bc` (`institute_id`),
  CONSTRAINT `institute_id_refs_id_db2eb8bc` FOREIGN KEY (`institute_id`) REFERENCES `breeze_institute` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shiny_shinytag_attached_report`
--

DROP TABLE IF EXISTS `shiny_shinytag_attached_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shiny_shinytag_attached_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shinytag_id` int(11) NOT NULL,
  `shinyreport_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shinytag_id` (`shinytag_id`,`shinyreport_id`),
  CONSTRAINT `shinytag_id_refs_id_56dde903` FOREIGN KEY (`shinytag_id`) REFERENCES `shiny_shinytag` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `south_migrationhistory`
--

DROP TABLE IF EXISTS `south_migrationhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `south_migrationhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(255) NOT NULL,
  `migration` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-07 19:08:22
