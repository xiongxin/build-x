-- Adminer 4.7.3 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `authors`;
CREATE TABLE `authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `authors` (`id`, `first_name`, `last_name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	'aa',	'dfs',	NULL,	NULL,	NULL),
(2,	'asfd',	'asfd',	NULL,	NULL,	NULL),
(3,	'asf',	'sdfa',	NULL,	NULL,	NULL);

DROP TABLE IF EXISTS `books`;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `books` (`id`, `author_id`, `title`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	1,	'阿斯蒂芬',	NULL,	NULL,	NULL),
(2,	1,	'围绕所多',	NULL,	NULL,	NULL),
(3,	3,	'撒旦法第三方是的',	NULL,	'2019-12-03 03:03:23',	NULL);

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) DEFAULT NULL,
  `ctitle` varchar(255) DEFAULT NULL,
  `ccontent` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `comments` (`id`, `post_id`, `ctitle`, `ccontent`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	1,	'sdf sadf',	'但是的说法',	NULL,	NULL,	NULL),
(2,	1,	'sdfsadf ',	'撒地方撒地方sa',	NULL,	NULL,	NULL),
(3,	1,	'撒地方撒地方',	'撒地方但是',	NULL,	NULL,	NULL),
(4,	1,	'abd',	'dd',	'2019-12-03 02:46:52',	'2019-12-03 02:46:52',	NULL),
(5,	NULL,	'abd',	'dd',	'2019-12-03 02:47:35',	'2019-12-03 02:47:35',	NULL);

DROP TABLE IF EXISTS `destinations`;
CREATE TABLE `destinations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_flight` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `destinations` (`id`, `last_flight`, `name`, `created_at`, `updated_at`) VALUES
(1,	1,	'2手动阀',	NULL,	NULL),
(2,	2,	'sdaf fdsaf',	NULL,	NULL),
(3,	12,	'sadffdsa',	NULL,	NULL),
(4,	1,	'sdaf sadf ',	NULL,	NULL);

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `flights`;
CREATE TABLE `flights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `destination_id` int(11) DEFAULT NULL,
  `arrived_at` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='航班';

INSERT INTO `flights` (`id`, `destination_id`, `arrived_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	1,	12,	'2019-12-02 20:28:10',	'2019-12-02 13:30:06',	NULL),
(2,	2,	22,	NULL,	NULL,	NULL),
(3,	3,	3,	NULL,	NULL,	NULL),
(4,	4,	10,	NULL,	NULL,	NULL),
(5,	NULL,	111,	'2019-12-02 12:56:45',	'2019-12-02 12:56:45',	NULL),
(6,	NULL,	111,	'2019-12-02 12:56:49',	'2019-12-02 12:56:49',	NULL),
(7,	NULL,	111,	'2019-12-02 12:56:50',	'2019-12-02 12:56:50',	NULL),
(8,	NULL,	111,	'2019-12-02 12:57:16',	'2019-12-02 12:57:16',	NULL),
(9,	NULL,	111,	'2019-12-02 12:57:23',	'2019-12-02 12:57:23',	NULL),
(10,	NULL,	111,	'2019-12-02 12:57:24',	'2019-12-02 12:57:24',	NULL),
(11,	NULL,	111,	'2019-12-02 12:57:25',	'2019-12-02 12:57:25',	NULL),
(12,	NULL,	111,	'2019-12-02 12:57:26',	'2019-12-02 12:57:26',	NULL),
(13,	NULL,	111,	'2019-12-02 12:57:27',	'2019-12-02 12:57:27',	NULL),
(14,	NULL,	111,	'2019-12-02 12:57:28',	'2019-12-02 12:57:28',	NULL),
(15,	NULL,	1,	'2019-12-02 13:11:05',	'2019-12-02 13:11:05',	NULL),
(16,	NULL,	1,	'2019-12-02 13:11:17',	'2019-12-02 13:11:17',	NULL),
(17,	NULL,	1,	'2019-12-02 13:11:19',	'2019-12-02 13:11:19',	NULL),
(18,	NULL,	1,	'2019-12-02 13:11:21',	'2019-12-02 13:11:21',	NULL),
(19,	NULL,	1,	'2019-12-02 13:11:21',	'2019-12-02 13:11:21',	NULL),
(20,	NULL,	1,	'2019-12-02 13:11:23',	'2019-12-02 13:11:23',	NULL),
(21,	NULL,	1,	'2019-12-02 13:11:43',	'2019-12-02 13:11:43',	NULL),
(22,	NULL,	1,	'2019-12-02 13:11:46',	'2019-12-02 13:11:46',	NULL),
(23,	NULL,	1,	'2019-12-02 13:11:48',	'2019-12-02 13:11:48',	NULL),
(24,	NULL,	1,	'2019-12-02 13:11:53',	'2019-12-02 13:11:53',	NULL),
(25,	111,	1,	'2019-12-02 13:12:04',	'2019-12-02 13:12:04',	NULL),
(26,	111,	1,	'2019-12-02 13:12:06',	'2019-12-02 13:12:06',	NULL),
(27,	111,	1,	'2019-12-02 13:12:07',	'2019-12-02 13:12:07',	NULL),
(28,	111,	1,	'2019-12-02 13:12:57',	'2019-12-02 13:12:57',	NULL),
(29,	111,	1,	'2019-12-02 13:12:59',	'2019-12-02 13:12:59',	NULL),
(30,	111,	1,	'2019-12-02 13:16:41',	'2019-12-02 13:16:41',	NULL),
(31,	1000,	100,	'2019-12-02 13:19:22',	'2019-12-02 13:19:22',	NULL);

