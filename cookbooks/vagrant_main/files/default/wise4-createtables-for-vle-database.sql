-- based on http://mysystem.dev.concord.org/wise4/wise4-4_3-3.box
-- mysqldump -uroot -ppassword --add-drop-table --no-data vle_database
--
-- in the stepwork_<name> tables as well as the ideaBasket and journal tables all occurrences of:
--
--   `data` varchar(1024) DEFAULT NULL,
--
-- are replaced with: 
--
--    `data` text,
--
-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: vle_database
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.10-log

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
-- Table structure for table `annotation`
--

DROP TABLE IF EXISTS `annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `annotateTime` datetime DEFAULT NULL,
  `postTime` datetime DEFAULT NULL,
  `runId` bigint(20) DEFAULT NULL,
  `stepWork_id` bigint(20) DEFAULT NULL,
  `userInfo_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKA34FEB2FE8A0978C` (`stepWork_id`),
  KEY `FKA34FEB2F206FE92` (`userInfo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `annotation_comment`
--

DROP TABLE IF EXISTS `annotation_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotation_comment` (
  `data` varchar(512) DEFAULT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKB3FAE14F5B80E7FE` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `annotation_flag`
--

DROP TABLE IF EXISTS `annotation_flag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotation_flag` (
  `data` varchar(512) DEFAULT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6E89727C5B80E7FE` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `annotation_score`
--

DROP TABLE IF EXISTS `annotation_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotation_score` (
  `data` varchar(255) DEFAULT NULL,
  `score` float DEFAULT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK63582D825B80E7FE` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ideaBasket`
--

DROP TABLE IF EXISTS `ideaBasket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ideaBasket` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `data` text,
  `postTime` datetime DEFAULT NULL,
  `projectId` bigint(20) DEFAULT NULL,
  `runId` bigint(20) DEFAULT NULL,
  `workgroupId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `journal`
--

DROP TABLE IF EXISTS `journal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `journal` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `data` text,
  `userInfo_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKAB64AF37206FE92` (`userInfo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nodeId` varchar(255) DEFAULT NULL,
  `nodeType` varchar(255) DEFAULT NULL,
  `runId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peerreviewgate`
--

DROP TABLE IF EXISTS `peerreviewgate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peerreviewgate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `open` bit(1) DEFAULT NULL,
  `periodId` bigint(20) DEFAULT NULL,
  `runId` bigint(20) DEFAULT NULL,
  `node_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKD0AB7705D11C35FB` (`node_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peerreviewwork`
--

DROP TABLE IF EXISTS `peerreviewwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peerreviewwork` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `periodId` bigint(20) DEFAULT NULL,
  `runId` bigint(20) DEFAULT NULL,
  `annotation_id` bigint(20) DEFAULT NULL,
  `node_id` bigint(20) DEFAULT NULL,
  `reviewerUserInfo_id` bigint(20) DEFAULT NULL,
  `stepWork_id` bigint(20) DEFAULT NULL,
  `userInfo_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKD0B2F14BD11C35FB` (`node_id`),
  KEY `FKD0B2F14B2CBBDF0E` (`annotation_id`),
  KEY `FKD0B2F14BD10BEB6D` (`reviewerUserInfo_id`),
  KEY `FKD0B2F14BE8A0978C` (`stepWork_id`),
  KEY `FKD0B2F14B206FE92` (`userInfo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork`
--

DROP TABLE IF EXISTS `stepwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `data` text,
  `duplicateId` varchar(255) DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `postTime` datetime DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `node_id` bigint(20) DEFAULT NULL,
  `userInfo_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK553587DDD11C35FB` (`node_id`),
  KEY `FK553587DD206FE92` (`userInfo_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_al`
--

DROP TABLE IF EXISTS `stepwork_al`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_al` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE06EFFCD831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_branch`
--

DROP TABLE IF EXISTS `stepwork_branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_branch` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK10577844831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_bs`
--

DROP TABLE IF EXISTS `stepwork_bs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_bs` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE06EFFF3831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_cache`
--

DROP TABLE IF EXISTS `stepwork_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_cache` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cacheTime` datetime DEFAULT NULL,
  `data` mediumtext,
  `getRevisions` bit(1) DEFAULT NULL,
  `userInfo_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK953280A0206FE92` (`userInfo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_challenge`
--

DROP TABLE IF EXISTS `stepwork_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_challenge` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK35828E81831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_fillin`
--

DROP TABLE IF EXISTS `stepwork_fillin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_fillin` (
  `data` varchar(512) DEFAULT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK16B1008A831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_html`
--

DROP TABLE IF EXISTS `stepwork_html`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_html` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK80B19ACD831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_matchsequence`
--

DROP TABLE IF EXISTS `stepwork_matchsequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_matchsequence` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKA1948FA4831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_mc`
--

DROP TABLE IF EXISTS `stepwork_mc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_mc` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE06F0138831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_note`
--

DROP TABLE IF EXISTS `stepwork_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_note` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK80B44314831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_or`
--

DROP TABLE IF EXISTS `stepwork_or`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_or` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE06F0185831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_sensor`
--

DROP TABLE IF EXISTS `stepwork_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_sensor` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2CA8A65C831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_svgdraw`
--

DROP TABLE IF EXISTS `stepwork_svgdraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_svgdraw` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK85051B46831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stepwork_template`
--

DROP TABLE IF EXISTS `stepwork_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stepwork_template` (
  `data` text,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKB18FE9C831A3EA` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userinfo`
--

DROP TABLE IF EXISTS `userinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userinfo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `workgroupId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workgroupId` (`workgroupId`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-08-26  6:41:40
