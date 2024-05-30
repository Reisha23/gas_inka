-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 30, 2024 at 04:59 AM
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
-- Database: `gas_rev`
--

-- --------------------------------------------------------

--
-- Table structure for table `gas_history`
--

CREATE TABLE `gas_history` (
  `id_history` int(11) NOT NULL,
  `id_tabung` int(11) DEFAULT NULL,
  `tanggal` date NOT NULL,
  `jenis_aktivitas` enum('masuk','keluar') NOT NULL,
  `id_supplier` int(11) DEFAULT NULL,
  `id_supplier_out` int(11) DEFAULT NULL,
  `jumlah` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gas_keluar`
--

CREATE TABLE `gas_keluar` (
  `id_gas_keluar` int(11) NOT NULL,
  `id_tabung` int(11) DEFAULT NULL,
  `tanggal_keluar` timestamp NOT NULL DEFAULT current_timestamp(),
  `jumlah_keluar` int(11) NOT NULL,
  `id_supplier_out` int(11) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `gas_keluar`
--
DELIMITER $$
CREATE TRIGGER `after_gas_keluar_insert` AFTER INSERT ON `gas_keluar` FOR EACH ROW BEGIN
    INSERT INTO gas_history(
        id_tabung,
        tanggal,
        jenis_aktivitas,
        id_supplier_out,
        jumlah,
        id_user
    )
VALUES(
    NEW.id_tabung,
    NEW.tanggal_keluar,
    'keluar',
    NEW.id_supplier_out,
    NEW.jumlah_keluar,
    NEW.id_user
) ;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `gas_masuk`
--

CREATE TABLE `gas_masuk` (
  `id_gas_masuk` int(11) NOT NULL,
  `id_tabung` int(11) DEFAULT NULL,
  `tanggal_masuk` timestamp NOT NULL DEFAULT current_timestamp(),
  `jumlah_masuk` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `gas_masuk`
--
DELIMITER $$
CREATE TRIGGER `after_gas_masuk_insert` AFTER INSERT ON `gas_masuk` FOR EACH ROW BEGIN
    INSERT INTO gas_history(
        id_tabung,
        tanggal,
        jenis_aktivitas,
        id_supplier,
        jumlah,
        id_user
    )
VALUES(
    NEW.id_tabung,
    NEW.tanggal_masuk,
    'masuk',
    NEW.jumlah_masuk,
    NEW.id_user
) ;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jenis_tabung`
--

CREATE TABLE `jenis_tabung` (
  `id_jenis_tabung` int(11) NOT NULL,
  `jenis_tabung` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_user` int(11) NOT NULL,
  `nama_user` varchar(255) NOT NULL,
  `email_user` varchar(255) NOT NULL,
  `password_user` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_user`, `nama_user`, `email_user`, `password_user`) VALUES
(3, 'Gudang1', 'gudangInv1@gmail.com', '25d55ad283aa400af464c76d713c07ad');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` int(11) NOT NULL,
  `nama_supplier` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`) VALUES
(1, 'SGI'),
(2, 'SIG'),
(3, 'LANGGENG'),
(4, 'TIRA'),
(5, 'SAMATOR');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_out`
--

CREATE TABLE `supplier_out` (
  `id_supplier_out` int(11) NOT NULL,
  `nama_supplier_out` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier_out`
--

INSERT INTO `supplier_out` (`id_supplier_out`, `nama_supplier_out`) VALUES
(1, 'SGI'),
(2, 'SIG'),
(3, 'LANGGENG'),
(4, 'TIRA'),
(5, 'SAMATOR');

-- --------------------------------------------------------

--
-- Table structure for table `tabung`
--

