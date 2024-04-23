-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 23, 2024 at 01:47 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gudang_gas_rev1`
--

-- --------------------------------------------------------

--
-- Table structure for table `bpm`
--

CREATE TABLE `bpm` (
  `id_bpm` varchar(20) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `bpm`
--

INSERT INTO `bpm` (`id_bpm`, `id_user`) VALUES
('0000061120', 11),
('0000061121', 11),
('0000061124', 11),
('0000061122', 12),
('0000061123', 12);

-- --------------------------------------------------------

--
-- Table structure for table `bprm`
--

CREATE TABLE `bprm` (
  `id_bprm` varchar(20) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `bprm`
--

INSERT INTO `bprm` (`id_bprm`, `id_user`) VALUES
('0000071120', 11),
('0000071121', 11),
('0000071122', 11),
('0000071123', 12),
('0000071124', 12);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id_Customer` int(11) NOT NULL,
  `id_custType` int(11) NOT NULL,
  `id_city` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `address` varchar(100) NOT NULL,
  `postalcode` varchar(45) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `fax` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id_Customer`, `id_custType`, `id_city`, `name`, `address`, `postalcode`, `phone`, `fax`) VALUES
(211, 0, 0, 'PT KAI', 'Jalan Perintis Kemerdekaan No. 1 Bandung ', '4011', '4230039', '111'),
(212, 0, 0, 'PT IMS', 'Jalan Raya Surabaya - Madiun Km. 161 No.1, Bagi, Kec. Madiun, Kabupaten Madiun, Jawa Timur ', '63151', '2812105', '222'),
(212, 0, 0, 'PT IMST', 'Jalan Raya Surabaya - Madiun Km. 162 No.2, Bagi, Kec. Madiun, Kabupaten Madiun, Jawa Timur', '63151', '2812106', '223');

-- --------------------------------------------------------

--
-- Table structure for table `detail_bpm`
--

CREATE TABLE `detail_bpm` (
  `id_bpm` varchar(20) NOT NULL,
  `id_jenis_gas` int(11) NOT NULL,
  `spesifikasi` varchar(45) NOT NULL,
  `kuantitas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `detail_bpm`
--

INSERT INTO `detail_bpm` (`id_bpm`, `id_jenis_gas`, `spesifikasi`, `kuantitas`) VALUES
('0000061120', 1, 'Argon 100%', 2),
('0000061120', 3, 'Argon 82%', 2);

-- --------------------------------------------------------

--
-- Table structure for table `detail_bprm`
--