DROP TABLE IF EXISTS `histories`;
CREATE TABLE `histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `content` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `histories` (`id`, `user_id`, `content`, `created_at`, `updated_at`) VALUES
(1,	1,	'历史正文1',	NULL,	NULL),
(2,	1,	'历史正文2',	NULL,	NULL),
(3,	2,	'历史正文2',	NULL,	NULL);

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1,	'2014_10_12_000000_create_users_table',	1),
(2,	'2014_10_12_100000_create_password_resets_table',	1),
(3,	'2019_08_19_000000_create_failed_jobs_table',	1);

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `phones`;
CREATE TABLE `phones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `phones` (`id`, `phone_number`, `created_at`, `updated_at`, `deleted_at`, `user_id`) VALUES
(1,	'123',	NULL,	NULL,	NULL,	1);

DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ptitle` varchar(255) DEFAULT NULL,
  `pcontent` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `posts` (`id`, `ptitle`, `pcontent`, `created_at`, `updated_at`, `deleted_at`, `user_id`) VALUES
(1,	'十大撒地方',	'的说法士大夫撒地方',	NULL,	NULL,	NULL,	1),
(2,	'和国家科委人',	'都发高热',	NULL,	NULL,	NULL,	1);

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rname` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `roles` (`id`, `rname`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	'管理员',	NULL,	NULL,	NULL),
(2,	'编辑',	NULL,	NULL,	NULL),
(3,	'开发',	NULL,	NULL,	NULL),
(4,	'运营',	NULL,	NULL,	NULL);

DROP TABLE IF EXISTS `role_user`;
CREATE TABLE `role_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `roles_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `role_user` (`id`, `user_id`, `roles_id`) VALUES
(10,	1,	4),
(29,	1,	1),
(30,	1,	2),
(31,	1,	3);

DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `suppliers` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1,	'供应商A',	NULL,	NULL),
(2,	'供应商B',	NULL,	NULL);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `supplier_id`) VALUES
(1,	'sadf',	'sdf@qq.com',	NULL,	'sdf',	NULL,	NULL,	NULL,	1),
(2,	'asdf',	'dsf',	NULL,	'sdfa',	NULL,	NULL,	NULL,	2),
(3,	'df',	'dsfasdf@qq.com',	NULL,	'$2y$10$B1VetnWdcX3i/lOf43BUwOw4clINmwWJOdFPPHg9tmyy6SBHTIm6e',	NULL,	'2019-12-02 23:47:31',	'2019-12-02 23:47:31',	NULL);

-- 2019-12-03 10:12:59