CREATE TABLE `tabung` (
  `id_tabung` int(11) NOT NULL,
  `nomor_tabung` varchar(255) NOT NULL,
  `id_jenis_tabung` int(11) DEFAULT NULL,
  `id_supplier` int(11) DEFAULT NULL,
  `kode_supplier` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tabung`
--

INSERT INTO `tabung` (`id_tabung`, `nomor_tabung`, `id_jenis_tabung`, `id_supplier`, `kode_supplier`) VALUES
(1, 'TAB001_SGI_AR100', 1, 1, 'SGI_AR100'),
(2, 'TAB002_SGI_AR97', 2, 1, 'SGI_AR97'),
(3, 'TAB003_SGI_AR82', 3, 1, 'SGI_AR82'),
(4, 'TAB004_SGI_O2', 4, 1, 'SGI_O2'),
(5, 'TAB005_SGI_CO2', 5, 1, 'SGI_CO2'),
(6, 'TAB006_SGI_NITRO', 6, 1, 'SGI_CO2'),
(7, 'TAB001_SIG_AR100', 1, 2, 'SIG_AR100'),
(8, 'TAB002_SIG_AR97', 2, 2, 'SIG_AR97'),
(9, 'TAB003_SIG_AR82', 3, 2, 'SIG_AR82'),
(10, 'TAB004_SIG_O2', 4, 2, 'SIG_O2'),
(11, 'TAB005_SIG_CO2', 5, 2, 'SIG_CO2'),
(12, 'TAB006_SIG_NITRO', 6, 2, 'SIG_CO2'),
(13, 'TAB001_LANG_AR100', 1, 3, 'LANGGENG_AR100'),
(14, 'TAB002_LANG_AR97', 2, 3, 'LANGGENG_AR97'),
(15, 'TAB003_LANG_AR82', 3, 3, 'LANGGENG_AR82'),
(16, 'TAB004_LANG_O2', 4, 3, 'LANGGENG_O2'),
(17, 'TAB005_LANG_CO2', 5, 3, 'LANGGENG_CO2'),
(18, 'TAB006_LANG_NITRO', 6, 3, 'LANGGENG_CO2'),
(19, 'TAB001_TIRA_AR100', 1, 4, 'TIRA_AR100'),
(20, 'TAB002_TIRA_AR97', 2, 4, 'TIRA_AR97'),
(21, 'TAB003_TIRA_AR82', 3, 4, 'TIRA_AR82'),
(22, 'TAB004_TIRA_O2', 4, 4, 'TIRA_O2'),
(23, 'TAB005_TIRA_CO2', 5, 4, 'TIRA_CO2'),
(24, 'TAB006_TIRA_NITRO', 6, 4, 'TIRA_CO2'),
(25, 'TAB001_SMTR_AR100', 1, 5, 'SAMATOR_AR100'),
(26, 'TAB002_SMTR_AR97', 2, 5, 'SAMATOR_AR97'),
(27, 'TAB003_SMTR_AR82', 3, 5, 'SAMATOR_AR82'),
(28, 'TAB004_SMTR_O2', 4, 5, 'SAMATOR_O2'),
(29, 'TAB005_SMTR_CO2', 5, 5, 'SAMATOR_CO2'),
(30, 'TAB006_SMTR_NITRO', 6, 5, 'SAMATOR_CO2');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `gas_history`
--
ALTER TABLE `gas_history`
  ADD PRIMARY KEY (`id_history`),
  ADD KEY `id_tabung` (`id_tabung`),
  ADD KEY `id_supplier` (`id_supplier`),
  ADD KEY `id_supplier_out` (`id_supplier_out`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `gas_keluar`
--
ALTER TABLE `gas_keluar`
  ADD PRIMARY KEY (`id_gas_keluar`),
  ADD KEY `id_tabung` (`id_tabung`),
  ADD KEY `id_supplier_out` (`id_supplier_out`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `gas_masuk`
--
ALTER TABLE `gas_masuk`
  ADD PRIMARY KEY (`id_gas_masuk`),
  ADD KEY `id_tabung` (`id_tabung`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `jenis_tabung`
--
ALTER TABLE `jenis_tabung`
  ADD PRIMARY KEY (`id_jenis_tabung`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `email_user` (`email_user`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indexes for table `supplier_out`
--
ALTER TABLE `supplier_out`
  ADD PRIMARY KEY (`id_supplier_out`);

--
-- Indexes for table `tabung`
--
ALTER TABLE `tabung`
  ADD PRIMARY KEY (`id_tabung`),
  ADD KEY `id_jenis_tabung` (`id_jenis_tabung`),
  ADD KEY `id_supplier` (`id_supplier`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `gas_history`
--
ALTER TABLE `gas_history`
  MODIFY `id_history` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gas_keluar`
--
ALTER TABLE `gas_keluar`
  MODIFY `id_gas_keluar` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gas_masuk`
--
ALTER TABLE `gas_masuk`
  MODIFY `id_gas_masuk` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jenis_tabung`
--
ALTER TABLE `jenis_tabung`
  MODIFY `id_jenis_tabung` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id_supplier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `supplier_out`
--
ALTER TABLE `supplier_out`
  MODIFY `id_supplier_out` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tabung`
--
ALTER TABLE `tabung`
  MODIFY `id_tabung` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `gas_history`
--
ALTER TABLE `gas_history`
  ADD CONSTRAINT `gas_history_ibfk_1` FOREIGN KEY (`id_tabung`) REFERENCES `tabung` (`id_tabung`),
  ADD CONSTRAINT `gas_history_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`),
  ADD CONSTRAINT `gas_history_ibfk_3` FOREIGN KEY (`id_supplier_out`) REFERENCES `supplier_out` (`id_supplier_out`),
  ADD CONSTRAINT `gas_history_ibfk_4` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id_user`);

--
-- Constraints for table `gas_keluar`
--
ALTER TABLE `gas_keluar`
  ADD CONSTRAINT `gas_keluar_ibfk_1` FOREIGN KEY (`id_tabung`) REFERENCES `tabung` (`id_tabung`),
  ADD CONSTRAINT `gas_keluar_ibfk_2` FOREIGN KEY (`id_supplier_out`) REFERENCES `supplier_out` (`id_supplier_out`),
  ADD CONSTRAINT `gas_keluar_ibfk_3` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id_user`);

--
-- Constraints for table `gas_masuk`
--
ALTER TABLE `gas_masuk`
  ADD CONSTRAINT `gas_masuk_ibfk_1` FOREIGN KEY (`id_tabung`) REFERENCES `tabung` (`id_tabung`),
  ADD CONSTRAINT `gas_masuk_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id_user`);

--
-- Constraints for table `tabung`
--
ALTER TABLE `tabung`
  ADD CONSTRAINT `tabung_ibfk_1` FOREIGN KEY (`id_jenis_tabung`) REFERENCES `jenis_tabung` (`id_jenis_tabung`),
  ADD CONSTRAINT `tabung_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
