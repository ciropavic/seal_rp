-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 01, 2021 at 02:59 PM
-- Server version: 10.3.31-MariaDB-cll-lve
-- PHP Version: 7.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `serverhr_fivem`
--

-- --------------------------------------------------------

--
-- Table structure for table `addon_account`
--

CREATE TABLE `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addon_account`
--

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('bank_savings', 'Livret Bleu', 0),
('caution', 'Caution', 0),
('society_ambulance', 'Ambulance', 1),
('society_automafija', 'Automafija', 1),
('society_ballas', 'Ballas', 1),
('society_banker', 'Banque', 1),
('society_cardealer', 'Concessionnaire', 1),
('society_hitman', 'Hitman', 1),
('society_mechanic', 'Mechanic', 1),
('society_police', 'Police', 1),
('society_reporter', 'Reporter', 1),
('society_sipa', 'SIPA', 1),
('society_taxi', 'Taxi', 1),
('society_test', 'Test', 1),
('society_test2', 'Test 2', 1);

-- --------------------------------------------------------

--
-- Table structure for table `addon_account_data`
--

CREATE TABLE `addon_account_data` (
  `id` int(11) NOT NULL,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addon_account_data`
--

INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
(1, 'society_ambulance', 18513000, NULL),
(2, 'society_banker', 0, NULL),
(3, 'society_cardealer', 0, NULL),
(4, 'society_hitman', 258500, NULL),
(5, 'society_mechanic', 992985603, NULL),
(6, 'society_police', 503310361, NULL),
(7, 'society_reporter', 1166520, NULL),
(8, 'society_taxi', 641326, NULL),
(276, 'society_ballas', 582, NULL),
(279, 'society_ballas', 582, NULL),
(1189, 'society_sipa', 5964103, NULL),
(2469, 'society_automafija', 0, NULL),
(2471, 'bank_savings', 0, 'steam:11000010a1d1042'),
(2472, 'caution', 0, 'steam:11000010a1d1042'),
(2473, 'bank_savings', 0, 'steam:11000010441bee9'),
(2474, 'caution', 0, 'steam:11000010441bee9'),
(2475, 'bank_savings', 0, 'steam:110000115e9ac6b'),
(2476, 'caution', 0, 'steam:110000115e9ac6b'),
(2477, 'society_test', 0, NULL),
(2478, 'society_test2', 0, NULL),
(2479, 'bank_savings', 0, 'steam:11000010e086b7e'),
(2480, 'caution', 0, 'steam:11000010e086b7e'),
(2481, 'bank_savings', 0, 'steam:11000010ad5cf80'),
(2482, 'caution', 0, 'steam:11000010ad5cf80'),
(2483, 'bank_savings', 0, 'steam:110000106921eea'),
(2484, 'caution', 0, 'steam:110000106921eea'),
(2485, 'bank_savings', 0, 'steam:110000111cd0aa0'),
(2486, 'caution', 0, 'steam:110000111cd0aa0'),
(2488, 'bank_savings', 0, 'steam:11000014694839f'),
(2489, 'caution', 0, 'steam:11000014694839f');

-- --------------------------------------------------------

--
-- Table structure for table `addon_inventory`
--

CREATE TABLE `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addon_inventory`
--

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('housing', 'Housing', 0),
('society_ambulance', 'Ambulance', 1),
('society_automafija', 'Automafija', 1),
('society_ballas', 'Ballas', 1),
('society_cardealer', 'Concesionnaire', 1),
('society_fbi', 'FBI', 1),
('society_hitman', 'Hitman', 1),
('society_mechanic', 'Mécano', 1),
('society_police', 'Police', 1),
('society_reporter', 'Reporter', 1),
('society_sipa', 'SIPA', 1),
('society_taxi', 'Taxi', 1),
('society_test', 'Test', 1),
('society_test2', 'Test 2', 1);

-- --------------------------------------------------------

--
-- Table structure for table `addon_inventory_items`
--

CREATE TABLE `addon_inventory_items` (
  `id` int(11) NOT NULL,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addon_inventory_items`
--

INSERT INTO `addon_inventory_items` (`id`, `inventory_name`, `name`, `count`, `owner`) VALUES
(1, 'society_ballas', 'cannabis', 1345, NULL),
(2, 'housing', 'beer', 0, 'steam:11000010441bee9');

-- --------------------------------------------------------

--
-- Table structure for table `baninfo`
--

CREATE TABLE `baninfo` (
  `identifier` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `playername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `baninfo`
--

INSERT INTO `baninfo` (`identifier`, `license`, `liveid`, `xblid`, `discord`, `playerip`, `playername`) VALUES
('steam:11000010441bee9', 'license:23735c7344bc9f32a2137cba6cbd67751184a27f', 'live:844427293949585', 'xbl:2535427538323355', 'discord:319628026251837442', 'ip:93.141.189.230', '#Sikora'),
('steam:110000106921eea', 'license:1a17700fb3ebe57d0e8179efdd6e6e1ccb43168b', 'live:1688852646456500', 'xbl:2533274866168124', 'discord:275436547317301248', 'ip:93.143.214.100', 'Ficho'),
('steam:11000010a1d1042', 'no info', 'no info', 'no info', 'no info', 'ip:77.78.215.88', 'refik'),
('steam:11000010ad5cf80', 'license:104849bd70250f8f538fb51379f5a4a258f6e960', 'live:1829582274463247', 'xbl:2535463957312212', 'no info', 'ip:92.195.150.104', 'MaZz'),
('steam:11000010e086b7e', 'license:ebdfe690c597862ea966a6893ad2fe9aaddcc873', 'live:985153873677826', 'xbl:2535440026774096', 'discord:267022675866550275', 'ip:109.227.20.189', 'LJANTU'),
('steam:110000111cd0aa0', 'license:e4090a08909875dbb99f15633c3ec4ef87d9e9f8', 'live:914801695294364', 'xbl:2535456657275324', 'no info', 'ip:80.187.98.182', 'GABO'),
('steam:110000115e9ac6b', 'no info', 'no info', 'no info', 'no info', 'ip:141.170.197.97', 'SpeLLe'),
('steam:11000014694839f', 'license:90b661c3b1f4c5647edd360963abfb730037ed79', 'no info', 'no info', 'no info', 'ip:185.193.240.203', 'zarezarkovski csgocases.com');

-- --------------------------------------------------------

--
-- Table structure for table `banlist`
--

CREATE TABLE `banlist` (
  `identifier` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetplayername` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `sourceplayername` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `timeat` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `added` datetime DEFAULT current_timestamp(),
  `expiration` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `permanent` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `banlisthistory`
--

CREATE TABLE `banlisthistory` (
  `id` int(11) NOT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetplayername` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `sourceplayername` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `timeat` int(11) NOT NULL,
  `added` datetime DEFAULT current_timestamp(),
  `expiration` int(11) NOT NULL,
  `permanent` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `banlisthistory`
--

INSERT INTO `banlisthistory` (`id`, `identifier`, `license`, `liveid`, `xblid`, `discord`, `playerip`, `targetplayername`, `sourceplayername`, `reason`, `timeat`, `added`, `expiration`, `permanent`) VALUES
(1, 'steam:11000010ad5cf80', 'license:104849bd70250f8f538fb51379f5a4a258f6e960', 'live:1829582274463247', 'xbl:2535463957312212', '', 'ip:92.195.233.240', 'MaZz', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635024253, '2021-10-23 23:24:13', 1635024253, 1),
(2, 'steam:11000010ad5cf80', 'license:104849bd70250f8f538fb51379f5a4a258f6e960', 'live:1829582274463247', 'xbl:2535463957312212', '', 'ip:92.195.233.240', 'MaZz', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635036020, '2021-10-24 02:40:20', 1635036020, 1),
(3, 'steam:11000014694839f', 'license:90b661c3b1f4c5647edd360963abfb730037ed79', 'no info', 'no info', 'no info', 'ip:185.193.240.203', 'zarezarkovski csgocases.com', '#Sikora', 'ode (#Sikora)', 1635080138, '2021-10-24 14:55:38', 1635080138, 1),
(4, 'steam:110000111cd0aa0', 'license:e4090a08909875dbb99f15633c3ec4ef87d9e9f8', 'live:914801695294364', 'xbl:2535456657275324', '', 'ip:80.187.97.35', 'GABO', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635083175, '2021-10-24 15:46:15', 1635083175, 1),
(5, 'steam:11000010e086b7e', 'license:ebdfe690c597862ea966a6893ad2fe9aaddcc873', 'live:985153873677826', 'xbl:2535440026774096', 'discord:267022675866550275', 'ip:109.227.20.189', 'LJANTU', 'Ficho', 'dm (Ficho)', 1635083389, '2021-10-24 15:49:49', 1635169789, 0),
(6, 'steam:110000106921eea', 'license:1a17700fb3ebe57d0e8179efdd6e6e1ccb43168b', 'live:1688852646456500', 'xbl:2533274866168124', 'discord:275436547317301248', 'ip:91.49.39.37', 'Ficho', '#Sikora', '0 (#Sikora)', 1635083613, '2021-10-24 15:53:33', 1635083613, 1),
(7, 'steam:110000106921eea', 'license:1a17700fb3ebe57d0e8179efdd6e6e1ccb43168b', 'live:1688852646456500', 'xbl:2533274866168124', 'discord:275436547317301248', 'ip:91.49.39.37', 'Ficho', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635084076, '2021-10-24 16:01:16', 1635084076, 1),
(8, 'steam:11000010441bee9', 'license:23735c7344bc9f32a2137cba6cbd67751184a27f', 'live:844427293949585', 'xbl:2535427538323355', 'discord:319628026251837442', 'ip:89.172.237.211', '#Sikora', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635279492, '2021-10-26 22:18:12', 1635279492, 1),
(9, 'steam:11000010441bee9', 'license:23735c7344bc9f32a2137cba6cbd67751184a27f', 'live:844427293949585', 'xbl:2535427538323355', 'discord:319628026251837442', 'ip:93.143.253.4', '#Sikora', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635359946, '2021-10-27 20:39:06', 1635359946, 1),
(10, 'steam:11000010e086b7e', 'license:ebdfe690c597862ea966a6893ad2fe9aaddcc873', 'live:985153873677826', 'xbl:2535440026774096', 'discord:267022675866550275', 'ip:109.227.20.189', 'LJANTU', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635727042, '2021-11-01 01:37:22', 1635727042, 1),
(11, 'steam:11000010441bee9', 'license:23735c7344bc9f32a2137cba6cbd67751184a27f', 'live:844427293949585', 'xbl:2535427538323355', 'discord:319628026251837442', 'ip:89.172.244.191', '#Sikora', 'autobanned', 'Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: https://discord.gg/rAWxYmp', 1635727281, '2021-11-01 01:41:21', 1635727281, 1);

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `billing`
--

INSERT INTO `billing` (`id`, `identifier`, `sender`, `target_type`, `target`, `label`, `amount`) VALUES
(97, 'steam:11000010ad5cf80', 'Kazna', 'society', 'society_police', 'Policija: Kazna za prebrzu voznju', 2400);

-- --------------------------------------------------------

--
-- Table structure for table `biznisi`
--

CREATE TABLE `biznisi` (
  `ID` int(11) NOT NULL,
  `Ime` text NOT NULL,
  `Label` text NOT NULL,
  `Koord` longtext NOT NULL DEFAULT '{}',
  `Sef` int(20) NOT NULL DEFAULT 0,
  `Vlasnik` varchar(60) DEFAULT NULL,
  `Posao` varchar(100) DEFAULT NULL,
  `Sati` longtext NOT NULL DEFAULT '{}',
  `Tjedan` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `biznisi`
--

INSERT INTO `biznisi` (`ID`, `Ime`, `Label`, `Koord`, `Sef`, `Vlasnik`, `Posao`, `Sati`, `Tjedan`) VALUES
(4, 'drvosjeca', 'Drvosjeca', '[1189.6624755859376,-1278.3201904296876,34.89719009399414]', 3300, NULL, 'drvosjeca', '[{\"Identifier\":\"steam:11000010e086b7e\",\"Ture\":23,\"Posao\":\"drvosjeca\",\"Ime\":\"LJANTU\"},{\"Identifier\":\"steam:11000010441bee9\",\"Ture\":2,\"Posao\":\"drvosjeca\",\"Ime\":\"#Sikora\"}]', 3300),
(3, 'kosac', 'Kosac trave', '[-1366.4168701171876,56.53075408935547,53.09845733642578]', 691, NULL, 'kosac', '[{\"Posao\":\"kosac\",\"Identifier\":\"steam:11000010ad5cf80\",\"Ture\":86,\"Ime\":\"MaZz\"},{\"Posao\":\"kosac\",\"Identifier\":\"steam:11000010e086b7e\",\"Ture\":76,\"Ime\":\"LJANTU\"},{\"Posao\":\"kosac\",\"Identifier\":\"steam:110000106921eea\",\"Ture\":25,\"Ime\":\"Ficho\"}]', 691),
(5, 'farmer', 'Farmer', '[2415.745849609375,4993.283203125,45.2213249206543]', 917, NULL, 'farmer', '[{\"Posao\":\"farmer\",\"Identifier\":\"steam:11000010ad5cf80\",\"Ture\":20,\"Ime\":\"MaZz\"},{\"Posao\":\"farmer\",\"Identifier\":\"steam:110000106921eea\",\"Ture\":40,\"Ime\":\"Ficho\"},{\"Posao\":\"farmer\",\"Identifier\":\"steam:11000010e086b7e\",\"Ture\":61,\"Ime\":\"LJANTU\"}]', 917),
(6, 'kamion', 'Kamiondzija', '[1183.4019775390626,-3303.89501953125,5.9168572425842289]', 21210, NULL, 'kamion', '[{\"Identifier\":\"steam:11000010441bee9\",\"Posao\":\"kamion\",\"Ime\":\"#Sikora\",\"Ture\":4},{\"Identifier\":\"steam:11000010e086b7e\",\"Posao\":\"kamion\",\"Ime\":\"LJANTU\",\"Ture\":2}]', 3270),
(7, 'elektricar', 'Elektricar', '[679.0198364257813,73.37919616699219,82.1897964477539]', 2340, NULL, 'elektricar', '[{\"Ime\":\"#Sikora\",\"Ture\":19,\"Identifier\":\"steam:11000010441bee9\",\"Posao\":\"elektricar\"},{\"Ime\":\"LJANTU\",\"Ture\":1,\"Identifier\":\"steam:11000010e086b7e\",\"Posao\":\"elektricar\"}]', 2340),
(8, 'dostavljac', 'Dostavljac', '[812.78662109375,-911.2910766601563,24.41560173034668]', 903, NULL, 'deliverer', '[{\"Ime\":\"#Sikora\",\"Ture\":2,\"Identifier\":\"steam:11000010441bee9\",\"Posao\":\"deliverer\"},{\"Ime\":\"MaZz\",\"Ture\":2,\"Identifier\":\"steam:11000010ad5cf80\",\"Posao\":\"deliverer\"},{\"Ime\":\"LJANTU\",\"Ture\":3,\"Identifier\":\"steam:11000010e086b7e\",\"Posao\":\"deliverer\"}]', 903),
(9, 'vodoinstalater', 'Vodoinstalater', '[990.3715209960938,-1853.208984375,30.039819717407228]', 510, NULL, 'vodoinstalater', '[{\"Identifier\":\"steam:11000010ad5cf80\",\"Posao\":\"vodoinstalater\",\"Ime\":\"MaZz\",\"Ture\":2}]', 510),
(10, 'vatrogasac', 'Vatrogasci', '[210.68028259277345,-1656.9088134765626,28.80321502685547]', 66, NULL, 'vatrogasac', '[{\"Identifier\":\"steam:11000010ad5cf80\",\"Posao\":\"vatrogasac\",\"Ime\":\"MaZz\",\"Ture\":1}]', 66),
(11, 'garbage', 'Smetlari', '[-355.04974365234377,-1513.8880615234376,26.71724510192871]', 134, NULL, 'garbage', '[{\"Identifier\":\"steam:11000010e086b7e\",\"Posao\":\"garbage\",\"Ime\":\"LJANTU\",\"Ture\":1}]', 134),
(12, 'market', '3.0', '{}', 0, NULL, NULL, '{}', 0);

-- --------------------------------------------------------

--
-- Table structure for table `bought_houses`
--

CREATE TABLE `bought_houses` (
  `houseid` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bought_houses`
--

INSERT INTO `bought_houses` (`houseid`) VALUES
(83),
(346);

-- --------------------------------------------------------

--
-- Table structure for table `brod`
--

CREATE TABLE `brod` (
  `ID` int(11) NOT NULL,
  `Kutije` longtext NOT NULL DEFAULT '{}',
  `Pedovi` longtext NOT NULL DEFAULT '{}'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `brod`
--

INSERT INTO `brod` (`ID`, `Kutije`, `Pedovi`) VALUES
(1, '{}', '{}');

-- --------------------------------------------------------

--
-- Table structure for table `cardealer_vehicles`
--

CREATE TABLE `cardealer_vehicles` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(255) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `dateofbirth` varchar(255) NOT NULL,
  `sex` varchar(1) NOT NULL DEFAULT 'M',
  `height` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `characters`
--

INSERT INTO `characters` (`id`, `identifier`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`) VALUES
(2, 'steam:11000010441bee9', 'Tony', 'Sikora', '1998-09-25', 'm', '200'),
(3, 'steam:11000010e086b7e', 'Tuljan', 'Ljantu', '33333333', 'm', '195'),
(4, 'steam:11000010ad5cf80', 'Max', 'Cigarett', '0611199', 'm', '180'),
(5, 'steam:110000106921eea', 'Filip', 'Wizzy', '19980208', 'm', '180'),
(6, 'steam:110000111cd0aa0', 'Daniel', 'Deacon', '03.11.1997', 'm', '180');

-- --------------------------------------------------------

--
-- Table structure for table `communityservice`
--

CREATE TABLE `communityservice` (
  `identifier` varchar(100) NOT NULL,
  `actions_remaining` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `datastore`
--

CREATE TABLE `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `datastore`
--

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('housing', 'Housing', 0),
('property', 'Propriété', 0),
('society_ambulance', 'Ambulance', 1),
('society_automafija', 'Automafija', 1),
('society_ballas', 'Ballas', 1),
('society_fbi', 'FBI', 1),
('society_hitman', 'Hitman', 1),
('society_police', 'Police', 1),
('society_reporter', 'Reporter', 1),
('society_sipa', 'SIPA', 1),
('society_taxi', 'Taxi', 1),
('society_test', 'Test', 1),
('society_test2', 'Test 2', 1);

-- --------------------------------------------------------

--
-- Table structure for table `datastore_data`
--

CREATE TABLE `datastore_data` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `datastore_data`
--

INSERT INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
(1, 'society_ambulance', NULL, '{}'),
(2, 'society_fbi', NULL, '{}'),
(3, 'society_hitman', NULL, '{}'),
(4, 'society_police', NULL, '{}'),
(5, 'society_reporter', NULL, '{}'),
(6, 'society_taxi', NULL, '{}'),
(7, 'society_zemunski', NULL, '{}'),
(798, 'society_ballas', NULL, '{}'),
(3515, 'society_sipa', NULL, '{}'),
(7297, 'society_automafija', NULL, '{\"weapons\":[{\"name\":\"WEAPON_PISTOL\",\"count\":1,\"ammo\":250}]}'),
(7299, 'housing', 'steam:11000010a1d1042', '{}'),
(7300, 'property', 'steam:11000010a1d1042', '{}'),
(7301, 'housing', 'steam:11000010441bee9', '{\"weapons\":[]}'),
(7302, 'property', 'steam:11000010441bee9', '{}'),
(7303, 'housing', 'steam:110000115e9ac6b', '{}'),
(7304, 'property', 'steam:110000115e9ac6b', '{}'),
(7305, 'society_test', NULL, '{}'),
(7306, 'society_test2', NULL, '{}'),
(7307, 'housing', 'steam:11000010e086b7e', '{}'),
(7308, 'property', 'steam:11000010e086b7e', '{}'),
(7309, 'housing', 'steam:11000010ad5cf80', '{}'),
(7310, 'property', 'steam:11000010ad5cf80', '{}'),
(7311, 'housing', 'steam:110000106921eea', '{}'),
(7312, 'property', 'steam:110000106921eea', '{}'),
(7313, 'housing', 'steam:110000111cd0aa0', '{}'),
(7314, 'property', 'steam:110000111cd0aa0', '{}'),
(7316, 'property', 'steam:11000014694839f', '{}'),
(7317, 'housing', 'steam:11000014694839f', '{}');

-- --------------------------------------------------------

--
-- Table structure for table `elektricar`
--

CREATE TABLE `elektricar` (
  `ID` int(11) NOT NULL,
  `ime` varchar(255) NOT NULL,
  `lokacija` varchar(255) NOT NULL DEFAULT '{}',
  `radius` int(11) NOT NULL DEFAULT 40
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `elektricar`
--

INSERT INTO `elektricar` (`ID`, `ime`, `lokacija`, `radius`) VALUES
(2, 'Kvar 1', '{\"x\":19.09602165222168,\"y\":-1335.6456298828126,\"z\":29.27881050109863}', 40),
(7, 'Kvar 2', '{\"x\":239.26345825195313,\"y\":-1277.830078125,\"z\":29.2890396118164}', 80),
(8, 'Kvar 3', '{\"x\":-88.11775970458985,\"y\":-1750.27880859375,\"z\":29.5396614074707}', 60),
(9, 'Kvar 4', '{\"x\":71.82926940917969,\"y\":-1392.4063720703126,\"z\":34.8285026550293}', 30),
(10, 'Kvar 5', '{\"x\":149.0435333251953,\"y\":-837.6505737304688,\"z\":31.05932998657226}', 150),
(11, 'Kvar 6', '{\"x\":137.57676696777345,\"y\":-1280.72802734375,\"z\":29.36229515075683}', 70),
(12, 'Kvar 7', '{\"x\":1125.5672607421876,\"y\":-983.0593872070313,\"z\":45.41583251953125}', 40),
(13, 'Kvar 8', '{\"x\":14.96589946746826,\"y\":-1114.8077392578126,\"z\":29.79118537902832}', 40),
(14, 'Kvar 9', '{\"x\":-143.32786560058595,\"y\":-272.4048156738281,\"z\":41.81704711914062}', 60),
(15, 'Kvar 10', '{\"x\":-40.79038619995117,\"y\":-135.7283477783203,\"z\":57.3576431274414}', 40),
(16, 'Kvar 11', '{\"x\":-712.393798828125,\"y\":-165.4031524658203,\"z\":36.98808288574219}', 40),
(17, 'Kvar 12', '{\"x\":-804.3504638671875,\"y\":-186.19041442871095,\"z\":37.31045532226562}', 40),
(18, 'Kvar 13', '{\"x\":-1299.04296875,\"y\":-389.1418762207031,\"z\":36.5162467956543}', 50),
(19, 'Kvar 14', '{\"x\":-1479.5716552734376,\"y\":-372.41796875,\"z\":39.18350601196289}', 40),
(20, 'Kvar 15', '{\"x\":-1201.5537109375,\"y\":-776.0203857421875,\"z\":17.32086563110351}', 40),
(21, 'Kvar 16', '{\"x\":-1217.572998046875,\"y\":-915.7728881835938,\"z\":11.32657718658447}', 40),
(22, 'Kvar 17', '{\"x\":-1291.820068359375,\"y\":-1123.7720947265626,\"z\":6.39883995056152}', 40),
(23, 'Kvar 18', '{\"x\":-678.8347778320313,\"y\":-923.9144287109375,\"z\":23.07683372497558}', 80),
(24, 'Kvar 19', '{\"x\":-790.18310546875,\"y\":-1103.57666015625,\"z\":10.64577770233154}', 60),
(25, 'Kvar 20', '{\"x\":138.62147521972657,\"y\":-1703.9486083984376,\"z\":29.29162788391113}', 25),
(26, 'Kvar 21', '{\"x\":813.984130859375,\"y\":-2159.734130859375,\"z\":29.61902046203613}', 45),
(27, 'Kvar 22', '{\"x\":1167.103759765625,\"y\":-321.4547119140625,\"z\":69.27613067626953}', 45),
(28, 'Kvar 23', '{\"x\":1216.796630859375,\"y\":-472.6036682128906,\"z\":66.20800018310547}', 25),
(29, 'Kvar 24', '{\"x\":370.0440979003906,\"y\":324.3636169433594,\"z\":103.56730651855469}', 25),
(30, 'Kvar 25', '{\"x\":216.95556640625,\"y\":-49.9837532043457,\"z\":69.08808898925781}', 45),
(31, 'Kvar 26', '{\"x\":852.3270874023438,\"y\":-995.280029296875,\"z\":29.03023338317871}', 80),
(32, 'Kvar 27', '{\"x\":-1837.3992919921876,\"y\":789.905029296875,\"z\":138.655029296875}', 70),
(33, 'Kvar 28', '{\"x\":2545.80615234375,\"y\":371.99755859375,\"z\":108.61490631103516}', 120),
(34, 'Kvar 29', '{\"x\":-3049.685302734375,\"y\":589.705810546875,\"z\":7.74872827529907}', 40),
(35, 'Kvar 30', '{\"x\":-3241.970947265625,\"y\":1012.9772338867188,\"z\":12.39639091491699}', 25),
(36, 'Kvar 31', '{\"x\":555.2152099609375,\"y\":2665.177490234375,\"z\":42.20278167724609}', 40),
(37, 'Kvar 32', '{\"x\":1965.1390380859376,\"y\":3750.11083984375,\"z\":32.24761581420898}', 40),
(38, 'Kvar 33', '{\"x\":2678.63232421875,\"y\":3275.0673828125,\"z\":55.40906143188476}', 40),
(39, 'Kvar 34', '{\"x\":1713.204833984375,\"y\":6426.8837890625,\"z\":32.7645034790039}', 55),
(40, 'Kvar 35', '{\"x\":-2978.6943359375,\"y\":383.77398681640627,\"z\":14.99244022369384}', 40),
(41, 'Kvar 36', '{\"x\":-356.1400451660156,\"y\":-1475.953857421875,\"z\":30.00131797790527}', 70),
(42, 'Kvar 37', '{\"x\":-543.7998657226563,\"y\":-1226.195556640625,\"z\":18.45167732238769}', 50),
(43, 'Kvar 38', '{\"x\":430.98272705078127,\"y\":-803.9796752929688,\"z\":29.49115943908691}', 40),
(44, 'Kvar 39', '{\"x\":8.64949512481689,\"y\":6505.0302734375,\"z\":31.53084564208984}', 40),
(45, 'Kvar 40', '{\"x\":1702.630126953125,\"y\":4818.22412109375,\"z\":41.95983505249023}', 40),
(46, 'Kvar 41', '{\"x\":1710.8399658203126,\"y\":4934.6669921875,\"z\":42.07932662963867}', 50);

-- --------------------------------------------------------

--
-- Table structure for table `fine_types`
--

CREATE TABLE `fine_types` (
  `id` int(11) NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `fine_types`
--

INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`) VALUES
(1, 'Krivo koristenje trube', 5300, 0),
(2, 'Gazenje pune linije', 5400, 0),
(3, 'Voznja krivom stranom ceste', 7500, 0),
(4, 'Nelegalno okretanje', 7500, 0),
(5, 'Ilegalna voznja izvan ceste', 6700, 0),
(6, 'Odbijanje zakonite naredbe', 5300, 0),
(7, 'Nelegalno zaustavljanje vozila', 5150, 0),
(8, 'Nelegalno parkiranje', 5700, 0),
(9, 'Ne propustanje sluzbenog vozila', 5500, 0),
(10, 'Vozilo ne odgovara papirima', 7500, 0),
(11, 'Ne zaustavljanje na stop znak', 6500, 0),
(12, 'Ne zaustavljanje na crveno svjetlo', 6500, 0),
(13, 'Nelegalno obilazenje', 6000, 0),
(14, 'Voznja neregistriranog vozila', 6000, 0),
(15, 'Voznja bez vozacke dozvole', 6500, 0),
(16, 'Napustanje mjesta prometne nesrece', 13000, 0),
(17, 'Prekoracenje brzine > 5 km/h', 5900, 0),
(18, 'Prekoracenje brzine izmedju 5 i 15 km/h', 6200, 0),
(19, 'Prekoracenje brzine izmedju 15 i 30 km/h', 6800, 0),
(20, 'Prekoracenje brzine vise od 30 km/h', 8000, 0),
(21, 'Ometanje tijeka prometa', 5100, 1),
(22, 'Javno pijan', 5900, 1),
(23, 'Neprimjereno ponasanje', 5090, 1),
(24, 'Ometanje pravnih sluzbi', 5130, 1),
(25, 'Vrijedjanje osobe', 5075, 1),
(26, 'Nepostivanaje pravne osobe', 5110, 1),
(27, 'Verbalna prijetnja civilu', 5090, 1),
(28, 'Verbalna prijetnja sluzbenoj osobi', 5150, 1),
(29, 'Davanje laznih podataka', 5250, 1),
(30, 'Pokusaj korupcije', 6500, 1),
(31, 'Javno pokazivanje oruzja unutar grada', 5120, 2),
(32, 'Javno pokazivanje smrtonosnog oruzja unutar grada', 5300, 2),
(33, 'Nema dozvole za oruzje', 5600, 2),
(34, 'Posjedovanje nelegalnog oruzja', 5700, 2),
(35, 'Posjedovanje alata za provaljivanje', 5300, 2),
(36, 'Kradja vozila', 6800, 2),
(37, 'Namjera prodaje/distribucije ilegalnih substanci', 6500, 2),
(38, 'Proizvodnja ilegalnih substanci', 6500, 2),
(39, 'Posjedovanje ilegalne substance', 5650, 2),
(40, 'Otmica civila', 6500, 2),
(41, 'Otmica sluzbene osobe', 7000, 2),
(42, 'Pljacka', 5650, 2),
(43, 'Oruzana pljacka trgovine', 5650, 2),
(44, 'Oruzana pljacka banke', 6500, 2),
(45, 'Napad na civila', 7000, 3),
(46, 'Napad na sluzbenu osobu', 7500, 3),
(47, 'Pokusaj ubojstva civila', 8000, 3),
(48, 'Pokusaj ubojstva sluzbene osobe', 10000, 3),
(49, 'Ubojstvo civila', 15000, 3),
(50, 'Ubojstvo sluzbene osobe', 35000, 3),
(51, 'Ubojstvo iz nehaja', 6800, 3),
(52, 'Prevara', 7000, 2),
(53, 'Nepropisno parkiranje osobnog vozila.', 15000, 2),
(54, 'Pljacka Banke.', 150000, 2),
(55, 'Pljacka trgovine.', 20000, 2),
(56, 'Pljacka zlatare.', 50000, 2),
(57, 'Organizirani Kriminal.', 80000, 2);

-- --------------------------------------------------------

--
-- Table structure for table `fine_types_hitman`
--

CREATE TABLE `fine_types_hitman` (
  `id` int(11) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fine_types_hitman`
--

INSERT INTO `fine_types_hitman` (`id`, `label`, `amount`, `category`) VALUES
(1, 'Assasination Invoice', 100000, 3);

-- --------------------------------------------------------

--
-- Table structure for table `fine_types_mafia`
--

CREATE TABLE `fine_types_mafia` (
  `id` int(11) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fine_types_mafia`
--

INSERT INTO `fine_types_mafia` (`id`, `label`, `amount`, `category`) VALUES
(1, 'Raket', 3000, 0),
(2, 'Raket', 5000, 0),
(3, 'Raket', 10000, 1),
(4, 'Raket', 20000, 1),
(5, 'Raket', 50000, 2),
(6, 'Raket', 150000, 3),
(7, 'Raket', 350000, 3);

-- --------------------------------------------------------

--
-- Table structure for table `firme`
--

CREATE TABLE `firme` (
  `ID` int(11) NOT NULL,
  `Ime` varchar(255) NOT NULL,
  `Label` varchar(255) DEFAULT NULL,
  `Tip` int(11) NOT NULL DEFAULT 1,
  `Kupovina` varchar(255) NOT NULL DEFAULT '{}',
  `Ulaz` varchar(255) NOT NULL DEFAULT '{}',
  `Izlaz` varchar(255) NOT NULL DEFAULT '{}',
  `VlasnikKoord` varchar(255) NOT NULL DEFAULT '{}',
  `Vlasnik` varchar(255) DEFAULT NULL,
  `Sef` int(11) NOT NULL DEFAULT 0,
  `Cijena` int(11) NOT NULL DEFAULT 1000000,
  `Zakljucana` int(11) NOT NULL DEFAULT 0,
  `Posao` int(11) NOT NULL DEFAULT 0,
  `Skladiste` int(11) NOT NULL DEFAULT 0,
  `Vozila` longtext NOT NULL DEFAULT '{}',
  `Proizvodi` longtext NOT NULL DEFAULT '{}'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `firme`
--

INSERT INTO `firme` (`ID`, `Ime`, `Label`, `Tip`, `Kupovina`, `Ulaz`, `Izlaz`, `VlasnikKoord`, `Vlasnik`, `Sef`, `Cijena`, `Zakljucana`, `Posao`, `Skladiste`, `Vozila`, `Proizvodi`) VALUES
(21, 'tuning', 'Firma 2', 4, '{\"x\":1203.4727783203126,\"y\":2648.84130859375,\"z\":37.80663299560547}', '{\"x\":1220.826171875,\"y\":2708.62939453125,\"z\":38.00592041015625}', '{\"x\":1199.8079833984376,\"y\":2654.869140625,\"z\":37.80668640136719}', '{\"x\":1199.736083984375,\"y\":2644.18505859375,\"z\":37.80663681030273}', NULL, 643397, 500000, 0, 0, 3201, '{}', '[{\"Stanje\":4,\"Item\":\"filter\"},{\"Stanje\":3,\"Item\":\"auspuh\"},{\"Stanje\":4,\"Item\":\"elektronika\"},{\"Stanje\":3,\"Item\":\"turbo\"},{\"Stanje\":4,\"Item\":\"intercooler\"},{\"Stanje\":3,\"Item\":\"finjectori\"},{\"Stanje\":3,\"Item\":\"kvacilo\"},{\"Stanje\":1,\"Item\":\"kmotor\"}]'),
(19, 'trgovina1', 'Firma 0', 1, '{\"x\":374.1128845214844,\"y\":326.7154541015625,\"z\":103.56636810302735}', '{}', '{}', '{\"x\":380.20220947265627,\"y\":332.0689392089844,\"z\":103.56636810302735}', NULL, 643, 500000, 1, 0, 0, '{}', '{}'),
(20, 'firmaljantu', 'Firma 1', 1, '{\"x\":1135.74072265625,\"y\":-982.6700439453125,\"z\":46.41584396362305}', '{}', '{}', '{\"x\":1126.34326171875,\"y\":-982.3389282226563,\"z\":45.41582870483398}', NULL, 100, 500000, 1, 0, 0, '{}', '{}'),
(22, 'rudar', 'Firma 3', 5, '{}', '{}', '{}', '{\"x\":2548.851318359375,\"y\":2581.461669921875,\"z\":37.9587516784668}', NULL, 16629, 50000, 0, 1, 0, '{}', '{}');

-- --------------------------------------------------------

--
-- Table structure for table `firme_kraft`
--

CREATE TABLE `firme_kraft` (
  `ID` int(11) NOT NULL,
  `Firma` int(11) NOT NULL,
  `Item` varchar(255) NOT NULL,
  `Vrijeme` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `limit` int(11) NOT NULL DEFAULT -1,
  `rare` int(11) NOT NULL DEFAULT 0,
  `can_remove` int(11) NOT NULL DEFAULT 1,
  `weight` int(255) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`, `weight`) VALUES
('absinthe', 'Pelin', 5, 0, 1, 0),
('acetone', 'Aceton', 5, 0, 1, 0),
('alive_chicken', 'Ziva Kokos', 20, 0, 1, 0),
('auspuh', 'Auspuh', 1, 0, 1, 2000),
('autobomba', 'Auto-bomba', 1, 0, 1, 0),
('bandage', 'Zavoj', 20, 0, 1, 0),
('beer', 'Pivo', 15, 0, 1, 0),
('biser', 'Biser', 20, 0, 1, 0),
('blowpipe', 'Chalumeaux', 10, 0, 1, 0),
('bread', 'Kruh', 10, 0, 1, 125),
('burek', 'Burek', 5, 0, 1, 0),
('cannabis', 'Kanabis', 20, 0, 1, 0),
('carokit', 'Kit carosserie', 3, 0, 1, 0),
('carotool', 'Repair Kit', 4, 0, 1, 0),
('ccijev', 'Carbine rifle (Cijev)', 5, 0, 1, 1000),
('champagne', 'Sampanjac', 10, 0, 1, 0),
('chemicals', 'Kemikalije', 20, 0, 1, 0),
('chemicalslisence', 'Chemicals license', 1, 0, 1, 0),
('cigarett', 'Cigara', 20, 0, 1, 0),
('ckundak', 'Carbine rifle (Kundak)', 5, 0, 1, 1000),
('clip', 'Sarzer', 15, 0, 1, 0),
('clothe', 'Krpa', 40, 0, 1, 0),
('cocaine', 'Kokain', 10, 0, 1, 0),
('coke', 'List Kokaina', 20, 0, 1, 100),
('contract', 'Kupoprodajni Ugovor', 5, 0, 1, 0),
('copper', 'Bakar', 56, 0, 1, 0),
('croquettes', 'Hrana za zivotinje', 20, 0, 1, 0),
('ctijelo', 'Carbine rifle (Tijelo)', 5, 0, 1, 2000),
('cutted_wood', 'Izrezano Drvo', 20, 0, 1, 0),
('diamond', 'Dijamant', 50, 0, 1, 0),
('drone_flyer_7', 'Policijski dron', -1, 0, 1, 0),
('duhan', 'Duhan', 25, 0, 1, 0),
('elektronika', 'Elektronika', 3, 0, 1, 200),
('essence', 'Essence', 24, 0, 1, 0),
('fabric', 'Tkanina', 80, 0, 1, 0),
('filter', 'Filter', 2, 0, 1, 200),
('finjectori', 'Fuel injectori', 2, 0, 1, 700),
('fish', 'Riba', 100, 0, 1, 0),
('fixkit', 'Repair Kit', 5, 0, 1, 0),
('fixtool', 'Gedore', 6, 0, 1, 0),
('gazbottle', 'Plinska boca', 11, 0, 1, 0),
('gintonic', 'Gin Tónic', 5, 0, 1, 0),
('gljive', 'Gljive', 30, 0, 1, 0),
('gold', 'Zlato', 21, 0, 1, 0),
('grebalica', 'Grebalica', 5, 0, 1, 100),
('gym_membership', 'Gym clanarina', -1, 0, 1, 0),
('headbag', 'Vreca', 2, 0, 1, 0),
('heartpump', 'Heartpump', 255, 0, 1, 0),
('heroin', 'Heroin', 10, 0, 1, 0),
('hydrochloric_acid', 'Hidrokloricna kiselina', 15, 0, 1, 0),
('intercooler', 'Intercooler', 1, 0, 1, 1600),
('iron', 'Zeljezo', 10, 0, 1, 1000),
('jewels', 'Nakit', -1, 0, 1, 1),
('kcijev', 'Assault rifle (Cijev)', 5, 0, 1, 1000),
('kemija', 'Kemija', 20, 0, 1, 0),
('kkundak', 'Assault rifle (Kundak)', 5, 0, 1, 1000),
('kmotor', 'Kovani motor', 1, 0, 1, 4000),
('kola', 'Coca-Cola', 5, 0, 1, 0),
('koza', 'Koža', -1, 0, 1, 0),
('ktijelo', 'Assault rifle (Tijelo)', 5, 0, 1, 2000),
('kvacilo', 'Kvacilo', 1, 0, 1, 600),
('lancic', 'Lancic', 50, 0, 1, 0),
('lighter', 'Upaljac', 1, 0, 1, 0),
('lithium', 'Litijum baterije', 10, 0, 1, 0),
('ljudi', 'osoba', 100, 0, 1, 0),
('loto', 'Loto listic', 1, 0, 1, 125),
('lsa', 'LSA', 20, 0, 1, 0),
('LSD', 'LSD', 10, 0, 1, 0),
('marijuana', 'Marihuana', 20, 0, 1, 0),
('medikit', 'Med-kit', 10, 0, 1, 0),
('meso', 'Meso', -1, 0, 1, 0),
('meth', 'Meth', 20, 0, 1, 0),
('methlab', 'Prijenosni laboratorij za meth', 1, 0, 1, 0),
('milk', 'Mlijeko', 10, 0, 1, 0),
('mobitel', 'Mobitel', 1, 0, 1, 0),
('moneywash', 'MoneyWash License', 1, 0, 1, 0),
('narukvica', 'Narukvica', 50, 0, 1, 0),
('net_cracker', 'Laptop', 1, 0, 1, 0),
('odznaka', 'Odznaka', -1, 0, 0, 0),
('packaged_chicken', 'Pakirana Piletina', 100, 0, 1, 0),
('packaged_plank', 'Pakirane daske', 100, 0, 1, 0),
('petarda', 'Petarda', 50, 0, 1, 0),
('petarde', 'Petarde', 10, 0, 1, 0),
('petrol', 'Benzin', 24, 0, 1, 0),
('petrol_raffin', 'Rafinirani Benzin', 24, 0, 1, 0),
('pizza', 'Pizza', 2, 0, 1, 0),
('poppyresin', 'Makova smola', 20, 0, 1, 0),
('rakija', 'Rakija', 1, 0, 1, 0),
('repairkit', 'Repair Kit', 2, 0, 1, 0),
('ronjenje', 'Ronilacka oprema', 1, 0, 1, 0),
('saksija', 'Saksija', 5, 0, 1, 0),
('scijev', 'Special carbine (Cijev)', 5, 0, 1, 1000),
('seed', 'Sjeme kanabisa', 5, 0, 1, 0),
('skoljka', 'Skoljka', 10, 0, 1, 0),
('skundak', 'Special carbine (Kundak)', 5, 0, 1, 1000),
('slaughtered_chicken', 'Ubijena Kokos', 20, 0, 1, 0),
('smcijev', 'SMG (Cijev)', 5, 0, 1, 1000),
('smkundak', 'SMG (Kundak)', 5, 0, 1, 1000),
('smtijelo', 'SMG (Tijelo)', 5, 0, 1, 2000),
('sodium_hydroxide', 'Natrijev hidroksid', 15, 0, 1, 0),
('speed', 'Speed', 25, 0, 1, 0),
('stijelo', 'Special carbine (Tijelo)', 5, 0, 1, 2000),
('stone', 'Kamen', 7, 0, 1, 0),
('sulfuric_acid', 'Sumporna kiselina', 15, 0, 1, 0),
('tequila', 'Tequila', 15, 0, 1, 0),
('thermite', 'Termitna bomba', 5, 0, 1, 0),
('thionyl_chloride', 'Thionil klorid', 20, 0, 1, 0),
('turbo', 'Turbo', 2, 0, 1, 1200),
('ukosnica', 'Ukosnica', 5, 0, 1, 0),
('vatromet', 'Vatromet', 1, 0, 1, 0),
('vodka', 'Vodka', 15, 0, 1, 0),
('washed_stone', 'Isprani kamen', 7, 0, 1, 0),
('water', 'Voda', 5, 0, 1, 0),
('weapon_advancedrifle', 'Advanced Rifle(stvar)', 5, 0, 1, 0),
('weapon_appistol', 'AP Pistol(stvar)', 5, 0, 1, 0),
('weapon_assaultrifle', 'Kalas(stvar)', 5, 0, 1, 0),
('weapon_assaultrifle_mk2', 'Assault Rifle MK2(stvar)', 5, 0, 1, 0),
('weapon_assaultshotgun', 'Assault Shotgun(stvar)', 5, 0, 1, 0),
('weapon_assaultsmg', 'Assault SMG(stvar)', 5, 0, 1, 0),
('weapon_autoshotgun', 'Auto Shotgun(stvar)', 5, 0, 1, 0),
('weapon_bat', 'Palica(stvar)', 5, 0, 1, 0),
('weapon_battleaxe', 'Battle Sjekira(stvar)', 5, 0, 1, 0),
('weapon_bullpuprifle', 'Bullpup Rifle(stvar)', 5, 0, 1, 0),
('weapon_bullpupshotgun', 'Bullpup Shotgun(stvar)', 5, 0, 1, 0),
('weapon_carbinerifle', 'Carbine Rifle(stvar)', 5, 0, 1, 0),
('weapon_carbinerifle_mk2', 'Carbine Rifle MK2(stvar)', 5, 0, 1, 0),
('weapon_combatmg', 'Combat MG(stvar)', 5, 0, 1, 0),
('weapon_combatpdw', 'Combat PDW(stvar)', 5, 0, 1, 0),
('weapon_combatpistol', 'Combat Pistol(stvar)', 5, 0, 1, 0),
('weapon_compactrifle', 'Compact Rifle(stvar)', 5, 0, 1, 0),
('weapon_crowbar', 'Pajser(stvar)', 5, 0, 1, 0),
('weapon_dbshotgun', 'DBShotgun(stvar)', 5, 0, 1, 0),
('weapon_doubleaction', 'Double Action(stvar)', 5, 0, 1, 0),
('weapon_fireextinguisher', 'Aparat za gasenje(stvar)', 5, 0, 1, 0),
('weapon_firework', 'Firework(stvar)', 5, 0, 1, 0),
('weapon_flashlight', 'Lampa(stvar)', 5, 0, 1, 0),
('weapon_golfclub', 'Golfclub(stvar)', 5, 0, 1, 0),
('weapon_gusenberg', 'Gusenberg(stvar)', 5, 0, 1, 0),
('weapon_hammer', 'Cekic(stvar)', 5, 0, 1, 0),
('weapon_hatchet', 'Sjekira(stvar)', 5, 0, 1, 0),
('weapon_heavypistol', 'Heavy Pistolj(stvar)', 6, 0, 1, 0),
('weapon_heavyshotgun', 'Heavy Shotgun(stvar)', 5, 0, 1, 0),
('weapon_heavysniper', 'Heavy Sniper(stvar)', 5, 0, 1, 0),
('weapon_knife', 'Noz(stvar)', 5, 0, 1, 0),
('weapon_machete', 'Maceta(stvar)', 5, 0, 1, 0),
('weapon_machinepsitol', 'Machine Pistolj(stvar)', 5, 0, 1, 0),
('weapon_marksmanpistol', 'Marksman Pistolj(stvar)', 5, 0, 1, 0),
('weapon_marksmanrifle', 'Marksman Sniper(stvar)', 5, 0, 1, 0),
('weapon_marksmanrifle_mk2', 'Marksman Rifle MK2(stvar)', 5, 0, 1, 0),
('weapon_mg', 'MG(stvar)', 5, 0, 1, 0),
('weapon_microsmg', 'Micro SMG(stvar)', 5, 0, 1, 0),
('weapon_minismg', 'Mini SMG(stvar)', 5, 0, 1, 0),
('weapon_musket', 'Musket(stvar)', 5, 0, 1, 0),
('weapon_nightstick', 'Pendrek(stvar)', 5, 0, 1, 0),
('weapon_pistol', 'Pistolj(stvar)', 6, 0, 1, 0),
('weapon_pistol50', 'Pistol50(stvar)', 5, 0, 1, 0),
('weapon_poolcue', 'Stap(stvar)', 5, 0, 1, 0),
('weapon_pumpshotgun', 'Sacma(stvar)', 5, 0, 1, 0),
('weapon_revolver', 'Revolver(stvar)', 5, 0, 1, 0),
('weapon_revolver_mk2', 'Revolver MK2(stvar)', 5, 0, 1, 0),
('weapon_sawnoffshotgun', 'Sawnoff sacma(stvar)', 5, 0, 1, 0),
('weapon_smg', 'SMG(stvar)', 5, 0, 1, 0),
('weapon_sniperrifle', 'Sniper(stvar)', 5, 0, 1, 0),
('weapon_snspistol', 'SNS Pistolj(stvar)', 5, 0, 1, 0),
('weapon_specialcarbine', 'Special Carbine(stvar)', 5, 0, 1, 0),
('weapon_switchblade', 'Switchblade(stvar)', 5, 0, 1, 0),
('weapon_vintagepistol', 'Vintage Pistolj(stvar)', 5, 0, 1, 0),
('weapon_wrench', 'Wrench(stvar)', 5, 0, 1, 0),
('whisky', 'Whisky', 15, 0, 1, 0),
('wine', 'Vino', 15, 0, 1, 0),
('wood', 'Drvo', 20, 0, 1, 0),
('wool', 'Vuna', 40, 0, 1, 0),
('zemlja', 'Vreca zemlje', 5, 0, 1, 0),
('zeton', 'Zeton', -1, 0, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `pID` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `id` int(255) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`pID`, `name`, `label`, `whitelisted`, `id`) VALUES
(2, 'ambulance', 'LSMD', 1, 0),
(3, 'mechanic', 'Mehanicar', 1, 0),
(4, 'police', 'LSPD', 1, 0),
(5, 'reporter', 'Reporter', 1, 1),
(6, 'taxi', 'Uber', 1, 0),
(7, 'test', 'Test', 1, 1),
(8, 'test2', 'Test 2', 1, 1),
(1, 'unemployed', 'Nezaposlen', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `job_grades`
--

CREATE TABLE `job_grades` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `job_grades`
--

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Nezaposlen', 50, '{}', '{}'),
(3, 'fisherman', 0, 'employee', 'Radnik', 300, '{}', '{}'),
(4, 'fueler', 0, 'employee', 'Radnik', 350, '{}', '{}'),
(6, 'tailor', 0, 'employee', 'Radnik', 350, '{\"mask_1\":0,\"arms\":1,\"glasses_1\":0,\"hair_color_2\":4,\"makeup_1\":0,\"face\":19,\"glasses\":0,\"mask_2\":0,\"makeup_3\":0,\"skin\":29,\"helmet_2\":0,\"lipstick_4\":0,\"sex\":0,\"torso_1\":24,\"makeup_2\":0,\"bags_2\":0,\"chain_2\":0,\"ears_1\":-1,\"bags_1\":0,\"bproof_1\":0,\"shoes_2\":0,\"lipstick_2\":0,\"chain_1\":0,\"tshirt_1\":0,\"eyebrows_3\":0,\"pants_2\":0,\"beard_4\":0,\"torso_2\":0,\"beard_2\":6,\"ears_2\":0,\"hair_2\":0,\"shoes_1\":36,\"tshirt_2\":0,\"beard_3\":0,\"hair_1\":2,\"hair_color_1\":0,\"pants_1\":48,\"helmet_1\":-1,\"bproof_2\":0,\"eyebrows_4\":0,\"eyebrows_2\":0,\"decals_1\":0,\"age_2\":0,\"beard_1\":5,\"shoes\":10,\"lipstick_1\":0,\"eyebrows_1\":0,\"glasses_2\":0,\"makeup_4\":0,\"decals_2\":0,\"lipstick_3\":0,\"age_1\":0}', '{\"mask_1\":0,\"arms\":5,\"glasses_1\":5,\"hair_color_2\":4,\"makeup_1\":0,\"face\":19,\"glasses\":0,\"mask_2\":0,\"makeup_3\":0,\"skin\":29,\"helmet_2\":0,\"lipstick_4\":0,\"sex\":1,\"torso_1\":52,\"makeup_2\":0,\"bags_2\":0,\"chain_2\":0,\"ears_1\":-1,\"bags_1\":0,\"bproof_1\":0,\"shoes_2\":1,\"lipstick_2\":0,\"chain_1\":0,\"tshirt_1\":23,\"eyebrows_3\":0,\"pants_2\":0,\"beard_4\":0,\"torso_2\":0,\"beard_2\":6,\"ears_2\":0,\"hair_2\":0,\"shoes_1\":42,\"tshirt_2\":4,\"beard_3\":0,\"hair_1\":2,\"hair_color_1\":0,\"pants_1\":36,\"helmet_1\":-1,\"bproof_2\":0,\"eyebrows_4\":0,\"eyebrows_2\":0,\"decals_1\":0,\"age_2\":0,\"beard_1\":5,\"shoes\":10,\"lipstick_1\":0,\"eyebrows_1\":0,\"glasses_2\":0,\"makeup_4\":0,\"decals_2\":0,\"lipstick_3\":0,\"age_1\":0}'),
(7, 'miner', 0, 'employee', 'Radnik', 550, '{\"tshirt_2\":0,\"ears_1\":8,\"glasses_1\":15,\"torso_2\":0,\"ears_2\":2,\"glasses_2\":3,\"shoes_2\":6,\"pants_1\":98,\"shoes_1\":61,\"bags_1\":0,\"helmet_2\":0,\"pants_2\":0,\"torso_1\":56,\"tshirt_1\":59,\"arms\":19,\"bags_2\":0,\"helmet_1\":0}', '{}'),
(8, 'slaughterer', 0, 'employee', 'Radnik', 300, '{\"age_1\":0,\"glasses_2\":0,\"beard_1\":5,\"decals_2\":0,\"beard_4\":0,\"shoes_2\":0,\"tshirt_2\":0,\"lipstick_2\":0,\"hair_2\":0,\"arms\":67,\"pants_1\":36,\"skin\":29,\"eyebrows_2\":0,\"shoes\":10,\"helmet_1\":-1,\"lipstick_1\":0,\"helmet_2\":0,\"hair_color_1\":0,\"glasses\":0,\"makeup_4\":0,\"makeup_1\":0,\"hair_1\":2,\"bproof_1\":0,\"bags_1\":0,\"mask_1\":0,\"lipstick_3\":0,\"chain_1\":0,\"eyebrows_4\":0,\"sex\":0,\"torso_1\":56,\"beard_2\":6,\"shoes_1\":12,\"decals_1\":0,\"face\":19,\"lipstick_4\":0,\"tshirt_1\":15,\"mask_2\":0,\"age_2\":0,\"eyebrows_3\":0,\"chain_2\":0,\"glasses_1\":0,\"ears_1\":-1,\"bags_2\":0,\"ears_2\":0,\"torso_2\":0,\"bproof_2\":0,\"makeup_2\":0,\"eyebrows_1\":0,\"makeup_3\":0,\"pants_2\":0,\"beard_3\":0,\"hair_color_2\":4}', '{\"age_1\":0,\"glasses_2\":0,\"beard_1\":5,\"decals_2\":0,\"beard_4\":0,\"shoes_2\":0,\"tshirt_2\":0,\"lipstick_2\":0,\"hair_2\":0,\"arms\":72,\"pants_1\":45,\"skin\":29,\"eyebrows_2\":0,\"shoes\":10,\"helmet_1\":-1,\"lipstick_1\":0,\"helmet_2\":0,\"hair_color_1\":0,\"glasses\":0,\"makeup_4\":0,\"makeup_1\":0,\"hair_1\":2,\"bproof_1\":0,\"bags_1\":0,\"mask_1\":0,\"lipstick_3\":0,\"chain_1\":0,\"eyebrows_4\":0,\"sex\":1,\"torso_1\":49,\"beard_2\":6,\"shoes_1\":24,\"decals_1\":0,\"face\":19,\"lipstick_4\":0,\"tshirt_1\":9,\"mask_2\":0,\"age_2\":0,\"eyebrows_3\":0,\"chain_2\":0,\"glasses_1\":5,\"ears_1\":-1,\"bags_2\":0,\"ears_2\":0,\"torso_2\":0,\"bproof_2\":0,\"makeup_2\":0,\"eyebrows_1\":0,\"makeup_3\":0,\"pants_2\":0,\"beard_3\":0,\"hair_color_2\":4}'),
(9, 'banker', 0, 'advisor', 'Savjetnik', 700, '{}', '{}'),
(10, 'banker', 1, 'banker', 'Bankar', 900, '{}', '{}'),
(11, 'banker', 2, 'business_banker', 'Visi bankar', 1100, '{}', '{}'),
(12, 'banker', 3, 'trader', 'Bitcoin', 1400, '{}', '{}'),
(13, 'banker', 4, 'boss', 'Gazda', 1300, '{}', '{}'),
(14, 'cardealer', 0, 'recruit', 'Pocetnik', 650, '{}', '{}'),
(15, 'cardealer', 1, 'novice', 'Prodavac', 800, '{}', '{}'),
(16, 'cardealer', 2, 'experienced', 'Visi Prodavac', 900, '{}', '{}'),
(17, 'cardealer', 3, 'boss', 'Sef Autosalona', 1100, '{}', '{}'),
(18, 'taxi', 0, 'recrue', 'Pocetnik', 500, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":32,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":31,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":0,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":27,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(19, 'taxi', 1, 'novice', 'Vozac', 650, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":32,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":31,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":0,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":27,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(20, 'taxi', 2, 'experimente', 'Iskusni Vozac', 850, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":26,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":57,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":11,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(21, 'taxi', 3, 'uber', 'Uber', 1000, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":26,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":57,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":11,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(22, 'taxi', 4, 'boss', 'Sef', 1500, '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":29,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":31,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":4,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":1,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":0,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":0,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":0,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":4,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":10,\"pants_1\":24}', '{\"hair_2\":0,\"hair_color_2\":0,\"torso_1\":57,\"bags_1\":0,\"helmet_2\":0,\"chain_2\":0,\"eyebrows_3\":0,\"makeup_3\":0,\"makeup_2\":0,\"tshirt_1\":38,\"makeup_1\":0,\"bags_2\":0,\"makeup_4\":0,\"eyebrows_4\":0,\"chain_1\":0,\"lipstick_4\":0,\"bproof_2\":0,\"hair_color_1\":0,\"decals_2\":0,\"pants_2\":1,\"age_2\":0,\"glasses_2\":0,\"ears_2\":0,\"arms\":21,\"lipstick_1\":0,\"ears_1\":-1,\"mask_2\":0,\"sex\":1,\"lipstick_3\":0,\"helmet_1\":-1,\"shoes_2\":0,\"beard_2\":0,\"beard_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"glasses_1\":5,\"bproof_1\":0,\"mask_1\":0,\"decals_1\":1,\"hair_1\":0,\"eyebrows_2\":0,\"beard_3\":0,\"age_1\":0,\"tshirt_2\":0,\"skin\":0,\"torso_2\":0,\"eyebrows_1\":0,\"face\":0,\"shoes_1\":49,\"pants_1\":11}'),
(23, 'police', 0, 'recruit', 'Kadet', 800, '{}', '{}'),
(24, 'police', 1, 'officer', 'Saobracajac', 1100, '{}', '{}'),
(26, 'police', 2, 'sergeant', 'Policajac', 1300, '{}', '{}'),
(27, 'police', 5, 'chef', 'Komandant', 1600, '{{\"tshirt_1\":96,\"tshirt_2\":0,\"torso_1\":32,\"arms\":4,\"pants_1\":28,\"shoes_1\":10,\"chain_1\":125,\"chain_2\":0,\"helmet_1\":46,\"helmet_2\":3}}', '{}'),
(28, 'mechanic', 0, 'recrue', 'Segrt', 1000, '{}', '{}'),
(29, 'mechanic', 1, 'novice', 'Radnik', 1200, '{}', '{}'),
(30, 'mechanic', 2, 'experimente', 'Iskusni Radnik', 1500, '{}', '{}'),
(31, 'mechanic', 3, 'chief', 'Podsef', 1700, '{}', '{}'),
(32, 'mechanic', 4, 'boss', 'Sef', 2000, '{}', '{}'),
(54, 'ambulance', 0, 'ambulance', 'Vozac', 1200, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":0,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(55, 'ambulance', 1, 'doctor', 'Medicinski Tehnicar', 1500, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":0,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(56, 'ambulance', 2, 'chief_doctor', 'Doktor', 1700, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":0,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(57, 'ambulance', 3, 'boss', 'Kirurg', 2000, '{\"tshirt_2\":0,\"hair_color_1\":5,\"glasses_2\":3,\"shoes\":9,\"torso_2\":3,\"hair_color_2\":0,\"pants_1\":24,\"glasses_1\":4,\"hair_1\":2,\"sex\":0,\"decals_2\":0,\"tshirt_1\":15,\"helmet_1\":0,\"helmet_2\":0,\"arms\":92,\"face\":19,\"decals_1\":60,\"torso_1\":13,\"hair_2\":0,\"skin\":34,\"pants_2\":5}', '{\"tshirt_2\":3,\"decals_2\":0,\"glasses\":0,\"hair_1\":2,\"torso_1\":73,\"shoes\":1,\"hair_color_2\":0,\"glasses_1\":19,\"skin\":13,\"face\":6,\"pants_2\":5,\"tshirt_1\":75,\"pants_1\":37,\"helmet_1\":57,\"torso_2\":0,\"arms\":14,\"sex\":1,\"glasses_2\":0,\"decals_1\":0,\"hair_2\":0,\"helmet_2\":0,\"hair_color_1\":0}'),
(58, 'kosac', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(59, 'deliverer', 0, 'employee', 'Radnik', 600, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(60, 'vatrogasac', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":75,\"torso_1\":267,\"arms\":17,\"pants_1\":34,\"glasses_1\":0,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":4,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":4,\"shoes_1\":71,\"shoes_2\":25,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":0,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":3,\"helmet_1\":126}', '{\"tshirt_1\":75,\"torso_1\":267,\"arms\":17,\"pants_1\":34,\"glasses_1\":0,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":4,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":4,\"shoes_1\":71,\"shoes_2\":25,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":0,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":3,\"helmet_1\":126}'),
(62, 'police', 4, 'lieutenant', 'Inspektor', 1500, '{}', '{}'),
(64, 'police', 3, 'intendent', 'Serif', 1300, '{\"tshirt_1\":5,\"tshirt_2\":3,\"torso_1\":53,\"arms\":17,\"pants_1\":33,\"shoes_1\":62,\"decals_1\":0,\"decals_2\":0,\"helmet_1\":59,\"helmet_2\":9,\"glasses_1\":15,\"glasses_2\":7,\"watch_1\":6,\"mask_1\":56,\"mask_2\":1}', '{}'),
(76, 'reporter', 0, 'soldato', 'Pocetnik', 100, '{}', '{}'),
(77, 'reporter', 1, 'capo', 'Novinar', 600, '{}', '{}'),
(78, 'reporter', 2, 'consigliere', 'Reporter', 1000, '{}', '{}'),
(79, 'reporter', 3, 'boss', 'Sef', 2000, '{}', '{}'),
(80, 'garbage', 0, 'employee', 'Employee', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(81, 'farmer', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}'),
(87, 'hitman', 0, 'assassin', 'Nepoznato', 1500, '{}', '{}'),
(88, 'hitman', 1, 'soldier', 'Nepoznato', 1800, '{}', '{}'),
(89, 'hitman', 2, 'coleader', 'Nepoznato', 2100, '{}', '{}'),
(90, 'hitman', 3, 'boss', 'Nepoznato', 2700, '{}', '{}'),
(113, 'vodoinstalater', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(114, 'police', 6, 'boss', 'Nacelnik', 2000, '{{\"tshirt_1\":96,\"tshirt_2\":0,\"torso_1\":32,\"arms\":4,\"pants_1\":28,\"shoes_1\":10,\"chain_1\":125,\"chain_2\":0,\"helmet_1\":46,\"helmet_2\":3}}', '{}'),
(120, 'drvosjeca', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(121, 'elektricar', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(135, 'ballas', 0, 'soldato', 'Younglings', 0, '{}', '{}'),
(136, 'ballas', 1, 'capo', 'Runners', 0, '{}', '{}'),
(137, 'ballas', 2, 'consigliere', 'Shooters', 0, '{}', '{}'),
(138, 'ballas', 3, 'boss', 'O.G\'s', 3500, '{}', '{}'),
(143, 'sipa', 0, 'intendent', 'SIPA', 2500, '{}', '{}'),
(144, 'sipa', 1, 'boss', 'Komandant', 3500, '{}', '{}'),
(153, 'kamion', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(181, 'gradjevinar', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(190, 'ralica', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(191, 'vlak', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":59,\"torso_1\":89,\"arms\":31,\"pants_1\":36,\"glasses_1\":19,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":1,\"shoes\":35,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":5}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(200, 'automafija', 4, 'boss', 'Sef', 300, '{}', '{}'),
(202, 'spasioc', 0, 'employee', 'Radnik', 200, '{\"tshirt_1\":129,\"torso_1\":148,\"arms\":1,\"pants_1\":16,\"glasses_1\":0,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":3,\"shoes\":5,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":-1}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(203, 'fastfood', 0, 'employee', 'Uber Eats', 200, '{\"tshirt_1\":59,\"torso_1\":67,\"arms\":1,\"pants_1\":22,\"glasses_1\":0,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":2,\"glasses_2\":0,\"torso_2\":3,\"shoes_1\":1,\"hair_1\":0,\"skin\":0,\"sex\":0,\"glasses_1\":19,\"pants_2\":5,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":17}', '{\"tshirt_1\":36,\"torso_1\":0,\"arms\":68,\"pants_1\":30,\"glasses_1\":15,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":0,\"face\":27,\"glasses_2\":0,\"torso_2\":11,\"shoes\":26,\"hair_1\":5,\"skin\":0,\"sex\":1,\"glasses_1\":15,\"pants_2\":2,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":19}'),
(204, 'test', 0, 'Test', 'Test', 300, '{}', '{}'),
(205, 'test2', 0, 'Test', 'Test', 300, '{}', '{}');

-- --------------------------------------------------------

--
-- Table structure for table `jsfour_criminalrecord`
--

CREATE TABLE `jsfour_criminalrecord` (
  `offense` varchar(160) NOT NULL,
  `date` varchar(255) DEFAULT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `charge` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `term` varchar(255) DEFAULT NULL,
  `classified` int(2) NOT NULL DEFAULT 0,
  `identifier` varchar(255) DEFAULT NULL,
  `dob` varchar(255) DEFAULT NULL,
  `warden` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jsfour_criminalrecord`
--

INSERT INTO `jsfour_criminalrecord` (`offense`, `date`, `institution`, `charge`, `description`, `term`, `classified`, `identifier`, `dob`, `warden`) VALUES
('D-192', '01.05.2021', 'LOS SANTOS', 'UBIO TROJICU', 'QEQEQEQE', '0 60 0 ', 1, 'steam:110000115e9ac6b', '19960405', 'Meha'),
('D-694', '01.05.2021', 'LOS SANTOS', 'Oruzana pljacka i ubistvo', 'Oruzana pljacka trgovine', '0 60 0 ', 1, 'steam:110000115e9ac6b', '19960405', 'Meha'),
('A-287', '2021-05-01', 'LOS SANTOS', 'TEST', 'eeqeqqe', '0 30 0 ', 0, 'steam:11000010a1d1042', '01021987', 'Meha'),
('D-713', '2021-05-01', 'LOS SANTOS', 'Pljacka', 'kkdkdkdk', '2 0 0', 0, 'steam:11000010441bee9', '1998-09-25', 'Tony'),
('A-270', '2021-05-01', 'LOS SANTOS', 'Ubojstvo', 'Ubio ga ko vola u kupusu jebote', '1 0 0', 0, 'steam:11000010441bee9', '1998-09-25', 'Tony'),
('F-301', '2021-05-01', 'LOS SANTOS', 'Kurcna', 'ahahah to je to', '5 2 1', 1, 'steam:11000010441bee9', '1998-09-25', 'Tony'),
('F-330', 'DANAS', 'LOS SANTOS', 'Jeo burek', 'Jeo burek sa sirom', '5 10 0', 1, 'steam:11000010441bee9', '1998-09-25', 'Tony');

-- --------------------------------------------------------

--
-- Table structure for table `jsfour_criminaluserinfo`
--

CREATE TABLE `jsfour_criminaluserinfo` (
  `identifier` varchar(160) NOT NULL,
  `aliases` varchar(255) DEFAULT NULL,
  `recordid` varchar(255) DEFAULT NULL,
  `weight` varchar(255) DEFAULT NULL,
  `eyecolor` varchar(255) DEFAULT NULL,
  `haircolor` varchar(255) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `dob` varchar(255) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `height` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jsfour_criminaluserinfo`
--

INSERT INTO `jsfour_criminaluserinfo` (`identifier`, `aliases`, `recordid`, `weight`, `eyecolor`, `haircolor`, `firstname`, `lastname`, `dob`, `sex`, `height`) VALUES
('steam:11000010a1d1042', 'MEHA ', 'F767D915', '71kg', 'Smedja', 'Smedja', 'MEHA ', 'VAN DAMME', '01021987', 'm', '182cm'),
('steam:11000010441bee9', 'TONY', 'F408C951', '77kg', 'Crna', 'Crna', 'TONY', 'SIKORA', '1998-09-25', 'm', '200cm'),
('steam:110000115e9ac6b', 'DERIM', 'F755A779', '65kg', 'Crna', 'Crna', 'DERIM', 'UPAKAS', '19960405', 'm', '177cm');

-- --------------------------------------------------------

--
-- Table structure for table `kuce`
--

CREATE TABLE `kuce` (
  `ID` int(11) NOT NULL,
  `prop` varchar(255) NOT NULL,
  `door` longtext NOT NULL,
  `price` int(11) NOT NULL,
  `prodaja` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kuce`
--

INSERT INTO `kuce` (`ID`, `prop`, `door`, `price`, `prodaja`) VALUES
(1, 'trevor', '{\"x\":-1112.25,\"y\":-1578.4000244140626,\"z\":7.69999980926513}', 250000, 0),
(2, 'trevor', '{\"x\":-1114.3399658203126,\"y\":-1579.469970703125,\"z\":7.69999980926513}', 250000, 0),
(3, 'trevor', '{\"x\":-1114.949951171875,\"y\":-1577.5699462890626,\"z\":3.55999994277954}', 250000, 0),
(4, 'trevor', '{\"x\":373.9276123046875,\"y\":427.87890625,\"z\":144.7342071533203}', 350000, 0),
(5, 'nice', '{\"x\":346.4424133300781,\"y\":440.6260070800781,\"z\":146.7830047607422}', 450000, 0),
(6, 'nice', '{\"x\":331.4053955078125,\"y\":465.68231201171877,\"z\":150.2642059326172}', 450000, 0),
(7, 'mansion', '{\"x\":316.0714111328125,\"y\":501.47869873046877,\"z\":152.22979736328126}', 750000, 0),
(8, 'mansion', '{\"x\":325.3428039550781,\"y\":537.4041748046875,\"z\":152.92059326171876}', 750000, 0),
(9, 'nice', '{\"x\":223.64830017089845,\"y\":513.9970703125,\"z\":139.8170928955078}', 450000, 0),
(10, 'nice', '{\"x\":119.22889709472656,\"y\":494.32330322265627,\"z\":146.3928985595703}', 450000, 0),
(11, 'nice', '{\"x\":80.12486267089844,\"y\":485.8677978515625,\"z\":147.25169372558595}', 450000, 0),
(12, 'nice', '{\"x\":57.8746109008789,\"y\":450.0857849121094,\"z\":146.0814971923828}', 450000, 0),
(13, 'nice', '{\"x\":42.98038864135742,\"y\":468.6543884277344,\"z\":147.14590454101563}', 450000, 0),
(14, 'mansion', '{\"x\":-7.60816717147827,\"y\":468.3959045410156,\"z\":144.92080688476563}', 750000, 0),
(15, 'nice', '{\"x\":-66.48236846923828,\"y\":490.8035888671875,\"z\":143.74229431152345}', 450000, 0),
(16, 'mansion', '{\"x\":-109.8572006225586,\"y\":502.61920166015627,\"z\":142.3531036376953}', 750000, 0),
(17, 'nice', '{\"x\":-174.7194061279297,\"y\":502.5979919433594,\"z\":136.47059631347657}', 450000, 0),
(18, 'nice', '{\"x\":84.86479949951172,\"y\":561.9719848632813,\"z\":181.8175048828125}', 450000, 0),
(19, 'lester', '{\"x\":119.08489990234375,\"y\":564.5529174804688,\"z\":183.00369262695313}', 150000, 0),
(20, 'nice', '{\"x\":215.64540100097657,\"y\":620.1937255859375,\"z\":186.66729736328126}', 450000, 0),
(21, 'nice', '{\"x\":231.95640563964845,\"y\":672.4473266601563,\"z\":188.99549865722657}', 450000, 0),
(22, 'nice', '{\"x\":-230.5478057861328,\"y\":488.45928955078127,\"z\":127.81749725341797}', 450000, 0),
(23, 'nice', '{\"x\":-311.9219970703125,\"y\":474.8205871582031,\"z\":110.87239837646485}', 450000, 0),
(24, 'nice', '{\"x\":-166.7200927734375,\"y\":424.6629943847656,\"z\":110.85579681396485}', 450000, 0),
(25, 'mansion', '{\"x\":-297.89208984375,\"y\":380.3153076171875,\"z\":111.14530181884766}', 750000, 0),
(26, 'lester', '{\"x\":-328.2933044433594,\"y\":369.9056091308594,\"z\":109.05599975585938}', 150000, 0),
(27, 'nice', '{\"x\":-371.7889099121094,\"y\":344.114990234375,\"z\":108.9926986694336}', 450000, 0),
(28, 'nice', '{\"x\":-409.4172058105469,\"y\":341.6883850097656,\"z\":107.9573974609375}', 450000, 0),
(29, 'nice', '{\"x\":-349.23748779296877,\"y\":514.6478881835938,\"z\":119.69670104980469}', 450000, 0),
(30, 'nice', '{\"x\":-386.6803894042969,\"y\":504.57440185546877,\"z\":119.46150207519531}', 450000, 0),
(31, 'nice', '{\"x\":-406.48748779296877,\"y\":567.513427734375,\"z\":123.65290069580078}', 450000, 0),
(32, 'mansion', '{\"x\":-459.1129150390625,\"y\":537.52099609375,\"z\":120.50679779052735}', 750000, 0),
(33, 'nice', '{\"x\":-500.55029296875,\"y\":552.2288818359375,\"z\":119.6604995727539}', 450000, 0),
(34, 'nice', '{\"x\":-520.2656860351563,\"y\":594.2166137695313,\"z\":119.88670349121094}', 450000, 0),
(35, 'nice', '{\"x\":-475.13739013671877,\"y\":585.8267822265625,\"z\":127.7333984375}', 450000, 0),
(36, 'nice', '{\"x\":-559.4097900390625,\"y\":664.381591796875,\"z\":144.50660705566407}', 450000, 0),
(37, 'mansion', '{\"x\":-605.9417114257813,\"y\":672.86669921875,\"z\":150.647705078125}', 750000, 0),
(38, 'nice', '{\"x\":-579.7288818359375,\"y\":733.1072998046875,\"z\":183.2602996826172}', 450000, 0),
(39, 'nice', '{\"x\":-655.07958984375,\"y\":803.4769287109375,\"z\":198.04190063476563}', 450000, 0),
(40, 'lester', '{\"x\":-746.9130859375,\"y\":808.4434814453125,\"z\":214.08009338378907}', 150000, 0),
(41, 'lester', '{\"x\":-597.1287231445313,\"y\":851.828125,\"z\":210.4842071533203}', 150000, 0),
(42, 'nice', '{\"x\":-494.42401123046877,\"y\":795.8173828125,\"z\":183.39340209960938}', 450000, 0),
(43, 'mansion', '{\"x\":-495.45819091796877,\"y\":738.9638061523438,\"z\":162.08070373535157}', 750000, 0),
(44, 'nice', '{\"x\":-533.0499877929688,\"y\":709.0921020507813,\"z\":152.13070678710938}', 450000, 0),
(45, 'nice', '{\"x\":-686.1759033203125,\"y\":596.1190185546875,\"z\":142.69200134277345}', 450000, 0),
(46, 'nice', '{\"x\":-732.7766723632813,\"y\":594.086181640625,\"z\":141.1907958984375}', 450000, 0),
(47, 'nice', '{\"x\":-752.8132934570313,\"y\":620.974609375,\"z\":141.55650329589845}', 450000, 0),
(48, 'mansion', '{\"x\":-699.1110229492188,\"y\":706.7750854492188,\"z\":156.99630737304688}', 750000, 0),
(49, 'nice', '{\"x\":-476.8587951660156,\"y\":648.3369750976563,\"z\":143.4365997314453}', 450000, 0),
(50, 'mansion', '{\"x\":-400.098388671875,\"y\":665.4254150390625,\"z\":162.8802032470703}', 750000, 0),
(51, 'nice', '{\"x\":-353.2795104980469,\"y\":667.8524780273438,\"z\":168.11900329589845}', 450000, 0),
(52, 'nice', '{\"x\":-299.8464050292969,\"y\":635.0609130859375,\"z\":174.73170471191407}', 450000, 0),
(53, 'nice', '{\"x\":-293.52978515625,\"y\":601.4298706054688,\"z\":180.62550354003907}', 450000, 0),
(54, 'nice', '{\"x\":-232.61129760742188,\"y\":588.7606811523438,\"z\":189.58619689941407}', 450000, 0),
(55, 'nice', '{\"x\":-189.13409423828126,\"y\":617.6110229492188,\"z\":198.71249389648438}', 450000, 0),
(56, 'nice', '{\"x\":-185.30760192871095,\"y\":591.8223266601563,\"z\":196.87100219726563}', 450000, 0),
(57, 'mansion', '{\"x\":-126.82649993896485,\"y\":588.7379150390625,\"z\":203.56680297851563}', 750000, 0),
(58, 'nice', '{\"x\":-527.0712280273438,\"y\":517.5831909179688,\"z\":111.99120330810547}', 450000, 0),
(59, 'nice', '{\"x\":-580.6823120117188,\"y\":492.38800048828127,\"z\":107.95120239257813}', 450000, 0),
(60, 'mansion', '{\"x\":-640.75341796875,\"y\":519.7141723632813,\"z\":108.73780059814453}', 750000, 0),
(61, 'mansion', '{\"x\":-667.3151245117188,\"y\":471.9706115722656,\"z\":113.1884994506836}', 750000, 0),
(62, 'nice', '{\"x\":-678.8621215820313,\"y\":511.72918701171877,\"z\":112.57599639892578}', 450000, 0),
(63, 'mansion', '{\"x\":-718.1337280273438,\"y\":449.260009765625,\"z\":105.95909881591797}', 750000, 0),
(64, 'nice', '{\"x\":-762.3024291992188,\"y\":431.52801513671877,\"z\":99.22505187988281}', 450000, 0),
(65, 'nice', '{\"x\":-784.1950073242188,\"y\":459.1264953613281,\"z\":99.22904205322266}', 450000, 0),
(66, 'nice', '{\"x\":-824.7244873046875,\"y\":422.07879638671877,\"z\":91.17418670654297}', 450000, 0),
(67, 'nice', '{\"x\":-843.2042236328125,\"y\":466.74700927734377,\"z\":86.6477279663086}', 450000, 0),
(68, 'nice', '{\"x\":-848.961669921875,\"y\":508.8512878417969,\"z\":89.86675262451172}', 450000, 0),
(69, 'nice', '{\"x\":-883.855224609375,\"y\":518.0172729492188,\"z\":91.49284362792969}', 450000, 0),
(70, 'mansion', '{\"x\":-905.24658203125,\"y\":587.4351806640625,\"z\":100.04090118408203}', 750000, 0),
(71, 'nice', '{\"x\":-924.6613159179688,\"y\":561.7769775390625,\"z\":98.99629211425781}', 450000, 0),
(72, 'nice', '{\"x\":-947.9395141601563,\"y\":568.203125,\"z\":100.527099609375}', 450000, 0),
(73, 'nice', '{\"x\":-974.3864135742188,\"y\":582.1177978515625,\"z\":101.97810363769531}', 450000, 0),
(74, 'nice', '{\"x\":-1022.6699829101563,\"y\":587.364501953125,\"z\":102.28350067138672}', 450000, 0),
(75, 'nice', '{\"x\":-1107.261962890625,\"y\":593.9844970703125,\"z\":103.50399780273438}', 450000, 0),
(76, 'nice', '{\"x\":-1125.425048828125,\"y\":548.6654052734375,\"z\":101.61920166015625}', 450000, 0),
(77, 'nice', '{\"x\":-1146.4339599609376,\"y\":545.8892822265625,\"z\":100.95369720458985}', 450000, 0),
(78, 'nice', '{\"x\":-1193.072998046875,\"y\":563.761474609375,\"z\":99.38944244384766}', 450000, 0),
(79, 'nice', '{\"x\":-970.9652709960938,\"y\":456.0506896972656,\"z\":78.85919189453125}', 450000, 0),
(80, 'mansion', '{\"x\":-967.3018188476563,\"y\":510.3299865722656,\"z\":81.11641693115235}', 750000, 0),
(81, 'nice', '{\"x\":-987.416015625,\"y\":487.6513977050781,\"z\":81.31524658203125}', 450000, 0),
(82, 'nice', '{\"x\":-1052.02099609375,\"y\":432.3935852050781,\"z\":76.12246704101563}', 450000, 0),
(83, 'nice', '{\"x\":-1094.1839599609376,\"y\":427.4130859375,\"z\":74.93000793457031}', 450000, 0),
(84, 'nice', '{\"x\":-1122.762939453125,\"y\":485.6831970214844,\"z\":81.21085357666016}', 450000, 0),
(85, 'nice', '{\"x\":-1174.9530029296876,\"y\":440.31561279296877,\"z\":85.8994369506836}', 450000, 0),
(86, 'nice', '{\"x\":-1215.7030029296876,\"y\":458.46771240234377,\"z\":90.9036865234375}', 450000, 0),
(87, 'lester', '{\"x\":-1294.4229736328126,\"y\":454.8558044433594,\"z\":96.52876281738281}', 150000, 0),
(88, 'nice', '{\"x\":-1308.1939697265626,\"y\":449.26409912109377,\"z\":100.0197982788086}', 450000, 0),
(89, 'nice', '{\"x\":-1413.60205078125,\"y\":462.2876892089844,\"z\":108.25859832763672}', 450000, 0),
(90, 'nice', '{\"x\":-1404.8590087890626,\"y\":561.2164916992188,\"z\":124.456298828125}', 450000, 0),
(91, 'nice', '{\"x\":-1346.741943359375,\"y\":560.8566284179688,\"z\":129.5814971923828}', 450000, 0),
(92, 'lester', '{\"x\":-1366.824951171875,\"y\":611.169189453125,\"z\":132.95590209960938}', 150000, 0),
(93, 'nice', '{\"x\":-1337.7559814453126,\"y\":606.1082153320313,\"z\":133.42979431152345}', 450000, 0),
(94, 'nice', '{\"x\":-1291.7220458984376,\"y\":650.06640625,\"z\":140.55130004882813}', 450000, 0),
(95, 'nice', '{\"x\":-1248.572021484375,\"y\":643.0164794921875,\"z\":141.747802734375}', 450000, 0),
(96, 'nice', '{\"x\":-1241.2509765625,\"y\":674.0632934570313,\"z\":141.86349487304688}', 450000, 0),
(97, 'nice', '{\"x\":-1219.115966796875,\"y\":665.676025390625,\"z\":143.5832977294922}', 450000, 0),
(98, 'nice', '{\"x\":-1197.6800537109376,\"y\":693.6865844726563,\"z\":146.43890380859376}', 450000, 0),
(99, 'lester', '{\"x\":-1165.6500244140626,\"y\":727.1096801757813,\"z\":154.6566925048828}', 150000, 0),
(100, 'nice', '{\"x\":-1130.0260009765626,\"y\":784.1541748046875,\"z\":162.93699645996095}', 450000, 0),
(101, 'nice', '{\"x\":-1100.4239501953126,\"y\":797.4185791015625,\"z\":166.3083038330078}', 450000, 0),
(102, 'nice', '{\"x\":-1056.18505859375,\"y\":761.752685546875,\"z\":166.3686065673828}', 450000, 0),
(103, 'nice', '{\"x\":-999.0889892578125,\"y\":816.4957275390625,\"z\":172.09719848632813}', 450000, 0),
(104, 'nice', '{\"x\":-962.6514282226563,\"y\":813.8961181640625,\"z\":176.61570739746095}', 450000, 0),
(105, 'lester', '{\"x\":-912.3673095703125,\"y\":777.6082153320313,\"z\":186.0594024658203}', 150000, 0),
(106, 'nice', '{\"x\":-867.3571166992188,\"y\":785.290771484375,\"z\":190.98379516601563}', 450000, 0),
(107, 'nice', '{\"x\":-824.052490234375,\"y\":806.051513671875,\"z\":201.83250427246095}', 450000, 0),
(108, 'nice', '{\"x\":-1065.2779541015626,\"y\":727.3834838867188,\"z\":164.52459716796876}', 450000, 0),
(109, 'lester', '{\"x\":-1019.85498046875,\"y\":719.11279296875,\"z\":163.0460968017578}', 150000, 0),
(110, 'nice', '{\"x\":-931.4409790039063,\"y\":691.4453125,\"z\":152.51669311523438}', 450000, 0),
(111, 'nice', '{\"x\":-908.8555908203125,\"y\":693.87841796875,\"z\":150.48609924316407}', 450000, 0),
(112, 'nice', '{\"x\":-885.5114135742188,\"y\":699.32568359375,\"z\":150.3199005126953}', 450000, 0),
(113, 'lester', '{\"x\":-853.5562133789063,\"y\":696.361572265625,\"z\":147.83090209960938}', 150000, 0),
(114, 'nice', '{\"x\":-819.3508911132813,\"y\":696.5076904296875,\"z\":147.15420532226563}', 450000, 0),
(115, 'nice', '{\"x\":-765.37109375,\"y\":650.6353149414063,\"z\":144.7480926513672}', 450000, 0),
(116, 'trailer', '{\"x\":1632.530029296875,\"y\":3719.43701171875,\"z\":34.04853820800781}', 75000, 0),
(117, 'trailer', '{\"x\":1733.47802734375,\"y\":3808.677978515625,\"z\":34.12612915039062}', 75000, 0),
(118, 'trailer', '{\"x\":1760.14599609375,\"y\":3821.47900390625,\"z\":34.7677993774414}', 75000, 0),
(119, 'trailer', '{\"x\":1777.5679931640626,\"y\":3799.884033203125,\"z\":34.52312088012695}', 75000, 0),
(120, 'trailer', '{\"x\":1777.1829833984376,\"y\":3737.909912109375,\"z\":33.70544052124023}', 75000, 0),
(121, 'trailer', '{\"x\":1748.654052734375,\"y\":3783.681884765625,\"z\":33.88486862182617}', 75000, 0),
(122, 'trailer', '{\"x\":1639.6510009765626,\"y\":3731.573974609375,\"z\":34.11709976196289}', 75000, 0),
(123, 'trailer', '{\"x\":1642.6199951171876,\"y\":3727.39697265625,\"z\":34.11709976196289}', 75000, 0),
(124, 'trailer', '{\"x\":1691.5269775390626,\"y\":3866.06298828125,\"z\":33.95724105834961}', 75000, 0),
(125, 'trailer', '{\"x\":1700.3389892578126,\"y\":3867.1298828125,\"z\":33.94834899902344}', 75000, 0),
(126, 'trailer', '{\"x\":1733.616943359375,\"y\":3895.489990234375,\"z\":34.60903930664062}', 75000, 0),
(127, 'trailer', '{\"x\":1786.594970703125,\"y\":3913.041015625,\"z\":33.96126174926758}', 75000, 0),
(128, 'lester', '{\"x\":1803.4420166015626,\"y\":3913.945068359375,\"z\":36.10694885253906}', 150000, 0),
(129, 'lester', '{\"x\":1809.0810546875,\"y\":3907.696044921875,\"z\":32.79610824584961}', 150000, 0),
(130, 'trailer', '{\"x\":1838.583984375,\"y\":3907.39599609375,\"z\":32.38100814819336}', 75000, 0),
(131, 'trailer', '{\"x\":1841.9110107421876,\"y\":3928.6220703125,\"z\":32.77209091186523}', 75000, 0),
(132, 'lester', '{\"x\":1880.2879638671876,\"y\":3920.64599609375,\"z\":32.25875854492187}', 150000, 0),
(133, 'trailer', '{\"x\":1895.43798828125,\"y\":3873.758056640625,\"z\":31.8044490814209}', 75000, 0),
(134, 'trailer', '{\"x\":1888.4749755859376,\"y\":3892.89306640625,\"z\":32.22338104248047}', 75000, 0),
(135, 'lester', '{\"x\":1943.6820068359376,\"y\":3804.373046875,\"z\":31.08716011047363}', 150000, 0),
(136, 'lester', '{\"x\":-374.5137939453125,\"y\":6190.9580078125,\"z\":30.77953910827636}', 150000, 0),
(137, 'lester', '{\"x\":-356.8976135253906,\"y\":6207.4541015625,\"z\":30.89236068725586}', 150000, 0),
(138, 'lester', '{\"x\":-347.4773864746094,\"y\":6225.40087890625,\"z\":30.93763923645019}', 150000, 0),
(139, 'lester', '{\"x\":-360.1221923828125,\"y\":6260.69384765625,\"z\":30.95252990722656}', 150000, 0),
(140, 'lester', '{\"x\":-407.23968505859377,\"y\":6314.18798828125,\"z\":27.99109077453613}', 150000, 0),
(141, 'trevor', '{\"x\":-359.7261047363281,\"y\":6334.634765625,\"z\":28.90011024475097}', 350000, 0),
(142, 'lester', '{\"x\":-332.5201110839844,\"y\":6302.31884765625,\"z\":32.12770080566406}', 150000, 0),
(143, 'lester', '{\"x\":-302.2420959472656,\"y\":6326.9169921875,\"z\":31.93611907958984}', 150000, 0),
(144, 'lester', '{\"x\":-280.5108947753906,\"y\":6350.701171875,\"z\":31.64801025390625}', 150000, 0),
(145, 'lester', '{\"x\":-247.7366943359375,\"y\":6370.14697265625,\"z\":30.90242004394531}', 150000, 0),
(146, 'lester', '{\"x\":-227.1403045654297,\"y\":6377.43017578125,\"z\":30.80915069580078}', 150000, 0),
(147, 'lester', '{\"x\":-272.4501037597656,\"y\":6400.94287109375,\"z\":30.45620918273925}', 150000, 0),
(148, 'lester', '{\"x\":-246.12770080566407,\"y\":6413.9482421875,\"z\":30.5086498260498}', 150000, 0),
(149, 'lester', '{\"x\":-213.84559631347657,\"y\":6396.2900390625,\"z\":32.13463973999023}', 150000, 0),
(150, 'lester', '{\"x\":-188.93359375,\"y\":6409.4658203125,\"z\":31.34683990478515}', 150000, 0),
(151, 'lester', '{\"x\":-215.0478973388672,\"y\":6444.32421875,\"z\":30.3631591796875}', 150000, 0),
(152, 'lester', '{\"x\":-15.28662967681884,\"y\":6557.60595703125,\"z\":32.29037857055664}', 150000, 0),
(153, 'lester', '{\"x\":4.47418022155761,\"y\":6568.0859375,\"z\":32.12141036987305}', 150000, 0),
(154, 'lester', '{\"x\":30.94100952148437,\"y\":6596.576171875,\"z\":31.85994911193847}', 150000, 0),
(155, 'lester', '{\"x\":-9.35308074951171,\"y\":6654.244140625,\"z\":30.44062042236328}', 150000, 0),
(156, 'lester', '{\"x\":-41.70463943481445,\"y\":6637.40087890625,\"z\":30.1366901397705}', 150000, 0),
(157, 'lester', '{\"x\":-34.11275863647461,\"y\":-1846.8740234375,\"z\":25.24352073669433}', 150000, 0),
(158, 'lester', '{\"x\":-20.60475921630859,\"y\":-1858.613037109375,\"z\":24.45816993713379}', 150000, 0),
(159, 'lester', '{\"x\":21.12751960754394,\"y\":-1844.6500244140626,\"z\":23.65169906616211}', 150000, 0),
(160, 'lester', '{\"x\":-5.16767406463623,\"y\":-1871.823974609375,\"z\":23.20046997070312}', 150000, 0),
(161, 'lester', '{\"x\":4.92084312438964,\"y\":-1884.343994140625,\"z\":22.74724960327148}', 150000, 0),
(162, 'lester', '{\"x\":46.00617980957031,\"y\":-1864.281005859375,\"z\":22.32830047607422}', 150000, 0),
(163, 'lester', '{\"x\":23.06887054443359,\"y\":-1896.68701171875,\"z\":22.0528392791748}', 150000, 0),
(164, 'lester', '{\"x\":54.56005096435547,\"y\":-1873.2020263671876,\"z\":21.87973976135254}', 150000, 0),
(165, 'lester', '{\"x\":38.99372863769531,\"y\":-1911.6409912109376,\"z\":21.00349998474121}', 150000, 0),
(166, 'lester', '{\"x\":56.53649139404297,\"y\":-1922.5980224609376,\"z\":20.96063041687011}', 150000, 0),
(167, 'lester', '{\"x\":100.85590362548828,\"y\":-1912.47705078125,\"z\":20.45294952392578}', 150000, 0),
(168, 'lester', '{\"x\":72.05095672607422,\"y\":-1938.9439697265626,\"z\":20.41856956481933}', 150000, 0),
(169, 'lester', '{\"x\":76.55005645751953,\"y\":-1948.3819580078126,\"z\":20.22415924072265}', 150000, 0),
(170, 'lester', '{\"x\":85.69458770751953,\"y\":-1959.39697265625,\"z\":20.17106056213379}', 150000, 0),
(171, 'lester', '{\"x\":114.5376968383789,\"y\":-1961.072998046875,\"z\":20.36113929748535}', 150000, 0),
(172, 'lester', '{\"x\":126.5083999633789,\"y\":-1929.905029296875,\"z\":20.43240928649902}', 150000, 0),
(173, 'lester', '{\"x\":104.08090209960938,\"y\":-1885.3480224609376,\"z\":23.3687801361084}', 150000, 0),
(174, 'lester', '{\"x\":130.7884979248047,\"y\":-1853.3330078125,\"z\":24.32526969909668}', 150000, 0),
(175, 'lester', '{\"x\":150.04629516601563,\"y\":-1864.904052734375,\"z\":23.63022994995117}', 150000, 0),
(176, 'lester', '{\"x\":127.75759887695313,\"y\":-1897.176025390625,\"z\":22.71497917175293}', 150000, 0),
(177, 'lester', '{\"x\":148.6717071533203,\"y\":-1904.125,\"z\":22.54187965393066}', 150000, 0),
(178, 'lester', '{\"x\":171.31500244140626,\"y\":-1871.39697265625,\"z\":23.45022964477539}', 150000, 0),
(179, 'lester', '{\"x\":192.45140075683595,\"y\":-1883.4520263671876,\"z\":24.15228080749511}', 150000, 0),
(180, 'lester', '{\"x\":179.0854949951172,\"y\":-1924.2640380859376,\"z\":20.4210205078125}', 150000, 0),
(181, 'lester', '{\"x\":165.5446014404297,\"y\":-1945.0260009765626,\"z\":19.27413940429687}', 150000, 0),
(182, 'lester', '{\"x\":148.8780059814453,\"y\":-1960.5269775390626,\"z\":18.54301071166992}', 150000, 0),
(183, 'lester', '{\"x\":143.86380004882813,\"y\":-1968.9610595703126,\"z\":17.90508079528808}', 150000, 0),
(184, 'lester', '{\"x\":236.57009887695313,\"y\":-2045.9560546875,\"z\":17.42999076843261}', 150000, 0),
(185, 'lester', '{\"x\":256.685302734375,\"y\":-2023.3990478515626,\"z\":18.38438987731933}', 150000, 0),
(186, 'lester', '{\"x\":279.556396484375,\"y\":-1993.748046875,\"z\":19.891939163208}', 150000, 0),
(187, 'lester', '{\"x\":291.3570861816406,\"y\":-1980.2860107421876,\"z\":20.64545059204101}', 150000, 0),
(188, 'lester', '{\"x\":295.8619079589844,\"y\":-1971.990966796875,\"z\":21.81773948669433}', 150000, 0),
(189, 'lester', '{\"x\":312.06988525390627,\"y\":-1956.2850341796876,\"z\":23.66682052612304}', 150000, 0),
(190, 'lester', '{\"x\":324.42138671875,\"y\":-1937.9329833984376,\"z\":24.06393051147461}', 150000, 0),
(191, 'lester', '{\"x\":319.8839111328125,\"y\":-1854.20703125,\"z\":26.56307029724121}', 150000, 0),
(192, 'lester', '{\"x\":329.2549133300781,\"y\":-1845.7490234375,\"z\":26.80142974853515}', 150000, 0),
(193, 'lester', '{\"x\":339.0870056152344,\"y\":-1829.2640380859376,\"z\":27.38430976867675}', 150000, 0),
(194, 'lester', '{\"x\":348.77081298828127,\"y\":-1820.5279541015626,\"z\":27.94408988952636}', 150000, 0),
(195, 'lester', '{\"x\":440.2500915527344,\"y\":-1829.9949951171876,\"z\":27.41186904907226}', 150000, 0),
(196, 'lester', '{\"x\":427.45001220703127,\"y\":-1841.81396484375,\"z\":27.50075912475586}', 150000, 0),
(197, 'lester', '{\"x\":412.5542907714844,\"y\":-1856.125,\"z\":26.37175941467285}', 150000, 0),
(198, 'lester', '{\"x\":399.5801086425781,\"y\":-1864.5909423828126,\"z\":25.76935958862304}', 150000, 0),
(199, 'lester', '{\"x\":385.0556945800781,\"y\":-1881.489990234375,\"z\":25.08609962463379}', 150000, 0),
(200, 'lester', '{\"x\":495.37091064453127,\"y\":-1823.4580078125,\"z\":27.91968917846679}', 150000, 0),
(201, 'lester', '{\"x\":512.5225219726563,\"y\":-1790.4329833984376,\"z\":27.96949958801269}', 150000, 0),
(202, 'lester', '{\"x\":472.17620849609377,\"y\":-1775.282958984375,\"z\":28.11978912353515}', 150000, 0),
(203, 'lester', '{\"x\":479.372802734375,\"y\":-1735.7320556640626,\"z\":28.20037078857422}', 150000, 0),
(204, 'lester', '{\"x\":489.68170166015627,\"y\":-1713.9730224609376,\"z\":28.72011947631836}', 150000, 0),
(205, 'lester', '{\"x\":500.44879150390627,\"y\":-1697.029052734375,\"z\":28.82995986938476}', 150000, 0),
(206, 'lester', '{\"x\":405.3066101074219,\"y\":-1751.10498046875,\"z\":28.76036071777343}', 150000, 0),
(207, 'lester', '{\"x\":419.1455993652344,\"y\":-1735.9320068359376,\"z\":28.65644073486328}', 150000, 0),
(208, 'lester', '{\"x\":431.0881042480469,\"y\":-1725.8089599609376,\"z\":28.651460647583}', 150000, 0),
(209, 'lester', '{\"x\":443.41241455078127,\"y\":-1707.2440185546876,\"z\":28.75728988647461}', 150000, 0),
(210, 'lester', '{\"x\":332.92388916015627,\"y\":-1741.041015625,\"z\":28.78051948547363}', 150000, 0),
(211, 'lester', '{\"x\":320.85589599609377,\"y\":-1760.2149658203126,\"z\":28.68787956237793}', 150000, 0),
(212, 'lester', '{\"x\":304.5138854980469,\"y\":-1775.3680419921876,\"z\":28.20438003540039}', 150000, 0),
(213, 'lester', '{\"x\":300.00518798828127,\"y\":-1784.344970703125,\"z\":27.48621940612793}', 150000, 0),
(214, 'lester', '{\"x\":288.7145080566406,\"y\":-1792.511962890625,\"z\":27.16629028320312}', 150000, 0),
(215, 'lester', '{\"x\":198.1999053955078,\"y\":-1725.60205078125,\"z\":28.71232032775879}', 150000, 0),
(216, 'lester', '{\"x\":216.56219482421876,\"y\":-1717.3070068359376,\"z\":28.72633934020996}', 150000, 0),
(217, 'lester', '{\"x\":249.60549926757813,\"y\":-1730.614013671875,\"z\":28.72248077392578}', 150000, 0),
(218, 'lester', '{\"x\":223.07040405273438,\"y\":-1702.9610595703126,\"z\":28.74216079711914}', 150000, 0),
(219, 'lester', '{\"x\":257.2825927734375,\"y\":-1723.1590576171876,\"z\":28.70379066467285}', 150000, 0),
(220, 'lester', '{\"x\":269.3035888671875,\"y\":-1712.8800048828126,\"z\":28.71730041503906}', 150000, 0),
(221, 'lester', '{\"x\":252.8022003173828,\"y\":-1670.6209716796876,\"z\":28.71315956115722}', 150000, 0),
(222, 'lester', '{\"x\":240.77520751953126,\"y\":-1687.9239501953126,\"z\":28.73524093627929}', 150000, 0),
(223, 'trevor', '{\"x\":1060.572021484375,\"y\":-378.39630126953127,\"z\":67.28117370605469}', 350000, 0),
(224, 'trevor', '{\"x\":1029.074951171875,\"y\":-408.5787048339844,\"z\":65.1752700805664}', 350000, 0),
(225, 'nice', '{\"x\":1044.2679443359376,\"y\":-449.1225891113281,\"z\":65.3031997680664}', 400000, 0),
(226, 'trevor', '{\"x\":1010.5189819335938,\"y\":-423.3440856933594,\"z\":64.39826965332031}', 350000, 0),
(227, 'trevor', '{\"x\":1014.4290161132813,\"y\":-469.0126953125,\"z\":63.55712890625}', 350000, 0),
(228, 'trevor', '{\"x\":987.8521728515625,\"y\":-433.585205078125,\"z\":62.94142913818359}', 350000, 0),
(229, 'trevor', '{\"x\":967.1243286132813,\"y\":-451.5813903808594,\"z\":61.84420013427734}', 350000, 0),
(230, 'trevor', '{\"x\":970.1668701171875,\"y\":-502.1628112792969,\"z\":61.19075012207031}', 350000, 0),
(231, 'nice', '{\"x\":943.9503784179688,\"y\":-463.34381103515627,\"z\":60.44573974609375}', 400000, 0),
(232, 'trevor', '{\"x\":945.9931030273438,\"y\":-518.9094848632813,\"z\":59.66810989379883}', 350000, 0),
(233, 'trevor', '{\"x\":921.9141845703125,\"y\":-478.1665954589844,\"z\":60.13360977172851}', 350000, 0),
(234, 'nice', '{\"x\":906.4796142578125,\"y\":-490.0975036621094,\"z\":58.48627090454101}', 400000, 0),
(235, 'lester', '{\"x\":878.5615844726563,\"y\":-498.1047058105469,\"z\":57.14323043823242}', 150000, 0),
(236, 'trevor', '{\"x\":862.4705810546875,\"y\":-509.7611999511719,\"z\":56.37899017333984}', 350000, 0),
(237, 'trevor', '{\"x\":850.8225708007813,\"y\":-532.6475219726563,\"z\":56.97534942626953}', 350000, 0),
(238, 'trevor', '{\"x\":893.1566772460938,\"y\":-540.6182861328125,\"z\":57.55649948120117}', 350000, 0),
(239, 'nice', '{\"x\":844.0634155273438,\"y\":-563.1956176757813,\"z\":56.88386917114258}', 400000, 0),
(240, 'trevor', '{\"x\":861.7772216796875,\"y\":-583.19140625,\"z\":57.20605850219726}', 350000, 0),
(241, 'trevor', '{\"x\":886.8756713867188,\"y\":-608.086181640625,\"z\":57.4929084777832}', 350000, 0),
(242, 'nice', '{\"x\":903.2581787109375,\"y\":-615.666015625,\"z\":57.50368118286133}', 400000, 0),
(243, 'trevor', '{\"x\":928.9735107421875,\"y\":-639.6768188476563,\"z\":57.28987121582031}', 350000, 0),
(244, 'trevor', '{\"x\":943.5170288085938,\"y\":-653.4185180664063,\"z\":57.47093963623047}', 350000, 0),
(245, 'nice', '{\"x\":960.40771484375,\"y\":-669.7490234375,\"z\":57.49974822998047}', 400000, 0),
(246, 'trevor', '{\"x\":970.8856201171875,\"y\":-701.3883056640625,\"z\":57.53192901611328}', 350000, 0),
(247, 'trevor', '{\"x\":979.3054809570313,\"y\":-716.3038940429688,\"z\":57.26874160766601}', 350000, 0),
(248, 'lester', '{\"x\":997.111328125,\"y\":-729.2736206054688,\"z\":56.86407089233398}', 150000, 0),
(249, 'trevor', '{\"x\":1090.0069580078126,\"y\":-484.2412109375,\"z\":64.71035766601563}', 350000, 0),
(250, 'trevor', '{\"x\":1098.5870361328126,\"y\":-464.70379638671877,\"z\":66.36903381347656}', 350000, 0),
(251, 'trevor', '{\"x\":1099.4110107421876,\"y\":-438.3407897949219,\"z\":66.83293914794922}', 350000, 0),
(252, 'trevor', '{\"x\":1100.8370361328126,\"y\":-411.4032897949219,\"z\":66.6018295288086}', 350000, 0),
(253, 'trevor', '{\"x\":1046.2349853515626,\"y\":-497.9067077636719,\"z\":63.12947082519531}', 350000, 0),
(254, 'trevor', '{\"x\":1051.8499755859376,\"y\":-470.5256042480469,\"z\":62.94894027709961}', 350000, 0),
(255, 'trevor', '{\"x\":1056.177001953125,\"y\":-448.88580322265627,\"z\":65.30745697021485}', 350000, 0),
(256, 'trevor', '{\"x\":964.1450805664063,\"y\":-596.046875,\"z\":58.95257949829101}', 350000, 0),
(257, 'lester', '{\"x\":976.3568725585938,\"y\":-579.2255249023438,\"z\":58.68561172485351}', 150000, 0),
(258, 'trevor', '{\"x\":1009.9130249023438,\"y\":-572.3914184570313,\"z\":59.64313888549805}', 350000, 0),
(259, 'trevor', '{\"x\":1229.2860107421876,\"y\":-725.4603271484375,\"z\":59.84466934204101}', 350000, 0),
(260, 'lester', '{\"x\":1222.5980224609376,\"y\":-697.0645141601563,\"z\":59.85625076293945}', 150000, 0),
(261, 'trevor', '{\"x\":1221.362060546875,\"y\":-669.0396728515625,\"z\":62.54291915893555}', 350000, 0),
(262, 'trevor', '{\"x\":1206.8179931640626,\"y\":-620.2753295898438,\"z\":65.48861694335938}', 350000, 0),
(263, 'trevor', '{\"x\":1200.93896484375,\"y\":-575.8314819335938,\"z\":68.1892318725586}', 350000, 0),
(264, 'trevor', '{\"x\":1241.9239501953126,\"y\":-566.2299194335938,\"z\":68.70738220214844}', 350000, 0),
(265, 'trevor', '{\"x\":1240.510009765625,\"y\":-601.5778198242188,\"z\":68.83270263671875}', 350000, 0),
(266, 'trevor', '{\"x\":1251.303955078125,\"y\":-621.6561279296875,\"z\":68.46317291259766}', 350000, 0),
(267, 'trevor', '{\"x\":1265.5870361328126,\"y\":-648.352294921875,\"z\":66.9722671508789}', 350000, 0),
(268, 'trevor', '{\"x\":1270.9940185546876,\"y\":-683.5012817382813,\"z\":65.08128356933594}', 350000, 0),
(269, 'trevor', '{\"x\":1265.156982421875,\"y\":-703.1201171875,\"z\":63.61639022827148}', 350000, 0),
(270, 'lester', '{\"x\":1251.3260498046876,\"y\":-515.7340087890625,\"z\":68.3991470336914}', 150000, 0),
(271, 'trevor', '{\"x\":1251.593017578125,\"y\":-494.16180419921877,\"z\":68.9568862915039}', 350000, 0),
(272, 'trevor', '{\"x\":1260.58203125,\"y\":-479.6108093261719,\"z\":69.23887634277344}', 350000, 0),
(273, 'trevor', '{\"x\":1266.2919921875,\"y\":-457.9032897949219,\"z\":69.56670379638672}', 350000, 0),
(274, 'trevor', '{\"x\":1263.196044921875,\"y\":-429.37188720703127,\"z\":68.85603332519531}', 350000, 0),
(275, 'nice', '{\"x\":1301.0379638671876,\"y\":-574.0164184570313,\"z\":70.78176879882813}', 400000, 0),
(276, 'nice', '{\"x\":1302.89697265625,\"y\":-527.9202270507813,\"z\":70.51077270507813}', 400000, 0),
(277, 'nice', '{\"x\":1323.51904296875,\"y\":-582.8726196289063,\"z\":72.29634094238281}', 400000, 0),
(278, 'nice', '{\"x\":1348.259033203125,\"y\":-547.1375732421875,\"z\":72.9415512084961}', 400000, 0),
(279, 'nice', '{\"x\":1341.7869873046876,\"y\":-597.4871826171875,\"z\":73.75066375732422}', 400000, 0),
(280, 'nice', '{\"x\":1367.3160400390626,\"y\":-605.9420776367188,\"z\":73.76093292236328}', 400000, 0),
(281, 'nice', '{\"x\":1385.77197265625,\"y\":-593.0620727539063,\"z\":73.53543853759766}', 400000, 0),
(282, 'nice', '{\"x\":1388.7490234375,\"y\":-569.701171875,\"z\":73.54611206054688}', 400000, 0),
(283, 'nice', '{\"x\":1372.821044921875,\"y\":-555.698974609375,\"z\":73.73565673828125}', 400000, 0),
(284, 'nice', '{\"x\":1328.1800537109376,\"y\":-535.9559936523438,\"z\":71.49114227294922}', 400000, 0),
(285, 'kinda_nice', '{\"x\":1203.4749755859376,\"y\":-1671.0159912109376,\"z\":41.76279067993164}', 125000, 0),
(286, 'kinda_nice', '{\"x\":1220.2850341796876,\"y\":-1658.9549560546876,\"z\":47.68088150024414}', 125000, 0),
(287, 'kinda_nice', '{\"x\":1252.8060302734376,\"y\":-1638.5849609375,\"z\":52.17658996582031}', 125000, 0),
(288, 'kinda_nice', '{\"x\":1276.39501953125,\"y\":-1628.864013671875,\"z\":53.8273696899414}', 125000, 0),
(289, 'lester', '{\"x\":1297.35595703125,\"y\":-1618.011962890625,\"z\":53.63013076782226}', 150000, 0),
(290, 'kinda_nice', '{\"x\":1336.9639892578126,\"y\":-1579.0760498046876,\"z\":53.52740859985351}', 125000, 0),
(291, 'lester', '{\"x\":1437.1669921875,\"y\":-1492.4620361328126,\"z\":62.68135070800781}', 150000, 0),
(292, 'trailer', '{\"x\":1404.5830078125,\"y\":-1496.260986328125,\"z\":59.01226043701172}', 75000, 0),
(293, 'trailer', '{\"x\":1411.3900146484376,\"y\":-1490.81396484375,\"z\":59.70767974853515}', 75000, 0),
(294, 'lester', '{\"x\":1390.93994140625,\"y\":-1508.0880126953126,\"z\":57.48577880859375}', 150000, 0),
(295, 'lester', '{\"x\":1381.906005859375,\"y\":-1544.7969970703126,\"z\":56.1573486328125}', 150000, 0),
(296, 'kinda_nice', '{\"x\":1338.2879638671876,\"y\":-1524.47705078125,\"z\":53.6551399230957}', 125000, 0),
(297, 'kinda_nice', '{\"x\":1315.85595703125,\"y\":-1526.364013671875,\"z\":50.85356903076172}', 125000, 0),
(298, 'kinda_nice', '{\"x\":1327.47900390625,\"y\":-1552.9019775390626,\"z\":53.1015396118164}', 125000, 0),
(299, 'lester', '{\"x\":1286.64501953125,\"y\":-1604.1910400390626,\"z\":53.87475967407226}', 150000, 0),
(300, 'kinda_nice', '{\"x\":1230.72900390625,\"y\":-1590.9110107421876,\"z\":52.82479858398437}', 125000, 0),
(301, 'lester', '{\"x\":1261.345947265625,\"y\":-1616.60205078125,\"z\":53.79375076293945}', 150000, 0),
(302, 'kinda_nice', '{\"x\":1245.14404296875,\"y\":-1626.56298828125,\"z\":52.3319091796875}', 125000, 0),
(303, 'kinda_nice', '{\"x\":1210.6829833984376,\"y\":-1607.112060546875,\"z\":49.5815200805664}', 125000, 0),
(304, 'kinda_nice', '{\"x\":1214.2939453125,\"y\":-1644.031982421875,\"z\":47.69498062133789}', 125000, 0),
(305, 'kinda_nice', '{\"x\":1193.241943359375,\"y\":-1622.39599609375,\"z\":44.27138900756836}', 125000, 0),
(306, 'lester', '{\"x\":1193.2919921875,\"y\":-1656.072998046875,\"z\":42.07606887817383}', 150000, 0),
(307, 'kinda_nice', '{\"x\":1258.863037109375,\"y\":-1761.5009765625,\"z\":48.71435928344726}', 125000, 0),
(308, 'kinda_nice', '{\"x\":1250.8179931640626,\"y\":-1734.79296875,\"z\":51.08211135864258}', 125000, 0),
(309, 'lester', '{\"x\":1294.9759521484376,\"y\":-1739.7679443359376,\"z\":53.3220100402832}', 150000, 0),
(310, 'kinda_nice', '{\"x\":1289.490966796875,\"y\":-1711.032958984375,\"z\":54.54447937011719}', 125000, 0),
(311, 'lester', '{\"x\":1314.7669677734376,\"y\":-1732.9339599609376,\"z\":53.75003814697265}', 150000, 0),
(312, 'lester', '{\"x\":1316.885986328125,\"y\":-1698.85400390625,\"z\":57.27156066894531}', 150000, 0),
(313, 'kinda_nice', '{\"x\":1355.0660400390626,\"y\":-1690.5269775390626,\"z\":59.54116821289062}', 125000, 0),
(314, 'lester', '{\"x\":1365.324951171875,\"y\":-1721.376953125,\"z\":64.68388366699219}', 150000, 0),
(315, 'mansion', '{\"x\":-1135.864990234375,\"y\":375.7330017089844,\"z\":71.29975891113281}', 50000000, 0),
(316, 'mansion', '{\"x\":-447.6820068359375,\"y\":6271.76220703125,\"z\":33.33002090454101}', 50000000, 0),
(346, 'nice', '{\"x\":195.03074645996095,\"y\":3211.7197265625,\"z\":42.28659439086914}', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `licenses`
--

CREATE TABLE `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `licenses`
--

INSERT INTO `licenses` (`type`, `label`) VALUES
('chemicalslisence', 'Chemicals license'),
('dmv', 'Teorija za voznju'),
('drive', 'Vozacka dozvola'),
('drive_bike', 'Vozacka za motor'),
('drive_truck', 'Vozacka za kamion'),
('weapon', 'dozvola za posjedovanje oruzja'),
('weed_processing', 'Weed Processing License');

-- --------------------------------------------------------

--
-- Table structure for table `mafije`
--

CREATE TABLE `mafije` (
  `ID` int(11) NOT NULL,
  `Ime` varchar(60) NOT NULL,
  `Label` varchar(60) NOT NULL,
  `Rankovi` varchar(255) NOT NULL DEFAULT '{}',
  `Oruzarnica` varchar(250) NOT NULL DEFAULT '{}',
  `Lider` varchar(250) NOT NULL DEFAULT '{}',
  `SpawnV` varchar(250) NOT NULL DEFAULT '{}',
  `DeleteV` varchar(250) NOT NULL DEFAULT '{}',
  `LokVozila` varchar(250) NOT NULL DEFAULT '{}',
  `CrateDrop` varchar(250) NOT NULL DEFAULT '{}',
  `Vozila` longtext NOT NULL DEFAULT '{}',
  `Oruzja` longtext NOT NULL DEFAULT '{}',
  `Boje` varchar(255) NOT NULL DEFAULT '{}',
  `Ulaz` varchar(250) NOT NULL DEFAULT '{}',
  `Izlaz` varchar(250) NOT NULL DEFAULT '{}',
  `Gradonacelnik` int(11) NOT NULL DEFAULT 0,
  `DeleteV2` varchar(255) NOT NULL DEFAULT '{}',
  `LokVozila2` varchar(250) NOT NULL DEFAULT '{}',
  `Kokain` varchar(255) NOT NULL DEFAULT '{}',
  `KamionK` varchar(255) NOT NULL DEFAULT '{}',
  `Skladiste` int(5) NOT NULL DEFAULT 0,
  `Posao` int(11) NOT NULL DEFAULT 0,
  `KPosao` varchar(255) NOT NULL DEFAULT '{}',
  `PosaoSpawn` varchar(255) NOT NULL DEFAULT '{}'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mafije`
--

INSERT INTO `mafije` (`ID`, `Ime`, `Label`, `Rankovi`, `Oruzarnica`, `Lider`, `SpawnV`, `DeleteV`, `LokVozila`, `CrateDrop`, `Vozila`, `Oruzja`, `Boje`, `Ulaz`, `Izlaz`, `Gradonacelnik`, `DeleteV2`, `LokVozila2`, `Kokain`, `KamionK`, `Skladiste`, `Posao`, `KPosao`, `PosaoSpawn`) VALUES
(3, 'test', 'Test', '[{\"Ime\":\"Test\",\"ID\":0}]', '[226.26747131347657,-842.2459716796875,29.25794601440429]', '[226.26747131347657,-842.2459716796875,29.25794601440429]', '[228.4384002685547,-847.6431274414063,29.15518569946289]', '[216.63900756835938,-846.9087524414063,29.3080997467041]', '[209.24130249023438,-841.5880737304688,29.61085128784179,63.80375289916992]', '{}', '{}', '{}', '{}', '[210.4995880126953,-834.4686889648438,29.6725959777832]', '{}', 0, '{}', '{}', '{}', '{}', 0, 1, '[311.0863952636719,-857.6184692382813,28.3426399230957]', '[305.8469543457031,-856.6913452148438,28.23912620544433,92.25516510009766]'),
(4, 'test2', 'Test 2', '[{\"ID\":0,\"Ime\":\"Test\"}]', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', 0, '{}', '{}', '{}', '{}', 0, 1, '[299.21368408203127,-837.381591796875,28.2196044921875]', '[301.5842590332031,-830.746826171875,28.32886886596679,342.5087585449219]');

-- --------------------------------------------------------

--
-- Table structure for table `mete`
--

CREATE TABLE `mete` (
  `ID` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `cijena` int(11) NOT NULL,
  `ime` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mete`
--

INSERT INTO `mete` (`ID`, `identifier`, `cijena`, `ime`) VALUES
(2, 'steam:11000010a1d1042', 40000, 'chame'),
(6, 'steam:110000106921eea', 30000, 'Ficho'),
(7, 'steam:11000010e086b7e', 80000, 'LJANTU'),
(8, 'steam:11000010441bee9', 40000, '#Sikora');

-- --------------------------------------------------------

--
-- Table structure for table `minute`
--

CREATE TABLE `minute` (
  `identifier` varchar(255) NOT NULL,
  `minute` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `minute`
--

INSERT INTO `minute` (`identifier`, `minute`) VALUES
('steam:11000010441bee9', 8500),
('steam:11000010a1d1042', 580),
('steam:110000115e9ac6b', 115),
('steam:11000010e086b7e', 2270),
('steam:11000010ad5cf80', 320),
('steam:110000106921eea', 805),
('steam:110000111cd0aa0', 260),
('steam:11000014694839f', 10);

-- --------------------------------------------------------

--
-- Table structure for table `mskladiste`
--

CREATE TABLE `mskladiste` (
  `ID` int(11) NOT NULL,
  `ime` varchar(255) NOT NULL,
  `listovi` int(11) NOT NULL,
  `kokain` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `narudzbe`
--

CREATE TABLE `narudzbe` (
  `ID` int(11) NOT NULL,
  `Firma` int(11) NOT NULL,
  `Dobavljac` int(11) NOT NULL,
  `Kolicina` int(11) NOT NULL,
  `Rezervirano` int(11) NOT NULL DEFAULT 0,
  `Cijena` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `owned_properties`
--

CREATE TABLE `owned_properties` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `rented` int(11) NOT NULL,
  `owner` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `owned_vehicles`
--

CREATE TABLE `owned_vehicles` (
  `owner` varchar(22) NOT NULL,
  `state` int(1) NOT NULL DEFAULT 1 COMMENT 'State vozila',
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` int(1) NOT NULL DEFAULT 0,
  `lasthouse` int(11) DEFAULT 0,
  `mjenjac` int(11) NOT NULL DEFAULT 1,
  `brod` int(11) NOT NULL DEFAULT 0,
  `model` varchar(255) NOT NULL,
  `kilometri` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `owned_vehicles`
--

INSERT INTO `owned_vehicles` (`owner`, `state`, `plate`, `vehicle`, `type`, `job`, `stored`, `lasthouse`, `mjenjac`, `brod`, `model`, `kilometri`) VALUES
('steam:11000010e086b7e', 1, 'CFQ 560', '{\"plate\":\"CFQ 560\",\"modSpeakers\":-1,\"modSeats\":-1,\"modBackWheels\":-1,\"color2\":27,\"modEngineBlock\":-1,\"extras\":[],\"modLivery\":-1,\"modVanityPlate\":-1,\"modHood\":-1,\"modFrame\":-1,\"modHydrolic\":-1,\"modHorns\":-1,\"windowTint\":-1,\"modDoorSpeaker\":-1,\"fuel\":64.91604614257813,\"modRoof\":-1,\"modFrontWheels\":-1,\"modOrnaments\":-1,\"modBrakes\":-1,\"modWindows\":-1,\"modDashboard\":-1,\"modAerials\":-1,\"modGrille\":-1,\"pearlescentColor\":4,\"modSmokeEnabled\":false,\"modAPlate\":-1,\"modFender\":-1,\"modSpoilers\":-1,\"modTank\":-1,\"modExhaust\":-1,\"neonEnabled\":[false,false,false,false],\"modTrunk\":-1,\"wheelColor\":156,\"modPlateHolder\":-1,\"model\":54844044,\"modRearBumper\":-1,\"neonColor\":[255,0,255],\"modTurbo\":false,\"health\":1000,\"modArchCover\":-1,\"modXenon\":false,\"color1\":27,\"modSuspension\":-1,\"plateIndex\":0,\"modStruts\":-1,\"modRightFender\":-1,\"modSideSkirt\":-1,\"modAirFilter\":-1,\"modTrimB\":-1,\"wheels\":0,\"dirtLevel\":0.0,\"modTrimA\":-1,\"modEngine\":-1,\"modSteeringWheel\":-1,\"modTransmission\":-1,\"modFrontBumper\":-1,\"modDial\":-1,\"svijetlaColor\":255,\"modArmor\":-1,\"tyreSmokeColor\":[255,255,255],\"modShifterLeavers\":-1}', 'car', NULL, 0, 0, 2, 0, '54844044', 0),
('steam:11000010441bee9', 0, 'FVM 738', '{\"fuel\":65.0,\"modSpeakers\":-1,\"wheels\":1,\"modFender\":-1,\"modEngine\":-1,\"modAirFilter\":-1,\"modEngineBlock\":-1,\"windowTint\":-1,\"modSeats\":-1,\"plate\":\"FVM 738\",\"modPlateHolder\":-1,\"modStruts\":-1,\"modRearBumper\":-1,\"modArchCover\":-1,\"modTrimA\":-1,\"modBrakes\":-1,\"tyreSmokeColor\":[255,255,255],\"modRightFender\":-1,\"wheelColor\":156,\"modTank\":-1,\"modFrame\":-1,\"neonColor\":[255,0,255],\"modBackWheels\":-1,\"color2\":0,\"modTransmission\":-1,\"modHorns\":-1,\"modSuspension\":-1,\"modWindows\":-1,\"modTrunk\":-1,\"modLivery\":-1,\"modHood\":-1,\"modShifterLeavers\":-1,\"modHydrolic\":-1,\"extras\":{\"2\":true,\"1\":true},\"neonEnabled\":[false,false,false,false],\"modSmokeEnabled\":false,\"plateIndex\":3,\"modXenon\":false,\"modAPlate\":-1,\"modFrontBumper\":-1,\"modDial\":-1,\"svijetlaColor\":255,\"modSideSkirt\":-1,\"modTurbo\":false,\"model\":-1687864389,\"modRoof\":-1,\"health\":1000,\"modGrille\":-1,\"modTrimB\":-1,\"modOrnaments\":-1,\"modSpoilers\":-1,\"modSteeringWheel\":-1,\"modDashboard\":-1,\"modVanityPlate\":-1,\"pearlescentColor\":37,\"modDoorSpeaker\":-1,\"modExhaust\":-1,\"modFrontWheels\":-1,\"dirtLevel\":0.0,\"modAerials\":-1,\"color1\":0,\"modArmor\":-1}', 'car', NULL, 0, 0, 2, 0, '-1687864389', 0),
('steam:11000010441bee9', 1, 'IYY 542', '{\"modTrimA\":-1,\"modSpeakers\":-1,\"modSmokeEnabled\":1,\"plate\":\"IYY 542\",\"modExhaust\":-1,\"modEngineBlock\":-1,\"modRoof\":-1,\"modFrontBumper\":-1,\"modTrimB\":-1,\"modOrnaments\":-1,\"color1\":0,\"modSideSkirt\":-1,\"wheels\":0,\"wheelColor\":156,\"modSeats\":-1,\"modFender\":-1,\"modSuspension\":-1,\"svijetlaColor\":255,\"modTank\":-1,\"health\":1000,\"modDashboard\":-1,\"neonColor\":[255,0,255],\"modShifterLeavers\":-1,\"modPlateHolder\":-1,\"model\":-1513691047,\"extras\":[],\"modFrame\":-1,\"modHydrolic\":-1,\"modSpoilers\":-1,\"modArchCover\":-1,\"neonEnabled\":[false,false,false,false],\"plateIndex\":4,\"modEngine\":-1,\"modStruts\":-1,\"modTrunk\":-1,\"modTurbo\":false,\"modRearBumper\":-1,\"modHood\":-1,\"modDoorSpeaker\":-1,\"modTransmission\":-1,\"modSteeringWheel\":-1,\"color2\":0,\"modRightFender\":-1,\"modDial\":-1,\"modAirFilter\":-1,\"pearlescentColor\":4,\"modAPlate\":-1,\"fuel\":64.64600372314453,\"modBackWheels\":-1,\"modArmor\":-1,\"modVanityPlate\":-1,\"modLivery\":4,\"tyreSmokeColor\":[255,255,255],\"modGrille\":-1,\"modHorns\":-1,\"modAerials\":-1,\"dirtLevel\":0.00752837536856,\"modWindows\":-1,\"modXenon\":false,\"modBrakes\":-1,\"modFrontWheels\":-1,\"windowTint\":-1}', 'car', NULL, 0, 0, 2, 0, '-1513691047', 0),
('steam:11000010441bee9', 1, 'JDL 417', '{\"modDashboard\":-1,\"color1\":0,\"modTrunk\":-1,\"svijetlaColor\":255,\"dirtLevel\":0.0,\"modArchCover\":-1,\"modTrimA\":-1,\"modAerials\":-1,\"modFrontWheels\":-1,\"modSpoilers\":-1,\"extras\":{\"7\":false,\"6\":true,\"9\":false,\"8\":false,\"12\":false,\"10\":false,\"1\":false,\"11\":true,\"3\":false,\"2\":false,\"5\":false,\"4\":false},\"modVanityPlate\":-1,\"modRoof\":-1,\"modRightFender\":-1,\"plate\":\"JDL 417\",\"modFrame\":-1,\"modArmor\":-1,\"modLivery\":1,\"modDoorSpeaker\":-1,\"wheels\":4,\"modOrnaments\":-1,\"modDial\":-1,\"modHydrolic\":-1,\"windowTint\":-1,\"modStruts\":-1,\"health\":1000,\"modTransmission\":-1,\"fuel\":262.5,\"model\":-1564056869,\"neonColor\":[255,0,255],\"pearlescentColor\":5,\"modHorns\":-1,\"modEngine\":-1,\"color2\":0,\"wheelColor\":156,\"modSteeringWheel\":-1,\"modBrakes\":-1,\"tyreSmokeColor\":[255,255,255],\"modFender\":-1,\"plateIndex\":2,\"modExhaust\":-1,\"modTrimB\":-1,\"modAirFilter\":-1,\"modSuspension\":-1,\"modGrille\":-1,\"modXenon\":false,\"modSideSkirt\":-1,\"modPlateHolder\":-1,\"modSmokeEnabled\":false,\"modSeats\":-1,\"modEngineBlock\":-1,\"modFrontBumper\":-1,\"modTank\":-1,\"modShifterLeavers\":-1,\"modAPlate\":-1,\"modBackWheels\":-1,\"modHood\":-1,\"modWindows\":-1,\"modRearBumper\":-1,\"modSpeakers\":-1,\"neonEnabled\":[false,false,false,false],\"modTurbo\":false}', 'car', NULL, 0, 0, 1, 0, '-1564056869', 0),
('steam:11000010441bee9', 0, 'MBB 665', '{\"plateIndex\":1,\"modPlateHolder\":-1,\"modHorns\":-1,\"modEngine\":-1,\"modSuspension\":-1,\"pearlescentColor\":112,\"modRoof\":-1,\"modRearBumper\":-1,\"modExhaust\":-1,\"modDial\":-1,\"modAerials\":-1,\"plate\":\"MBB 665\",\"modShifterLeavers\":-1,\"modFrame\":-1,\"modGrille\":-1,\"modDashboard\":-1,\"modRightFender\":-1,\"health\":1000,\"modSideSkirt\":-1,\"modStruts\":-1,\"modArchCover\":-1,\"fuel\":61.81498718261719,\"modFender\":-1,\"extras\":[],\"windowTint\":-1,\"modBackWheels\":-1,\"modBrakes\":-1,\"modWindows\":-1,\"modTrimA\":-1,\"tyreSmokeColor\":[255,255,255],\"model\":836213613,\"modSeats\":-1,\"color2\":0,\"modFrontWheels\":-1,\"modFrontBumper\":-1,\"modAirFilter\":-1,\"modSmokeEnabled\":1,\"neonEnabled\":[false,false,false,false],\"modDoorSpeaker\":-1,\"modTrimB\":-1,\"modSpoilers\":-1,\"modTank\":-1,\"svijetlaColor\":255,\"color1\":0,\"neonColor\":[255,0,255],\"modTurbo\":false,\"modSteeringWheel\":-1,\"modArmor\":-1,\"modLivery\":-1,\"modSpeakers\":-1,\"wheelColor\":0,\"modHydrolic\":-1,\"wheels\":7,\"modTransmission\":-1,\"modXenon\":false,\"dirtLevel\":4.32457065582275,\"modOrnaments\":-1,\"modHood\":-1,\"modAPlate\":-1,\"modVanityPlate\":-1,\"modEngineBlock\":-1,\"modTrunk\":-1}', 'car', NULL, 0, 0, 2, 0, '836213613', 16.768),
('steam:11000010441bee9', 1, 'NQE 362', '{\"modFrontWheels\":-1,\"plate\":\"NQE 362\",\"modEngineBlock\":-1,\"modFrontBumper\":-1,\"wheelColor\":156,\"modHydrolic\":-1,\"modLivery\":0,\"modTurbo\":false,\"windowTint\":-1,\"modOrnaments\":-1,\"modSeats\":-1,\"modBrakes\":-1,\"svijetlaColor\":255,\"modGrille\":-1,\"modTrimB\":-1,\"modPlateHolder\":-1,\"modFender\":-1,\"modAirFilter\":-1,\"modXenon\":false,\"modAPlate\":-1,\"color1\":27,\"tyreSmokeColor\":[255,255,255],\"modDial\":-1,\"neonEnabled\":[false,false,false,false],\"modSpeakers\":-1,\"modHorns\":-1,\"modArchCover\":-1,\"dirtLevel\":0.0,\"modAerials\":-1,\"modTank\":-1,\"health\":1000,\"modSideSkirt\":-1,\"modArmor\":-1,\"modWindows\":-1,\"modRoof\":-1,\"modTransmission\":-1,\"modHood\":-1,\"modEngine\":-1,\"extras\":{\"11\":false},\"modBackWheels\":-1,\"modShifterLeavers\":-1,\"modDoorSpeaker\":-1,\"pearlescentColor\":31,\"modSpoilers\":-1,\"plateIndex\":0,\"modRearBumper\":-1,\"modSmokeEnabled\":false,\"modSteeringWheel\":-1,\"modRightFender\":-1,\"modFrame\":-1,\"color2\":31,\"modSuspension\":-1,\"modTrunk\":-1,\"modDashboard\":-1,\"modTrimA\":-1,\"neonColor\":[255,0,255],\"model\":433374210,\"fuel\":64.87998962402344,\"modVanityPlate\":-1,\"modExhaust\":-1,\"wheels\":0,\"modStruts\":-1}', 'car', NULL, 0, 0, 2, 0, '433374210', 33.846),
('steam:11000010ad5cf80', 1, 'RLA 177', '{\"modAPlate\":-1,\"svijetlaColor\":255,\"modExhaust\":-1,\"modTrunk\":-1,\"modHydrolic\":-1,\"wheels\":7,\"modVanityPlate\":-1,\"health\":1000,\"modFrame\":-1,\"modSmokeEnabled\":false,\"modTurbo\":false,\"modTrimB\":-1,\"modDoorSpeaker\":-1,\"modWindows\":-1,\"modSpeakers\":-1,\"color1\":3,\"dirtLevel\":0.0,\"plateIndex\":0,\"modAirFilter\":-1,\"modDial\":-1,\"modArmor\":-1,\"neonColor\":[255,0,255],\"modEngine\":-1,\"modSpoilers\":-1,\"tyreSmokeColor\":[255,255,255],\"modTransmission\":-1,\"extras\":[],\"modPlateHolder\":-1,\"modRearBumper\":-1,\"modAerials\":-1,\"color2\":28,\"modArchCover\":-1,\"model\":-143695728,\"fuel\":64.70599365234375,\"modShifterLeavers\":-1,\"modSuspension\":-1,\"modFrontBumper\":-1,\"modSideSkirt\":-1,\"modEngineBlock\":-1,\"modDashboard\":-1,\"modTrimA\":-1,\"modHorns\":-1,\"modRoof\":-1,\"windowTint\":-1,\"neonEnabled\":[false,false,false,false],\"wheelColor\":4,\"modTank\":-1,\"plate\":\"RLA 177\",\"modXenon\":false,\"modGrille\":-1,\"modFender\":-1,\"modRightFender\":-1,\"modSteeringWheel\":-1,\"modOrnaments\":-1,\"modBrakes\":-1,\"modBackWheels\":-1,\"modFrontWheels\":-1,\"pearlescentColor\":156,\"modStruts\":-1,\"modSeats\":-1,\"modLivery\":-1,\"modHood\":-1}', 'car', NULL, 0, 0, 2, 0, '-143695728', 0.375),
('steam:11000010441bee9', 1, 'VDG 551', '{\"fuel\":65.0,\"modSpeakers\":-1,\"wheels\":0,\"modFender\":-1,\"modEngine\":-1,\"modAirFilter\":-1,\"modEngineBlock\":-1,\"windowTint\":-1,\"modSeats\":-1,\"plate\":\"VDG 551\",\"modPlateHolder\":-1,\"modStruts\":-1,\"modRearBumper\":-1,\"modArchCover\":-1,\"modTrimA\":-1,\"modBrakes\":-1,\"tyreSmokeColor\":[255,255,255],\"modRightFender\":-1,\"wheelColor\":15,\"modTank\":-1,\"modFrame\":-1,\"neonColor\":[255,0,255],\"modBackWheels\":-1,\"color2\":0,\"modTransmission\":-1,\"modHorns\":-1,\"modSuspension\":-1,\"modWindows\":-1,\"modTrunk\":-1,\"modLivery\":-1,\"modHood\":-1,\"modShifterLeavers\":-1,\"modHydrolic\":-1,\"extras\":{\"10\":true,\"3\":true,\"2\":true,\"5\":true},\"neonEnabled\":[false,false,false,false],\"modSmokeEnabled\":false,\"plateIndex\":0,\"modXenon\":false,\"modAPlate\":-1,\"modFrontBumper\":-1,\"modDial\":-1,\"svijetlaColor\":255,\"modSideSkirt\":-1,\"modTurbo\":false,\"model\":-1404319008,\"modRoof\":-1,\"health\":1000,\"modGrille\":-1,\"modTrimB\":-1,\"modOrnaments\":-1,\"modSpoilers\":-1,\"modSteeringWheel\":-1,\"modDashboard\":-1,\"modVanityPlate\":-1,\"pearlescentColor\":73,\"modDoorSpeaker\":-1,\"modExhaust\":-1,\"modFrontWheels\":-1,\"dirtLevel\":0.0,\"modAerials\":-1,\"color1\":0,\"modArmor\":-1}', 'car', NULL, 0, 0, 2, 0, '-1404319008', 0),
('steam:11000010441bee9', 1, 'WBU 561', '{\"modTrimA\":-1,\"modSpeakers\":-1,\"modSmokeEnabled\":1,\"plate\":\"WBU 561\",\"modExhaust\":-1,\"modEngineBlock\":-1,\"modRoof\":-1,\"modFrontBumper\":-1,\"modTrimB\":-1,\"modOrnaments\":-1,\"color1\":0,\"modSideSkirt\":-1,\"wheels\":0,\"wheelColor\":0,\"modSeats\":-1,\"modFender\":-1,\"modSuspension\":-1,\"svijetlaColor\":255,\"modTank\":-1,\"health\":1000,\"modDashboard\":-1,\"neonColor\":[255,0,255],\"modShifterLeavers\":-1,\"modPlateHolder\":-1,\"model\":-1752116803,\"extras\":[],\"modFrame\":-1,\"modHydrolic\":-1,\"modSpoilers\":-1,\"modArchCover\":-1,\"neonEnabled\":[false,false,false,false],\"plateIndex\":4,\"modEngine\":-1,\"modStruts\":-1,\"modTrunk\":-1,\"modTurbo\":false,\"modRearBumper\":-1,\"modHood\":-1,\"modDoorSpeaker\":-1,\"modTransmission\":-1,\"modSteeringWheel\":-1,\"color2\":0,\"modRightFender\":-1,\"modDial\":-1,\"modAirFilter\":-1,\"pearlescentColor\":6,\"modAPlate\":-1,\"fuel\":63.29600524902344,\"modBackWheels\":-1,\"modArmor\":-1,\"modVanityPlate\":-1,\"modLivery\":0,\"tyreSmokeColor\":[255,255,255],\"modGrille\":-1,\"modHorns\":-1,\"modAerials\":-1,\"dirtLevel\":0.11207189410924,\"modWindows\":-1,\"modXenon\":false,\"modBrakes\":-1,\"modFrontWheels\":-1,\"windowTint\":-1}', 'car', NULL, 0, 0, 2, 0, '-1752116803', 0),
('steam:110000111cd0aa0', 1, 'XIX 824', '{\"modAPlate\":-1,\"svijetlaColor\":255,\"modExhaust\":-1,\"modHydrolic\":-1,\"modRearBumper\":-1,\"wheels\":7,\"modVanityPlate\":-1,\"modGrille\":-1,\"modFrame\":-1,\"modSmokeEnabled\":false,\"modFender\":-1,\"modLivery\":-1,\"modDoorSpeaker\":-1,\"health\":1000,\"modSpeakers\":-1,\"color1\":21,\"modWindows\":-1,\"plateIndex\":1,\"modAirFilter\":-1,\"modDial\":-1,\"modArmor\":-1,\"neonColor\":[0,0,0],\"modEngine\":-1,\"modSpoilers\":-1,\"tyreSmokeColor\":[255,255,255],\"modTransmission\":-1,\"extras\":{\"1\":true,\"2\":false},\"modPlateHolder\":-1,\"dirtLevel\":0.0,\"modAerials\":-1,\"color2\":127,\"modArchCover\":-1,\"model\":1503141430,\"fuel\":64.62899780273438,\"modShifterLeavers\":-1,\"modSuspension\":-1,\"modFrontBumper\":-1,\"modSideSkirt\":-1,\"modEngineBlock\":-1,\"modDashboard\":-1,\"modTrimA\":-1,\"modHorns\":-1,\"modRoof\":-1,\"modHood\":-1,\"neonEnabled\":[false,false,false,false],\"wheelColor\":0,\"modTank\":-1,\"plate\":\"XIX 824\",\"modXenon\":false,\"modRightFender\":-1,\"modTurbo\":false,\"windowTint\":-1,\"modSteeringWheel\":-1,\"modOrnaments\":-1,\"modBrakes\":-1,\"modBackWheels\":-1,\"modFrontWheels\":-1,\"pearlescentColor\":1,\"modSeats\":-1,\"modStruts\":-1,\"modTrunk\":-1,\"modTrimB\":-1}', 'car', NULL, 0, 0, 1, 0, '1503141430', 0),
('steam:11000010a1d1042', 0, 'YJA 241', '{\"modFrame\":-1,\"modSpeakers\":-1,\"modSmokeEnabled\":1,\"neonEnabled\":[false,false,false,false],\"modRightFender\":-1,\"modRoof\":-1,\"modSpoilers\":-1,\"modFrontBumper\":-1,\"modArmor\":-1,\"modOrnaments\":-1,\"color1\":4,\"modSideSkirt\":-1,\"wheels\":1,\"wheelColor\":156,\"modSeats\":-1,\"modFender\":-1,\"modDoorSpeaker\":-1,\"svijetlaColor\":255,\"modTank\":-1,\"health\":991,\"modDashboard\":-1,\"modSuspension\":-1,\"modShifterLeavers\":-1,\"modPlateHolder\":-1,\"modRearBumper\":-1,\"model\":981770764,\"modTrunk\":-1,\"modFrontWheels\":-1,\"modEngineBlock\":-1,\"modArchCover\":-1,\"modAirFilter\":-1,\"modVanityPlate\":-1,\"modEngine\":-1,\"neonColor\":[255,0,255],\"modDial\":-1,\"modTurbo\":false,\"modHorns\":-1,\"plateIndex\":4,\"modStruts\":-1,\"modTransmission\":-1,\"modSteeringWheel\":-1,\"color2\":0,\"pearlescentColor\":4,\"modAPlate\":-1,\"modExhaust\":-1,\"modHydrolic\":-1,\"tyreSmokeColor\":[255,255,255],\"fuel\":62.55000305175781,\"modBackWheels\":-1,\"modTrimA\":-1,\"modTrimB\":-1,\"modLivery\":3,\"modGrille\":-1,\"dirtLevel\":0.17332875728607,\"modHood\":-1,\"modAerials\":-1,\"extras\":{\"7\":true,\"4\":false,\"11\":false,\"10\":true,\"8\":false,\"12\":false,\"2\":false,\"3\":false,\"1\":false},\"modWindows\":-1,\"modXenon\":false,\"modBrakes\":-1,\"plate\":\"YJA 241\",\"windowTint\":-1}', 'car', NULL, 0, 0, 1, 0, '981770764', 0),
('steam:11000010441bee9', 0, 'ZSP 493', '{\"pearlescentColor\":28,\"extras\":{\"2\":false},\"modEngineBlock\":-1,\"svijetlaColor\":255,\"modOrnaments\":-1,\"modSteeringWheel\":-1,\"modTransmission\":-1,\"modFrame\":-1,\"plate\":\"ZSP 493\",\"color1\":0,\"modDial\":-1,\"modArchCover\":-1,\"modFrontWheels\":-1,\"modDashboard\":-1,\"modBackWheels\":-1,\"model\":-1745789659,\"wheels\":0,\"windowTint\":-1,\"modSideSkirt\":-1,\"modBrakes\":-1,\"tyreSmokeColor\":[255,255,255],\"modArmor\":-1,\"modSpoilers\":-1,\"modAirFilter\":-1,\"modPlateHolder\":-1,\"modTurbo\":false,\"modLivery\":0,\"modDoorSpeaker\":-1,\"modTrimA\":-1,\"modSmokeEnabled\":1,\"modGrille\":-1,\"modHorns\":-1,\"modStruts\":-1,\"health\":1000,\"modWindows\":-1,\"modRearBumper\":-1,\"modAPlate\":-1,\"modTank\":-1,\"dirtLevel\":4.07459449768066,\"plateIndex\":3,\"fuel\":63.91397857666015,\"modSuspension\":-1,\"modFender\":-1,\"modTrimB\":-1,\"modRoof\":-1,\"modVanityPlate\":-1,\"wheelColor\":156,\"modExhaust\":-1,\"modSpeakers\":-1,\"modXenon\":false,\"color2\":0,\"neonColor\":[255,0,255],\"neonEnabled\":[false,false,false,false],\"modRightFender\":-1,\"modTrunk\":-1,\"modAerials\":-1,\"modHood\":-1,\"modFrontBumper\":-1,\"modShifterLeavers\":-1,\"modSeats\":-1,\"modHydrolic\":-1,\"modEngine\":-1}', 'car', NULL, 0, 0, 1, 0, '-1745789659', 17.336);

-- --------------------------------------------------------

--
-- Table structure for table `phone_app_chat`
--

CREATE TABLE `phone_app_chat` (
  `id` int(11) NOT NULL,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `identifier` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `phone_app_chat`
--

INSERT INTO `phone_app_chat` (`id`, `channel`, `message`, `time`, `identifier`) VALUES
(1, 'test', 'test', '2021-04-01 18:37:53', 'steam:110000100242687'),
(2, 'test', 'aaaa', '2021-04-01 18:41:04', 'steam:11000010441bee9'),
(3, 'ulicnetrke', 'aaaa', '2021-04-01 18:41:30', 'steam:11000010441bee9'),
(4, 'ulicnetrke', 'test', '2021-04-01 18:46:32', 'steam:11000010441bee9'),
(5, 'ulicnetrke', 'test', '2021-04-01 18:46:55', 'steam:11000010441bee9'),
(6, 'ulicnetrke', 'opaa', '2021-04-01 18:47:39', 'steam:11000010441bee9'),
(7, 'ulicnetrke', 'ko si ti jbt', '2021-04-01 18:47:43', 'steam:11000010441bee9'),
(8, 'ulicnetrke', 'ko je tebe zvao ovdje', '2021-04-01 18:47:47', 'steam:11000010441bee9'),
(9, 'ulicnetrke', 'otkud tebe majke ti ga nabijem', '2021-04-01 18:47:52', 'steam:11000010441bee9'),
(10, 'test', 'mamaa', '2021-04-01 18:50:00', 'steam:11000010441bee9'),
(11, 'test', 'aaa', '2021-04-01 18:53:42', 'steam:11000010441bee9'),
(12, 'ulicnetrke', 'aaaaaaaa', '2021-04-01 18:54:42', 'steam:11000010441bee9'),
(13, 'ulicnetrke', 'opaaaaa', '2021-04-01 18:55:20', 'steam:11000010441bee9'),
(14, 'test', 'eeeeeee', '2021-04-01 18:55:24', 'steam:11000010441bee9'),
(15, 'novikanal', 'otkud tebe ovdje', '2021-04-01 18:55:31', 'steam:11000010441bee9'),
(16, 'novikanal', 'sta ti ovdje radis koji kurac ono, ko je tebe jebeno zvao ovdjwe', '2021-04-01 18:55:55', 'steam:11000010441bee9');

-- --------------------------------------------------------

--
-- Table structure for table `phone_calls`
--

CREATE TABLE `phone_calls` (
  `id` int(11) NOT NULL,
  `owner` varchar(10) NOT NULL COMMENT 'Name',
  `num` varchar(10) NOT NULL COMMENT 'Phone Number',
  `incoming` int(11) NOT NULL COMMENT 'Define Incoming Call',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepts` int(11) NOT NULL COMMENT 'Accept Call'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `phone_messages`
--

CREATE TABLE `phone_messages` (
  `id` int(11) NOT NULL,
  `transmitter` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `isRead` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `phone_messages`
--

INSERT INTO `phone_messages` (`id`, `transmitter`, `receiver`, `message`, `time`, `isRead`, `owner`) VALUES
(1, 'mechanic', '239-7597', 'test -1423.8825683594, -288.03799438477 #239-7597', '2021-04-01 18:35:01', 1, 0),
(2, '239-7537', '239-7597', 'eee', '2021-04-01 18:36:31', 1, 1),
(3, 'mechanic', '239-7597', 'eeeee -1425.8504638672, -284.25854492188 #239-7597', '2021-04-01 18:56:14', 1, 0),
(4, '239-7597', '239-7597', 'ko si ti', '2021-04-01 18:56:22', 1, 0),
(5, '239-7597', '239-7597', 'ko si ti', '2021-04-01 18:56:22', 1, 1),
(6, 'police', '239-7597', 'Koi kurac 441.08374023438, -982.21588134766 #7', '2021-04-04 23:14:06', 1, 0),
(7, 'police', '7', 'Koi kurac 441.08374023438, -982.21588134766 #7', '2021-04-04 23:14:06', 1, 0),
(8, 'police', '239-7597', 'koi kurac je ovo 437.37634277344, -982.68786621094 #7', '2021-04-04 23:14:39', 0, 0),
(9, 'police', '7', 'koi kurac je ovo 437.37634277344, -982.68786621094 #7', '2021-04-04 23:14:39', 1, 0),
(10, 'Ljantu', '530-0343', 'sasakldlsfds', '2021-10-23 22:42:50', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `phone_users_contacts`
--

CREATE TABLE `phone_users_contacts` (
  `id` int(11) NOT NULL,
  `identifier` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `playerhousing`
--

CREATE TABLE `playerhousing` (
  `id` int(32) NOT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `rented` tinyint(1) DEFAULT NULL,
  `price` int(32) DEFAULT NULL,
  `wardrobe` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `playerstattoos`
--

CREATE TABLE `playerstattoos` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `tattoos` varchar(1500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `poslovi`
--

CREATE TABLE `poslovi` (
  `pID` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `id` int(255) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `poslovi`
--

INSERT INTO `poslovi` (`pID`, `name`, `label`, `whitelisted`, `id`) VALUES
(2, 'deliverer', 'Dostavljac', 0, 0),
(3, 'drvosjeca', 'Drvosjeca', 0, 0),
(4, 'elektricar', 'Elektricar', 0, 0),
(5, 'farmer', 'Farmer', 0, 1),
(6, 'garbage', 'Smetlar', 0, 1),
(7, 'gradjevinar', 'Gradjevinar', 0, 1),
(8, 'kamion', 'Kamiondzija', 0, 1),
(9, 'kosac', 'Kosac trave', 0, 0),
(10, 'ralica', 'Cistac snijega', 1, 1),
(1, 'unemployed', 'Nezaposlen', 0, 0),
(11, 'vatrogasac', 'Vatrogasac', 0, 0),
(12, 'vlak', 'Vlakovodja', 0, 1),
(13, 'vodoinstalater', 'Vodoinstalater', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `prijatelji`
--

CREATE TABLE `prijatelji` (
  `ID` int(11) NOT NULL,
  `VlasnikID` int(11) NOT NULL,
  `PrijateljID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `prijatelji`
--

INSERT INTO `prijatelji` (`ID`, `VlasnikID`, `PrijateljID`) VALUES
(15, 10003, 10000),
(16, 10003, 10001),
(17, 10000, 10001),
(18, 10002, 10003);

-- --------------------------------------------------------

--
-- Table structure for table `priority`
--

CREATE TABLE `priority` (
  `ID` int(11) NOT NULL,
  `identifier` varchar(100) NOT NULL,
  `power` int(11) NOT NULL,
  `ime` varchar(255) DEFAULT NULL,
  `datum` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `priority`
--

INSERT INTO `priority` (`ID`, `identifier`, `power`, `ime`, `datum`) VALUES
(1, 'steam:110000142bd57ad', 10, 'SaSuKe', '03/15/21 22:39:34'),
(2, 'steam:110000136ababbf', 10, 'KarlitoR1', '03/15/21 22:39:51'),
(3, 'steam:11000013f954fd9', 10, 'MrZenzify', '03/15/21 22:40:05'),
(4, 'steam:1100001423beac6', 10, 'MrZengaa', '03/15/21 22:45:49'),
(5, 'steam:11000013f19f16f', 10, 'Stefuri', '03/15/21 22:46:56'),
(6, 'steam:11000010e76d26f', 10, 'marketinja', '03/15/21 22:47:17'),
(7, 'steam:11000010b4f617b', 10, 'menkavac', '03/15/21 23:03:35'),
(8, 'steam:1100001193a8deb', 10, 'DOM1NO', '03/15/21 23:03:58'),
(9, 'steam:110000117cdb4d1', 10, 'DuLeLega', '03/15/21 23:04:16'),
(10, 'steam:11000013d37140e', 10, 'S3doX', '03/15/21 23:04:33'),
(11, 'steam:110000106cd50b7', 10, 'RATAMATA', '03/15/21 23:04:53'),
(12, 'steam:110000118fe4a37', 10, 'Deni2k', '03/15/21 23:05:06'),
(13, 'steam:11000010818616c', 10, 'TheWitch', '03/15/21 23:05:20'),
(14, 'steam:11000013c4e1c46', 10, 'NBGD', '03/15/21 23:10:00');

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `entering` varchar(255) DEFAULT NULL,
  `exit` varchar(255) DEFAULT NULL,
  `inside` varchar(255) DEFAULT NULL,
  `outside` varchar(255) DEFAULT NULL,
  `ipls` varchar(255) DEFAULT '[]',
  `gateway` varchar(255) DEFAULT NULL,
  `is_single` int(11) DEFAULT NULL,
  `is_room` int(11) DEFAULT NULL,
  `is_gateway` int(11) DEFAULT NULL,
  `room_menu` varchar(255) DEFAULT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pumpe`
--

CREATE TABLE `pumpe` (
  `ID` int(11) NOT NULL,
  `ime` varchar(255) NOT NULL,
  `koord` varchar(255) NOT NULL DEFAULT '{}',
  `vlasnik` varchar(100) DEFAULT NULL,
  `cijena` int(11) NOT NULL,
  `sef` int(11) NOT NULL,
  `gcijena` double NOT NULL DEFAULT 1.5,
  `kcijena` double NOT NULL DEFAULT 250,
  `gorivo` int(11) NOT NULL DEFAULT 500,
  `narudzba` int(2) NOT NULL DEFAULT 0,
  `dostava` varchar(255) NOT NULL DEFAULT '{}',
  `kapacitet` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pumpe`
--

INSERT INTO `pumpe` (`ID`, `ime`, `koord`, `vlasnik`, `cijena`, `sef`, `gcijena`, `kcijena`, `gorivo`, `narudzba`, `dostava`, `kapacitet`) VALUES
(5, 'Pumpa 1', '{\"x\":288.7102966308594,\"y\":-1266.9971923828126,\"z\":29.44075202941894}', 'steam:11000010441bee9', 1600000, 7009, 1.5, 250, 918, 0, '{\"x\":284.2962341308594,\"y\":-1251.5218505859376,\"z\":29.25572204589843}', 1),
(6, 'Pumpa 2', '{\"x\":46.5079116821289,\"y\":2789.208740234375,\"z\":57.87831497192383}', NULL, 600000, 0, 1.5, 250, 500, 0, '{\"x\":65.29000854492188,\"y\":2782.740966796875,\"z\":57.8783073425293}', 0),
(7, 'Pumpa 3', '{\"x\":265.904296875,\"y\":2598.3525390625,\"z\":44.83026885986328}', NULL, 500000, 0, 1.5, 250, 500, 0, '{\"x\":243.4324493408203,\"y\":2599.6689453125,\"z\":45.12274551391601}', 0),
(8, 'Pumpa 4', '{\"x\":1039.33837890625,\"y\":2664.4296875,\"z\":39.55110931396484}', NULL, 700000, 0, 1.5, 250, 500, 0, '{\"x\":1057.305908203125,\"y\":2657.41064453125,\"z\":39.55492782592773}', 0),
(9, 'Pumpa 5', '{\"x\":1204.728759765625,\"y\":2663.441162109375,\"z\":37.80981826782226}', 'steam:11000010e086b7e', 700000, 389, 1.5, 250, 362, 1, '{\"x\":1208.5582275390626,\"y\":2642.334228515625,\"z\":37.83019256591797}', 0),
(10, 'Pumpa 6', '{\"x\":2545.087646484375,\"y\":2592.07177734375,\"z\":37.95740509033203}', NULL, 200000, 0, 1.5, 250, 500, 0, '{\"x\":2537.218017578125,\"y\":2587.263427734375,\"z\":37.94486999511719}', 0),
(11, 'Pumpa 7', '{\"x\":2673.765625,\"y\":3267.038330078125,\"z\":55.24057006835937}', NULL, 800000, 0, 1.5, 250, 500, 0, '{\"x\":2685.82470703125,\"y\":3259.474853515625,\"z\":55.24052047729492}', 0),
(12, 'Pumpa 8', '{\"x\":2001.4554443359376,\"y\":3779.962890625,\"z\":32.18083190917969}', NULL, 700000, 0, 1.5, 250, 500, 0, '{\"x\":1985.66357421875,\"y\":3757.26171875,\"z\":32.17351150512695}', 0),
(13, 'Pumpa 9', '{\"x\":1693.9664306640626,\"y\":4924.24267578125,\"z\":42.07815170288086}', NULL, 700000, 54, 1.5, 250, 500, 0, '{\"x\":1699.9659423828126,\"y\":4942.923828125,\"z\":42.1611213684082}', 0),
(14, 'Pumpa 10', '{\"x\":1706.0556640625,\"y\":6425.56298828125,\"z\":32.76841735839844}', NULL, 800000, 0, 1.5, 250, 500, 0, '{\"x\":1685.691650390625,\"y\":6435.3154296875,\"z\":32.35713958740234}', 0),
(15, 'Pumpa 11', '{\"x\":179.8773956298828,\"y\":6602.54345703125,\"z\":31.86820411682129}', NULL, 1000000, 0, 1.5, 250, 500, 0, '{\"x\":201.42800903320313,\"y\":6622.1669921875,\"z\":31.57495498657226}', 0),
(16, 'Pumpa 12', '{\"x\":-92.73368072509766,\"y\":6409.70263671875,\"z\":31.64035034179687}', NULL, 900000, 0, 1.5, 250, 500, 0, '{\"x\":-79.52699279785156,\"y\":6431.9990234375,\"z\":31.49045944213867}', 0),
(17, 'Pumpa 13', '{\"x\":-2544.21923828125,\"y\":2316.140380859375,\"z\":33.21610641479492}', NULL, 1100000, 0, 1.5, 250, 500, 0, '{\"x\":-2544.855224609375,\"y\":2323.4072265625,\"z\":33.0599250793457}', 0),
(18, 'Pumpa 14', '{\"x\":-1801.026611328125,\"y\":804.757080078125,\"z\":138.4710693359375}', NULL, 1200000, 0, 1.5, 250, 500, 0, '{\"x\":-1813.795654296875,\"y\":799.1516723632813,\"z\":138.47694396972657}', 0),
(19, 'Pumpa 15', '{\"x\":-1427.7933349609376,\"y\":-268.3453674316406,\"z\":46.2274169921875}', 'steam:11000010e086b7e', 1300000, 1811618, 11, 250, 176, 1, '{\"x\":-1408.90771484375,\"y\":-276.75555419921877,\"z\":46.37263870239258}', 1),
(20, 'Pumpa 16', '{\"x\":-2073.2041015625,\"y\":-327.2723083496094,\"z\":13.31596565246582}', NULL, 1300000, 899, 1000000, 600, 355, 1, '{\"x\":-2064.948974609375,\"y\":-305.96405029296877,\"z\":13.142915725708}', 0),
(21, 'Pumpa 17', '{\"x\":-724.0491333007813,\"y\":-937.43115234375,\"z\":19.03470802307129}', 'steam:110000111cd0aa0', 1400000, 1900962, 4, 250, 315, 1, '{\"x\":-711.2090454101563,\"y\":-927.6903686523438,\"z\":19.01409339904785}', 1),
(22, 'Pumpa 18', '{\"x\":-531.4134521484375,\"y\":-1220.990234375,\"z\":18.45499420166015}', NULL, 1100000, 0, 1.5, 250, 500, 0, '{\"x\":-520.8833618164063,\"y\":-1201.466796875,\"z\":18.56760597229004}', 0),
(23, 'Pumpa 19', '{\"x\":-71.19830322265625,\"y\":-1763.1817626953126,\"z\":29.3459243774414}', NULL, 1300000, 0, 1.5, 250, 500, 0, '{\"x\":-62.38230514526367,\"y\":-1745.2607421875,\"z\":29.33869361877441}', 0),
(24, 'Pumpa 20', '{\"x\":818.1276245117188,\"y\":-1040.5389404296876,\"z\":26.75078582763672}', NULL, 1400000, 0, 1.5, 250, 500, 0, '{\"x\":817.4137573242188,\"y\":-1035.2459716796876,\"z\":26.3928050994873}', 0),
(25, 'Pumpa 21', '{\"x\":1211.0872802734376,\"y\":-1389.131591796875,\"z\":35.37686920166015}', NULL, 1200000, 0, 1.5, 250, 500, 0, '{\"x\":1205.057861328125,\"y\":-1406.123291015625,\"z\":35.22417449951172}', 0),
(26, 'Pumpa 22', '{\"x\":1182.912353515625,\"y\":-329.9923095703125,\"z\":69.17447662353516}', 'steam:110000111cd0aa0', 1400000, 250250, 5, 250, 450, 0, '{\"x\":1173.80419921875,\"y\":-317.5242614746094,\"z\":69.17607879638672}', 0),
(27, 'Pumpa 23', '{\"x\":646.076904296875,\"y\":267.31439208984377,\"z\":103.25042724609375}', NULL, 1500000, 0, 1.5, 250, 500, 0, '{\"x\":638.5718383789063,\"y\":274.66485595703127,\"z\":103.08860778808594}', 0),
(28, 'Pumpa 24', '{\"x\":2559.566650390625,\"y\":373.7714538574219,\"z\":108.62117767333985}', NULL, 1300000, 0, 1.5, 250, 500, 0, '{\"x\":2565.124267578125,\"y\":357.2509765625,\"z\":108.46162414550781}', 0),
(29, 'Pumpa 25', '{\"x\":167.09417724609376,\"y\":-1553.5196533203126,\"z\":29.26177215576172}', NULL, 1200000, 0, 1.5, 250, 500, 0, '{\"x\":173.6867218017578,\"y\":-1553.2872314453126,\"z\":29.21279525756836}', 0),
(30, 'Pumpa 26', '{\"x\":-341.90545654296877,\"y\":-1482.9364013671876,\"z\":30.69084167480468}', NULL, 1200000, 0, 1.5, 250, 500, 0, '{\"x\":-336.7940673828125,\"y\":-1486.441162109375,\"z\":30.59874725341797}', 0),
(31, 'Pumpa 27', '{\"x\":1776.7811279296876,\"y\":3327.733642578125,\"z\":41.4331169128418}', NULL, 800000, 0, 1.5, 250, 500, 0, '{\"x\":1776.112548828125,\"y\":3337.34912109375,\"z\":41.1572380065918}', 0);

-- --------------------------------------------------------

--
-- Table structure for table `qalle_brottsregister`
--

CREATE TABLE `qalle_brottsregister` (
  `id` int(255) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `dateofcrime` varchar(255) NOT NULL,
  `crime` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `rented_vehicles`
--

CREATE TABLE `rented_vehicles` (
  `vehicle` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `base_price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `owner` varchar(22) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `id` int(11) NOT NULL,
  `store` varchar(100) NOT NULL,
  `item` varchar(100) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`id`, `store`, `item`, `price`) VALUES
(1, 'TwentyFourSeven', 'bread', 7),
(2, 'TwentyFourSeven', 'water', 5),
(8, 'TwentyFourSeven', 'bandage', 50),
(9, 'TwentyFourSeven', 'burek', 10),
(15, 'TwentyFourSeven', 'rakija', 17),
(17, 'TwentyFourSeven', 'pizza', 9),
(18, 'TwentyFourSeven', 'kola', 7),
(23, 'TwentyFourSeven', 'contract', 1),
(27, 'TwentyFourSeven', 'repairkit', 2500),
(30, 'TwentyFourSeven', 'headbag', 2),
(55, 'TwentyFourSeven', 'saksija', 5),
(58, 'TwentyFourSeven', 'zemlja', 7),
(61, 'TwentyFourSeven', 'ronjenje', 500),
(64, 'TwentyFourSeven', 'milk', 10),
(67, 'TwentyFourSeven', 'acetone', 50),
(70, 'TwentyFourSeven', 'lithium', 150),
(73, 'TwentyFourSeven', 'ukosnica', 10),
(76, 'TwentyFourSeven', 'petarde', 10),
(79, 'TwentyFourSeven', 'vatromet', 20),
(82, 'TwentyFourSeven', 'mobitel', 250),
(85, 'TwentyFourSeven', 'grebalica', 50),
(88, 'TwentyFourSeven', 'loto', 150),
(91, 'TuningShop', 'filter', 23000),
(92, 'TuningShop', 'auspuh', 27000),
(93, 'TuningShop', 'elektronika', 25000),
(94, 'TuningShop', 'turbo', 3424),
(95, 'TuningShop', 'intercooler', 64544),
(96, 'TuningShop', 'finjectori', 4324),
(97, 'TuningShop', 'kvacilo', 87576),
(98, 'TuningShop', 'kmotor', 92424);

-- --------------------------------------------------------

--
-- Table structure for table `shops2`
--

CREATE TABLE `shops2` (
  `id` int(11) NOT NULL,
  `store` varchar(100) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `sef` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shops2`
--

INSERT INTO `shops2` (`id`, `store`, `owner`, `sef`) VALUES
(1, 'Trgovinica', NULL, 42);

-- --------------------------------------------------------

--
-- Table structure for table `shops_itemi`
--

CREATE TABLE `shops_itemi` (
  `ID` int(11) NOT NULL,
  `trgovina` varchar(250) NOT NULL,
  `item` varchar(250) NOT NULL,
  `cijena` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shops_itemi`
--

INSERT INTO `shops_itemi` (`ID`, `trgovina`, `item`, `cijena`) VALUES
(10, 'ljantu', 'bread', 500),
(9, 'Trgovinica', 'water', 6),
(8, 'Trgovinica', 'odjeca', 100),
(7, 'Trgovinica', 'sisanje', 51),
(6, 'Trgovinica', 'bread', 10),
(11, 'rudar', 'zeljezo', 69);

-- --------------------------------------------------------

--
-- Table structure for table `society_moneywash`
--

CREATE TABLE `society_moneywash` (
  `id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `society` varchar(60) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `truck_inventory`
--

CREATE TABLE `truck_inventory` (
  `id` int(11) NOT NULL,
  `item` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `name` varchar(255) NOT NULL,
  `itemt` varchar(50) DEFAULT NULL,
  `owned` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `truck_inventory`
--

INSERT INTO `truck_inventory` (`id`, `item`, `count`, `plate`, `name`, `itemt`, `owned`) VALUES
(1, 'coke', 80, '27DHD198', 'List Kokaina', 'item_standard', '0'),
(6, 'coke', 80, '81NEQ808', 'List Kokaina', 'item_standard', '0'),
(8, 'coke', 80, '46VSQ161', 'List Kokaina', 'item_standard', '0'),
(10, 'coke', 80, '62KGX946', 'List Kokaina', 'item_standard', '0'),
(12, 'coke', 80, '00FRJ936', 'List Kokaina', 'item_standard', '0'),
(14, 'coke', 80, '88DCV250', 'List Kokaina', 'item_standard', '0'),
(16, 'coke', 80, '82WMK428', 'List Kokaina', 'item_standard', '0'),
(18, 'coke', 40, '09OPQ777', 'List Kokaina', 'item_standard', '0'),
(19, 'coke', 80, '88LKT541', 'List Kokaina', 'item_standard', '0'),
(21, 'coke', 80, '29TAM884', 'List Kokaina', 'item_standard', '0'),
(23, 'coke', 80, '62EQE309', 'List Kokaina', 'item_standard', '0'),
(25, 'coke', 80, '87MYN675', 'List Kokaina', 'item_standard', '0'),
(27, 'coke', 80, '86VWJ780', 'List Kokaina', 'item_standard', '0'),
(29, 'coke', 80, '04HNS599', 'List Kokaina', 'item_standard', '0'),
(31, 'coke', 80, '00VLT493', 'List Kokaina', 'item_standard', '0'),
(33, 'coke', 80, '01PZK253', 'List Kokaina', 'item_standard', '0'),
(35, 'coke', 80, '41NTQ111', 'List Kokaina', 'item_standard', '0'),
(37, 'coke', 80, '28KHS951', 'List Kokaina', 'item_standard', '0'),
(39, 'coke', 80, '69NZE020', 'List Kokaina', 'item_standard', '0'),
(41, 'coke', 80, '04NVK849', 'List Kokaina', 'item_standard', '0'),
(43, 'coke', 80, '64CZB723', 'List Kokaina', 'item_standard', '0'),
(45, 'coke', 80, '07JHW876', 'List Kokaina', 'item_standard', '0'),
(47, 'coke', 80, '62HNM622', 'List Kokaina', 'item_standard', '0'),
(49, 'coke', 80, '26RGO148', 'List Kokaina', 'item_standard', '0'),
(51, 'coke', 80, '21AQG592', 'List Kokaina', 'item_standard', '0'),
(53, 'coke', 80, '03RUM378', 'List Kokaina', 'item_standard', '0'),
(55, 'coke', 80, '86SKA480', 'List Kokaina', 'item_standard', '0'),
(57, 'coke', 80, '67CRB215', 'List Kokaina', 'item_standard', '0'),
(59, 'coke', 160, '80TNV612', 'List Kokaina', 'item_standard', '0'),
(63, 'coke', 80, '45HBO454', 'List Kokaina', 'item_standard', '0'),
(65, 'coke', 40, '82WEZ945', 'List Kokaina', 'item_standard', '0'),
(66, 'coke', 50, '05QEY788', 'List Kokaina', 'item_standard', '0'),
(68, 'coke', 50, '86ROU365', 'List Kokaina', 'item_standard', '0'),
(70, 'kcijev', 2, '27WLX888', 'Assault rifle (Cijev)', 'item_standard', '0'),
(71, 'ccijev', 1, '27WLX888', 'Carbine rifle (Cijev)', 'item_standard', '0'),
(72, 'smcijev', 0, '89SBT362', 'SMG (Cijev)', 'item_standard', '0'),
(73, 'filter', 1, 'NQE 362 ', 'Filter', 'item_standard', '0');

-- --------------------------------------------------------

--
-- Table structure for table `twitter_accounts`
--

CREATE TABLE `twitter_accounts` (
  `id` int(11) NOT NULL,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `password` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `avatar_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `twitter_likes`
--

CREATE TABLE `twitter_likes` (
  `id` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `tweetId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `twitter_tweets`
--

CREATE TABLE `twitter_tweets` (
  `id` int(11) NOT NULL,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ukradeni`
--

CREATE TABLE `ukradeni` (
  `tablica` varchar(50) NOT NULL,
  `datum` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `skin` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `job` int(50) DEFAULT 1,
  `job_grade` int(11) DEFAULT 0,
  `loadout` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `permission_level` int(11) DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `phone_number` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `status` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `lastname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `dateofbirth` varchar(25) COLLATE utf8mb4_bin DEFAULT '',
  `sex` varchar(10) COLLATE utf8mb4_bin DEFAULT '',
  `height` varchar(5) COLLATE utf8mb4_bin DEFAULT '',
  `jail` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `last_property` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `armour` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `house` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '{"owns":false,"furniture":[],"houseId":0}',
  `bought_furniture` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `last_house` int(11) DEFAULT 0,
  `pet` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `mute` int(11) NOT NULL DEFAULT 0,
  `kpljacka` int(11) NOT NULL DEFAULT 0,
  `zadnji_login` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `kredit` int(100) NOT NULL DEFAULT 0,
  `rata` int(100) NOT NULL DEFAULT 0,
  `brplaca` int(100) NOT NULL DEFAULT 0,
  `sadnice` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '[]',
  `tattoos` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `zeton` int(11) NOT NULL DEFAULT 0,
  `lov` int(11) NOT NULL DEFAULT 0,
  `stamina` int(11) NOT NULL DEFAULT 20,
  `vjezbanje` int(11) NOT NULL DEFAULT 0,
  `exp` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `posao` int(11) NOT NULL DEFAULT 1,
  `firma` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`ID`, `identifier`, `license`, `money`, `name`, `skin`, `job`, `job_grade`, `loadout`, `position`, `bank`, `permission_level`, `group`, `phone_number`, `status`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `jail`, `last_property`, `is_dead`, `armour`, `house`, `bought_furniture`, `last_house`, `pet`, `mute`, `kpljacka`, `zadnji_login`, `kredit`, `rata`, `brplaca`, `sadnice`, `tattoos`, `zeton`, `lov`, `stamina`, `vjezbanje`, `exp`, `level`, `posao`, `firma`) VALUES
(10000, 'steam:11000010441bee9', 'license:23735c7344bc9f32a2137cba6cbd67751184a27f', 3209040, '#Sikora', '{\"eyebrows_2\":0,\"beard_1\":0,\"arms\":0,\"blemishes_2\":0,\"arms_2\":0,\"torso_2\":0,\"tshirt_2\":2,\"chain_2\":0,\"hair_1\":2,\"lipstick_3\":0,\"lipstick_2\":0,\"blush_1\":0,\"sex\":0,\"decals_1\":0,\"tshirt_1\":2,\"eyebrows_4\":0,\"age_1\":0,\"moles_2\":0,\"shoes_2\":0,\"blush_3\":0,\"sun_2\":0,\"hair_color_2\":0,\"age_2\":0,\"lipstick_4\":0,\"ears_2\":0,\"makeup_4\":0,\"skin\":0,\"makeup_2\":0,\"bodyb_2\":0,\"glasses_1\":0,\"bags_1\":0,\"sun_1\":0,\"complexion_1\":0,\"beard_4\":0,\"ears_1\":-1,\"hair_color_1\":0,\"chest_2\":0,\"chest_3\":0,\"bracelets_2\":0,\"helmet_2\":0,\"pants_2\":1,\"face\":0,\"blush_2\":0,\"bproof_1\":0,\"chest_1\":0,\"bracelets_1\":-1,\"makeup_1\":0,\"watches_1\":-1,\"beard_3\":0,\"glasses_2\":0,\"pants_1\":6,\"lipstick_1\":0,\"eyebrows_3\":0,\"helmet_1\":-1,\"watches_2\":0,\"torso_1\":69,\"chain_1\":0,\"bags_2\":0,\"eye_color\":0,\"complexion_2\":0,\"makeup_3\":0,\"bproof_2\":0,\"moles_1\":0,\"mask_1\":0,\"shoes_1\":2,\"mask_2\":0,\"decals_2\":0,\"bodyb_1\":0,\"beard_2\":0,\"hair_2\":0,\"blemishes_1\":0,\"eyebrows_1\":0}', 3, 2, '[{\"ammo\":0,\"components\":[],\"name\":\"WEAPON_HAMMER\",\"label\":\"Hammer\"},{\"ammo\":194,\"components\":[\"clip_default\"],\"name\":\"WEAPON_PISTOL\",\"label\":\"Pistol\"},{\"ammo\":194,\"components\":[\"clip_default\"],\"name\":\"WEAPON_APPISTOL\",\"label\":\"AP pistol\"},{\"ammo\":0,\"components\":[],\"name\":\"WEAPON_MINIGUN\",\"label\":\"Minigun\"}]', '{\"x\":1215.2000000001863,\"z\":38.0,\"y\":2713.0}', 212750, 69, 'superadmin', '185-9995', '[{\"percent\":79.39,\"name\":\"hunger\",\"val\":793900},{\"percent\":84.5425,\"name\":\"thirst\",\"val\":845425},{\"percent\":0.0,\"name\":\"drunk\",\"val\":0}]', 'Tony', 'Sikora', '1998-09-25', 'm', '200', 0, NULL, 0, 100, '{\"owns\":false,\"furniture\":[],\"houseId\":346}', '{}', 0, NULL, 0, 0, '01/11/2021 12:42:19', 0, 0, 877, '[]', NULL, 0, 0, 21, 1, 14, 5, 4, 22),
(10001, 'steam:110000106921eea', 'license:1a17700fb3ebe57d0e8179efdd6e6e1ccb43168b', 7292, 'Ficho', '{\"bags_2\":0,\"arms\":0,\"bracelets_2\":0,\"bodyb_1\":0,\"age_2\":0,\"pants_1\":0,\"complexion_2\":0,\"hair_1\":11,\"makeup_4\":0,\"bproof_1\":0,\"torso_1\":6,\"glasses_2\":0,\"makeup_1\":0,\"arms_2\":0,\"eyebrows_3\":0,\"chest_3\":0,\"moles_1\":0,\"helmet_1\":-1,\"torso_2\":0,\"sun_2\":0,\"eyebrows_1\":0,\"chain_2\":0,\"age_1\":0,\"decals_1\":0,\"watches_1\":-1,\"beard_4\":0,\"bodyb_2\":0,\"chain_1\":0,\"complexion_1\":0,\"moles_2\":0,\"glasses_1\":0,\"beard_1\":0,\"beard_3\":0,\"blush_3\":0,\"tshirt_2\":0,\"eyebrows_2\":0,\"makeup_2\":0,\"decals_2\":0,\"hair_2\":4,\"chest_2\":0,\"helmet_2\":0,\"lipstick_3\":0,\"shoes_1\":0,\"blush_2\":0,\"tshirt_1\":24,\"makeup_3\":0,\"blemishes_1\":0,\"eyebrows_4\":0,\"ears_1\":-1,\"mask_1\":0,\"pants_2\":0,\"hair_color_2\":0,\"blemishes_2\":0,\"bproof_2\":0,\"bracelets_1\":-1,\"chest_1\":0,\"hair_color_1\":3,\"eye_color\":0,\"lipstick_4\":0,\"ears_2\":0,\"watches_2\":0,\"blush_1\":0,\"lipstick_1\":0,\"face\":0,\"bags_1\":0,\"shoes_2\":0,\"beard_2\":0,\"sex\":0,\"sun_1\":0,\"skin\":1,\"lipstick_2\":0,\"mask_2\":0}', 1, 0, '[{\"label\":\"Assault rifle\",\"name\":\"WEAPON_ASSAULTRIFLE\",\"ammo\":32,\"components\":[\"clip_default\"]}]', '{\"z\":24.80000000000291,\"y\":-488.4000000000233,\"x\":596.1999999999534}', 999946900, 69, 'superadmin', '973-2181', '[{\"name\":\"hunger\",\"val\":411100,\"percent\":41.11},{\"name\":\"thirst\",\"val\":433325,\"percent\":43.3325},{\"name\":\"drunk\",\"val\":0,\"percent\":0.0}]', 'Filip', 'Wizzy', '19980208', 'm', '180', 0, NULL, 0, 0, '{\"owns\":false,\"furniture\":[],\"houseId\":0}', '{}', 0, NULL, 0, 0, '28/10/2021 23:34:14', 0, 0, 16, '[]', NULL, 0, 0, 20, 0, 4, 2, 1, 0),
(10002, 'steam:11000010ad5cf80', 'license:104849bd70250f8f538fb51379f5a4a258f6e960', 0, 'MaZz', '{\"bags_2\":0,\"arms\":0,\"bracelets_2\":0,\"bodyb_1\":0,\"age_2\":0,\"pants_1\":6,\"complexion_2\":0,\"hair_1\":9,\"makeup_4\":0,\"bproof_1\":4,\"torso_1\":0,\"glasses_2\":0,\"makeup_1\":0,\"arms_2\":0,\"eyebrows_3\":0,\"chest_3\":0,\"moles_1\":2,\"helmet_1\":-1,\"torso_2\":0,\"sun_2\":0,\"eyebrows_1\":0,\"chain_2\":0,\"age_1\":0,\"decals_1\":0,\"lipstick_2\":0,\"beard_4\":0,\"bodyb_2\":0,\"chain_1\":0,\"complexion_1\":4,\"pants_2\":0,\"glasses_1\":0,\"beard_1\":0,\"beard_3\":0,\"shoes_2\":0,\"tshirt_2\":2,\"mask_2\":0,\"makeup_2\":0,\"decals_2\":0,\"hair_2\":0,\"chest_2\":0,\"helmet_2\":0,\"lipstick_3\":0,\"shoes_1\":0,\"blush_2\":0,\"tshirt_1\":22,\"chest_1\":0,\"blemishes_1\":0,\"eyebrows_4\":0,\"sun_1\":0,\"mask_1\":0,\"lipstick_4\":0,\"hair_color_2\":0,\"blemishes_2\":0,\"bproof_2\":0,\"moles_2\":0,\"blush_1\":0,\"hair_color_1\":0,\"eye_color\":0,\"makeup_3\":0,\"ears_2\":0,\"watches_2\":0,\"blush_3\":0,\"lipstick_1\":0,\"bags_1\":0,\"ears_1\":-1,\"beard_2\":0,\"watches_1\":-1,\"sex\":0,\"face\":44,\"skin\":2,\"eyebrows_2\":0,\"bracelets_1\":-1}', 1, 0, '[{\"components\":[\"clip_default\"],\"ammo\":197,\"label\":\"Pistol .50\",\"name\":\"WEAPON_PISTOL50\"},{\"components\":[\"clip_default\"],\"ammo\":88,\"label\":\"Assault rifle\",\"name\":\"WEAPON_ASSAULTRIFLE\"}]', '{\"y\":2897.7999999998139,\"z\":40.80000000000291,\"x\":2442.2000000001864}', 22950, 69, 'superadmin', '530-0343', '[{\"val\":994800,\"name\":\"hunger\",\"percent\":99.48},{\"val\":996100,\"name\":\"thirst\",\"percent\":99.61},{\"val\":0,\"name\":\"drunk\",\"percent\":0.0}]', 'Max', 'Cigarett', '0611199', 'm', '180', 0, NULL, 0, 30, '{\"owns\":false,\"furniture\":[],\"houseId\":0}', '{}', 0, NULL, 0, 0, '30/10/2021 22:09:56', 0, 0, 43, '[]', NULL, 0, 0, 20, 0, 0, 1, 1, 0),
(10003, 'steam:11000010e086b7e', 'license:ebdfe690c597862ea966a6893ad2fe9aaddcc873', 79731, 'LJANTU', '{\"blush_1\":0,\"eyebrows_3\":0,\"face\":19,\"pants_1\":130,\"arms\":28,\"lipstick_3\":0,\"chest_2\":0,\"watches_1\":2,\"decals_1\":0,\"makeup_2\":0,\"eyebrows_4\":0,\"complexion_1\":0,\"makeup_3\":0,\"decals_2\":0,\"tshirt_1\":0,\"skin\":18,\"bracelets_1\":-1,\"hair_color_2\":0,\"beard_4\":0,\"age_2\":0,\"bags_1\":0,\"ears_1\":-1,\"moles_1\":0,\"eyebrows_2\":0,\"eyebrows_1\":0,\"shoes_1\":24,\"makeup_1\":0,\"ears_2\":0,\"bracelets_2\":0,\"pants_2\":0,\"bproof_2\":0,\"blemishes_2\":0,\"hair_2\":0,\"chain_1\":0,\"torso_1\":381,\"glasses_1\":30,\"sun_1\":0,\"chest_1\":0,\"watches_2\":0,\"blush_3\":0,\"blemishes_1\":0,\"lipstick_1\":0,\"beard_2\":0,\"helmet_1\":-1,\"torso_2\":0,\"helmet_2\":0,\"chain_2\":0,\"blush_2\":0,\"bodyb_1\":0,\"age_1\":0,\"glasses_2\":0,\"mask_2\":0,\"lipstick_4\":0,\"hair_1\":22,\"beard_1\":0,\"mask_1\":0,\"complexion_2\":0,\"makeup_4\":0,\"bodyb_2\":0,\"chest_3\":0,\"bags_2\":0,\"sun_2\":0,\"tshirt_2\":2,\"eye_color\":0,\"shoes\":35,\"shoes_2\":0,\"bproof_1\":54,\"arms_2\":0,\"beard_3\":0,\"sex\":0,\"moles_2\":0,\"lipstick_2\":0,\"hair_color_1\":29}', 3, 1, '[{\"ammo\":0,\"components\":[],\"name\":\"WEAPON_KNIFE\",\"label\":\"Knife\"},{\"ammo\":249,\"components\":[],\"name\":\"WEAPON_PUMPSHOTGUN\",\"label\":\"Pump shotgun\"},{\"ammo\":225,\"components\":[\"clip_default\"],\"name\":\"WEAPON_COMPACTRIFLE\",\"label\":\"Compact rifle\"},{\"ammo\":249,\"components\":[],\"name\":\"WEAPON_MUSKET\",\"label\":\"Musket\"},{\"ammo\":0,\"components\":[],\"name\":\"WEAPON_BATTLEAXE\",\"label\":\"Battle axe\"},{\"ammo\":0,\"components\":[],\"name\":\"WEAPON_POOLCUE\",\"label\":\"Pool cue\"},{\"ammo\":225,\"components\":[],\"name\":\"WEAPON_ASSAULTRIFLE_MK2\",\"label\":\"assault rifle mk2\"}]', '{\"x\":414.0,\"z\":29.19999999999709,\"y\":-840.8000000000466}', 574050, 69, 'superadmin', '579-9678', '[{\"percent\":49.62,\"name\":\"hunger\",\"val\":496200},{\"percent\":49.71499999999999,\"name\":\"thirst\",\"val\":497150},{\"percent\":0.0,\"name\":\"drunk\",\"val\":0}]', 'Tuljan', 'Ljantu', '33333333', 'm', '195', 0, NULL, 0, 100, '{\"owns\":false,\"furniture\":[],\"houseId\":83}', '{}', 0, NULL, 0, 0, '01/11/2021 01:39:24', 0, 0, 120, '[]', '[{\"nameHash\":\"MP_MP_Biker_Tat_057_F\",\"Count\":1,\"collection\":\"mpbiker_overlays\"},{\"nameHash\":\"MP_MP_Biker_Tat_025_F\",\"Count\":1,\"collection\":\"mpbiker_overlays\"},{\"nameHash\":\"MP_MP_Biker_Tat_004_F\",\"Count\":1,\"collection\":\"mpbiker_overlays\"},{\"nameHash\":\"MP_Bea_F_Chest_002\",\"Count\":1,\"collection\":\"mpbeach_overlays\"},{\"nameHash\":\"MP_MP_ImportExport_Tat_007_F\",\"Count\":1,\"collection\":\"mpimportexport_overlays\"},{\"nameHash\":\"FM_Tat_Award_F_000\",\"Count\":1,\"collection\":\"multiplayer_overlays\"}]', 0, 0, 20, 2, 11, 5, 7, 22),
(10004, 'steam:110000111cd0aa0', 'license:e4090a08909875dbb99f15633c3ec4ef87d9e9f8', 0, 'GABO', '{\"arms\":1,\"makeup_3\":0,\"hair_1\":19,\"ears_1\":-1,\"eye_color\":0,\"arms_2\":0,\"skin\":1,\"beard_1\":0,\"torso_1\":4,\"ears_2\":0,\"bproof_1\":0,\"hair_color_1\":5,\"age_2\":0,\"lipstick_2\":0,\"sun_2\":0,\"age_1\":0,\"eyebrows_2\":0,\"lipstick_3\":0,\"makeup_1\":0,\"blemishes_2\":0,\"watches_1\":-1,\"bodyb_2\":0,\"tshirt_1\":3,\"beard_3\":0,\"sex\":0,\"glasses_2\":0,\"bags_1\":0,\"helmet_1\":-1,\"pants_1\":7,\"watches_2\":0,\"chain_2\":0,\"blemishes_1\":0,\"tshirt_2\":0,\"decals_2\":0,\"chest_3\":0,\"shoes_1\":1,\"shoes_2\":0,\"glasses_1\":0,\"eyebrows_3\":0,\"blush_3\":0,\"makeup_4\":0,\"sun_1\":0,\"bracelets_2\":0,\"helmet_2\":0,\"bags_2\":0,\"moles_2\":0,\"hair_2\":4,\"lipstick_1\":0,\"bracelets_1\":-1,\"beard_2\":0,\"mask_2\":0,\"mask_1\":0,\"face\":12,\"blush_2\":0,\"lipstick_4\":0,\"chain_1\":0,\"beard_4\":0,\"eyebrows_1\":0,\"bproof_2\":0,\"moles_1\":0,\"makeup_2\":0,\"eyebrows_4\":0,\"complexion_2\":0,\"complexion_1\":0,\"torso_2\":3,\"blush_1\":0,\"hair_color_2\":0,\"decals_1\":0,\"chest_1\":0,\"pants_2\":0,\"bodyb_1\":0,\"chest_2\":0}', 1, 4, '[{\"label\":\"MG\",\"ammo\":190,\"name\":\"WEAPON_MG\",\"components\":[\"clip_default\"]}]', '{\"x\":-985.8000000000466,\"y\":39.0,\"z\":50.19999999999709}', 3041000, 69, 'superadmin', '537-5773', '[{\"percent\":48.36,\"val\":483600,\"name\":\"hunger\"},{\"percent\":48.77,\"val\":487700,\"name\":\"thirst\"},{\"percent\":0.0,\"val\":0,\"name\":\"drunk\"}]', 'Daniel', 'Deacon', '03.11.1997', 'm', '180', 0, NULL, 0, 0, '{\"owns\":false,\"furniture\":[],\"houseId\":0}', '{}', 0, NULL, 0, 0, '26/10/2021 20:19:06', 0, 0, 14, '[]', NULL, 0, 0, 20, 0, 3, 1, 69, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_accounts`
--

CREATE TABLE `user_accounts` (
  `id` int(11) NOT NULL,
  `identifier` varchar(22) NOT NULL,
  `name` varchar(50) NOT NULL,
  `money` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_accounts`
--

INSERT INTO `user_accounts` (`id`, `identifier`, `name`, `money`) VALUES
(2, 'steam:11000010a1d1042', 'black_money', 0),
(4, 'steam:11000010441bee9', 'black_money', 0),
(5, 'steam:110000115e9ac6b', 'black_money', 0),
(6, 'steam:11000010e086b7e', 'black_money', 0),
(7, 'steam:11000010ad5cf80', 'black_money', 0),
(8, 'steam:110000106921eea', 'black_money', 0),
(9, 'steam:110000111cd0aa0', 'black_money', 0),
(10, 'steam:11000014694839f', 'black_money', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_inventory`
--

CREATE TABLE `user_inventory` (
  `id` int(11) NOT NULL,
  `identifier` varchar(22) NOT NULL,
  `item` varchar(50) NOT NULL,
  `count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_inventory`
--

INSERT INTO `user_inventory` (`id`, `identifier`, `item`, `count`) VALUES
(1, 'steam:11000010441bee9', 'weapon_firework', 0),
(2, 'steam:11000010441bee9', 'weapon_crowbar', 0),
(3, 'steam:11000010441bee9', 'fish', 0),
(4, 'steam:11000010441bee9', 'weapon_gusenberg', 0),
(5, 'steam:11000010441bee9', 'gljive', 0),
(6, 'steam:11000010441bee9', 'weapon_machinepsitol', 0),
(7, 'steam:11000010441bee9', 'weapon_compactrifle', 0),
(8, 'steam:11000010441bee9', 'mobitel', 0),
(9, 'steam:11000010441bee9', 'lighter', 0),
(10, 'steam:11000010441bee9', 'smcijev', 0),
(11, 'steam:11000010441bee9', 'clothe', 0),
(12, 'steam:11000010441bee9', 'weapon_poolcue', 0),
(13, 'steam:11000010441bee9', 'weapon_pistol', 0),
(14, 'steam:11000010441bee9', 'weapon_advancedrifle', 0),
(15, 'steam:11000010441bee9', 'weapon_pistol50', 0),
(16, 'steam:11000010441bee9', 'pizza', 0),
(17, 'steam:11000010441bee9', 'methlab', 0),
(18, 'steam:11000010441bee9', 'weapon_switchblade', 0),
(19, 'steam:11000010441bee9', 'weapon_battleaxe', 0),
(20, 'steam:11000010441bee9', 'net_cracker', 0),
(21, 'steam:11000010441bee9', 'vatromet', 0),
(22, 'steam:11000010441bee9', 'weapon_assaultrifle_mk2', 0),
(23, 'steam:11000010441bee9', 'duhan', 0),
(24, 'steam:11000010441bee9', 'autobomba', 0),
(25, 'steam:11000010441bee9', 'weapon_minismg', 0),
(26, 'steam:11000010441bee9', 'washed_stone', 0),
(27, 'steam:11000010441bee9', 'skoljka', 0),
(28, 'steam:11000010441bee9', 'carotool', 0),
(29, 'steam:11000010441bee9', 'bandage', 0),
(30, 'steam:11000010441bee9', 'ckundak', 0),
(31, 'steam:11000010441bee9', 'weapon_nightstick', 0),
(32, 'steam:11000010441bee9', 'burek', 0),
(33, 'steam:11000010441bee9', 'weapon_musket', 0),
(34, 'steam:11000010441bee9', 'kkundak', 0),
(35, 'steam:11000010441bee9', 'fixtool', 0),
(36, 'steam:11000010441bee9', 'petarde', 0),
(37, 'steam:11000010441bee9', 'jewels', 0),
(38, 'steam:11000010441bee9', 'weapon_appistol', 0),
(39, 'steam:11000010441bee9', 'meth', 0),
(40, 'steam:11000010441bee9', 'champagne', 0),
(41, 'steam:11000010441bee9', 'clip', 0),
(42, 'steam:11000010441bee9', 'absinthe', 0),
(43, 'steam:11000010441bee9', 'milk', 0),
(44, 'steam:11000010441bee9', 'lancic', 0),
(45, 'steam:11000010441bee9', 'weapon_heavysniper', 0),
(46, 'steam:11000010441bee9', 'tequila', 0),
(47, 'steam:11000010441bee9', 'carokit', 0),
(48, 'steam:11000010441bee9', 'bread', 0),
(49, 'steam:11000010441bee9', 'wine', 0),
(50, 'steam:11000010441bee9', 'weapon_hatchet', 0),
(51, 'steam:11000010441bee9', 'weapon_revolver', 0),
(52, 'steam:11000010441bee9', 'acetone', 0),
(53, 'steam:11000010441bee9', 'ukosnica', 0),
(54, 'steam:11000010441bee9', 'skundak', 0),
(55, 'steam:11000010441bee9', 'kola', 0),
(56, 'steam:11000010441bee9', 'weapon_sniperrifle', 0),
(57, 'steam:11000010441bee9', 'grebalica', 0),
(58, 'steam:11000010441bee9', 'ccijev', 0),
(59, 'steam:11000010441bee9', 'zemlja', 0),
(60, 'steam:11000010441bee9', 'weapon_autoshotgun', 0),
(61, 'steam:11000010441bee9', 'saksija', 0),
(62, 'steam:11000010441bee9', 'fixkit', 0),
(63, 'steam:11000010441bee9', 'weapon_microsmg', 0),
(64, 'steam:11000010441bee9', 'headbag', 0),
(65, 'steam:11000010441bee9', 'ctijelo', 0),
(66, 'steam:11000010441bee9', 'weapon_carbinerifle_mk2', 0),
(67, 'steam:11000010441bee9', 'scijev', 0),
(68, 'steam:11000010441bee9', 'weapon_doubleaction', 0),
(69, 'steam:11000010441bee9', 'narukvica', 0),
(70, 'steam:11000010441bee9', 'weapon_carbinerifle', 0),
(71, 'steam:11000010441bee9', 'weapon_assaultshotgun', 0),
(72, 'steam:11000010441bee9', 'cigarett', 0),
(73, 'steam:11000010441bee9', 'weapon_hammer', 0),
(74, 'steam:11000010441bee9', 'meso', 0),
(75, 'steam:11000010441bee9', 'stone', 0),
(76, 'steam:11000010441bee9', 'heroin', 0),
(77, 'steam:11000010441bee9', 'biser', 0),
(78, 'steam:11000010441bee9', 'cannabis', 0),
(79, 'steam:11000010441bee9', 'petarda', 0),
(80, 'steam:11000010441bee9', 'gazbottle', 0),
(81, 'steam:11000010441bee9', 'weapon_combatpdw', 0),
(82, 'steam:11000010441bee9', 'croquettes', 0),
(83, 'steam:11000010441bee9', 'contract', 0),
(84, 'steam:11000010441bee9', 'thermite', 0),
(85, 'steam:11000010441bee9', 'lithium', 0),
(86, 'steam:11000010441bee9', 'ktijelo', 0),
(87, 'steam:11000010441bee9', 'weapon_bullpuprifle', 0),
(88, 'steam:11000010441bee9', 'iron', 0),
(89, 'steam:11000010441bee9', 'weapon_golfclub', 0),
(90, 'steam:11000010441bee9', 'packaged_chicken', 0),
(91, 'steam:11000010441bee9', 'stijelo', 0),
(92, 'steam:11000010441bee9', 'kemija', 0),
(93, 'steam:11000010441bee9', 'weapon_heavyshotgun', 0),
(94, 'steam:11000010441bee9', 'weapon_marksmanrifle_mk2', 0),
(95, 'steam:11000010441bee9', 'weapon_vintagepistol', 0),
(96, 'steam:11000010441bee9', 'weapon_pumpshotgun', 0),
(97, 'steam:11000010441bee9', 'cocaine', 0),
(98, 'steam:11000010441bee9', 'copper', 0),
(99, 'steam:11000010441bee9', 'gold', 0),
(100, 'steam:11000010441bee9', 'smtijelo', 0),
(101, 'steam:11000010441bee9', 'beer', 0),
(102, 'steam:11000010441bee9', 'koza', 0),
(103, 'steam:11000010441bee9', 'weapon_bat', 0),
(104, 'steam:11000010441bee9', 'whisky', 0),
(105, 'steam:11000010441bee9', 'repairkit', 0),
(106, 'steam:11000010441bee9', 'petrol_raffin', 0),
(107, 'steam:11000010441bee9', 'weapon_specialcarbine', 0),
(108, 'steam:11000010441bee9', 'weapon_snspistol', 0),
(109, 'steam:11000010441bee9', 'weapon_assaultsmg', 0),
(110, 'steam:11000010441bee9', 'seed', 0),
(111, 'steam:11000010441bee9', 'weapon_sawnoffshotgun', 0),
(112, 'steam:11000010441bee9', 'gintonic', 0),
(113, 'steam:11000010441bee9', 'weapon_revolver_mk2', 0),
(114, 'steam:11000010441bee9', 'weapon_mg', 0),
(115, 'steam:11000010441bee9', 'wool', 0),
(116, 'steam:11000010441bee9', 'weapon_marksmanpistol', 0),
(117, 'steam:11000010441bee9', 'weapon_bullpupshotgun', 0),
(118, 'steam:11000010441bee9', 'speed', 0),
(119, 'steam:11000010441bee9', 'alive_chicken', 0),
(120, 'steam:11000010441bee9', 'weapon_machete', 0),
(121, 'steam:11000010441bee9', 'kcijev', 0),
(122, 'steam:11000010441bee9', 'weapon_knife', 0),
(123, 'steam:11000010441bee9', 'weapon_smg', 0),
(124, 'steam:11000010441bee9', 'blowpipe', 0),
(125, 'steam:11000010441bee9', 'weapon_heavypistol', 0),
(126, 'steam:11000010441bee9', 'heartpump', 0),
(127, 'steam:11000010441bee9', 'cutted_wood', 0),
(128, 'steam:11000010441bee9', 'wood', 0),
(129, 'steam:11000010441bee9', 'packaged_plank', 0),
(130, 'steam:11000010441bee9', 'weapon_marksmanrifle', 0),
(131, 'steam:11000010441bee9', 'weapon_fireextinguisher', 0),
(132, 'steam:11000010441bee9', 'essence', 0),
(133, 'steam:11000010441bee9', 'weapon_flashlight', 0),
(134, 'steam:11000010441bee9', 'coke', 0),
(135, 'steam:11000010441bee9', 'weapon_dbshotgun', 0),
(136, 'steam:11000010441bee9', 'water', 0),
(137, 'steam:11000010441bee9', 'zeton', 0),
(138, 'steam:11000010441bee9', 'medikit', 0),
(139, 'steam:11000010441bee9', 'smkundak', 0),
(140, 'steam:11000010441bee9', 'drone_flyer_7', 0),
(141, 'steam:11000010441bee9', 'LSD', 0),
(142, 'steam:11000010441bee9', 'petrol', 0),
(143, 'steam:11000010441bee9', 'weapon_combatpistol', 0),
(144, 'steam:11000010441bee9', 'weapon_assaultrifle', 0),
(145, 'steam:11000010441bee9', 'vodka', 0),
(146, 'steam:11000010441bee9', 'fabric', 0),
(147, 'steam:11000010441bee9', 'slaughtered_chicken', 0),
(148, 'steam:11000010441bee9', 'diamond', 0),
(149, 'steam:11000010441bee9', 'ljudi', 0),
(150, 'steam:11000010441bee9', 'weapon_combatmg', 0),
(151, 'steam:11000010441bee9', 'odznaka', 0),
(152, 'steam:11000010441bee9', 'weapon_wrench', 0),
(153, 'steam:11000010441bee9', 'rakija', 0),
(154, 'steam:11000010441bee9', 'marijuana', 0),
(155, 'steam:11000010441bee9', 'ronjenje', 0),
(156, 'steam:11000010a1d1042', 'weapon_heavyshotgun', 0),
(157, 'steam:11000010a1d1042', 'weapon_assaultrifle_mk2', 0),
(158, 'steam:11000010a1d1042', 'biser', 0),
(159, 'steam:11000010a1d1042', 'washed_stone', 0),
(160, 'steam:11000010a1d1042', 'weapon_battleaxe', 0),
(161, 'steam:11000010a1d1042', 'narukvica', 0),
(162, 'steam:11000010a1d1042', 'water', 0),
(163, 'steam:11000010a1d1042', 'headbag', 0),
(164, 'steam:11000010a1d1042', 'weapon_autoshotgun', 0),
(165, 'steam:11000010a1d1042', 'ronjenje', 0),
(166, 'steam:11000010a1d1042', 'weapon_sawnoffshotgun', 0),
(167, 'steam:11000010a1d1042', 'iron', 0),
(168, 'steam:11000010a1d1042', 'heroin', 1),
(169, 'steam:11000010a1d1042', 'weapon_compactrifle', 0),
(170, 'steam:11000010a1d1042', 'coke', 0),
(171, 'steam:11000010a1d1042', 'weapon_mg', 0),
(172, 'steam:11000010a1d1042', 'weapon_knife', 0),
(173, 'steam:11000010a1d1042', 'petarda', 0),
(174, 'steam:11000010a1d1042', 'carokit', 0),
(175, 'steam:11000010a1d1042', 'speed', 0),
(176, 'steam:11000010a1d1042', 'alive_chicken', 0),
(177, 'steam:11000010a1d1042', 'smcijev', 0),
(178, 'steam:11000010a1d1042', 'essence', 0),
(179, 'steam:11000010a1d1042', 'rakija', 0),
(180, 'steam:11000010a1d1042', 'odznaka', 0),
(181, 'steam:11000010a1d1042', 'contract', 0),
(182, 'steam:11000010a1d1042', 'zeton', 0),
(183, 'steam:11000010a1d1042', 'petrol', 0),
(184, 'steam:11000010a1d1042', 'weapon_bullpuprifle', 0),
(185, 'steam:11000010a1d1042', 'LSD', 1),
(186, 'steam:11000010a1d1042', 'copper', 0),
(187, 'steam:11000010a1d1042', 'weapon_flashlight', 0),
(188, 'steam:11000010a1d1042', 'ctijelo', 0),
(189, 'steam:11000010a1d1042', 'saksija', 0),
(190, 'steam:11000010a1d1042', 'weapon_heavysniper', 0),
(191, 'steam:11000010a1d1042', 'gazbottle', 0),
(192, 'steam:11000010a1d1042', 'packaged_plank', 0),
(193, 'steam:11000010a1d1042', 'ktijelo', 0),
(194, 'steam:11000010a1d1042', 'weapon_gusenberg', 0),
(195, 'steam:11000010a1d1042', 'weapon_hammer', 0),
(196, 'steam:11000010a1d1042', 'lithium', 0),
(197, 'steam:11000010a1d1042', 'fabric', 0),
(198, 'steam:11000010a1d1042', 'ljudi', 0),
(199, 'steam:11000010a1d1042', 'stijelo', 0),
(200, 'steam:11000010a1d1042', 'stone', 0),
(201, 'steam:11000010a1d1042', 'zemlja', 0),
(202, 'steam:11000010a1d1042', 'meso', 0),
(203, 'steam:11000010a1d1042', 'weapon_dbshotgun', 0),
(204, 'steam:11000010a1d1042', 'ckundak', 0),
(205, 'steam:11000010a1d1042', 'thermite', 0),
(206, 'steam:11000010a1d1042', 'weapon_golfclub', 0),
(207, 'steam:11000010a1d1042', 'clothe', 0),
(208, 'steam:11000010a1d1042', 'weapon_switchblade', 0),
(209, 'steam:11000010a1d1042', 'carotool', 0),
(210, 'steam:11000010a1d1042', 'wool', 0),
(211, 'steam:11000010a1d1042', 'kola', 0),
(212, 'steam:11000010a1d1042', 'seed', 0),
(213, 'steam:11000010a1d1042', 'skundak', 0),
(214, 'steam:11000010a1d1042', 'blowpipe', 0),
(215, 'steam:11000010a1d1042', 'ukosnica', 0),
(216, 'steam:11000010a1d1042', 'fixkit', 0),
(217, 'steam:11000010a1d1042', 'kkundak', 0),
(218, 'steam:11000010a1d1042', 'duhan', 0),
(219, 'steam:11000010a1d1042', 'methlab', 0),
(220, 'steam:11000010a1d1042', 'weapon_hatchet', 0),
(221, 'steam:11000010a1d1042', 'beer', 0),
(222, 'steam:11000010a1d1042', 'packaged_chicken', 0),
(223, 'steam:11000010a1d1042', 'weapon_combatpdw', 0),
(224, 'steam:11000010a1d1042', 'weapon_marksmanpistol', 0),
(225, 'steam:11000010a1d1042', 'meth', 1),
(226, 'steam:11000010a1d1042', 'heartpump', 0),
(227, 'steam:11000010a1d1042', 'weapon_crowbar', 0),
(228, 'steam:11000010a1d1042', 'petrol_raffin', 0),
(229, 'steam:11000010a1d1042', 'weapon_doubleaction', 0),
(230, 'steam:11000010a1d1042', 'croquettes', 0),
(231, 'steam:11000010a1d1042', 'cocaine', 0),
(232, 'steam:11000010a1d1042', 'absinthe', 0),
(233, 'steam:11000010a1d1042', 'petarde', 0),
(234, 'steam:11000010a1d1042', 'weapon_combatpistol', 0),
(235, 'steam:11000010a1d1042', 'clip', 0),
(236, 'steam:11000010a1d1042', 'smkundak', 0),
(237, 'steam:11000010a1d1042', 'gold', 0),
(238, 'steam:11000010a1d1042', 'weapon_fireextinguisher', 0),
(239, 'steam:11000010a1d1042', 'scijev', 0),
(240, 'steam:11000010a1d1042', 'mobitel', 1),
(241, 'steam:11000010a1d1042', 'weapon_pistol50', 0),
(242, 'steam:11000010a1d1042', 'wood', 0),
(243, 'steam:11000010a1d1042', 'kcijev', 0),
(244, 'steam:11000010a1d1042', 'fixtool', 0),
(245, 'steam:11000010a1d1042', 'acetone', 0),
(246, 'steam:11000010a1d1042', 'marijuana', 1),
(247, 'steam:11000010a1d1042', 'cigarett', 0),
(248, 'steam:11000010a1d1042', 'fish', 0),
(249, 'steam:11000010a1d1042', 'champagne', 0),
(250, 'steam:11000010a1d1042', 'weapon_advancedrifle', 0),
(251, 'steam:11000010a1d1042', 'weapon_nightstick', 0),
(252, 'steam:11000010a1d1042', 'weapon_machete', 0),
(253, 'steam:11000010a1d1042', 'whisky', 0),
(254, 'steam:11000010a1d1042', 'gintonic', 0),
(255, 'steam:11000010a1d1042', 'wine', 0),
(256, 'steam:11000010a1d1042', 'weapon_wrench', 0),
(257, 'steam:11000010a1d1042', 'weapon_carbinerifle_mk2', 0),
(258, 'steam:11000010a1d1042', 'weapon_microsmg', 0),
(259, 'steam:11000010a1d1042', 'weapon_specialcarbine', 0),
(260, 'steam:11000010a1d1042', 'weapon_snspistol', 0),
(261, 'steam:11000010a1d1042', 'lighter', 0),
(262, 'steam:11000010a1d1042', 'weapon_assaultrifle', 0),
(263, 'steam:11000010a1d1042', 'autobomba', 0),
(264, 'steam:11000010a1d1042', 'weapon_revolver_mk2', 0),
(265, 'steam:11000010a1d1042', 'weapon_marksmanrifle', 0),
(266, 'steam:11000010a1d1042', 'weapon_pumpshotgun', 0),
(267, 'steam:11000010a1d1042', 'weapon_poolcue', 0),
(268, 'steam:11000010a1d1042', 'weapon_pistol', 0),
(269, 'steam:11000010a1d1042', 'lancic', 0),
(270, 'steam:11000010a1d1042', 'slaughtered_chicken', 0),
(271, 'steam:11000010a1d1042', 'weapon_minismg', 0),
(272, 'steam:11000010a1d1042', 'weapon_musket', 0),
(273, 'steam:11000010a1d1042', 'weapon_vintagepistol', 0),
(274, 'steam:11000010a1d1042', 'weapon_marksmanrifle_mk2', 0),
(275, 'steam:11000010a1d1042', 'weapon_revolver', 0),
(276, 'steam:11000010a1d1042', 'repairkit', 0),
(277, 'steam:11000010a1d1042', 'weapon_machinepsitol', 0),
(278, 'steam:11000010a1d1042', 'medikit', 0),
(279, 'steam:11000010a1d1042', 'diamond', 0),
(280, 'steam:11000010a1d1042', 'kemija', 0),
(281, 'steam:11000010a1d1042', 'weapon_smg', 0),
(282, 'steam:11000010a1d1042', 'drone_flyer_7', 0),
(283, 'steam:11000010a1d1042', 'weapon_assaultshotgun', 0),
(284, 'steam:11000010a1d1042', 'grebalica', 0),
(285, 'steam:11000010a1d1042', 'weapon_sniperrifle', 0),
(286, 'steam:11000010a1d1042', 'weapon_heavypistol', 0),
(287, 'steam:11000010a1d1042', 'skoljka', 0),
(288, 'steam:11000010a1d1042', 'bandage', 0),
(289, 'steam:11000010a1d1042', 'koza', 0),
(290, 'steam:11000010a1d1042', 'gljive', 0),
(291, 'steam:11000010a1d1042', 'weapon_firework', 0),
(292, 'steam:11000010a1d1042', 'cutted_wood', 0),
(293, 'steam:11000010a1d1042', 'weapon_combatmg', 0),
(294, 'steam:11000010a1d1042', 'milk', 0),
(295, 'steam:11000010a1d1042', 'weapon_carbinerifle', 0),
(296, 'steam:11000010a1d1042', 'smtijelo', 0),
(297, 'steam:11000010a1d1042', 'pizza', 0),
(298, 'steam:11000010a1d1042', 'burek', 0),
(299, 'steam:11000010a1d1042', 'weapon_bat', 0),
(300, 'steam:11000010a1d1042', 'weapon_assaultsmg', 0),
(301, 'steam:11000010a1d1042', 'weapon_appistol', 0),
(302, 'steam:11000010a1d1042', 'vodka', 0),
(303, 'steam:11000010a1d1042', 'vatromet', 0),
(304, 'steam:11000010a1d1042', 'jewels', 0),
(305, 'steam:11000010a1d1042', 'bread', 0),
(306, 'steam:11000010a1d1042', 'tequila', 0),
(307, 'steam:11000010a1d1042', 'weapon_bullpupshotgun', 0),
(308, 'steam:11000010a1d1042', 'net_cracker', 0),
(309, 'steam:11000010a1d1042', 'ccijev', 0),
(310, 'steam:11000010a1d1042', 'cannabis', 6),
(311, 'steam:11000010441bee9', 'gym_membership', 0),
(312, 'steam:11000010a1d1042', 'gym_membership', 0),
(313, 'steam:110000115e9ac6b', 'rakija', 0),
(314, 'steam:110000115e9ac6b', 'skundak', 0),
(315, 'steam:110000115e9ac6b', 'smtijelo', 0),
(316, 'steam:110000115e9ac6b', 'weapon_poolcue', 0),
(317, 'steam:110000115e9ac6b', 'packaged_chicken', 0),
(318, 'steam:110000115e9ac6b', 'LSD', 0),
(319, 'steam:110000115e9ac6b', 'weapon_combatpistol', 0),
(320, 'steam:110000115e9ac6b', 'drone_flyer_7', 0),
(321, 'steam:110000115e9ac6b', 'iron', 0),
(322, 'steam:110000115e9ac6b', 'weapon_crowbar', 0),
(323, 'steam:110000115e9ac6b', 'smkundak', 0),
(324, 'steam:110000115e9ac6b', 'weapon_pistol50', 0),
(325, 'steam:110000115e9ac6b', 'ckundak', 0),
(326, 'steam:110000115e9ac6b', 'skoljka', 0),
(327, 'steam:110000115e9ac6b', 'weapon_vintagepistol', 0),
(328, 'steam:110000115e9ac6b', 'acetone', 0),
(329, 'steam:110000115e9ac6b', 'seed', 0),
(330, 'steam:110000115e9ac6b', 'lancic', 0),
(331, 'steam:110000115e9ac6b', 'weapon_revolver_mk2', 0),
(332, 'steam:110000115e9ac6b', 'alive_chicken', 0),
(333, 'steam:110000115e9ac6b', 'weapon_machinepsitol', 0),
(334, 'steam:110000115e9ac6b', 'gintonic', 0),
(335, 'steam:110000115e9ac6b', 'weapon_heavypistol', 0),
(336, 'steam:110000115e9ac6b', 'essence', 0),
(337, 'steam:110000115e9ac6b', 'petrol_raffin', 0),
(338, 'steam:110000115e9ac6b', 'diamond', 0),
(339, 'steam:110000115e9ac6b', 'speed', 0),
(340, 'steam:110000115e9ac6b', 'weapon_pumpshotgun', 0),
(341, 'steam:110000115e9ac6b', 'bandage', 0),
(342, 'steam:110000115e9ac6b', 'weapon_advancedrifle', 0),
(343, 'steam:110000115e9ac6b', 'net_cracker', 0),
(344, 'steam:110000115e9ac6b', 'weapon_marksmanrifle_mk2', 0),
(345, 'steam:110000115e9ac6b', 'whisky', 0),
(346, 'steam:110000115e9ac6b', 'weapon_compactrifle', 0),
(347, 'steam:110000115e9ac6b', 'weapon_mg', 0),
(348, 'steam:110000115e9ac6b', 'ctijelo', 0),
(349, 'steam:110000115e9ac6b', 'weapon_fireextinguisher', 0),
(350, 'steam:110000115e9ac6b', 'champagne', 0),
(351, 'steam:110000115e9ac6b', 'koza', 0),
(352, 'steam:110000115e9ac6b', 'saksija', 0),
(353, 'steam:110000115e9ac6b', 'weapon_switchblade', 0),
(354, 'steam:110000115e9ac6b', 'copper', 0),
(355, 'steam:110000115e9ac6b', 'ktijelo', 0),
(356, 'steam:110000115e9ac6b', 'kola', 0),
(357, 'steam:110000115e9ac6b', 'weapon_specialcarbine', 0),
(358, 'steam:110000115e9ac6b', 'stijelo', 0),
(359, 'steam:110000115e9ac6b', 'scijev', 0),
(360, 'steam:110000115e9ac6b', 'gazbottle', 0),
(361, 'steam:110000115e9ac6b', 'fixkit', 0),
(362, 'steam:110000115e9ac6b', 'marijuana', 0),
(363, 'steam:110000115e9ac6b', 'weapon_smg', 0),
(364, 'steam:110000115e9ac6b', 'kcijev', 0),
(365, 'steam:110000115e9ac6b', 'weapon_combatmg', 0),
(366, 'steam:110000115e9ac6b', 'weapon_revolver', 0),
(367, 'steam:110000115e9ac6b', 'weapon_musket', 0),
(368, 'steam:110000115e9ac6b', 'ccijev', 0),
(369, 'steam:110000115e9ac6b', 'weapon_appistol', 0),
(370, 'steam:110000115e9ac6b', 'weapon_flashlight', 0),
(371, 'steam:110000115e9ac6b', 'gljive', 0),
(372, 'steam:110000115e9ac6b', 'zemlja', 0),
(373, 'steam:110000115e9ac6b', 'weapon_microsmg', 0),
(374, 'steam:110000115e9ac6b', 'cutted_wood', 0),
(375, 'steam:110000115e9ac6b', 'weapon_bat', 0),
(376, 'steam:110000115e9ac6b', 'grebalica', 0),
(377, 'steam:110000115e9ac6b', 'beer', 0),
(378, 'steam:110000115e9ac6b', 'stone', 0),
(379, 'steam:110000115e9ac6b', 'cannabis', 0),
(380, 'steam:110000115e9ac6b', 'milk', 0),
(381, 'steam:110000115e9ac6b', 'weapon_carbinerifle', 0),
(382, 'steam:110000115e9ac6b', 'zeton', 0),
(383, 'steam:110000115e9ac6b', 'weapon_assaultrifle_mk2', 0),
(384, 'steam:110000115e9ac6b', 'weapon_battleaxe', 0),
(385, 'steam:110000115e9ac6b', 'ljudi', 0),
(386, 'steam:110000115e9ac6b', 'kemija', 0),
(387, 'steam:110000115e9ac6b', 'smcijev', 0),
(388, 'steam:110000115e9ac6b', 'odznaka', 0),
(389, 'steam:110000115e9ac6b', 'clip', 0),
(390, 'steam:110000115e9ac6b', 'fabric', 0),
(391, 'steam:110000115e9ac6b', 'carokit', 0),
(392, 'steam:110000115e9ac6b', 'contract', 0),
(393, 'steam:110000115e9ac6b', 'mobitel', 0),
(394, 'steam:110000115e9ac6b', 'tequila', 0),
(395, 'steam:110000115e9ac6b', 'vodka', 0),
(396, 'steam:110000115e9ac6b', 'lighter', 0),
(397, 'steam:110000115e9ac6b', 'packaged_plank', 0),
(398, 'steam:110000115e9ac6b', 'absinthe', 0),
(399, 'steam:110000115e9ac6b', 'washed_stone', 0),
(400, 'steam:110000115e9ac6b', 'petrol', 0),
(401, 'steam:110000115e9ac6b', 'medikit', 0),
(402, 'steam:110000115e9ac6b', 'weapon_hatchet', 0),
(403, 'steam:110000115e9ac6b', 'heartpump', 0),
(404, 'steam:110000115e9ac6b', 'cigarett', 0),
(405, 'steam:110000115e9ac6b', 'bread', 0),
(406, 'steam:110000115e9ac6b', 'weapon_bullpupshotgun', 0),
(407, 'steam:110000115e9ac6b', 'pizza', 0),
(408, 'steam:110000115e9ac6b', 'wool', 0),
(409, 'steam:110000115e9ac6b', 'wine', 0),
(410, 'steam:110000115e9ac6b', 'slaughtered_chicken', 0),
(411, 'steam:110000115e9ac6b', 'wood', 0),
(412, 'steam:110000115e9ac6b', 'biser', 0),
(413, 'steam:110000115e9ac6b', 'weapon_bullpuprifle', 0),
(414, 'steam:110000115e9ac6b', 'weapon_hammer', 0),
(415, 'steam:110000115e9ac6b', 'weapon_assaultshotgun', 0),
(416, 'steam:110000115e9ac6b', 'weapon_sniperrifle', 0),
(417, 'steam:110000115e9ac6b', 'meth', 0),
(418, 'steam:110000115e9ac6b', 'weapon_wrench', 0),
(419, 'steam:110000115e9ac6b', 'ronjenje', 0),
(420, 'steam:110000115e9ac6b', 'weapon_sawnoffshotgun', 0),
(421, 'steam:110000115e9ac6b', 'petarda', 0),
(422, 'steam:110000115e9ac6b', 'weapon_pistol', 0),
(423, 'steam:110000115e9ac6b', 'methlab', 0),
(424, 'steam:110000115e9ac6b', 'weapon_minismg', 0),
(425, 'steam:110000115e9ac6b', 'weapon_marksmanrifle', 0),
(426, 'steam:110000115e9ac6b', 'weapon_combatpdw', 0),
(427, 'steam:110000115e9ac6b', 'weapon_marksmanpistol', 0),
(428, 'steam:110000115e9ac6b', 'weapon_machete', 0),
(429, 'steam:110000115e9ac6b', 'heroin', 0),
(430, 'steam:110000115e9ac6b', 'jewels', 0),
(431, 'steam:110000115e9ac6b', 'weapon_knife', 0),
(432, 'steam:110000115e9ac6b', 'weapon_heavysniper', 0),
(433, 'steam:110000115e9ac6b', 'blowpipe', 0),
(434, 'steam:110000115e9ac6b', 'duhan', 0),
(435, 'steam:110000115e9ac6b', 'weapon_heavyshotgun', 0),
(436, 'steam:110000115e9ac6b', 'gym_membership', 0),
(437, 'steam:110000115e9ac6b', 'carotool', 0),
(438, 'steam:110000115e9ac6b', 'weapon_gusenberg', 0),
(439, 'steam:110000115e9ac6b', 'cocaine', 0),
(440, 'steam:110000115e9ac6b', 'croquettes', 0),
(441, 'steam:110000115e9ac6b', 'weapon_golfclub', 0),
(442, 'steam:110000115e9ac6b', 'kkundak', 0),
(443, 'steam:110000115e9ac6b', 'weapon_firework', 0),
(444, 'steam:110000115e9ac6b', 'ukosnica', 0),
(445, 'steam:110000115e9ac6b', 'coke', 0),
(446, 'steam:110000115e9ac6b', 'fixtool', 0),
(447, 'steam:110000115e9ac6b', 'weapon_dbshotgun', 0),
(448, 'steam:110000115e9ac6b', 'clothe', 0),
(449, 'steam:110000115e9ac6b', 'fish', 0),
(450, 'steam:110000115e9ac6b', 'burek', 0),
(451, 'steam:110000115e9ac6b', 'weapon_assaultsmg', 0),
(452, 'steam:110000115e9ac6b', 'weapon_carbinerifle_mk2', 0),
(453, 'steam:110000115e9ac6b', 'weapon_doubleaction', 0),
(454, 'steam:110000115e9ac6b', 'weapon_autoshotgun', 0),
(455, 'steam:110000115e9ac6b', 'weapon_snspistol', 0),
(456, 'steam:110000115e9ac6b', 'weapon_nightstick', 0),
(457, 'steam:110000115e9ac6b', 'water', 0),
(458, 'steam:110000115e9ac6b', 'lithium', 0),
(459, 'steam:110000115e9ac6b', 'headbag', 0),
(460, 'steam:110000115e9ac6b', 'thermite', 0),
(461, 'steam:110000115e9ac6b', 'vatromet', 0),
(462, 'steam:110000115e9ac6b', 'repairkit', 0),
(463, 'steam:110000115e9ac6b', 'petarde', 0),
(464, 'steam:110000115e9ac6b', 'narukvica', 0),
(465, 'steam:110000115e9ac6b', 'gold', 0),
(466, 'steam:110000115e9ac6b', 'weapon_assaultrifle', 0),
(467, 'steam:110000115e9ac6b', 'autobomba', 0),
(468, 'steam:110000115e9ac6b', 'meso', 0),
(469, 'steam:110000115e9ac6b', 'sulfuric_acid', 0),
(470, 'steam:110000115e9ac6b', 'hydrochloric_acid', 0),
(471, 'steam:110000115e9ac6b', 'poppyresin', 0),
(472, 'steam:110000115e9ac6b', 'chemicals', 0),
(473, 'steam:110000115e9ac6b', 'moneywash', 0),
(474, 'steam:110000115e9ac6b', 'sodium_hydroxide', 2),
(475, 'steam:110000115e9ac6b', 'chemicalslisence', 0),
(476, 'steam:110000115e9ac6b', 'thionyl_chloride', 0),
(477, 'steam:110000115e9ac6b', 'lsa', 15),
(478, 'steam:11000010a1d1042', 'sulfuric_acid', 1),
(479, 'steam:11000010a1d1042', 'hydrochloric_acid', 5),
(480, 'steam:11000010a1d1042', 'poppyresin', 20),
(481, 'steam:11000010a1d1042', 'chemicals', 1),
(482, 'steam:11000010a1d1042', 'moneywash', 0),
(483, 'steam:11000010a1d1042', 'sodium_hydroxide', 2),
(484, 'steam:11000010a1d1042', 'chemicalslisence', 0),
(485, 'steam:11000010a1d1042', 'thionyl_chloride', 1),
(486, 'steam:11000010a1d1042', 'lsa', 1),
(487, 'steam:11000010441bee9', 'hydrochloric_acid', 0),
(488, 'steam:11000010441bee9', 'thionyl_chloride', 0),
(489, 'steam:11000010441bee9', 'lsa', 0),
(490, 'steam:11000010441bee9', 'moneywash', 0),
(491, 'steam:11000010441bee9', 'sulfuric_acid', 0),
(492, 'steam:11000010441bee9', 'poppyresin', 0),
(493, 'steam:11000010441bee9', 'chemicals', 0),
(494, 'steam:11000010441bee9', 'sodium_hydroxide', 0),
(495, 'steam:11000010441bee9', 'chemicalslisence', 0),
(496, 'steam:11000010441bee9', 'loto', 0),
(497, 'steam:11000010e086b7e', 'weapon_assaultshotgun', 0),
(498, 'steam:11000010e086b7e', 'weapon_bat', 0),
(499, 'steam:11000010e086b7e', 'bandage', 0),
(500, 'steam:11000010e086b7e', 'stijelo', 0),
(501, 'steam:11000010e086b7e', 'weapon_combatpistol', 0),
(502, 'steam:11000010e086b7e', 'coke', 0),
(503, 'steam:11000010e086b7e', 'diamond', 0),
(504, 'steam:11000010e086b7e', 'wool', 0),
(505, 'steam:11000010e086b7e', 'cutted_wood', 0),
(506, 'steam:11000010e086b7e', 'repairkit', 0),
(507, 'steam:11000010e086b7e', 'gintonic', 0),
(508, 'steam:11000010e086b7e', 'weapon_switchblade', 0),
(509, 'steam:11000010e086b7e', 'pizza', 0),
(510, 'steam:11000010e086b7e', 'weapon_doubleaction', 0),
(511, 'steam:11000010e086b7e', 'duhan', 0),
(512, 'steam:11000010e086b7e', 'weapon_sawnoffshotgun', 0),
(513, 'steam:11000010e086b7e', 'blowpipe', 0),
(514, 'steam:11000010e086b7e', 'fixkit', 0),
(515, 'steam:11000010e086b7e', 'grebalica', 0),
(516, 'steam:11000010e086b7e', 'narukvica', 0),
(517, 'steam:11000010e086b7e', 'chemicalslisence', 0),
(518, 'steam:11000010e086b7e', 'mobitel', 1),
(519, 'steam:11000010e086b7e', 'essence', 0),
(520, 'steam:11000010e086b7e', 'skundak', 0),
(521, 'steam:11000010e086b7e', 'weapon_heavyshotgun', 0),
(522, 'steam:11000010e086b7e', 'moneywash', 0),
(523, 'steam:11000010e086b7e', 'heartpump', 0),
(524, 'steam:11000010e086b7e', 'weapon_advancedrifle', 0),
(525, 'steam:11000010e086b7e', 'wine', 0),
(526, 'steam:11000010e086b7e', 'weapon_assaultsmg', 0),
(527, 'steam:11000010e086b7e', 'weapon_specialcarbine', 0),
(528, 'steam:11000010e086b7e', 'weapon_carbinerifle_mk2', 0),
(529, 'steam:11000010e086b7e', 'medikit', 0),
(530, 'steam:11000010e086b7e', 'ckundak', 0),
(531, 'steam:11000010e086b7e', 'slaughtered_chicken', 0),
(532, 'steam:11000010e086b7e', 'weapon_nightstick', 0),
(533, 'steam:11000010e086b7e', 'weapon_golfclub', 0),
(534, 'steam:11000010e086b7e', 'smcijev', 1),
(535, 'steam:11000010e086b7e', 'vodka', 0),
(536, 'steam:11000010e086b7e', 'loto', 0),
(537, 'steam:11000010e086b7e', 'weapon_marksmanrifle', 0),
(538, 'steam:11000010e086b7e', 'methlab', 0),
(539, 'steam:11000010e086b7e', 'carokit', 0),
(540, 'steam:11000010e086b7e', 'poppyresin', 0),
(541, 'steam:11000010e086b7e', 'gym_membership', 0),
(542, 'steam:11000010e086b7e', 'contract', 0),
(543, 'steam:11000010e086b7e', 'weapon_firework', 0),
(544, 'steam:11000010e086b7e', 'cannabis', 0),
(545, 'steam:11000010e086b7e', 'weapon_assaultrifle_mk2', 0),
(546, 'steam:11000010e086b7e', 'lancic', 0),
(547, 'steam:11000010e086b7e', 'ukosnica', 0),
(548, 'steam:11000010e086b7e', 'weapon_battleaxe', 0),
(549, 'steam:11000010e086b7e', 'clothe', 0),
(550, 'steam:11000010e086b7e', 'carotool', 0),
(551, 'steam:11000010e086b7e', 'weapon_marksmanpistol', 0),
(552, 'steam:11000010e086b7e', 'milk', 0),
(553, 'steam:11000010e086b7e', 'gazbottle', 0),
(554, 'steam:11000010e086b7e', 'bread', 0),
(555, 'steam:11000010e086b7e', 'ljudi', 0),
(556, 'steam:11000010e086b7e', 'weapon_hammer', 0),
(557, 'steam:11000010e086b7e', 'ctijelo', 0),
(558, 'steam:11000010e086b7e', 'drone_flyer_7', 0),
(559, 'steam:11000010e086b7e', 'weapon_minismg', 0),
(560, 'steam:11000010e086b7e', 'ktijelo', 0),
(561, 'steam:11000010e086b7e', 'speed', 0),
(562, 'steam:11000010e086b7e', 'burek', 0),
(563, 'steam:11000010e086b7e', 'skoljka', 0),
(564, 'steam:11000010e086b7e', 'autobomba', 0),
(565, 'steam:11000010e086b7e', 'lsa', 0),
(566, 'steam:11000010e086b7e', 'sodium_hydroxide', 0),
(567, 'steam:11000010e086b7e', 'weapon_gusenberg', 0),
(568, 'steam:11000010e086b7e', 'thionyl_chloride', 0),
(569, 'steam:11000010e086b7e', 'tequila', 0),
(570, 'steam:11000010e086b7e', 'weapon_musket', 0),
(571, 'steam:11000010e086b7e', 'marijuana', 0),
(572, 'steam:11000010e086b7e', 'kemija', 0),
(573, 'steam:11000010e086b7e', 'cocaine', 0),
(574, 'steam:11000010e086b7e', 'water', 0),
(575, 'steam:11000010e086b7e', 'weapon_appistol', 0),
(576, 'steam:11000010e086b7e', 'washed_stone', 0),
(577, 'steam:11000010e086b7e', 'beer', 0),
(578, 'steam:11000010e086b7e', 'ccijev', 0),
(579, 'steam:11000010e086b7e', 'fish', 0),
(580, 'steam:11000010e086b7e', 'kcijev', 0),
(581, 'steam:11000010e086b7e', 'heroin', 0),
(582, 'steam:11000010e086b7e', 'weapon_microsmg', 0),
(583, 'steam:11000010e086b7e', 'LSD', 0),
(584, 'steam:11000010e086b7e', 'scijev', 1),
(585, 'steam:11000010e086b7e', 'alive_chicken', 0),
(586, 'steam:11000010e086b7e', 'zemlja', 0),
(587, 'steam:11000010e086b7e', 'wood', 0),
(588, 'steam:11000010e086b7e', 'weapon_smg', 0),
(589, 'steam:11000010e086b7e', 'whisky', 0),
(590, 'steam:11000010e086b7e', 'saksija', 0),
(591, 'steam:11000010e086b7e', 'weapon_assaultrifle', 0),
(592, 'steam:11000010e086b7e', 'weapon_vintagepistol', 0),
(593, 'steam:11000010e086b7e', 'weapon_wrench', 0),
(594, 'steam:11000010e086b7e', 'weapon_snspistol', 0),
(595, 'steam:11000010e086b7e', 'weapon_sniperrifle', 0),
(596, 'steam:11000010e086b7e', 'smtijelo', 0),
(597, 'steam:11000010e086b7e', 'weapon_revolver_mk2', 0),
(598, 'steam:11000010e086b7e', 'petrol', 0),
(599, 'steam:11000010e086b7e', 'weapon_revolver', 0),
(600, 'steam:11000010e086b7e', 'weapon_poolcue', 0),
(601, 'steam:11000010e086b7e', 'lithium', 0),
(602, 'steam:11000010e086b7e', 'weapon_pistol50', 0),
(603, 'steam:11000010e086b7e', 'jewels', 0),
(604, 'steam:11000010e086b7e', 'weapon_pistol', 0),
(605, 'steam:11000010e086b7e', 'weapon_mg', 0),
(606, 'steam:11000010e086b7e', 'weapon_crowbar', 0),
(607, 'steam:11000010e086b7e', 'weapon_marksmanrifle_mk2', 0),
(608, 'steam:11000010e086b7e', 'weapon_machinepsitol', 0),
(609, 'steam:11000010e086b7e', 'petrol_raffin', 0),
(610, 'steam:11000010e086b7e', 'weapon_dbshotgun', 0),
(611, 'steam:11000010e086b7e', 'weapon_bullpupshotgun', 0),
(612, 'steam:11000010e086b7e', 'stone', 0),
(613, 'steam:11000010e086b7e', 'weapon_heavypistol', 0),
(614, 'steam:11000010e086b7e', 'weapon_pumpshotgun', 0),
(615, 'steam:11000010e086b7e', 'weapon_knife', 0),
(616, 'steam:11000010e086b7e', 'weapon_heavysniper', 0),
(617, 'steam:11000010e086b7e', 'weapon_hatchet', 0),
(618, 'steam:11000010e086b7e', 'meso', 0),
(619, 'steam:11000010e086b7e', 'zeton', 0),
(620, 'steam:11000010e086b7e', 'meth', 0),
(621, 'steam:11000010e086b7e', 'weapon_flashlight', 0),
(622, 'steam:11000010e086b7e', 'weapon_fireextinguisher', 0),
(623, 'steam:11000010e086b7e', 'weapon_combatpdw', 0),
(624, 'steam:11000010e086b7e', 'chemicals', 0),
(625, 'steam:11000010e086b7e', 'vatromet', 0),
(626, 'steam:11000010e086b7e', 'rakija', 0),
(627, 'steam:11000010e086b7e', 'smkundak', 0),
(628, 'steam:11000010e086b7e', 'lighter', 0),
(629, 'steam:11000010e086b7e', 'packaged_plank', 0),
(630, 'steam:11000010e086b7e', 'koza', 0),
(631, 'steam:11000010e086b7e', 'weapon_compactrifle', 0),
(632, 'steam:11000010e086b7e', 'weapon_combatmg', 0),
(633, 'steam:11000010e086b7e', 'thermite', 0),
(634, 'steam:11000010e086b7e', 'fixtool', 0),
(635, 'steam:11000010e086b7e', 'weapon_carbinerifle', 0),
(636, 'steam:11000010e086b7e', 'gold', 0),
(637, 'steam:11000010e086b7e', 'weapon_bullpuprifle', 0),
(638, 'steam:11000010e086b7e', 'acetone', 0),
(639, 'steam:11000010e086b7e', 'clip', 0),
(640, 'steam:11000010e086b7e', 'kkundak', 0),
(641, 'steam:11000010e086b7e', 'gljive', 0),
(642, 'steam:11000010e086b7e', 'packaged_chicken', 0),
(643, 'steam:11000010e086b7e', 'weapon_autoshotgun', 0),
(644, 'steam:11000010e086b7e', 'petarde', 0),
(645, 'steam:11000010e086b7e', 'odznaka', 0),
(646, 'steam:11000010e086b7e', 'ronjenje', 0),
(647, 'steam:11000010e086b7e', 'sulfuric_acid', 0),
(648, 'steam:11000010e086b7e', 'champagne', 0),
(649, 'steam:11000010e086b7e', 'iron', 0),
(650, 'steam:11000010e086b7e', 'biser', 0),
(651, 'steam:11000010e086b7e', 'weapon_machete', 0),
(652, 'steam:11000010e086b7e', 'croquettes', 0),
(653, 'steam:11000010e086b7e', 'seed', 0),
(654, 'steam:11000010e086b7e', 'hydrochloric_acid', 0),
(655, 'steam:11000010e086b7e', 'copper', 0),
(656, 'steam:11000010e086b7e', 'petarda', 0),
(657, 'steam:11000010e086b7e', 'net_cracker', 0),
(658, 'steam:11000010e086b7e', 'headbag', 0),
(659, 'steam:11000010e086b7e', 'fabric', 0),
(660, 'steam:11000010e086b7e', 'kola', 0),
(661, 'steam:11000010e086b7e', 'cigarett', 0),
(662, 'steam:11000010e086b7e', 'absinthe', 0),
(663, 'steam:11000010ad5cf80', 'thionyl_chloride', 0),
(664, 'steam:11000010ad5cf80', 'ljudi', 0),
(665, 'steam:11000010ad5cf80', 'iron', 0),
(666, 'steam:11000010ad5cf80', 'fixtool', 0),
(667, 'steam:11000010ad5cf80', 'coke', 0),
(668, 'steam:11000010ad5cf80', 'blowpipe', 0),
(669, 'steam:11000010ad5cf80', 'weapon_snspistol', 0),
(670, 'steam:11000010ad5cf80', 'weapon_bullpuprifle', 0),
(671, 'steam:11000010ad5cf80', 'weapon_machinepsitol', 0),
(672, 'steam:11000010ad5cf80', 'packaged_chicken', 0),
(673, 'steam:11000010ad5cf80', 'narukvica', 0),
(674, 'steam:11000010ad5cf80', 'weapon_revolver_mk2', 0),
(675, 'steam:11000010ad5cf80', 'sodium_hydroxide', 0),
(676, 'steam:11000010ad5cf80', 'weapon_fireextinguisher', 0),
(677, 'steam:11000010ad5cf80', 'heartpump', 0),
(678, 'steam:11000010ad5cf80', 'weapon_sawnoffshotgun', 0),
(679, 'steam:11000010ad5cf80', 'bandage', 0),
(680, 'steam:11000010ad5cf80', 'kola', 0),
(681, 'steam:11000010ad5cf80', 'seed', 0),
(682, 'steam:11000010ad5cf80', 'methlab', 0),
(683, 'steam:11000010ad5cf80', 'meso', 0),
(684, 'steam:11000010ad5cf80', 'weapon_assaultshotgun', 0),
(685, 'steam:11000010ad5cf80', 'weapon_bullpupshotgun', 0),
(686, 'steam:11000010ad5cf80', 'weapon_machete', 0),
(687, 'steam:11000010ad5cf80', 'weapon_poolcue', 0),
(688, 'steam:11000010ad5cf80', 'weapon_specialcarbine', 0),
(689, 'steam:11000010ad5cf80', 'weapon_bat', 0),
(690, 'steam:11000010ad5cf80', 'beer', 0),
(691, 'steam:11000010ad5cf80', 'grebalica', 0),
(692, 'steam:11000010ad5cf80', 'smtijelo', 0),
(693, 'steam:11000010ad5cf80', 'weapon_firework', 0),
(694, 'steam:11000010ad5cf80', 'champagne', 0),
(695, 'steam:11000010ad5cf80', 'hydrochloric_acid', 0),
(696, 'steam:11000010ad5cf80', 'marijuana', 0),
(697, 'steam:11000010ad5cf80', 'weapon_compactrifle', 0),
(698, 'steam:11000010ad5cf80', 'contract', 0),
(699, 'steam:11000010ad5cf80', 'washed_stone', 0),
(700, 'steam:11000010ad5cf80', 'gym_membership', 0),
(701, 'steam:11000010ad5cf80', 'lighter', 0),
(702, 'steam:11000010ad5cf80', 'ccijev', 0),
(703, 'steam:11000010ad5cf80', 'weapon_mg', 0),
(704, 'steam:11000010ad5cf80', 'poppyresin', 0),
(705, 'steam:11000010ad5cf80', 'petrol', 0),
(706, 'steam:11000010ad5cf80', 'weapon_pumpshotgun', 0),
(707, 'steam:11000010ad5cf80', 'lithium', 0),
(708, 'steam:11000010ad5cf80', 'scijev', 0),
(709, 'steam:11000010ad5cf80', 'ktijelo', 0),
(710, 'steam:11000010ad5cf80', 'cannabis', 0),
(711, 'steam:11000010ad5cf80', 'cigarett', 0),
(712, 'steam:11000010ad5cf80', 'vodka', 0),
(713, 'steam:11000010ad5cf80', 'ctijelo', 0),
(714, 'steam:11000010ad5cf80', 'petrol_raffin', 0),
(715, 'steam:11000010ad5cf80', 'weapon_minismg', 0),
(716, 'steam:11000010ad5cf80', 'zemlja', 0),
(717, 'steam:11000010ad5cf80', 'gintonic', 0),
(718, 'steam:11000010ad5cf80', 'gold', 0),
(719, 'steam:11000010ad5cf80', 'speed', 0),
(720, 'steam:11000010ad5cf80', 'wood', 0),
(721, 'steam:11000010ad5cf80', 'weapon_gusenberg', 0),
(722, 'steam:11000010ad5cf80', 'headbag', 0),
(723, 'steam:11000010ad5cf80', 'clothe', 0),
(724, 'steam:11000010ad5cf80', 'weapon_combatpistol', 0),
(725, 'steam:11000010ad5cf80', 'weapon_battleaxe', 0),
(726, 'steam:11000010ad5cf80', 'clip', 0),
(727, 'steam:11000010ad5cf80', 'weapon_nightstick', 0),
(728, 'steam:11000010ad5cf80', 'copper', 0),
(729, 'steam:11000010ad5cf80', 'alive_chicken', 0),
(730, 'steam:11000010ad5cf80', 'weapon_microsmg', 0),
(731, 'steam:11000010ad5cf80', 'smkundak', 0),
(732, 'steam:11000010ad5cf80', 'kemija', 0),
(733, 'steam:11000010ad5cf80', 'wine', 0),
(734, 'steam:11000010ad5cf80', 'smcijev', 0),
(735, 'steam:11000010ad5cf80', 'ukosnica', 0),
(736, 'steam:11000010ad5cf80', 'diamond', 0),
(737, 'steam:11000010ad5cf80', 'lsa', 0),
(738, 'steam:11000010ad5cf80', 'mobitel', 0),
(739, 'steam:11000010ad5cf80', 'bread', 0),
(740, 'steam:11000010ad5cf80', 'drone_flyer_7', 0),
(741, 'steam:11000010ad5cf80', 'pizza', 0),
(742, 'steam:11000010ad5cf80', 'odznaka', 0),
(743, 'steam:11000010ad5cf80', 'cutted_wood', 0),
(744, 'steam:11000010ad5cf80', 'weapon_switchblade', 0),
(745, 'steam:11000010ad5cf80', 'weapon_assaultrifle_mk2', 0),
(746, 'steam:11000010ad5cf80', 'weapon_advancedrifle', 0),
(747, 'steam:11000010ad5cf80', 'net_cracker', 0),
(748, 'steam:11000010ad5cf80', 'slaughtered_chicken', 0),
(749, 'steam:11000010ad5cf80', 'skundak', 0),
(750, 'steam:11000010ad5cf80', 'sulfuric_acid', 0),
(751, 'steam:11000010ad5cf80', 'weapon_hatchet', 0),
(752, 'steam:11000010ad5cf80', 'rakija', 0),
(753, 'steam:11000010ad5cf80', 'kkundak', 0),
(754, 'steam:11000010ad5cf80', 'jewels', 0),
(755, 'steam:11000010ad5cf80', 'weapon_knife', 0),
(756, 'steam:11000010ad5cf80', 'ckundak', 0),
(757, 'steam:11000010ad5cf80', 'autobomba', 0),
(758, 'steam:11000010ad5cf80', 'saksija', 0),
(759, 'steam:11000010ad5cf80', 'weapon_hammer', 0),
(760, 'steam:11000010ad5cf80', 'gljive', 0),
(761, 'steam:11000010ad5cf80', 'weapon_assaultrifle', 0),
(762, 'steam:11000010ad5cf80', 'weapon_dbshotgun', 0),
(763, 'steam:11000010ad5cf80', 'koza', 0),
(764, 'steam:11000010ad5cf80', 'chemicalslisence', 0),
(765, 'steam:11000010ad5cf80', 'fixkit', 0),
(766, 'steam:11000010ad5cf80', 'weapon_carbinerifle_mk2', 0),
(767, 'steam:11000010ad5cf80', 'weapon_combatmg', 0),
(768, 'steam:11000010ad5cf80', 'zeton', 0),
(769, 'steam:11000010ad5cf80', 'wool', 0),
(770, 'steam:11000010ad5cf80', 'whisky', 0),
(771, 'steam:11000010ad5cf80', 'chemicals', 0),
(772, 'steam:11000010ad5cf80', 'weapon_wrench', 0),
(773, 'steam:11000010ad5cf80', 'weapon_vintagepistol', 0),
(774, 'steam:11000010ad5cf80', 'weapon_sniperrifle', 0),
(775, 'steam:11000010ad5cf80', 'weapon_marksmanpistol', 0),
(776, 'steam:11000010ad5cf80', 'weapon_revolver', 0),
(777, 'steam:11000010ad5cf80', 'weapon_pistol', 0),
(778, 'steam:11000010ad5cf80', 'cocaine', 0),
(779, 'steam:11000010ad5cf80', 'weapon_musket', 0),
(780, 'steam:11000010ad5cf80', 'weapon_marksmanrifle_mk2', 0),
(781, 'steam:11000010ad5cf80', 'weapon_marksmanrifle', 0),
(782, 'steam:11000010ad5cf80', 'weapon_heavysniper', 0),
(783, 'steam:11000010ad5cf80', 'stone', 0),
(784, 'steam:11000010ad5cf80', 'weapon_smg', 0),
(785, 'steam:11000010ad5cf80', 'weapon_heavyshotgun', 0),
(786, 'steam:11000010ad5cf80', 'weapon_heavypistol', 0),
(787, 'steam:11000010ad5cf80', 'weapon_golfclub', 0),
(788, 'steam:11000010ad5cf80', 'meth', 0),
(789, 'steam:11000010ad5cf80', 'fish', 0),
(790, 'steam:11000010ad5cf80', 'lancic', 0),
(791, 'steam:11000010ad5cf80', 'croquettes', 0),
(792, 'steam:11000010ad5cf80', 'heroin', 0),
(793, 'steam:11000010ad5cf80', 'milk', 0),
(794, 'steam:11000010ad5cf80', 'weapon_appistol', 0),
(795, 'steam:11000010ad5cf80', 'weapon_doubleaction', 0),
(796, 'steam:11000010ad5cf80', 'water', 0),
(797, 'steam:11000010ad5cf80', 'moneywash', 0),
(798, 'steam:11000010ad5cf80', 'weapon_crowbar', 0),
(799, 'steam:11000010ad5cf80', 'essence', 0),
(800, 'steam:11000010ad5cf80', 'carotool', 0),
(801, 'steam:11000010ad5cf80', 'petarda', 0),
(802, 'steam:11000010ad5cf80', 'weapon_combatpdw', 0),
(803, 'steam:11000010ad5cf80', 'vatromet', 0),
(804, 'steam:11000010ad5cf80', 'biser', 0),
(805, 'steam:11000010ad5cf80', 'ronjenje', 0),
(806, 'steam:11000010ad5cf80', 'petarde', 0),
(807, 'steam:11000010ad5cf80', 'weapon_flashlight', 0),
(808, 'steam:11000010ad5cf80', 'weapon_carbinerifle', 0),
(809, 'steam:11000010ad5cf80', 'repairkit', 0),
(810, 'steam:11000010ad5cf80', 'medikit', 0),
(811, 'steam:11000010ad5cf80', 'weapon_autoshotgun', 0),
(812, 'steam:11000010ad5cf80', 'burek', 0),
(813, 'steam:11000010ad5cf80', 'weapon_pistol50', 0),
(814, 'steam:11000010ad5cf80', 'weapon_assaultsmg', 0),
(815, 'steam:11000010ad5cf80', 'packaged_plank', 0),
(816, 'steam:11000010ad5cf80', 'thermite', 0),
(817, 'steam:11000010ad5cf80', 'tequila', 0),
(818, 'steam:11000010ad5cf80', 'kcijev', 0),
(819, 'steam:11000010ad5cf80', 'stijelo', 0),
(820, 'steam:11000010ad5cf80', 'acetone', 0),
(821, 'steam:11000010ad5cf80', 'LSD', 0),
(822, 'steam:11000010ad5cf80', 'gazbottle', 0),
(823, 'steam:11000010ad5cf80', 'carokit', 0),
(824, 'steam:11000010ad5cf80', 'fabric', 0),
(825, 'steam:11000010ad5cf80', 'loto', 0),
(826, 'steam:11000010ad5cf80', 'skoljka', 0),
(827, 'steam:11000010ad5cf80', 'absinthe', 0),
(828, 'steam:11000010ad5cf80', 'duhan', 0),
(829, 'steam:110000106921eea', 'iron', 0),
(830, 'steam:110000106921eea', 'thionyl_chloride', 0),
(831, 'steam:110000106921eea', 'ljudi', 0),
(832, 'steam:110000106921eea', 'coke', 0),
(833, 'steam:110000106921eea', 'fixtool', 0),
(834, 'steam:110000106921eea', 'weapon_snspistol', 0),
(835, 'steam:110000106921eea', 'blowpipe', 0),
(836, 'steam:110000106921eea', 'weapon_bullpuprifle', 0),
(837, 'steam:110000106921eea', 'packaged_chicken', 0),
(838, 'steam:110000106921eea', 'weapon_machinepsitol', 0),
(839, 'steam:110000106921eea', 'narukvica', 0),
(840, 'steam:110000106921eea', 'weapon_revolver_mk2', 0),
(841, 'steam:110000106921eea', 'sodium_hydroxide', 0),
(842, 'steam:110000106921eea', 'weapon_fireextinguisher', 0),
(843, 'steam:110000106921eea', 'heartpump', 0),
(844, 'steam:110000106921eea', 'weapon_sawnoffshotgun', 0),
(845, 'steam:110000106921eea', 'bandage', 0),
(846, 'steam:110000106921eea', 'kola', 0),
(847, 'steam:110000106921eea', 'seed', 0),
(848, 'steam:110000106921eea', 'methlab', 0),
(849, 'steam:110000106921eea', 'meso', 0),
(850, 'steam:110000106921eea', 'weapon_assaultshotgun', 0),
(851, 'steam:110000106921eea', 'weapon_bullpupshotgun', 0),
(852, 'steam:110000106921eea', 'weapon_machete', 0),
(853, 'steam:110000106921eea', 'weapon_poolcue', 0),
(854, 'steam:110000106921eea', 'weapon_specialcarbine', 0),
(855, 'steam:110000106921eea', 'weapon_bat', 0),
(856, 'steam:110000106921eea', 'beer', 0),
(857, 'steam:110000106921eea', 'grebalica', 0),
(858, 'steam:110000106921eea', 'smtijelo', 0),
(859, 'steam:110000106921eea', 'weapon_firework', 0),
(860, 'steam:110000106921eea', 'champagne', 0),
(861, 'steam:110000106921eea', 'hydrochloric_acid', 0),
(862, 'steam:110000106921eea', 'marijuana', 0),
(863, 'steam:110000106921eea', 'weapon_compactrifle', 0),
(864, 'steam:110000106921eea', 'washed_stone', 0),
(865, 'steam:110000106921eea', 'contract', 0),
(866, 'steam:110000106921eea', 'gym_membership', 0),
(867, 'steam:110000106921eea', 'lighter', 0),
(868, 'steam:110000106921eea', 'ccijev', 0),
(869, 'steam:110000106921eea', 'poppyresin', 0),
(870, 'steam:110000106921eea', 'weapon_mg', 0),
(871, 'steam:110000106921eea', 'petrol', 0),
(872, 'steam:110000106921eea', 'weapon_pumpshotgun', 0),
(873, 'steam:110000106921eea', 'lithium', 0),
(874, 'steam:110000106921eea', 'scijev', 0),
(875, 'steam:110000106921eea', 'ktijelo', 0),
(876, 'steam:110000106921eea', 'cannabis', 0),
(877, 'steam:110000106921eea', 'cigarett', 0),
(878, 'steam:110000106921eea', 'vodka', 0),
(879, 'steam:110000106921eea', 'petrol_raffin', 0),
(880, 'steam:110000106921eea', 'ctijelo', 0),
(881, 'steam:110000106921eea', 'weapon_minismg', 0),
(882, 'steam:110000106921eea', 'zemlja', 0),
(883, 'steam:110000106921eea', 'gintonic', 0),
(884, 'steam:110000106921eea', 'gold', 0),
(885, 'steam:110000106921eea', 'speed', 0),
(886, 'steam:110000106921eea', 'weapon_gusenberg', 0),
(887, 'steam:110000106921eea', 'wood', 0),
(888, 'steam:110000106921eea', 'headbag', 0),
(889, 'steam:110000106921eea', 'clothe', 0),
(890, 'steam:110000106921eea', 'weapon_combatpistol', 0),
(891, 'steam:110000106921eea', 'weapon_battleaxe', 0),
(892, 'steam:110000106921eea', 'clip', 0),
(893, 'steam:110000106921eea', 'weapon_nightstick', 0),
(894, 'steam:110000106921eea', 'copper', 0),
(895, 'steam:110000106921eea', 'alive_chicken', 0),
(896, 'steam:110000106921eea', 'weapon_microsmg', 0),
(897, 'steam:110000106921eea', 'smkundak', 0),
(898, 'steam:110000106921eea', 'kemija', 0),
(899, 'steam:110000106921eea', 'wine', 0),
(900, 'steam:110000106921eea', 'smcijev', 0),
(901, 'steam:110000106921eea', 'diamond', 0),
(902, 'steam:110000106921eea', 'ukosnica', 0),
(903, 'steam:110000106921eea', 'lsa', 0),
(904, 'steam:110000106921eea', 'mobitel', 1),
(905, 'steam:110000106921eea', 'bread', 0),
(906, 'steam:110000106921eea', 'drone_flyer_7', 0),
(907, 'steam:110000106921eea', 'pizza', 0),
(908, 'steam:110000106921eea', 'odznaka', 0),
(909, 'steam:110000106921eea', 'cutted_wood', 0),
(910, 'steam:110000106921eea', 'weapon_switchblade', 0),
(911, 'steam:110000106921eea', 'weapon_assaultrifle_mk2', 0),
(912, 'steam:110000106921eea', 'weapon_advancedrifle', 0),
(913, 'steam:110000106921eea', 'slaughtered_chicken', 0),
(914, 'steam:110000106921eea', 'net_cracker', 0),
(915, 'steam:110000106921eea', 'skundak', 0),
(916, 'steam:110000106921eea', 'sulfuric_acid', 0),
(917, 'steam:110000106921eea', 'weapon_hatchet', 0),
(918, 'steam:110000106921eea', 'rakija', 0),
(919, 'steam:110000106921eea', 'kkundak', 0),
(920, 'steam:110000106921eea', 'jewels', 0),
(921, 'steam:110000106921eea', 'weapon_knife', 0),
(922, 'steam:110000106921eea', 'ckundak', 0),
(923, 'steam:110000106921eea', 'autobomba', 0),
(924, 'steam:110000106921eea', 'saksija', 0),
(925, 'steam:110000106921eea', 'gljive', 0),
(926, 'steam:110000106921eea', 'weapon_hammer', 0),
(927, 'steam:110000106921eea', 'weapon_assaultrifle', 0),
(928, 'steam:110000106921eea', 'weapon_dbshotgun', 0),
(929, 'steam:110000106921eea', 'koza', 0),
(930, 'steam:110000106921eea', 'chemicalslisence', 0),
(931, 'steam:110000106921eea', 'fixkit', 0),
(932, 'steam:110000106921eea', 'weapon_carbinerifle_mk2', 0),
(933, 'steam:110000106921eea', 'weapon_combatmg', 0),
(934, 'steam:110000106921eea', 'zeton', 0),
(935, 'steam:110000106921eea', 'wool', 0),
(936, 'steam:110000106921eea', 'whisky', 0),
(937, 'steam:110000106921eea', 'chemicals', 0),
(938, 'steam:110000106921eea', 'weapon_wrench', 0),
(939, 'steam:110000106921eea', 'weapon_vintagepistol', 0),
(940, 'steam:110000106921eea', 'weapon_sniperrifle', 0),
(941, 'steam:110000106921eea', 'weapon_marksmanpistol', 0),
(942, 'steam:110000106921eea', 'weapon_revolver', 0),
(943, 'steam:110000106921eea', 'cocaine', 0),
(944, 'steam:110000106921eea', 'weapon_pistol', 0),
(945, 'steam:110000106921eea', 'weapon_musket', 0),
(946, 'steam:110000106921eea', 'weapon_marksmanrifle_mk2', 0),
(947, 'steam:110000106921eea', 'weapon_marksmanrifle', 0),
(948, 'steam:110000106921eea', 'stone', 0),
(949, 'steam:110000106921eea', 'weapon_heavysniper', 0),
(950, 'steam:110000106921eea', 'weapon_smg', 0),
(951, 'steam:110000106921eea', 'weapon_heavyshotgun', 0),
(952, 'steam:110000106921eea', 'weapon_heavypistol', 0),
(953, 'steam:110000106921eea', 'weapon_golfclub', 0),
(954, 'steam:110000106921eea', 'meth', 0),
(955, 'steam:110000106921eea', 'fish', 0),
(956, 'steam:110000106921eea', 'lancic', 0),
(957, 'steam:110000106921eea', 'croquettes', 0),
(958, 'steam:110000106921eea', 'heroin', 0),
(959, 'steam:110000106921eea', 'milk', 0),
(960, 'steam:110000106921eea', 'weapon_doubleaction', 0),
(961, 'steam:110000106921eea', 'weapon_appistol', 0),
(962, 'steam:110000106921eea', 'water', 0),
(963, 'steam:110000106921eea', 'moneywash', 0),
(964, 'steam:110000106921eea', 'weapon_crowbar', 0),
(965, 'steam:110000106921eea', 'essence', 0),
(966, 'steam:110000106921eea', 'carotool', 0),
(967, 'steam:110000106921eea', 'petarda', 0),
(968, 'steam:110000106921eea', 'weapon_combatpdw', 0),
(969, 'steam:110000106921eea', 'vatromet', 0),
(970, 'steam:110000106921eea', 'biser', 0),
(971, 'steam:110000106921eea', 'ronjenje', 0),
(972, 'steam:110000106921eea', 'petarde', 0),
(973, 'steam:110000106921eea', 'weapon_flashlight', 0),
(974, 'steam:110000106921eea', 'weapon_carbinerifle', 0),
(975, 'steam:110000106921eea', 'repairkit', 0),
(976, 'steam:110000106921eea', 'medikit', 0),
(977, 'steam:110000106921eea', 'weapon_autoshotgun', 0),
(978, 'steam:110000106921eea', 'weapon_pistol50', 0),
(979, 'steam:110000106921eea', 'burek', 0),
(980, 'steam:110000106921eea', 'weapon_assaultsmg', 0),
(981, 'steam:110000106921eea', 'packaged_plank', 0),
(982, 'steam:110000106921eea', 'thermite', 0),
(983, 'steam:110000106921eea', 'tequila', 0),
(984, 'steam:110000106921eea', 'kcijev', 0),
(985, 'steam:110000106921eea', 'stijelo', 0),
(986, 'steam:110000106921eea', 'acetone', 0),
(987, 'steam:110000106921eea', 'LSD', 0),
(988, 'steam:110000106921eea', 'gazbottle', 0),
(989, 'steam:110000106921eea', 'carokit', 0),
(990, 'steam:110000106921eea', 'fabric', 0),
(991, 'steam:110000106921eea', 'skoljka', 0),
(992, 'steam:110000106921eea', 'loto', 0),
(993, 'steam:110000106921eea', 'absinthe', 0),
(994, 'steam:110000106921eea', 'duhan', 0),
(995, 'steam:110000111cd0aa0', 'iron', 0),
(996, 'steam:110000111cd0aa0', 'thionyl_chloride', 0),
(997, 'steam:110000111cd0aa0', 'ljudi', 0),
(998, 'steam:110000111cd0aa0', 'coke', 0),
(999, 'steam:110000111cd0aa0', 'fixtool', 0),
(1000, 'steam:110000111cd0aa0', 'blowpipe', 0),
(1001, 'steam:110000111cd0aa0', 'weapon_snspistol', 0),
(1002, 'steam:110000111cd0aa0', 'weapon_bullpuprifle', 0),
(1003, 'steam:110000111cd0aa0', 'weapon_machinepsitol', 0),
(1004, 'steam:110000111cd0aa0', 'packaged_chicken', 0),
(1005, 'steam:110000111cd0aa0', 'narukvica', 0),
(1006, 'steam:110000111cd0aa0', 'weapon_revolver_mk2', 0),
(1007, 'steam:110000111cd0aa0', 'sodium_hydroxide', 0),
(1008, 'steam:110000111cd0aa0', 'weapon_fireextinguisher', 0),
(1009, 'steam:110000111cd0aa0', 'heartpump', 0),
(1010, 'steam:110000111cd0aa0', 'bandage', 0),
(1011, 'steam:110000111cd0aa0', 'weapon_sawnoffshotgun', 0),
(1012, 'steam:110000111cd0aa0', 'seed', 0),
(1013, 'steam:110000111cd0aa0', 'kola', 0),
(1014, 'steam:110000111cd0aa0', 'methlab', 0),
(1015, 'steam:110000111cd0aa0', 'meso', 0),
(1016, 'steam:110000111cd0aa0', 'weapon_assaultshotgun', 0),
(1017, 'steam:110000111cd0aa0', 'weapon_bullpupshotgun', 0),
(1018, 'steam:110000111cd0aa0', 'weapon_machete', 0),
(1019, 'steam:110000111cd0aa0', 'weapon_poolcue', 0),
(1020, 'steam:110000111cd0aa0', 'weapon_specialcarbine', 0),
(1021, 'steam:110000111cd0aa0', 'weapon_bat', 0),
(1022, 'steam:110000111cd0aa0', 'beer', 0),
(1023, 'steam:110000111cd0aa0', 'grebalica', 0),
(1024, 'steam:110000111cd0aa0', 'smtijelo', 0),
(1025, 'steam:110000111cd0aa0', 'champagne', 0),
(1026, 'steam:110000111cd0aa0', 'weapon_firework', 0),
(1027, 'steam:110000111cd0aa0', 'marijuana', 0),
(1028, 'steam:110000111cd0aa0', 'hydrochloric_acid', 0),
(1029, 'steam:110000111cd0aa0', 'weapon_compactrifle', 0),
(1030, 'steam:110000111cd0aa0', 'washed_stone', 0),
(1031, 'steam:110000111cd0aa0', 'contract', 0),
(1032, 'steam:110000111cd0aa0', 'gym_membership', 0),
(1033, 'steam:110000111cd0aa0', 'lighter', 0),
(1034, 'steam:110000111cd0aa0', 'ccijev', 0),
(1035, 'steam:110000111cd0aa0', 'poppyresin', 0),
(1036, 'steam:110000111cd0aa0', 'weapon_mg', 0),
(1037, 'steam:110000111cd0aa0', 'weapon_pumpshotgun', 0),
(1038, 'steam:110000111cd0aa0', 'petrol', 0),
(1039, 'steam:110000111cd0aa0', 'lithium', 0),
(1040, 'steam:110000111cd0aa0', 'scijev', 0),
(1041, 'steam:110000111cd0aa0', 'ktijelo', 0),
(1042, 'steam:110000111cd0aa0', 'cannabis', 0),
(1043, 'steam:110000111cd0aa0', 'cigarett', 0),
(1044, 'steam:110000111cd0aa0', 'vodka', 0),
(1045, 'steam:110000111cd0aa0', 'ctijelo', 0),
(1046, 'steam:110000111cd0aa0', 'petrol_raffin', 0),
(1047, 'steam:110000111cd0aa0', 'weapon_minismg', 0),
(1048, 'steam:110000111cd0aa0', 'zemlja', 0);
INSERT INTO `user_inventory` (`id`, `identifier`, `item`, `count`) VALUES
(1049, 'steam:110000111cd0aa0', 'gintonic', 0),
(1050, 'steam:110000111cd0aa0', 'gold', 0),
(1051, 'steam:110000111cd0aa0', 'speed', 0),
(1052, 'steam:110000111cd0aa0', 'weapon_gusenberg', 0),
(1053, 'steam:110000111cd0aa0', 'wood', 0),
(1054, 'steam:110000111cd0aa0', 'headbag', 0),
(1055, 'steam:110000111cd0aa0', 'clothe', 0),
(1056, 'steam:110000111cd0aa0', 'weapon_combatpistol', 0),
(1057, 'steam:110000111cd0aa0', 'clip', 0),
(1058, 'steam:110000111cd0aa0', 'weapon_battleaxe', 0),
(1059, 'steam:110000111cd0aa0', 'weapon_nightstick', 0),
(1060, 'steam:110000111cd0aa0', 'copper', 0),
(1061, 'steam:110000111cd0aa0', 'alive_chicken', 0),
(1062, 'steam:110000111cd0aa0', 'weapon_microsmg', 0),
(1063, 'steam:110000111cd0aa0', 'smkundak', 0),
(1064, 'steam:110000111cd0aa0', 'kemija', 0),
(1065, 'steam:110000111cd0aa0', 'wine', 0),
(1066, 'steam:110000111cd0aa0', 'ukosnica', 0),
(1067, 'steam:110000111cd0aa0', 'smcijev', 0),
(1068, 'steam:110000111cd0aa0', 'diamond', 0),
(1069, 'steam:110000111cd0aa0', 'lsa', 0),
(1070, 'steam:110000111cd0aa0', 'mobitel', 0),
(1071, 'steam:110000111cd0aa0', 'bread', 0),
(1072, 'steam:110000111cd0aa0', 'pizza', 0),
(1073, 'steam:110000111cd0aa0', 'drone_flyer_7', 0),
(1074, 'steam:110000111cd0aa0', 'odznaka', 0),
(1075, 'steam:110000111cd0aa0', 'cutted_wood', 0),
(1076, 'steam:110000111cd0aa0', 'weapon_assaultrifle_mk2', 0),
(1077, 'steam:110000111cd0aa0', 'weapon_switchblade', 0),
(1078, 'steam:110000111cd0aa0', 'weapon_advancedrifle', 0),
(1079, 'steam:110000111cd0aa0', 'slaughtered_chicken', 0),
(1080, 'steam:110000111cd0aa0', 'net_cracker', 0),
(1081, 'steam:110000111cd0aa0', 'skundak', 0),
(1082, 'steam:110000111cd0aa0', 'sulfuric_acid', 0),
(1083, 'steam:110000111cd0aa0', 'weapon_hatchet', 0),
(1084, 'steam:110000111cd0aa0', 'rakija', 0),
(1085, 'steam:110000111cd0aa0', 'kkundak', 0),
(1086, 'steam:110000111cd0aa0', 'jewels', 0),
(1087, 'steam:110000111cd0aa0', 'ckundak', 0),
(1088, 'steam:110000111cd0aa0', 'autobomba', 0),
(1089, 'steam:110000111cd0aa0', 'weapon_knife', 0),
(1090, 'steam:110000111cd0aa0', 'weapon_hammer', 0),
(1091, 'steam:110000111cd0aa0', 'saksija', 0),
(1092, 'steam:110000111cd0aa0', 'gljive', 0),
(1093, 'steam:110000111cd0aa0', 'weapon_assaultrifle', 0),
(1094, 'steam:110000111cd0aa0', 'weapon_dbshotgun', 0),
(1095, 'steam:110000111cd0aa0', 'koza', 0),
(1096, 'steam:110000111cd0aa0', 'chemicalslisence', 0),
(1097, 'steam:110000111cd0aa0', 'fixkit', 0),
(1098, 'steam:110000111cd0aa0', 'weapon_carbinerifle_mk2', 0),
(1099, 'steam:110000111cd0aa0', 'weapon_combatmg', 0),
(1100, 'steam:110000111cd0aa0', 'zeton', 0),
(1101, 'steam:110000111cd0aa0', 'wool', 0),
(1102, 'steam:110000111cd0aa0', 'whisky', 0),
(1103, 'steam:110000111cd0aa0', 'chemicals', 0),
(1104, 'steam:110000111cd0aa0', 'weapon_wrench', 0),
(1105, 'steam:110000111cd0aa0', 'weapon_vintagepistol', 0),
(1106, 'steam:110000111cd0aa0', 'weapon_marksmanpistol', 0),
(1107, 'steam:110000111cd0aa0', 'weapon_sniperrifle', 0),
(1108, 'steam:110000111cd0aa0', 'weapon_revolver', 0),
(1109, 'steam:110000111cd0aa0', 'cocaine', 0),
(1110, 'steam:110000111cd0aa0', 'weapon_musket', 0),
(1111, 'steam:110000111cd0aa0', 'weapon_pistol', 0),
(1112, 'steam:110000111cd0aa0', 'weapon_marksmanrifle_mk2', 0),
(1113, 'steam:110000111cd0aa0', 'weapon_marksmanrifle', 0),
(1114, 'steam:110000111cd0aa0', 'stone', 0),
(1115, 'steam:110000111cd0aa0', 'weapon_heavysniper', 0),
(1116, 'steam:110000111cd0aa0', 'weapon_smg', 0),
(1117, 'steam:110000111cd0aa0', 'weapon_heavypistol', 0),
(1118, 'steam:110000111cd0aa0', 'weapon_heavyshotgun', 0),
(1119, 'steam:110000111cd0aa0', 'weapon_golfclub', 0),
(1120, 'steam:110000111cd0aa0', 'meth', 0),
(1121, 'steam:110000111cd0aa0', 'fish', 0),
(1122, 'steam:110000111cd0aa0', 'lancic', 0),
(1123, 'steam:110000111cd0aa0', 'croquettes', 0),
(1124, 'steam:110000111cd0aa0', 'heroin', 0),
(1125, 'steam:110000111cd0aa0', 'milk', 0),
(1126, 'steam:110000111cd0aa0', 'weapon_doubleaction', 0),
(1127, 'steam:110000111cd0aa0', 'weapon_appistol', 0),
(1128, 'steam:110000111cd0aa0', 'water', 0),
(1129, 'steam:110000111cd0aa0', 'moneywash', 0),
(1130, 'steam:110000111cd0aa0', 'weapon_crowbar', 0),
(1131, 'steam:110000111cd0aa0', 'essence', 0),
(1132, 'steam:110000111cd0aa0', 'carotool', 0),
(1133, 'steam:110000111cd0aa0', 'petarda', 0),
(1134, 'steam:110000111cd0aa0', 'weapon_combatpdw', 0),
(1135, 'steam:110000111cd0aa0', 'vatromet', 0),
(1136, 'steam:110000111cd0aa0', 'ronjenje', 0),
(1137, 'steam:110000111cd0aa0', 'biser', 0),
(1138, 'steam:110000111cd0aa0', 'petarde', 0),
(1139, 'steam:110000111cd0aa0', 'weapon_flashlight', 0),
(1140, 'steam:110000111cd0aa0', 'weapon_carbinerifle', 0),
(1141, 'steam:110000111cd0aa0', 'medikit', 0),
(1142, 'steam:110000111cd0aa0', 'repairkit', 0),
(1143, 'steam:110000111cd0aa0', 'weapon_autoshotgun', 0),
(1144, 'steam:110000111cd0aa0', 'weapon_pistol50', 0),
(1145, 'steam:110000111cd0aa0', 'burek', 0),
(1146, 'steam:110000111cd0aa0', 'packaged_plank', 0),
(1147, 'steam:110000111cd0aa0', 'weapon_assaultsmg', 0),
(1148, 'steam:110000111cd0aa0', 'thermite', 0),
(1149, 'steam:110000111cd0aa0', 'tequila', 0),
(1150, 'steam:110000111cd0aa0', 'kcijev', 0),
(1151, 'steam:110000111cd0aa0', 'stijelo', 0),
(1152, 'steam:110000111cd0aa0', 'acetone', 0),
(1153, 'steam:110000111cd0aa0', 'LSD', 0),
(1154, 'steam:110000111cd0aa0', 'gazbottle', 0),
(1155, 'steam:110000111cd0aa0', 'carokit', 0),
(1156, 'steam:110000111cd0aa0', 'loto', 0),
(1157, 'steam:110000111cd0aa0', 'absinthe', 0),
(1158, 'steam:110000111cd0aa0', 'fabric', 0),
(1159, 'steam:110000111cd0aa0', 'skoljka', 0),
(1160, 'steam:110000111cd0aa0', 'duhan', 0),
(1161, 'steam:11000014694839f', 'washed_stone', 0),
(1162, 'steam:11000014694839f', 'hydrochloric_acid', 0),
(1163, 'steam:11000014694839f', 'heroin', 0),
(1164, 'steam:11000014694839f', 'weapon_advancedrifle', 0),
(1165, 'steam:11000014694839f', 'fixkit', 0),
(1166, 'steam:11000014694839f', 'fabric', 0),
(1167, 'steam:11000014694839f', 'gintonic', 0),
(1168, 'steam:11000014694839f', 'petrol_raffin', 0),
(1169, 'steam:11000014694839f', 'speed', 0),
(1170, 'steam:11000014694839f', 'kola', 0),
(1171, 'steam:11000014694839f', 'medikit', 0),
(1172, 'steam:11000014694839f', 'wool', 0),
(1173, 'steam:11000014694839f', 'moneywash', 0),
(1174, 'steam:11000014694839f', 'burek', 0),
(1175, 'steam:11000014694839f', 'weapon_marksmanrifle_mk2', 0),
(1176, 'steam:11000014694839f', 'weapon_revolver_mk2', 0),
(1177, 'steam:11000014694839f', 'weapon_gusenberg', 0),
(1178, 'steam:11000014694839f', 'weapon_vintagepistol', 0),
(1179, 'steam:11000014694839f', 'gljive', 0),
(1180, 'steam:11000014694839f', 'skoljka', 0),
(1181, 'steam:11000014694839f', 'pizza', 0),
(1182, 'steam:11000014694839f', 'lighter', 0),
(1183, 'steam:11000014694839f', 'ctijelo', 0),
(1184, 'steam:11000014694839f', 'petarda', 0),
(1185, 'steam:11000014694839f', 'weapon_golfclub', 0),
(1186, 'steam:11000014694839f', 'seed', 0),
(1187, 'steam:11000014694839f', 'ktijelo', 0),
(1188, 'steam:11000014694839f', 'biser', 0),
(1189, 'steam:11000014694839f', 'autobomba', 0),
(1190, 'steam:11000014694839f', 'weapon_heavyshotgun', 0),
(1191, 'steam:11000014694839f', 'thionyl_chloride', 0),
(1192, 'steam:11000014694839f', 'packaged_chicken', 0),
(1193, 'steam:11000014694839f', 'ckundak', 0),
(1194, 'steam:11000014694839f', 'cigarett', 0),
(1195, 'steam:11000014694839f', 'petrol', 0),
(1196, 'steam:11000014694839f', 'lancic', 0),
(1197, 'steam:11000014694839f', 'ronjenje', 0),
(1198, 'steam:11000014694839f', 'ukosnica', 0),
(1199, 'steam:11000014694839f', 'wine', 0),
(1200, 'steam:11000014694839f', 'beer', 0),
(1201, 'steam:11000014694839f', 'absinthe', 0),
(1202, 'steam:11000014694839f', 'champagne', 0),
(1203, 'steam:11000014694839f', 'carotool', 0),
(1204, 'steam:11000014694839f', 'rakija', 0),
(1205, 'steam:11000014694839f', 'meth', 0),
(1206, 'steam:11000014694839f', 'zemlja', 0),
(1207, 'steam:11000014694839f', 'chemicals', 0),
(1208, 'steam:11000014694839f', 'weapon_bullpuprifle', 0),
(1209, 'steam:11000014694839f', 'weapon_mg', 0),
(1210, 'steam:11000014694839f', 'weapon_bullpupshotgun', 0),
(1211, 'steam:11000014694839f', 'weapon_flashlight', 0),
(1212, 'steam:11000014694839f', 'kkundak', 0),
(1213, 'steam:11000014694839f', 'skundak', 0),
(1214, 'steam:11000014694839f', 'weapon_sniperrifle', 0),
(1215, 'steam:11000014694839f', 'weapon_revolver', 0),
(1216, 'steam:11000014694839f', 'weapon_sawnoffshotgun', 0),
(1217, 'steam:11000014694839f', 'iron', 0),
(1218, 'steam:11000014694839f', 'weapon_marksmanpistol', 0),
(1219, 'steam:11000014694839f', 'koza', 0),
(1220, 'steam:11000014694839f', 'weapon_battleaxe', 0),
(1221, 'steam:11000014694839f', 'mobitel', 0),
(1222, 'steam:11000014694839f', 'jewels', 0),
(1223, 'steam:11000014694839f', 'petarde', 0),
(1224, 'steam:11000014694839f', 'narukvica', 0),
(1225, 'steam:11000014694839f', 'weapon_doubleaction', 0),
(1226, 'steam:11000014694839f', 'saksija', 0),
(1227, 'steam:11000014694839f', 'poppyresin', 0),
(1228, 'steam:11000014694839f', 'weapon_machinepsitol', 0),
(1229, 'steam:11000014694839f', 'ccijev', 0),
(1230, 'steam:11000014694839f', 'weapon_machete', 0),
(1231, 'steam:11000014694839f', 'vatromet', 0),
(1232, 'steam:11000014694839f', 'copper', 0),
(1233, 'steam:11000014694839f', 'methlab', 0),
(1234, 'steam:11000014694839f', 'weapon_carbinerifle', 0),
(1235, 'steam:11000014694839f', 'acetone', 0),
(1236, 'steam:11000014694839f', 'weapon_autoshotgun', 0),
(1237, 'steam:11000014694839f', 'weapon_carbinerifle_mk2', 0),
(1238, 'steam:11000014694839f', 'zeton', 0),
(1239, 'steam:11000014694839f', 'drone_flyer_7', 0),
(1240, 'steam:11000014694839f', 'milk', 0),
(1241, 'steam:11000014694839f', 'weapon_combatmg', 0),
(1242, 'steam:11000014694839f', 'gold', 0),
(1243, 'steam:11000014694839f', 'headbag', 0),
(1244, 'steam:11000014694839f', 'sodium_hydroxide', 0),
(1245, 'steam:11000014694839f', 'weapon_switchblade', 0),
(1246, 'steam:11000014694839f', 'weapon_appistol', 0),
(1247, 'steam:11000014694839f', 'weapon_assaultrifle_mk2', 0),
(1248, 'steam:11000014694839f', 'alive_chicken', 0),
(1249, 'steam:11000014694839f', 'weapon_wrench', 0),
(1250, 'steam:11000014694839f', 'blowpipe', 0),
(1251, 'steam:11000014694839f', 'weapon_poolcue', 0),
(1252, 'steam:11000014694839f', 'weapon_snspistol', 0),
(1253, 'steam:11000014694839f', 'weapon_smg', 0),
(1254, 'steam:11000014694839f', 'weapon_pumpshotgun', 0),
(1255, 'steam:11000014694839f', 'weapon_combatpdw', 0),
(1256, 'steam:11000014694839f', 'weapon_specialcarbine', 0),
(1257, 'steam:11000014694839f', 'weapon_pistol50', 0),
(1258, 'steam:11000014694839f', 'meso', 0),
(1259, 'steam:11000014694839f', 'duhan', 0),
(1260, 'steam:11000014694839f', 'carokit', 0),
(1261, 'steam:11000014694839f', 'LSD', 0),
(1262, 'steam:11000014694839f', 'weapon_nightstick', 0),
(1263, 'steam:11000014694839f', 'weapon_musket', 0),
(1264, 'steam:11000014694839f', 'stijelo', 0),
(1265, 'steam:11000014694839f', 'weapon_minismg', 0),
(1266, 'steam:11000014694839f', 'weapon_microsmg', 0),
(1267, 'steam:11000014694839f', 'fixtool', 0),
(1268, 'steam:11000014694839f', 'ljudi', 0),
(1269, 'steam:11000014694839f', 'coke', 0),
(1270, 'steam:11000014694839f', 'whisky', 0),
(1271, 'steam:11000014694839f', 'weapon_knife', 0),
(1272, 'steam:11000014694839f', 'weapon_heavysniper', 0),
(1273, 'steam:11000014694839f', 'contract', 0),
(1274, 'steam:11000014694839f', 'weapon_bat', 0),
(1275, 'steam:11000014694839f', 'weapon_hatchet', 0),
(1276, 'steam:11000014694839f', 'smtijelo', 0),
(1277, 'steam:11000014694839f', 'chemicalslisence', 0),
(1278, 'steam:11000014694839f', 'gym_membership', 0),
(1279, 'steam:11000014694839f', 'lsa', 0),
(1280, 'steam:11000014694839f', 'fish', 0),
(1281, 'steam:11000014694839f', 'weapon_heavypistol', 0),
(1282, 'steam:11000014694839f', 'weapon_fireextinguisher', 0),
(1283, 'steam:11000014694839f', 'weapon_assaultrifle', 0),
(1284, 'steam:11000014694839f', 'weapon_pistol', 0),
(1285, 'steam:11000014694839f', 'weapon_dbshotgun', 0),
(1286, 'steam:11000014694839f', 'clothe', 0),
(1287, 'steam:11000014694839f', 'weapon_crowbar', 0),
(1288, 'steam:11000014694839f', 'weapon_compactrifle', 0),
(1289, 'steam:11000014694839f', 'weapon_combatpistol', 0),
(1290, 'steam:11000014694839f', 'kcijev', 0),
(1291, 'steam:11000014694839f', 'smcijev', 0),
(1292, 'steam:11000014694839f', 'weapon_firework', 0),
(1293, 'steam:11000014694839f', 'grebalica', 0),
(1294, 'steam:11000014694839f', 'vodka', 0),
(1295, 'steam:11000014694839f', 'diamond', 0),
(1296, 'steam:11000014694839f', 'cutted_wood', 0),
(1297, 'steam:11000014694839f', 'clip', 0),
(1298, 'steam:11000014694839f', 'cannabis', 0),
(1299, 'steam:11000014694839f', 'slaughtered_chicken', 0),
(1300, 'steam:11000014694839f', 'weapon_assaultsmg', 0),
(1301, 'steam:11000014694839f', 'weapon_assaultshotgun', 0),
(1302, 'steam:11000014694839f', 'weapon_marksmanrifle', 0),
(1303, 'steam:11000014694839f', 'packaged_plank', 0),
(1304, 'steam:11000014694839f', 'water', 0),
(1305, 'steam:11000014694839f', 'bandage', 0),
(1306, 'steam:11000014694839f', 'odznaka', 0),
(1307, 'steam:11000014694839f', 'bread', 0),
(1308, 'steam:11000014694839f', 'scijev', 0),
(1309, 'steam:11000014694839f', 'tequila', 0),
(1310, 'steam:11000014694839f', 'marijuana', 0),
(1311, 'steam:11000014694839f', 'sulfuric_acid', 0),
(1312, 'steam:11000014694839f', 'thermite', 0),
(1313, 'steam:11000014694839f', 'cocaine', 0),
(1314, 'steam:11000014694839f', 'repairkit', 0),
(1315, 'steam:11000014694839f', 'kemija', 0),
(1316, 'steam:11000014694839f', 'essence', 0),
(1317, 'steam:11000014694839f', 'croquettes', 0),
(1318, 'steam:11000014694839f', 'stone', 0),
(1319, 'steam:11000014694839f', 'net_cracker', 0),
(1320, 'steam:11000014694839f', 'weapon_hammer', 0),
(1321, 'steam:11000014694839f', 'loto', 0),
(1322, 'steam:11000014694839f', 'smkundak', 0),
(1323, 'steam:11000014694839f', 'lithium', 0),
(1324, 'steam:11000014694839f', 'wood', 0),
(1325, 'steam:11000014694839f', 'heartpump', 0),
(1326, 'steam:11000014694839f', 'gazbottle', 0),
(1327, 'steam:11000010441bee9', 'auspuh', 1),
(1328, 'steam:11000010441bee9', 'kvacilo', 1),
(1329, 'steam:11000010441bee9', 'elektronika', 0),
(1330, 'steam:11000010441bee9', 'intercooler', 0),
(1331, 'steam:11000010441bee9', 'filter', 1),
(1332, 'steam:11000010441bee9', 'kmotor', 1),
(1333, 'steam:11000010441bee9', 'finjectori', 0),
(1334, 'steam:11000010441bee9', 'turbo', 0),
(1335, 'steam:11000010e086b7e', 'filter', 0),
(1336, 'steam:11000010e086b7e', 'intercooler', 1),
(1337, 'steam:11000010e086b7e', 'finjectori', 0),
(1338, 'steam:11000010e086b7e', 'turbo', 1),
(1339, 'steam:11000010e086b7e', 'kmotor', 1),
(1340, 'steam:11000010e086b7e', 'kvacilo', 0),
(1341, 'steam:11000010e086b7e', 'elektronika', 0),
(1342, 'steam:11000010e086b7e', 'auspuh', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_licenses`
--

CREATE TABLE `user_licenses` (
  `id` int(11) NOT NULL,
  `type` varchar(60) NOT NULL,
  `owner` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_licenses`
--

INSERT INTO `user_licenses` (`id`, `type`, `owner`) VALUES
(1, 'weapon', 'steam:11000010441bee9'),
(2, 'weapon', 'steam:11000010441bee9'),
(3, 'weapon', 'steam:11000010441bee9'),
(4, 'weapon', 'steam:11000010e086b7e'),
(5, 'dmv', 'steam:11000010e086b7e'),
(6, 'drive', 'steam:11000010e086b7e');

-- --------------------------------------------------------

--
-- Table structure for table `user_races`
--

CREATE TABLE `user_races` (
  `name` varchar(50) NOT NULL,
  `time` double NOT NULL,
  `race` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  `brod` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`name`, `model`, `price`, `category`, `brod`) VALUES
('VW Passat CC', '16cc', 60000, 'vw', 0),
('Dodge Charger 2016', '16charger', 190000, 'dodge', 0),
('BMW M5 Wagon', '16m5', 170000, 'bmw', 0),
('Nissan 180SX', '180sx', 48000, 'nissan', 0),
('Lamborghini Huracan Performante', '18performante', 560000, 'lamborghini', 0),
('Range Rover Vogue', '18velar', 170000, 'rangerover', 0),
('Opel Astra H', '2004astra', 14000, 'opel', 0),
('Seat Leon', '2012leon', 30000, 'seat', 0),
('Peugeot 206 GTi', '206', 16000, 'peugeot', 0),
('Nissan 370z', '370z', 130000, 'nissan', 0),
('Ferrari 458 Italia', '458spc', 400000, 'ferrari', 0),
('BMW X5', '48is', 90000, 'bmw', 0),
('Lamborghini Diablo', '500gtrlam', 360000, 'lamborghini', 0),
('Dodge Charger 1969', '69charger', 140000, 'dodge', 0),
('BMW Series 750li', '750li', 286000, 'bmw', 0),
('Porsche 911 Turbo', '911turbos', 420000, 'porsche', 0),
('Audi A6 Avant', 'a6avant', 150000, 'audi', 0),
('VW Amarok', 'amarok', 120000, 'vw', 0),
('Mercedes AMG GT C', 'amggtc', 340000, 'mercedes', 0),
('Aston Martin Vantage', 'amv19', 300000, 'astonmartin', 0),
('Alfa Romeo Giulia', 'aqv', 80000, 'alfa', 0),
('Audi Q7', 'as7', 120000, 'audi', 0),
('BMW M5 F90', 'bmci', 330000, 'bmw', 0),
('BMW e90', 'BMWe90', 60000, 'bmw', 0),
('BMW M8', 'bmwm8', 280000, 'bmw', 0),
('Honda CBR1000RR-R', 'cbrrr', 52000, 'honda', 0),
('Dodge challenger', 'chall70', 160000, 'dodge', 0),
('Honda Civic si 1999', 'civic', 16000, 'honda', 0),
('Mercedes CLS 2015', 'cls2015', 90000, 'mercedes', 0),
('Shelby Cobra 427 A/C', 'cobra', 500000000, 'shelby', 0),
('Aston Martin DB11', 'db11', 460000, 'astonmartin', 0),
('Dinghy', 'dinghy', 800000, 'gliser', 1),
('Bugatti Divo', 'divo', 5000000, 'bugatti', 0),
('Mercedes G Wagon', 'dubsta', 290000, 'mercedes', 0),
('BMW M5 e34', 'e34', 18000, 'bmw', 0),
('Mitsubishi Lancer EVO IX', 'evo9', 50000, 'mitsubishi', 0),
('BMW M4 f82', 'f82', 150000, 'bmw', 0),
('Ferrari Tributo', 'f8t', 472000, 'ferrari', 0),
('Ford Mustang 67', 'fastback', 270000, 'ford', 0),
('Ferrari Calfornia', 'fc15', 360000, 'ferrari', 0),
('Mazda RX7 fc3', 'fc3s', 46000, 'mazda', 0),
('Civikica', 'fk8', 5000, 'razz', 0),
('Jaguar F-Type', 'ftype', 260000, 'jaguar', 0),
('Mercedes G Wagon 2019', 'gclas9', 380000, 'mercedes', 0),
('Mercedes GLE 63c', 'gle63c', 230000, 'mercedes', 0),
('VW Golf R', 'golf7r', 100000, 'vw', 0),
('Suzuki GSXR1000', 'gsxr', 36000, 'suzuki', 0),
('Nissan GTR', 'gtr', 230000, 'nissan', 0),
('Hummer H1', 'h1', 160000, 'hummer', 0),
('Hummer H2', 'h2m', 160000, 'hummer', 0),
('Pagani Zonda Huayra R', 'huayrar', 4520000, 'pagani', 0),
('Mitsubishi Lancer EVO X', 'lancerevox', 70000, 'mitsubishi', 0),
('Lykan Hypersport', 'lykan', 500000000, 'lykan', 0),
('Mazda Miata MX-5', 'miata3', 26000, 'mazda', 0),
('VW Golf 1', 'mk1rabbit', 8000, 'vw', 0),
('Ford Mustang 2015', 'mst', 130000, 'ford', 0),
('Kawasaki Ninja NH2R', 'nh2r', 35000, 'kawasaki', 0),
('Nissan PS13 Silvia', 'ns13', 20000, 'obrisani', 0),
('Skoda Octavia VRS', 'octaviastyle', 45000, 'skoda', 0),
('McLaren P1', 'p1', 2700000, 'mclaren', 0),
('Porsche Panamera Turbo', 'panamera17turbo', 320000, 'porsche', 0),
('Patrola', 'patroly60', 5000, 'donatorski', 0),
('VW Polo', 'polo19', 40000, 'vw', 0),
('Fiat Punto', 'punto1', 7000, 'fiat', 0),
('Audi R8 2020', 'r820', 320000, 'audi', 0),
('Renault Captur', 'rencaptur', 26000, 'renault', 0),
('Mercedes C63', 'rmodamgc63', 340000, 'donatorski', 0),
('Mercedes GT63', 'rmodgt63', 350000, 'mercedes', 0),
('Audi RS7 Widebody', 'rmodrs7', 100000000, 'audi', 0),
('Lamborghini Sian', 'rmodsian', 400000000, 'lamborghini', 0),
('Range Rover Startech', 'rrst', 150000, 'rangerover', 0),
('Audi RS5', 'rs5', 150000, 'audi', 0),
('Audi RS7', 'rs7', 300000, 'audi', 0),
('Nissan Silvia S15', 's15', 70000, 'nissan', 0),
('Mercedes s500', 'S500W222', 100000, 'mercedes', 0),
('Mercedes S63 AMG', 's63amg', 125000, 'mercedes', 0),
('VW Scirocco', 'scijo', 38000, 'vw', 0),
('Jet Ski', 'seashark', 500000, 'jetski', 1),
('Nissan Skyline R34 GTR', 'skyline', 70000, 'nissan', 0),
('Mercedes SLK 55', 'slk55', 250000, 'mercedes', 0),
('Squalo', 'squalo', 1500000, 'gliser', 1),
('Ford Focus ST', 'st', 60000, 'ford', 0),
('Stara Impreza', 'sti', 35000, 'obrisani', 0),
('Podmornica', 'submersible', 5000000, 'podmornica', 1),
('Podmornica 2', 'submersible2', 5000000, 'podmornica', 1),
('Subaru Impreza WRX STi', 'subwrx', 70000, 'subaru', 0),
('Suntrap', 'suntrap', 700000, 'gliser', 1),
('Toyota Supra MK4', 'supra2', 160000, 'toyota', 0),
('Toyota Supra A90', 'supraa90', 130000, 'toyota', 0),
('Tesla Roadster', 'tr22', 220000, 'tesla', 0),
('Tropic', 'tropic2', 1000000, 'gliser', 1),
('Lada Niva', 'urban', 5000, 'lada', 0),
('VW Golf 4', 'vwgolf', 12000, 'vw', 0),
('Mercedes W140 AMG', 'w140', 28000, 'mercedes', 0),
('Mercedes W204', 'w204amgc', 240000, 'mercedes', 0),
('BMW X6M', 'x6m', 210000, 'bmw', 0),
('Yugo 45', 'yugo', 3000, 'yugo', 0),
('Yamaha R6', 'yzfr6', 40000, 'yamaha', 0),
('BMW Z4', 'z4bmw', 110000, 'bmw', 0);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles_for_sale`
--

CREATE TABLE `vehicles_for_sale` (
  `id` int(11) NOT NULL,
  `seller` varchar(50) NOT NULL,
  `vehicleProps` longtext NOT NULL,
  `plate` varchar(30) NOT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `mjenjac` int(11) NOT NULL DEFAULT 1,
  `prodan` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_categories`
--

CREATE TABLE `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  `brod` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehicle_categories`
--

INSERT INTO `vehicle_categories` (`name`, `label`, `brod`) VALUES
('alfa', 'Alfa Romeo', 0),
('astonmartin', 'Aston Martin', 0),
('audi', 'Audi', 0),
('bmw', 'BMW', 0),
('bugatti', 'Bugatti', 0),
('dodge', 'Dodge', 0),
('donatorski', 'Donatorski', 0),
('ferrari', 'Ferrari', 0),
('fiat', 'Fiat', 0),
('ford', 'Ford', 0),
('gliser', 'Gliser', 1),
('honda', 'Honda', 0),
('hummer', 'Hummer', 0),
('jaguar', 'Jaguar', 0),
('jetski', 'Jet Ski', 1),
('kawasaki', 'Kawasaki', 0),
('lada', 'Lada', 0),
('lamborghini', 'Lamborghini', 0),
('lykan', 'Lykan', 0),
('mazda', 'Mazda', 0),
('mclaren', 'McLaren', 0),
('mercedes', 'Mercedes', 0),
('mitsubishi', 'Mitsubishi', 0),
('nissan', 'Nissan', 0),
('obrisani', 'Obrisani', 0),
('opel', 'Opel', 0),
('pagani', 'Pagani', 0),
('peugeot', 'Peugeot', 0),
('podmornica', 'Podmornice', 1),
('porsche', 'Porsche', 0),
('rangerover', 'Range Rover', 0),
('razz', 'RazzMotoring', 0),
('renault', 'Renault', 0),
('seat', 'Seat', 0),
('shelby', 'Shelby', 0),
('skoda', 'Skoda', 0),
('subaru', 'Subaru', 0),
('suzuki', 'Suzuki', 0),
('tesla', 'Tesla', 0),
('toyota', 'Toyota', 0),
('vw', 'VW', 0),
('yamaha', 'Yamaha', 0),
('yugo', 'Yugo', 0);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_sold`
--

CREATE TABLE `vehicle_sold` (
  `client` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `soldby` varchar(50) NOT NULL,
  `date` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vijesti`
--

CREATE TABLE `vijesti` (
  `ID` int(11) NOT NULL,
  `Naziv` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Clanak` longtext CHARACTER SET latin1 NOT NULL,
  `Autor` varchar(255) CHARACTER SET latin1 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_croatian_ci;

--
-- Dumping data for table `vijesti`
--

INSERT INTO `vijesti` (`ID`, `Naziv`, `Clanak`, `Autor`) VALUES
(1, 'Sikora najvolji skripter', 'Sickora je najbolj iskripter na balkanu, ostale ko jebe ! ', 'GABO'),
(2, 'Slika', '<img src=&quot;https://i.imgur.com/s3V8w2q.png&quot;>', '#Sikora'),
(3, 'Slika 2', '<img src=&quot;https://i.imgur.com/FMD4QIl.png&quot;>', '#Sikora'),
(4, 'Slika 2', '<img src=&quot;https://i.imgur.com/FMD4QIl.png&quot; width=&quot;500px&quot;>', '#Sikora'),
(5, 'Slika 2', '<img src=&quot;https://i.imgur.com/FMD4QIl.png&quot; style=&quot;width=\'500px\'&quot;>', '#Sikora'),
(6, 'Slika 2', '<img src=&quot;https://i.imgur.com/FMD4QIl.png&quot; style=&quot;width: 500px&quot;>', '#Sikora'),
(7, 'Slika 2', '<img src=&quot;https://i.imgur.com/FMD4QIl.png&quot; style=&quot;min-width: 500px&quot;>', '#Sikora');

-- --------------------------------------------------------

--
-- Table structure for table `vocnjaci`
--

CREATE TABLE `vocnjaci` (
  `ID` int(11) NOT NULL,
  `Ime` varchar(255) NOT NULL,
  `Koord1` longtext NOT NULL DEFAULT '{}',
  `Koord2` longtext NOT NULL DEFAULT '{}',
  `Cijena` int(11) NOT NULL DEFAULT 0,
  `Vlasnik` varchar(128) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vocnjaci`
--

INSERT INTO `vocnjaci` (`ID`, `Ime`, `Koord1`, `Koord2`, `Cijena`, `Vlasnik`) VALUES
(2, 'test', '[-80.58973693847656,-1128.614013671875,24.65234184265136]', '[-115.77655792236328,-1151.2000732421876,24.65714263916015]', 15000, 'steam:11000010441bee9');

-- --------------------------------------------------------

--
-- Table structure for table `waroruzja`
--

CREATE TABLE `waroruzja` (
  `ID` int(11) NOT NULL,
  `identifier` char(60) NOT NULL,
  `data` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `warovi`
--

CREATE TABLE `warovi` (
  `ID` int(11) NOT NULL,
  `Ime` tinytext DEFAULT NULL,
  `Win` int(11) DEFAULT 0,
  `Lose` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `weashops`
--

CREATE TABLE `weashops` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `weashops`
--

INSERT INTO `weashops` (`id`, `name`, `item`, `price`) VALUES
(1, 'GunShop', 'WEAPON_PISTOL', 1000),
(5, 'GunShop', 'WEAPON_MACHETE', 100),
(11, 'GunShop', 'WEAPON_STUNGUN', 200),
(41, 'GunShop', 'WEAPON_KNIFE', 50),
(42, 'GunShop', 'WEAPON_CROWBAR', 75),
(43, 'GunShop', 'WEAPON_DAGGER', 75),
(44, 'GunShop', 'WEAPON_KNUCKLE', 45),
(45, 'GunShop', 'WEAPON_SWITCHBLADE', 75),
(46, 'GunShop', 'WEAPON_PISTOL_MK2', 1200),
(47, 'GunShop', 'WEAPON_PISTOL50', 1400),
(48, 'GunShop', 'WEAPON_MICROSMG', 25000),
(49, 'GunShop', 'WEAPON_COMBATPISTOL', 5000);

-- --------------------------------------------------------

--
-- Table structure for table `weashops2`
--

CREATE TABLE `weashops2` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `sef` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `weashops2`
--

INSERT INTO `weashops2` (`id`, `name`, `owner`, `sef`) VALUES
(1, 'GunShop1', NULL, 0),
(2, 'GunShop2', NULL, 0),
(3, 'GunShop3', 'steam:11000010e086b7e', 2850),
(4, 'GunShop4', 'steam:11000010e086b7e', 161238),
(5, 'GunShop5', NULL, 0),
(6, 'GunShop6', 'steam:11000010441bee9', 54499),
(7, 'GunShop7', NULL, 0),
(8, 'GunShop8', NULL, 0),
(9, 'GunShop9', NULL, 0),
(10, 'GunShop10', 'steam:11000010441bee9', 18100);

-- --------------------------------------------------------

--
-- Table structure for table `whitelist`
--

CREATE TABLE `whitelist` (
  `identifier` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `yellow_tweets`
--

CREATE TABLE `yellow_tweets` (
  `id` int(11) NOT NULL,
  `phone_number` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstname` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `yellow_tweets`
--

INSERT INTO `yellow_tweets` (`id`, `phone_number`, `firstname`, `lastname`, `message`, `time`) VALUES
(1, '185-9995', 'Tony', 'Sikora', 'aaa', '2021-10-17 14:41:40'),
(2, '579-9678', 'Tuljan', 'Ljantu', 'Prodajem 10 crvenih dijamanata', '2021-10-23 23:00:18'),
(3, '579-9678', 'Tuljan', 'Ljantu', 'moze zamjena za plave', '2021-10-23 23:00:28'),
(4, '530-0343', 'Max', 'Cigarett', 'Pusis kurac', '2021-10-23 23:01:02'),
(5, '579-9678', 'Tuljan', 'Ljantu', 'Kupujem ferrari', '2021-10-28 20:29:24');

-- --------------------------------------------------------

--
-- Table structure for table `zemljista`
--

CREATE TABLE `zemljista` (
  `ID` int(11) NOT NULL,
  `Ime` varchar(255) NOT NULL,
  `Koord1` longtext NOT NULL DEFAULT '{}',
  `Koord2` longtext NOT NULL DEFAULT '{}',
  `Cijena` int(11) NOT NULL DEFAULT 0,
  `Vlasnik` varchar(128) DEFAULT NULL,
  `Kuca` varchar(255) DEFAULT NULL,
  `KKoord` longtext NOT NULL DEFAULT '{}',
  `MKoord` longtext NOT NULL DEFAULT '{}',
  `KucaID` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zemljista`
--

INSERT INTO `zemljista` (`ID`, `Ime`, `Koord1`, `Koord2`, `Cijena`, `Vlasnik`, `Kuca`, `KKoord`, `MKoord`, `KucaID`) VALUES
(9, 'Zemljiste 1', '[203.828125,3219.237548828125,41.32288360595703]', '[187.4740753173828,3200.868896484375,41.16582870483398]', 120000, 'steam:11000010441bee9', 'lf_house_07_', '[194.000244140625,3207.30419921875,40.90900039672851,176.9990692138672]', '{\"x\":207.5401153564453,\"y\":3218.24755859375,\"z\":42.37691497802734}', 346);

-- --------------------------------------------------------

--
-- Table structure for table `zone`
--

CREATE TABLE `zone` (
  `ID` int(11) NOT NULL,
  `ime` varchar(250) NOT NULL,
  `koord` varchar(255) NOT NULL,
  `velicina` int(11) NOT NULL,
  `rotacija` int(11) NOT NULL,
  `boja` int(11) NOT NULL DEFAULT 0,
  `vlasnik` varchar(35) DEFAULT NULL,
  `label` varchar(250) DEFAULT NULL,
  `vrijeme` int(11) NOT NULL DEFAULT 0,
  `vrijednost` int(11) NOT NULL DEFAULT 30000
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zone`
--

INSERT INTO `zone` (`ID`, `ime`, `koord`, `velicina`, `rotacija`, `boja`, `vlasnik`, `label`, `vrijeme`, `vrijednost`) VALUES
(1, 'zona1', '{\"x\":105.22411346435547,\"y\":-1940.76611328125,\"z\":20.23876953125}', 300, 51, 0, NULL, NULL, 0, 40000),
(2, 'zona2', '{\"x\":1297.9000244140626,\"y\":-1724.8807373046876,\"z\":53.41697311401367}', 200, 115, 0, NULL, NULL, 0, 30000),
(3, 'zona3', '{\"x\":8.01981258392334,\"y\":-2478.081787109375,\"z\":5.44206237792968}', 200, -123, 0, NULL, NULL, 0, 30000),
(4, 'zona4', '{\"x\":-1048.6021728515626,\"y\":-1143.892578125,\"z\":1.55892622470855}', 100, 121, 0, NULL, NULL, 0, 20000),
(5, 'zona5', '{\"x\":-956.7833862304688,\"y\":-1090.5233154296876,\"z\":1.65182423591613}', 100, 122, 0, NULL, NULL, 0, 20000),
(6, 'zona6', '{\"x\":-113.91008758544922,\"y\":923.5415649414063,\"z\":235.12802124023438}', 200, 39, 0, NULL, NULL, 0, 30000),
(7, 'zona7', '{\"x\":1829.34326171875,\"y\":3860.934814453125,\"z\":33.62311553955078}', 200, 31, 0, NULL, NULL, 0, 30000),
(8, 'zona8', '{\"x\":-210.73080444335938,\"y\":6362.62939453125,\"z\":31.49229049682617}', 200, -44, 0, NULL, NULL, 0, 30000),
(9, 'zona9', '{\"x\":-1054.79931640625,\"y\":-1576.043212890625,\"z\":4.77379131317138}', 200, -147, 0, NULL, NULL, 0, 30000),
(10, 'zona10', '{\"x\":2862.156005859375,\"y\":2823.3935546875,\"z\":53.36796569824219}', 400, -121, 0, NULL, NULL, 0, 50000);

-- --------------------------------------------------------

--
-- Table structure for table `zpostavke`
--

CREATE TABLE `zpostavke` (
  `id` int(11) NOT NULL,
  `idzone` int(11) NOT NULL,
  `mafije` longtext NOT NULL,
  `vrijeme` int(11) NOT NULL,
  `sat` int(11) NOT NULL DEFAULT 0,
  `minuta` int(11) NOT NULL DEFAULT 0,
  `zauzimanje` int(11) NOT NULL DEFAULT 10
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zpostavke`
--

INSERT INTO `zpostavke` (`id`, `idzone`, `mafije`, `vrijeme`, `sat`, `minuta`, `zauzimanje`) VALUES
(1, 11, '[]', 10, 0, 0, 10);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addon_account`
--
ALTER TABLE `addon_account`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  ADD KEY `index_addon_account_data_account_name` (`account_name`);

--
-- Indexes for table `addon_inventory`
--
ALTER TABLE `addon_inventory`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  ADD KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  ADD KEY `index_addon_inventory_inventory_name` (`inventory_name`);

--
-- Indexes for table `baninfo`
--
ALTER TABLE `baninfo`
  ADD PRIMARY KEY (`identifier`);

--
-- Indexes for table `banlist`
--
ALTER TABLE `banlist`
  ADD PRIMARY KEY (`identifier`),
  ADD KEY `target` (`targetplayername`);

--
-- Indexes for table `banlisthistory`
--
ALTER TABLE `banlisthistory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ident` (`identifier`);

--
-- Indexes for table `biznisi`
--
ALTER TABLE `biznisi`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `vlasnik` (`Vlasnik`);

--
-- Indexes for table `bought_houses`
--
ALTER TABLE `bought_houses`
  ADD PRIMARY KEY (`houseid`);

--
-- Indexes for table `brod`
--
ALTER TABLE `brod`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `communityservice`
--
ALTER TABLE `communityservice`
  ADD PRIMARY KEY (`identifier`);

--
-- Indexes for table `datastore`
--
ALTER TABLE `datastore`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `datastore_data`
--
ALTER TABLE `datastore_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  ADD KEY `index_datastore_data_name` (`name`);

--
-- Indexes for table `elektricar`
--
ALTER TABLE `elektricar`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `fine_types`
--
ALTER TABLE `fine_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category`);

--
-- Indexes for table `fine_types_hitman`
--
ALTER TABLE `fine_types_hitman`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fine_types_mafia`
--
ALTER TABLE `fine_types_mafia`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `firme`
--
ALTER TABLE `firme`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `firme_kraft`
--
ALTER TABLE `firme_kraft`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`),
  ADD KEY `whitelisted` (`whitelisted`),
  ADD KEY `pID` (`pID`);

--
-- Indexes for table `job_grades`
--
ALTER TABLE `job_grades`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jsfour_criminalrecord`
--
ALTER TABLE `jsfour_criminalrecord`
  ADD PRIMARY KEY (`offense`);

--
-- Indexes for table `jsfour_criminaluserinfo`
--
ALTER TABLE `jsfour_criminaluserinfo`
  ADD PRIMARY KEY (`identifier`);

--
-- Indexes for table `kuce`
--
ALTER TABLE `kuce`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`type`);

--
-- Indexes for table `mafije`
--
ALTER TABLE `mafije`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `mete`
--
ALTER TABLE `mete`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `minute`
--
ALTER TABLE `minute`
  ADD PRIMARY KEY (`identifier`);

--
-- Indexes for table `mskladiste`
--
ALTER TABLE `mskladiste`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `narudzbe`
--
ALTER TABLE `narudzbe`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `owned_properties`
--
ALTER TABLE `owned_properties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `owned_vehicles`
--
ALTER TABLE `owned_vehicles`
  ADD PRIMARY KEY (`plate`),
  ADD KEY `owner` (`owner`),
  ADD KEY `plate` (`plate`);

--
-- Indexes for table `phone_app_chat`
--
ALTER TABLE `phone_app_chat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `phone_calls`
--
ALTER TABLE `phone_calls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`);

--
-- Indexes for table `phone_messages`
--
ALTER TABLE `phone_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `time` (`time`),
  ADD KEY `rec` (`receiver`);

--
-- Indexes for table `phone_users_contacts`
--
ALTER TABLE `phone_users_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ident` (`identifier`);

--
-- Indexes for table `playerhousing`
--
ALTER TABLE `playerhousing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `playerstattoos`
--
ALTER TABLE `playerstattoos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `poslovi`
--
ALTER TABLE `poslovi`
  ADD PRIMARY KEY (`name`),
  ADD KEY `whitelisted` (`whitelisted`),
  ADD KEY `pID` (`pID`);

--
-- Indexes for table `prijatelji`
--
ALTER TABLE `prijatelji`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `priority`
--
ALTER TABLE `priority`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pumpe`
--
ALTER TABLE `pumpe`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `qalle_brottsregister`
--
ALTER TABLE `qalle_brottsregister`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rented_vehicles`
--
ALTER TABLE `rented_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item` (`item`);

--
-- Indexes for table `shops2`
--
ALTER TABLE `shops2`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owstore` (`owner`,`store`) USING BTREE;

--
-- Indexes for table `shops_itemi`
--
ALTER TABLE `shops_itemi`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `truck_inventory`
--
ALTER TABLE `truck_inventory`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `item` (`item`,`name`,`plate`),
  ADD KEY `count` (`count`),
  ADD KEY `plate` (`plate`);

--
-- Indexes for table `twitter_accounts`
--
ALTER TABLE `twitter_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `twitter_likes`
--
ALTER TABLE `twitter_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_twitter_likes_twitter_accounts` (`authorId`),
  ADD KEY `FK_twitter_likes_twitter_tweets` (`tweetId`);

--
-- Indexes for table `twitter_tweets`
--
ALTER TABLE `twitter_tweets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_twitter_tweets_twitter_accounts` (`authorId`);

--
-- Indexes for table `ukradeni`
--
ALTER TABLE `ukradeni`
  ADD PRIMARY KEY (`tablica`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`identifier`),
  ADD KEY `ident` (`identifier`),
  ADD KEY `phone` (`phone_number`),
  ADD KEY `ID` (`ID`);

--
-- Indexes for table `user_accounts`
--
ALTER TABLE `user_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `identname` (`identifier`,`name`);

--
-- Indexes for table `user_inventory`
--
ALTER TABLE `user_inventory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idenitem` (`identifier`,`item`) USING BTREE,
  ADD KEY `ident` (`identifier`);

--
-- Indexes for table `user_licenses`
--
ALTER TABLE `user_licenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`model`);

--
-- Indexes for table `vehicles_for_sale`
--
ALTER TABLE `vehicles_for_sale`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plprodan` (`plate`,`prodan`),
  ADD KEY `selprodan` (`seller`,`prodan`),
  ADD KEY `prodan` (`prodan`);

--
-- Indexes for table `vehicle_categories`
--
ALTER TABLE `vehicle_categories`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `vehicle_sold`
--
ALTER TABLE `vehicle_sold`
  ADD PRIMARY KEY (`plate`);

--
-- Indexes for table `vijesti`
--
ALTER TABLE `vijesti`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vocnjaci`
--
ALTER TABLE `vocnjaci`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `waroruzja`
--
ALTER TABLE `waroruzja`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `warovi`
--
ALTER TABLE `warovi`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `weashops`
--
ALTER TABLE `weashops`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weashops2`
--
ALTER TABLE `weashops2`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owname` (`owner`,`name`) USING BTREE;

--
-- Indexes for table `whitelist`
--
ALTER TABLE `whitelist`
  ADD PRIMARY KEY (`identifier`);

--
-- Indexes for table `yellow_tweets`
--
ALTER TABLE `yellow_tweets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `zemljista`
--
ALTER TABLE `zemljista`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `zone`
--
ALTER TABLE `zone`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `zpostavke`
--
ALTER TABLE `zpostavke`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addon_account_data`
--
ALTER TABLE `addon_account_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2490;

--
-- AUTO_INCREMENT for table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `banlisthistory`
--
ALTER TABLE `banlisthistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `biznisi`
--
ALTER TABLE `biznisi`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `brod`
--
ALTER TABLE `brod`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cardealer_vehicles`
--
ALTER TABLE `cardealer_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `characters`
--
ALTER TABLE `characters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `datastore_data`
--
ALTER TABLE `datastore_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7318;

--
-- AUTO_INCREMENT for table `elektricar`
--
ALTER TABLE `elektricar`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `fine_types`
--
ALTER TABLE `fine_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `fine_types_hitman`
--
ALTER TABLE `fine_types_hitman`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fine_types_mafia`
--
ALTER TABLE `fine_types_mafia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `firme`
--
ALTER TABLE `firme`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `firme_kraft`
--
ALTER TABLE `firme_kraft`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `pID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `job_grades`
--
ALTER TABLE `job_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=206;

--
-- AUTO_INCREMENT for table `kuce`
--
ALTER TABLE `kuce`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=347;

--
-- AUTO_INCREMENT for table `mafije`
--
ALTER TABLE `mafije`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mete`
--
ALTER TABLE `mete`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `mskladiste`
--
ALTER TABLE `mskladiste`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `narudzbe`
--
ALTER TABLE `narudzbe`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `owned_properties`
--
ALTER TABLE `owned_properties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `phone_app_chat`
--
ALTER TABLE `phone_app_chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `phone_calls`
--
ALTER TABLE `phone_calls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `phone_messages`
--
ALTER TABLE `phone_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `phone_users_contacts`
--
ALTER TABLE `phone_users_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `playerstattoos`
--
ALTER TABLE `playerstattoos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `poslovi`
--
ALTER TABLE `poslovi`
  MODIFY `pID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `prijatelji`
--
ALTER TABLE `prijatelji`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `priority`
--
ALTER TABLE `priority`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `pumpe`
--
ALTER TABLE `pumpe`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `qalle_brottsregister`
--
ALTER TABLE `qalle_brottsregister`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `shops2`
--
ALTER TABLE `shops2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `shops_itemi`
--
ALTER TABLE `shops_itemi`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `society_moneywash`
--
ALTER TABLE `society_moneywash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `truck_inventory`
--
ALTER TABLE `truck_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `twitter_accounts`
--
ALTER TABLE `twitter_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `twitter_likes`
--
ALTER TABLE `twitter_likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `twitter_tweets`
--
ALTER TABLE `twitter_tweets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10006;

--
-- AUTO_INCREMENT for table `user_accounts`
--
ALTER TABLE `user_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user_inventory`
--
ALTER TABLE `user_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1343;

--
-- AUTO_INCREMENT for table `user_licenses`
--
ALTER TABLE `user_licenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vehicles_for_sale`
--
ALTER TABLE `vehicles_for_sale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=644;

--
-- AUTO_INCREMENT for table `vijesti`
--
ALTER TABLE `vijesti`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `vocnjaci`
--
ALTER TABLE `vocnjaci`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `waroruzja`
--
ALTER TABLE `waroruzja`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `warovi`
--
ALTER TABLE `warovi`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `weashops`
--
ALTER TABLE `weashops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `weashops2`
--
ALTER TABLE `weashops2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `yellow_tweets`
--
ALTER TABLE `yellow_tweets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `zemljista`
--
ALTER TABLE `zemljista`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `zone`
--
ALTER TABLE `zone`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `zpostavke`
--
ALTER TABLE `zpostavke`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `twitter_likes`
--
ALTER TABLE `twitter_likes`
  ADD CONSTRAINT `FK_twitter_likes_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`),
  ADD CONSTRAINT `FK_twitter_likes_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `twitter_tweets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `twitter_tweets`
--
ALTER TABLE `twitter_tweets`
  ADD CONSTRAINT `FK_twitter_tweets_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
