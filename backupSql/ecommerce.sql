-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 29, 2024 at 04:07 PM
-- Server version: 10.4.10-MariaDB
-- PHP Version: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
CREATE TABLE IF NOT EXISTS `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lineOne` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lineTwo` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pincode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `addresses_userId_fkey` (`userId`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `lineOne`, `lineTwo`, `city`, `country`, `pincode`, `userId`, `createdAt`, `updatedAt`) VALUES
(3, 'Olowoeko', '', 'iseyin', 'Nigeria', '123456', 1, '2024-06-04 23:35:42.335', '2024-06-05 11:32:33.496'),
(2, 'Olowoeko', '', 'iseyin', 'Nigeria', '123456', 1, '2024-06-04 23:24:12.835', '2024-06-05 11:32:33.496');

-- --------------------------------------------------------

--
-- Table structure for table `cartitems`
--

DROP TABLE IF EXISTS `cartitems`;
CREATE TABLE IF NOT EXISTS `cartitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cartItems_userId_fkey` (`userId`),
  KEY `cartItems_productId_fkey` (`productId`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `netAmount` decimal(65,30) NOT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `status` enum('PENDING','ACCEPTED','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  KEY `orders_userId_fkey` (`userId`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `userId`, `netAmount`, `address`, `createdAt`, `updatedAt`, `status`) VALUES
(3, 1, '138.000000000000000000000000000000', 'Olowoeko, ,iseyin, Nigeria - 123456', '2024-06-06 15:38:21.177', '2024-06-07 13:21:25.603', 'PENDING'),
(4, 1, '46.000000000000000000000000000000', 'Olowoeko, ,iseyin, Nigeria - 123456', '2024-06-06 16:03:58.223', '2024-06-06 16:03:58.223', 'PENDING');

-- --------------------------------------------------------

--
-- Table structure for table `order_events`
--

DROP TABLE IF EXISTS `order_events`;
CREATE TABLE IF NOT EXISTS `order_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `status` enum('PENDING','ACCEPTED','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  KEY `order_events_orderId_fkey` (`orderId`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_events`
--

INSERT INTO `order_events` (`id`, `orderId`, `createdAt`, `updatedAt`, `status`) VALUES
(1, 2, '2024-06-06 14:21:58.426', '2024-06-06 14:21:58.426', 'PENDING'),
(2, 3, '2024-06-06 15:38:21.177', '2024-06-06 15:38:21.177', 'PENDING'),
(3, 4, '2024-06-06 16:03:58.223', '2024-06-06 16:03:58.223', 'PENDING'),
(4, 1, '2024-06-07 08:35:27.936', '2024-06-07 08:35:27.936', 'CANCELLED'),
(5, 1, '2024-06-07 08:57:37.227', '2024-06-07 08:57:37.227', 'CANCELLED'),
(6, 3, '2024-06-07 13:00:48.373', '2024-06-07 13:00:48.373', 'OUT_FOR_DELIVERY'),
(7, 3, '2024-06-07 13:12:06.794', '2024-06-07 13:12:06.794', 'DELIVERED'),
(8, 3, '2024-06-07 13:21:25.603', '2024-06-07 13:21:25.603', 'PENDING');

-- --------------------------------------------------------

--
-- Table structure for table `order_products`
--

DROP TABLE IF EXISTS `order_products`;
CREATE TABLE IF NOT EXISTS `order_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `productId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_products_orderId_fkey` (`orderId`),
  KEY `order_products_productId_fkey` (`productId`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_products`
--

INSERT INTO `order_products` (`id`, `orderId`, `quantity`, `createdAt`, `updatedAt`, `productId`) VALUES
(1, 3, 6, '2024-06-06 15:38:21.177', '2024-06-06 15:38:21.177', 3),
(2, 4, 2, '2024-06-06 16:03:58.223', '2024-06-06 16:03:58.223', 3);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(65,30) NOT NULL,
  `tags` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `tags`, `createdAt`, `updatedAt`) VALUES
(1, 'beans', 'White beans updated', '23.000000000000000000000000000000', 'rich,neat', '2024-06-04 14:23:44.659', '2024-06-04 15:24:02.605'),
(3, 'beans', 'White rice', '23.000000000000000000000000000000', 'rich,egg', '2024-06-05 16:11:54.710', '2024-06-07 13:59:12.963'),
(4, 'wheat', 'wheat', '23.000000000000000000000000000000', 'grains', '2024-06-07 11:36:22.376', '2024-06-07 14:00:20.859'),
(5, 'corn', 'red corn', '23.000000000000000000000000000000', 'rich,neat', '2024-06-07 11:36:27.752', '2024-06-07 14:00:20.859'),
(6, 'corn', 'yellow corn', '23.000000000000000000000000000000', 'bag', '2024-06-07 11:36:37.700', '2024-06-07 14:00:20.859'),
(7, 'yam', 'white yam', '23.000000000000000000000000000000', 'tuber', '2024-06-07 11:36:39.750', '2024-06-07 14:00:20.859'),
(8, 'yam', 'water yam', '23.000000000000000000000000000000', 'rich,neat', '2024-06-07 11:36:40.880', '2024-06-07 14:00:20.859');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `role` enum('ADMIN','USER') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
  `defaultBillingAddressId` int(11) DEFAULT NULL,
  `defaultShippingAddressId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_key` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `createdAt`, `updatedAt`, `role`, `defaultBillingAddressId`, `defaultShippingAddressId`) VALUES
