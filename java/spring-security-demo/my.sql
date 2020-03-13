-- Adminer 4.7.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `role` (`id`, `name`) VALUES
(1,	'normal'),
(2,	'editor');

DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `url` varchar(512) DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `sys_permission` (`id`, `name`, `description`, `url`, `pid`) VALUES
(1,	'ROLE_HOME',	'home',	'/',	NULL),
(2,	'ROLE_ADMIN',	'ABel',	'/admin',	NULL);

DROP TABLE IF EXISTS `sys_permission_role`;
CREATE TABLE `sys_permission_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `permission_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `sys_permission_role` (`id`, `role_id`, `permission_id`) VALUES
(1,	1,	1),
(2,	1,	2),
(3,	2,	1);

DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `sys_role` (`id`, `name`) VALUES
(1,	'ROLE_ADMIN'),
(2,	'ROLE_USER');

DROP TABLE IF EXISTS `sys_role_user`;
CREATE TABLE `sys_role_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sys_user_id` int(11) DEFAULT NULL,
  `sys_role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `sys_role_user` (`id`, `sys_user_id`, `sys_role_id`) VALUES
(1,	1,	1),
(2,	2,	2);

DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `sys_user` (`id`, `username`, `password`) VALUES
(1,	'admin',	'admin'),
(2,	'abel',	'abel');

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `user` (`id`, `username`, `password`) VALUES
(1,	'a',	'b'),
(2,	'registration',	'$2a$10$oZrjmmTTILXjKhEsV8utG.FgkArCfnc.7THyvc9FrUPRNDdSCDr.2'),
(3,	'Baeldung',	'$2a$10$Hf1i6UVxgcT5puyFVvGou.M8meNBXYchyscjJdUz3VuY2elkz0q9G'),
(4,	'validateCodeFilter',	'$2a$10$4OX1rwpZiwGdA/srVsOykOsiG2UUoy9Uh5D0gMMMQ.BpAHPcLB6Vi'),
(5,	'smsCodeFilter',	'$2a$10$fgbSCC5MbZYHGLiHQs9R3eP5TXajOktza8JA6FHnKTSCZfw3M0eaa');

DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `user_roles` (`id`, `user_id`, `role_id`) VALUES
(1,	1,	1),
(2,	1,	2);

-- 2020-03-13 10:03:30