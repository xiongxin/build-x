-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- 服务器版本:                        10.4.10-MariaDB - mariadb.org binary distribution
-- 服务器OS:                        Win64
-- HeidiSQL 版本:                  10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for laravel
CREATE DATABASE IF NOT EXISTS `laravel` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `laravel`;

-- Dumping structure for table laravel.comments
CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) DEFAULT NULL,
  `ctitle` varchar(255) DEFAULT NULL,
  `ccontent` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.comments: ~3 rows (大约)
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` (`id`, `post_id`, `ctitle`, `ccontent`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(1, 1, 'sdf sadf', '但是的说法', NULL, NULL, NULL),
	(2, 1, 'sdfsadf ', '撒地方撒地方sa', NULL, NULL, NULL),
	(3, 1, '撒地方撒地方', '撒地方但是', NULL, NULL, NULL);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;

-- Dumping structure for table laravel.destinations
CREATE TABLE IF NOT EXISTS `destinations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_flight` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.destinations: ~4 rows (大约)
/*!40000 ALTER TABLE `destinations` DISABLE KEYS */;
INSERT INTO `destinations` (`id`, `last_flight`, `name`, `created_at`, `updated_at`) VALUES
	(1, 1, '2手动阀', NULL, NULL),
	(2, 2, 'sdaf fdsaf', NULL, NULL),
	(3, 12, 'sadffdsa', NULL, NULL),
	(4, 1, 'sdaf sadf ', NULL, NULL);
/*!40000 ALTER TABLE `destinations` ENABLE KEYS */;

-- Dumping structure for table laravel.failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel.failed_jobs: ~0 rows (大约)
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;

-- Dumping structure for table laravel.flights
CREATE TABLE IF NOT EXISTS `flights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `destination_id` int(11) DEFAULT NULL,
  `arrived_at` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='航班';