(1, 'Test', 'test@gmail.com', '$2b$10$5CX1CDdn1OG/FQ9WMAbWP.WnN0w0Pv0tTI5zAYrLnRJgZfkmcxeDq', '2024-05-31 09:55:16.753', '2024-06-07 10:31:40.512', 'ADMIN', NULL, 3),
(2, 'User', 'user@gmail.com', '$2b$10$gcd8F2OVvaA1eWEh4hilaOt4EUMk3epCFDqdUxVNQCdkBqxbVsaQ6', '2024-06-04 15:43:02.158', '2024-06-07 10:34:15.266', 'USER', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
CREATE TABLE IF NOT EXISTS `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('9ef349af-8551-4cbd-909c-d33681ba2a10', 'ef579d1d874155cdaedce86b6a12171d5fcf463477837cb37a4b39ac04576d71', '2024-05-30 12:42:17.123', '20240530124216_create_users_table', NULL, NULL, '2024-05-30 12:42:17.047', 1),
('ede20f04-8b2c-4c7b-a0c7-788e3bc70d7a', '39b4a0907fc52e31c6f9c1dff25034f3b364deb9bf67fcb88a92ba148ad6da28', '2024-06-01 18:39:27.092', '20240601183926_add_role_to_user', NULL, NULL, '2024-06-01 18:39:26.292', 1),
('5deb505b-e29c-4933-ad7b-747960a646ec', 'a1a598608e3b06a11f8790f1abb2def9e1f251366be51bceea20c7b7c7d795b9', '2024-06-04 14:20:09.592', '20240604142009_create_product_table', NULL, NULL, '2024-06-04 14:20:09.392', 1),
('c4fcbdaa-8aad-4904-b4d6-092d4a56f097', '3f8461454c3abd19dd9a2bfebf11a998558ab6af1fc3ff848bf93ef5d04c6da0', '2024-06-04 16:17:37.732', '20240604161737_create_address_table', NULL, NULL, '2024-06-04 16:17:37.285', 1),
('5e1b1238-1370-4f36-95c0-66998b639533', 'a1ceedda3a2e7ff3b3acdba73391efc11b92c83a969f2a3c41b2f94017a818aa', '2024-06-05 09:43:10.013', '20240605094309_add_default_addresses', NULL, NULL, '2024-06-05 09:43:09.655', 1),
('554b925a-2071-47ac-b95f-35a95ac648ed', '9eb4868aab5e483c834204693aaf50e34585133856be832acdbb5af343b559f0', '2024-06-05 10:13:30.152', '20240605101329_fix_address_in_user_table', NULL, NULL, '2024-06-05 10:13:29.828', 1),
('fb19af9f-9de2-4bc9-a89f-bdbfe20b38c0', 'c8e8503f12977729625590c62c84938570d430e1274c7cbd09147ba6b6c414d0', '2024-06-05 12:19:20.471', '20240605121919_create_cart_table', NULL, NULL, '2024-06-05 12:19:19.880', 1),
('bcb386e0-2a63-48a5-bad5-d2796edccd4b', '07c72f87c464d51ee051c0cc5850ea9d769b50189d15a60ae4f62c7e96cfb22f', '2024-06-05 13:47:40.933', '20240605134739_added_quantity_field_to_cart_item_table', NULL, NULL, '2024-06-05 13:47:39.552', 1),
('2cbbcc24-f82a-4ff3-ae32-0150132c1755', '6592012cc662d51e656209ea0deb8f6893319973dc69fcd063976aa03370f905', '2024-06-06 10:47:31.697', '20240606104729_create_order_table', NULL, NULL, '2024-06-06 10:47:29.108', 1),
('9c29ee45-7cb9-4968-883e-7a9f705038f0', '57c043773092f723f0e50557cf15854ad1fe376f19e8e3fa3528e1d6ead909b1', '2024-06-06 14:14:23.391', '20240606141421_updated_order_table', NULL, NULL, '2024-06-06 14:14:21.611', 1),
('537e29bd-58d5-4fc1-a02a-0dcd7b2a2e90', '9b1df3810f5a4e6460145d7ca150f93810a35561e5c26c0ccb886562573966da', '2024-06-06 14:19:44.193', '20240606141941_added_status_to_order_event', NULL, NULL, '2024-06-06 14:19:41.644', 1),
('2b1a27f0-f7e3-4501-aace-1e64e9f55545', 'f715ebfd1014eb8647ee7273975d0dc5802e68a369e543abdbf3c6251956a758', '2024-06-06 15:54:22.079', '20240606155416_added_status_to_order', NULL, NULL, '2024-06-06 15:54:16.994', 1),
('1ab03e0a-9dc7-47af-b82a-dbae5c725c8e', 'c48b4eadb5f07f03650b68f164609fe33dfbf64aabfca62611bcdd5637c53a86', '2024-06-06 17:03:39.804', '20240606170335_added_status_to_order', NULL, NULL, '2024-06-06 17:03:36.017', 1),
('b14c1e5c-beec-4f53-a236-5a4f6b786761', 'dde1694b92a87006d67dd4397bfb4ad790c3eb91192b98b4adc447bd0597d885', '2024-06-07 13:34:55.251', '20240607133452_added_full_text_search', NULL, NULL, '2024-06-07 13:34:52.503', 1),
('731a97df-45c4-4150-8555-aceaf05f234c', 'b1dab71396bc6d8e24902a6ed0a61b81a6dc0af1448079fe3f5a0c12696c32c2', '2024-06-07 13:51:29.015', '20240607135126_added_full_text_search', NULL, NULL, '2024-06-07 13:51:26.088', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `products`
--
ALTER TABLE `products` ADD FULLTEXT KEY `products_name_description_tags_idx` (`name`,`description`,`tags`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