CREATE TABLE `detail_bprm` (
  `id_bprm` varchar(20) NOT NULL,
  `id_jenis_tabung` int(11) NOT NULL,
  `kuantitas` int(11) DEFAULT NULL,
  `spesifikasi` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `detail_bprm`
--

INSERT INTO `detail_bprm` (`id_bprm`, `id_jenis_tabung`, `kuantitas`, `spesifikasi`) VALUES
('0000071120', 1, 2, 'AR 82');

-- --------------------------------------------------------

--
-- Table structure for table `gedung`
--

CREATE TABLE `gedung` (
  `id_gedung` varchar(5) NOT NULL,
  `nama_gedung` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `gedung`
--

INSERT INTO `gedung` (`id_gedung`, `nama_gedung`) VALUES
('W1', 'Welding 1'),
('W2', 'Welding 2'),
('WH', 'Warehouse');

-- --------------------------------------------------------

--
-- Table structure for table `hak_akses`
--

CREATE TABLE `hak_akses` (
  `id_hak_akses` int(11) NOT NULL,
  `jenis_hak_akses` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `hak_akses`
--

INSERT INTO `hak_akses` (`id_hak_akses`, `jenis_hak_akses`) VALUES
(0, 'Admin'),
(1, 'Operator');

-- --------------------------------------------------------

--
-- Table structure for table `history_mutasi`
--

CREATE TABLE `history_mutasi` (
  `id_mutasi` varchar(20) NOT NULL,
  `id_operasi` varchar(10) DEFAULT NULL,
  `id_tabung` varchar(50) NOT NULL,
  `id_lokasi` varchar(20) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_keterangan_gas` int(11) NOT NULL,
  `bpm_id_bpm` varchar(20) DEFAULT NULL,
  `bprm_id_bprm` varchar(20) DEFAULT NULL,
  `tanggal_mutasi` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `history_mutasi`
--

INSERT INTO `history_mutasi` (`id_mutasi`, `id_operasi`, `id_tabung`, `id_lokasi`, `id_user`, `id_keterangan_gas`, `bpm_id_bpm`, `bprm_id_bprm`, `tanggal_mutasi`) VALUES
('M0001', NULL, 'AR100-001', 'WH1', 10, 1, NULL, NULL, '2024-01-11 08:15:49.000000'),
('M0002', 'AW1', 'AR100-001', 'CW1', 10, 2, '0000061120', '0000071120', '2024-01-13 08:15:00.000000'),
('M0003', NULL, 'AR100-002', 'WH1', 10, 1, '0000061120', '0000071120', '2024-01-11 08:15:49.000000'),
('M0004', 'AW1', 'AR100-002', 'CW1', 10, 1, '0000061120', '0000071120', '2024-01-16 08:15:49.000000'),
('M0005', NULL, 'AR100-002', 'WH1', 10, 3, '0000061120', '0000071120', '2024-01-18 08:15:00.000000'),
('M0006', NULL, 'AR100-001', 'WH1', 10, 3, '0000061120', '0000071120', '2024-01-18 08:15:00.000000'),
('M0007', NULL, 'AR097-001', 'WH1', 10, 1, NULL, NULL, '2024-01-18 08:15:00.000000'),
('M0008', NULL, 'AR097-002', 'WH1', 10, 1, NULL, NULL, '2024-01-18 08:15:00.000000'),
('M0009', NULL, 'AR097-003', 'WH1', 10, 1, NULL, NULL, '2024-01-11 10:05:53.000000'),
('M0010', NULL, 'AR097-004', 'WH1', 10, 1, NULL, NULL, '2024-01-11 10:05:53.000000'),
('M0011', NULL, 'AR097-005', 'WH1', 10, 1, NULL, NULL, '2024-01-11 10:05:53.000000'),
('M0012', NULL, 'AR100-003', 'WH1', 10, 1, NULL, NULL, '2024-01-11 10:05:53.000000'),
('M0013', NULL, 'AR100-004', 'WH1', 10, 1, NULL, NULL, '2024-01-11 10:05:53.000000'),
('M0014', NULL, 'AR100-005', 'WH1', 10, 1, NULL, NULL, '2024-01-11 10:05:53.000000'),
('M0015', 'AW1', 'AR097-003', 'CW1', 10, 2, '0000061120', '0000071120', '2024-01-11 10:05:53.000000'),
('M0016', 'AW1', 'AR097-003', 'WH1', 10, 3, '0000061120', '0000071120', '2024-01-16 10:05:00.000000'),
('M0017', 'AW1', 'AR097-002', 'WH1', 10, 2, '0000061120', '0000071120', '2024-01-20 10:05:00.000000'),
('M0018', 'AW1', 'AR097-001', 'CW1', 10, 2, '0000061120', '0000071120', '2024-01-21 10:05:00.000000'),
('M0019', 'AW1', 'AR097-004', 'CW1', 10, 2, '0000061120', '0000071120', '2024-01-21 10:05:00.000000'),
('M0020', NULL, 'AR100-002', 'WH1', 10, 4, NULL, NULL, '2024-01-19 10:05:00.000000'),
('M0021', NULL, 'AR100-002', 'WH1', 10, 1, NULL, NULL, '2024-01-20 10:05:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `item_project`
--

CREATE TABLE `item_project` (
  `id_item_project` varchar(8) NOT NULL,
  `id_project` varchar(15) NOT NULL,
  `id_project_set` varchar(5) NOT NULL,
  `id_product_type` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `item_project`
--

INSERT INTO `item_project` (`id_item_project`, `id_project`, `id_project_set`, `id_product_type`, `quantity`) VALUES
('E210011', 'VM-KD', 'SET1', 301, 1);

-- --------------------------------------------------------

--
-- Table structure for table `jenis_tabung`
--

CREATE TABLE `jenis_tabung` (
  `id_jenis_tabung` int(11) NOT NULL,
  `jenis_tabung` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `jenis_tabung`
--

INSERT INTO `jenis_tabung` (`id_jenis_tabung`, `jenis_tabung`) VALUES
(1, 'AR.100.%'),
(2, 'AR.97.%'),
(3, 'AR.82.%'),
(4, 'O2'),
(5, 'CO2'),
(6, 'N2');

-- --------------------------------------------------------

--
-- Table structure for table `keterangan_gas`
--

CREATE TABLE `keterangan_gas` (
  `id_keterangan_gas` int(11) NOT NULL,
  `keterangan_gas` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `keterangan_gas`
--

INSERT INTO `keterangan_gas` (`id_keterangan_gas`, `keterangan_gas`) VALUES
(1, 'Tersedia'),
(2, 'Dipakai'),
(3, 'Habis'),
(4, 'Diisi');

-- --------------------------------------------------------

--
-- Table structure for table `lokasi`
--

CREATE TABLE `lokasi` (
  `id_lokasi` varchar(20) NOT NULL,
  `id_gedung` varchar(5) NOT NULL,
  `lokasi` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `lokasi`
--

INSERT INTO `lokasi` (`id_lokasi`, `id_gedung`, `lokasi`) VALUES
('CW1', 'W1', 'C/Welding 1'),
('WH1', 'WH', 'Warehouse');

-- --------------------------------------------------------

--
-- Table structure for table `operasi`
--

CREATE TABLE `operasi` (
  `id_operasi` varchar(10) NOT NULL,
  `nama_operasi` varchar(45) DEFAULT NULL,
  `estStartTime` datetime NOT NULL,
  `estFinishTime` datetime NOT NULL,
  `realStartTime` datetime DEFAULT NULL,
  `realFinishTime` datetime DEFAULT NULL,
  `id_product` varchar(30) NOT NULL,
  `id_lokasi` varchar(20) NOT NULL,
  `id_proses` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `operasi`
--

INSERT INTO `operasi` (`id_operasi`, `nama_operasi`, `estStartTime`, `estFinishTime`, `realStartTime`, `realFinishTime`, `id_product`, `id_lokasi`, `id_proses`) VALUES
('AW1', 'Welding Frame ASS \'Y', '2024-01-10 15:11:48', '2024-01-10 16:21:00', NULL, NULL, 'I', 'CW1', '319H22001001AP02\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id_product` varchar(30) NOT NULL,
  `item_project_id_item_project` varchar(8) NOT NULL,
  `item_project_id_project` varchar(15) NOT NULL,
  `item_project_id_project_set` varchar(5) NOT NULL,
  `product` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id_product`, `item_project_id_item_project`, `item_project_id_project`, `item_project_id_project_set`, `product`) VALUES
('I', 'E210011', 'VM-KD', 'SET1', 'Gerboid_mutasiid_operasiid_operasing'),
('J', 'E210011', 'VM-KD', 'SET1', 'Spare Part'),
('K', 'E210011', 'VM-KD', 'SET1', 'Guided Vehicle'),
('U', 'E210011', 'VM-KD', 'SET1', 'Kereta Khusus');

-- --------------------------------------------------------

--
-- Table structure for table `product_type`
--

CREATE TABLE `product_type` (
  `id_product_type` int(11) NOT NULL,
  `product_type` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `product_type`
--

INSERT INTO `product_type` (`id_product_type`, `product_type`) VALUES
(301, 'Kelas Anggrek'),
(302, 'Kelas Lawu'),
(303, 'Kelas Satwa'),
(304, 'Kelas Bisnis'),
(305, 'Kelas Ekonomi');

-- --------------------------------------------------------

--
-- Table structure for table `product_type_structure`
--

CREATE TABLE `product_type_structure` (
  `id_node` varchar(15) NOT NULL,
  `id_product_type` int(11) NOT NULL,
  `id_parent_node` varchar(15) DEFAULT NULL,
  `nodename` varchar(30) NOT NULL,
  `kuantitas_node` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `product_type_structure`
--

INSERT INTO `product_type_structure` (`id_node`, `id_product_type`, `id_parent_node`, `nodename`, `kuantitas_node`) VALUES
('301H22006', 301, NULL, 'Fitting Of Radar Sensor', 1),
('319H22001000A', 301, '301H22006', 'Fitting Of Radar Sensor', 2),
('319H22001001A', 301, '319H22001000A', 'Frame Assy', 2),
('319H22001001L', 301, '319H22001002A', 'Frame 1', 4),
('319H22001001R', 301, '319H22001002A', 'Frame 1', 4),
('319H22001002', 301, '319H22001002A', 'Frame 2', 4),
('319H22001002A', 301, '319H22001001A', 'Frame Assy', 4),
('319H22001003', 301, '319H22001003A', 'Plate 1', 4),
('319H22001003A', 301, '319H22001000A', 'Frame Assy', 2),
('319H22001004', 301, '319H22001003A', 'Plate 2', 2),
('319H22001005', 301, '319H22001001A', 'Plate 3', 2),
('319H22001006', 301, '319H22001003A', 'Stiffener', 8);

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `id_project` varchar(15) NOT NULL,
  `project_name` varchar(45) NOT NULL,
  `start_contract` datetime(6) DEFAULT NULL,
  `end_contract` datetime(6) DEFAULT NULL,
  `remark` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `id_project_type` int(11) NOT NULL,
  `id_Customer` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`id_project`, `project_name`, `start_contract`, `end_contract`, `remark`, `create_date`, `id_project_type`, `id_Customer`) VALUES
('VM-KD', 'Argo Bromo Anggrek', '2024-01-10 13:47:21.000000', '2025-01-10 13:47:24.000000', NULL, '2024-01-10 13:47:36', 101, 211);

-- --------------------------------------------------------

--
-- Table structure for table `project_set`
--

CREATE TABLE `project_set` (
  `id_project_set` varchar(5) NOT NULL,
  `id_project` varchar(15) NOT NULL,
  `project_set_name` varchar(45) NOT NULL,
  `delivery_date` datetime NOT NULL,
  `kuantitas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `project_set`
--

INSERT INTO `project_set` (`id_project_set`, `id_project`, `project_set_name`, `delivery_date`, `kuantitas`) VALUES
('SET1', 'VM-KD', 'SET SATU', '2024-09-10 17:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `project_type`
--

CREATE TABLE `project_type` (
  `id_project_type` int(11) NOT NULL,
  `project_type` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `project_type`
--

INSERT INTO `project_type` (`id_project_type`, `project_type`) VALUES
(1, 'Repair'),
(2, 'Retrofit'),
(3, 'Manufacture'),
(4, 'Prototype');

-- --------------------------------------------------------

--
-- Table structure for table `proses`
--

CREATE TABLE `proses` (
  `id_proses` varchar(40) NOT NULL,
  `aft_id_proses` varchar(40) DEFAULT NULL,
  `id_node_type_structure` varchar(40) NOT NULL,
  `nama_proses` varchar(45) DEFAULT NULL,
  `durasi` float DEFAULT NULL,
  `unit_durasi` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `proses`
--

INSERT INTO `proses` (`id_proses`, `aft_id_proses`, `id_node_type_structure`, `nama_proses`, `durasi`, `unit_durasi`) VALUES
('319H22001001AP01', '319H22001001AP02\r\n', '319H22001001A', 'Assy Temporary Frame Assy', 2, 'JM'),
('319H22001001AP02\r\n', '319H22001001AP03\r\n\r\n', '319H22001001A', 'Assy Welding Frame Assy', 2, 'JM'),
('319H22001001AP03\r\n\r\n', '319H22001001AP03\r\n\r\n', '319H22001001A', 'Assy Grinding Frame Assy', 1, 'JM'),
('319H22001001LP01', NULL, '319H22001003A', 'Marking Frame 1', 2, 'JM'),
('319H22001001RP01', NULL, '319H22001003A', 'Marking Frame 1', 2, 'JM'),
('319H22001002AP01\r\n\r\n\r\n', '319H22001002AP02', '319H22001002A', 'Assy Temporary Frame Assy', 2, 'JM'),
('319H22001002AP02', '319H22001002AP03\r\n', '319H22001002A', 'Assy Welding Frame Assy', 2, 'JM'),
('319H22001002AP03\r\n', '319H22001002AP03\r\n', '319H22001002A', 'Assy Grinding Frame Assy', 1, 'JM'),
('319H22001003AP01', '319H22001003AP02', '319H22001003A', 'Assy Temporary Frame Assy', 2, 'JM'),
('319H22001003AP02', '319H22001003AP03', '319H22001003A', 'Assy Welding Frame Assy', 2, 'JM'),
('319H22001003AP03', '319H22001003AP03', '319H22001003A', 'Assy Grinding Frame Assy', 1, 'JM');

-- --------------------------------------------------------

--
-- Table structure for table `proses_node`
--

CREATE TABLE `proses_node` (
  `product_type_structure_id_node` varchar(50) NOT NULL,
  `proses_id_proses` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `proses_node`
--

INSERT INTO `proses_node` (`product_type_structure_id_node`, `proses_id_proses`) VALUES
('319H22001001A', '319H22001001AP01'),
('319H22001001L', '319H22001001LP01'),
('319H22001001R', '319H22001001RP01'),
('319H22001002A', '319H22001002AP01\r\n\r\n\r\n'),
('319H22001003A', '319H22001003AP01');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` int(11) NOT NULL,
  `nama_supplier` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`) VALUES
(20, 'SGI'),
(21, 'SIG'),
(22, 'LANGGENG'),
(23, 'TIRA'),
(24, 'SAMATOR');

-- --------------------------------------------------------

--
-- Table structure for table `tabung`
--

CREATE TABLE `tabung` (
  `id_tabung` varchar(10) NOT NULL,
  `id_jenis_tabung` int(11) NOT NULL,
  `id_supplier` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tabung`
--

INSERT INTO `tabung` (`id_tabung`, `id_jenis_tabung`, `id_supplier`) VALUES
('AR097-001', 2, 20),
('AR097-002', 2, 20),
('AR097-003', 2, 20),
('AR097-004', 2, 20),
('AR097-005', 2, 20),
('AR100-001', 1, 24),
('AR100-002', 1, 24),
('AR100-003', 1, 24),
('AR100-004', 1, 24),
('AR100-005', 1, 24);

-- --------------------------------------------------------

--
-- Table structure for table `tipe_operasi`
--

CREATE TABLE `tipe_operasi` (
  `id_tipe_operasi` varchar(50) NOT NULL,
  `tipe_operasi` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tipe_operasi`
--

INSERT INTO `tipe_operasi` (`id_tipe_operasi`, `tipe_operasi`) VALUES
('AW1', 'Assembly Welding 1');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `id_hak_akses` int(11) NOT NULL,
  `nama_pengguna` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `id_hak_akses`, `nama_pengguna`) VALUES
(10, 1, 'Reisha'),
(11, 1, 'Novianto'),
(12, 0, 'Afta');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bpm`
--
ALTER TABLE `bpm`
  ADD PRIMARY KEY (`id_bpm`),
  ADD KEY `fk_id_user_bpm_idx` (`id_user`);

--
-- Indexes for table `bprm`
--
ALTER TABLE `bprm`
  ADD PRIMARY KEY (`id_bprm`),
  ADD KEY `fk_id_user_bprm_idx` (`id_user`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_Customer`);

--
-- Indexes for table `detail_bpm`
--
ALTER TABLE `detail_bpm`
  ADD KEY `fk_id_jenis_gas_idx` (`id_jenis_gas`),
  ADD KEY `fk_id_BPM_idxS` (`id_bpm`) USING BTREE;

--
-- Indexes for table `detail_bprm`
--
ALTER TABLE `detail_bprm`
  ADD PRIMARY KEY (`id_bprm`),
  ADD KEY `fk_id_jenis_tabung_idx` (`id_jenis_tabung`),
  ADD KEY `fk_no_bprm_detail_bprm_idx` (`id_bprm`);

--
-- Indexes for table `gedung`
--
ALTER TABLE `gedung`
  ADD PRIMARY KEY (`id_gedung`);

--
-- Indexes for table `hak_akses`
--
ALTER TABLE `hak_akses`
  ADD PRIMARY KEY (`id_hak_akses`);

--
-- Indexes for table `history_mutasi`
--
ALTER TABLE `history_mutasi`
  ADD PRIMARY KEY (`id_mutasi`),
  ADD KEY `fk_id_work_station_pengalokasian_idx` (`id_lokasi`),
  ADD KEY `fk_id_user_pengalokasian_idx` (`id_user`),
  ADD KEY `fk_id_keterangan_gas_mutasi_terkini_idx` (`id_keterangan_gas`),
  ADD KEY `fk_history_mutasi_tabung1_idx` (`id_tabung`),
  ADD KEY `fk_history_mutasi_operasi1_idx` (`id_operasi`),
  ADD KEY `fk_history_mutasi_bpm1_idx` (`bpm_id_bpm`),
  ADD KEY `fk_history_mutasi_bprm1_idx` (`bprm_id_bprm`);

--
-- Indexes for table `item_project`
--
ALTER TABLE `item_project`
  ADD PRIMARY KEY (`id_item_project`,`id_project`,`id_project_set`),
  ADD KEY `fk_item_project_project1_idx` (`id_project`),
  ADD KEY `fk_item_project_product_type1_idx` (`id_product_type`),
  ADD KEY `fk_item_project_project_set1_idx` (`id_project_set`);

--
-- Indexes for table `jenis_tabung`
--
ALTER TABLE `jenis_tabung`
  ADD PRIMARY KEY (`id_jenis_tabung`);

--
-- Indexes for table `keterangan_gas`
--
ALTER TABLE `keterangan_gas`
  ADD PRIMARY KEY (`id_keterangan_gas`);

--
-- Indexes for table `lokasi`
--
ALTER TABLE `lokasi`
  ADD PRIMARY KEY (`id_lokasi`),
  ADD KEY `fk_lokasi_gedung1_idx` (`id_gedung`);

--
-- Indexes for table `operasi`
--
ALTER TABLE `operasi`
  ADD PRIMARY KEY (`id_operasi`),
  ADD KEY `fk_operasi_product1_idx` (`id_product`),
  ADD KEY `fk_operasi_lokasi1_idx` (`id_lokasi`),
  ADD KEY `fk_operasi_proses1_idx` (`id_proses`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id_product`),
  ADD KEY `fk_product_item_project1_idx` (`item_project_id_item_project`,`item_project_id_project`,`item_project_id_project_set`);

--
-- Indexes for table `product_type`
--
ALTER TABLE `product_type`
  ADD PRIMARY KEY (`id_product_type`);

--
-- Indexes for table `product_type_structure`
--
ALTER TABLE `product_type_structure`
  ADD PRIMARY KEY (`id_node`),
  ADD KEY `fk_product_type_structure_product_type1_idx` (`id_product_type`),
  ADD KEY `fk_product_type_structure_product_type_structure1_idx` (`id_parent_node`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`id_project`),
  ADD KEY `fk_project_project_type1_idx` (`id_project_type`),
  ADD KEY `fk_project_Customer1_idx` (`id_Customer`);

--
-- Indexes for table `project_set`
--
ALTER TABLE `project_set`
  ADD PRIMARY KEY (`id_project_set`,`id_project`),
  ADD KEY `fk_project_set_project1_idx` (`id_project`);

--
-- Indexes for table `project_type`
--
ALTER TABLE `project_type`
  ADD PRIMARY KEY (`id_project_type`);

--
-- Indexes for table `proses`
--
ALTER TABLE `proses`
  ADD PRIMARY KEY (`id_proses`),
  ADD KEY `fk_proses_product_type_structure1_idx` (`id_node_type_structure`),
  ADD KEY `fk_proses_proses1_idx` (`aft_id_proses`);

--
-- Indexes for table `proses_node`
--
ALTER TABLE `proses_node`
  ADD PRIMARY KEY (`product_type_structure_id_node`,`proses_id_proses`),
  ADD KEY `fk_proses_node_proses1_idx` (`proses_id_proses`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indexes for table `tabung`
--
ALTER TABLE `tabung`
  ADD PRIMARY KEY (`id_tabung`),
  ADD KEY `id_jenis_tabung_idx` (`id_jenis_tabung`),
  ADD KEY `fk_id_supplier_tabung_idx` (`id_supplier`);

--
-- Indexes for table `tipe_operasi`
--
ALTER TABLE `tipe_operasi`
  ADD PRIMARY KEY (`id_tipe_operasi`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `fk_hak_akses_user_idx` (`id_hak_akses`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bpm`
--
ALTER TABLE `bpm`
  ADD CONSTRAINT `fk_id_user_bpm` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `bprm`
--
ALTER TABLE `bprm`
  ADD CONSTRAINT `fk_id_user_bprm` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_bpm`
--
ALTER TABLE `detail_bpm`
  ADD CONSTRAINT `fk_id_bpm_detail_bpm` FOREIGN KEY (`id_bpm`) REFERENCES `bpm` (`id_bpm`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_jenis_gas` FOREIGN KEY (`id_jenis_gas`) REFERENCES `jenis_tabung` (`id_jenis_tabung`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_bprm`
--
ALTER TABLE `detail_bprm`
  ADD CONSTRAINT `fk_id_bprm_detail_bprm` FOREIGN KEY (`id_bprm`) REFERENCES `bprm` (`id_bprm`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_jenis_tabung_bprm` FOREIGN KEY (`id_jenis_tabung`) REFERENCES `jenis_tabung` (`id_jenis_tabung`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `history_mutasi`
--
ALTER TABLE `history_mutasi`
  ADD CONSTRAINT `fk_history_mutasi_bpm1` FOREIGN KEY (`bpm_id_bpm`) REFERENCES `bpm` (`id_bpm`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_history_mutasi_bprm1` FOREIGN KEY (`bprm_id_bprm`) REFERENCES `bprm` (`id_bprm`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_history_mutasi_operasi1` FOREIGN KEY (`id_operasi`) REFERENCES `operasi` (`id_operasi`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_history_mutasi_tabung1` FOREIGN KEY (`id_tabung`) REFERENCES `tabung` (`id_tabung`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_keterangan_gas_mutasi_terkini` FOREIGN KEY (`id_keterangan_gas`) REFERENCES `keterangan_gas` (`id_keterangan_gas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_user_pengalokasian` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_work_station_pengalokasian` FOREIGN KEY (`id_lokasi`) REFERENCES `lokasi` (`id_lokasi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `item_project`
--
ALTER TABLE `item_project`
  ADD CONSTRAINT `fk_item_project_product_type1` FOREIGN KEY (`id_product_type`) REFERENCES `product_type` (`id_product_type`),
  ADD CONSTRAINT `fk_item_project_project1` FOREIGN KEY (`id_project`) REFERENCES `project` (`id_project`),
  ADD CONSTRAINT `fk_item_project_project_set1` FOREIGN KEY (`id_project_set`) REFERENCES `project_set` (`id_project_set`);

--
-- Constraints for table `lokasi`
--
ALTER TABLE `lokasi`
  ADD CONSTRAINT `fk_lokasi_gedung1` FOREIGN KEY (`id_gedung`) REFERENCES `gedung` (`id_gedung`);

--
-- Constraints for table `operasi`
--
ALTER TABLE `operasi`
  ADD CONSTRAINT `fk_operasi_lokasi1` FOREIGN KEY (`id_lokasi`) REFERENCES `lokasi` (`id_lokasi`),
  ADD CONSTRAINT `fk_operasi_product1` FOREIGN KEY (`id_product`) REFERENCES `product` (`id_product`),
  ADD CONSTRAINT `fk_operasi_proses1` FOREIGN KEY (`id_proses`) REFERENCES `proses` (`id_proses`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_product_item_project1` FOREIGN KEY (`item_project_id_item_project`,`item_project_id_project`,`item_project_id_project_set`) REFERENCES `item_project` (`id_item_project`, `id_project`, `id_project_set`);

--
-- Constraints for table `product_type_structure`
--
ALTER TABLE `product_type_structure`
  ADD CONSTRAINT `fk_product_type_structure_product_type1` FOREIGN KEY (`id_product_type`) REFERENCES `product_type` (`id_product_type`),
  ADD CONSTRAINT `fk_product_type_structure_product_type_structure1` FOREIGN KEY (`id_parent_node`) REFERENCES `product_type_structure` (`id_node`);

--
-- Constraints for table `project`
--
ALTER TABLE `project`
  ADD CONSTRAINT `fk_project_Customer1` FOREIGN KEY (`id_Customer`) REFERENCES `customer` (`id_Customer`),
  ADD CONSTRAINT `fk_project_project_type1` FOREIGN KEY (`id_project_type`) REFERENCES `project_type` (`id_project_type`);

--
-- Constraints for table `project_set`
--
ALTER TABLE `project_set`
  ADD CONSTRAINT `fk_project_set_project1` FOREIGN KEY (`id_project`) REFERENCES `project` (`id_project`);

--
-- Constraints for table `proses`
--
ALTER TABLE `proses`
  ADD CONSTRAINT `fk_proses_product_type_structure1` FOREIGN KEY (`id_node_type_structure`) REFERENCES `product_type_structure` (`id_node`),
  ADD CONSTRAINT `fk_proses_proses1` FOREIGN KEY (`aft_id_proses`) REFERENCES `proses` (`id_proses`);

--
-- Constraints for table `proses_node`
--
ALTER TABLE `proses_node`
  ADD CONSTRAINT `fk_proses_node_product_type_structure1` FOREIGN KEY (`product_type_structure_id_node`) REFERENCES `product_type_structure` (`id_node`),
  ADD CONSTRAINT `fk_proses_node_proses1` FOREIGN KEY (`proses_id_proses`) REFERENCES `proses` (`id_proses`);

--
-- Constraints for table `tabung`
--
ALTER TABLE `tabung`
  ADD CONSTRAINT `fk_id_jenis_tabung` FOREIGN KEY (`id_jenis_tabung`) REFERENCES `jenis_tabung` (`id_jenis_tabung`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_supplier_tabung` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_hak_akses_user` FOREIGN KEY (`id_hak_akses`) REFERENCES `hak_akses` (`id_hak_akses`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