-- Dumping data for table laravel.flights: ~29 rows (大约)
/*!40000 ALTER TABLE `flights` DISABLE KEYS */;
INSERT INTO `flights` (`id`, `destination_id`, `arrived_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(1, 1, 12, '2019-12-02 20:28:10', '2019-12-02 13:30:06', NULL),
	(2, 2, 22, NULL, NULL, NULL),
	(3, 3, 3, NULL, NULL, NULL),
	(4, 4, 10, NULL, NULL, NULL),
	(5, NULL, 111, '2019-12-02 12:56:45', '2019-12-02 12:56:45', NULL),
	(6, NULL, 111, '2019-12-02 12:56:49', '2019-12-02 12:56:49', NULL),
	(7, NULL, 111, '2019-12-02 12:56:50', '2019-12-02 12:56:50', NULL),
	(8, NULL, 111, '2019-12-02 12:57:16', '2019-12-02 12:57:16', NULL),
	(9, NULL, 111, '2019-12-02 12:57:23', '2019-12-02 12:57:23', NULL),
	(10, NULL, 111, '2019-12-02 12:57:24', '2019-12-02 12:57:24', NULL),
	(11, NULL, 111, '2019-12-02 12:57:25', '2019-12-02 12:57:25', NULL),
	(12, NULL, 111, '2019-12-02 12:57:26', '2019-12-02 12:57:26', NULL),
	(13, NULL, 111, '2019-12-02 12:57:27', '2019-12-02 12:57:27', NULL),
	(14, NULL, 111, '2019-12-02 12:57:28', '2019-12-02 12:57:28', NULL),
	(15, NULL, 1, '2019-12-02 13:11:05', '2019-12-02 13:11:05', NULL),
	(16, NULL, 1, '2019-12-02 13:11:17', '2019-12-02 13:11:17', NULL),
	(17, NULL, 1, '2019-12-02 13:11:19', '2019-12-02 13:11:19', NULL),
	(18, NULL, 1, '2019-12-02 13:11:21', '2019-12-02 13:11:21', NULL),
	(19, NULL, 1, '2019-12-02 13:11:21', '2019-12-02 13:11:21', NULL),
	(20, NULL, 1, '2019-12-02 13:11:23', '2019-12-02 13:11:23', NULL),
	(21, NULL, 1, '2019-12-02 13:11:43', '2019-12-02 13:11:43', NULL),
	(22, NULL, 1, '2019-12-02 13:11:46', '2019-12-02 13:11:46', NULL),
	(23, NULL, 1, '2019-12-02 13:11:48', '2019-12-02 13:11:48', NULL),
	(24, NULL, 1, '2019-12-02 13:11:53', '2019-12-02 13:11:53', NULL),
	(25, 111, 1, '2019-12-02 13:12:04', '2019-12-02 13:12:04', NULL),
	(26, 111, 1, '2019-12-02 13:12:06', '2019-12-02 13:12:06', NULL),
	(27, 111, 1, '2019-12-02 13:12:07', '2019-12-02 13:12:07', NULL),
	(28, 111, 1, '2019-12-02 13:12:57', '2019-12-02 13:12:57', NULL),
	(29, 111, 1, '2019-12-02 13:12:59', '2019-12-02 13:12:59', NULL),
	(30, 111, 1, '2019-12-02 13:16:41', '2019-12-02 13:16:41', NULL),
	(31, 1000, 100, '2019-12-02 13:19:22', '2019-12-02 13:19:22', NULL);
/*!40000 ALTER TABLE `flights` ENABLE KEYS */;

-- Dumping structure for table laravel.histories
CREATE TABLE IF NOT EXISTS `histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `content` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.histories: ~3 rows (大约)
/*!40000 ALTER TABLE `histories` DISABLE KEYS */;
INSERT INTO `histories` (`id`, `user_id`, `content`, `created_at`, `updated_at`) VALUES
	(1, 1, '历史正文1', NULL, NULL),
	(2, 1, '历史正文2', NULL, NULL),
	(3, 2, '历史正文2', NULL, NULL);
/*!40000 ALTER TABLE `histories` ENABLE KEYS */;

-- Dumping structure for table laravel.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel.migrations: ~3 rows (大约)
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '2014_10_12_000000_create_users_table', 1),
	(2, '2014_10_12_100000_create_password_resets_table', 1),
	(3, '2019_08_19_000000_create_failed_jobs_table', 1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

-- Dumping structure for table laravel.password_resets
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel.password_resets: ~0 rows (大约)
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;

-- Dumping structure for table laravel.phones
CREATE TABLE IF NOT EXISTS `phones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.phones: ~1 rows (大约)
/*!40000 ALTER TABLE `phones` DISABLE KEYS */;
INSERT INTO `phones` (`id`, `phone_number`, `created_at`, `updated_at`, `deleted_at`, `user_id`) VALUES
	(1, '123', NULL, NULL, NULL, 1);
/*!40000 ALTER TABLE `phones` ENABLE KEYS */;

-- Dumping structure for table laravel.posts
CREATE TABLE IF NOT EXISTS `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ptitle` varchar(255) DEFAULT NULL,
  `pcontent` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.posts: ~2 rows (大约)
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` (`id`, `ptitle`, `pcontent`, `created_at`, `updated_at`, `deleted_at`, `user_id`) VALUES
	(1, '十大撒地方', '的说法士大夫撒地方', NULL, NULL, NULL, 1),
	(2, '和国家科委人', '都发高热', NULL, NULL, NULL, 1);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;

-- Dumping structure for table laravel.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rname` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.roles: ~4 rows (大约)
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`id`, `rname`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(1, '管理员', NULL, NULL, NULL),
	(2, '编辑', NULL, NULL, NULL),
	(3, '开发', NULL, NULL, NULL),
	(4, '运营', NULL, NULL, NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- Dumping structure for table laravel.role_user
CREATE TABLE IF NOT EXISTS `role_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `roles_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.role_user: ~4 rows (大约)
/*!40000 ALTER TABLE `role_user` DISABLE KEYS */;
INSERT INTO `role_user` (`id`, `user_id`, `roles_id`) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 2, 1),
	(4, 2, 3);
/*!40000 ALTER TABLE `role_user` ENABLE KEYS */;

-- Dumping structure for table laravel.suppliers
CREATE TABLE IF NOT EXISTS `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table laravel.suppliers: ~2 rows (大约)
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` (`id`, `name`, `created_at`, `updated_at`) VALUES
	(1, '供应商A', NULL, NULL),
	(2, '供应商B', NULL, NULL);
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;

-- Dumping structure for table laravel.users
CREATE TABLE IF NOT EXISTS `users` (
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel.users: ~2 rows (大约)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `supplier_id`) VALUES
	(1, 'sadf', 'sdf@qq.com', NULL, 'sdf', NULL, NULL, NULL, 1),
	(2, 'asdf', 'dsf', NULL, 'sdfa', NULL, NULL, NULL, 2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
