-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 01, 2024 at 09:32 AM
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
  `id_supplier` int(11) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `tanggal` date NOT NULL,
  `jenis_aktivitas` enum('masuk','keluar') NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gas_history`
--

INSERT INTO `gas_history` (`id_history`, `id_tabung`, `id_supplier`, `id_user`, `tanggal`, `jenis_aktivitas`, `jumlah`) VALUES
(1, 2, 3, 5, '2024-06-01', 'masuk', 10),
(3, 2, 4, 5, '2024-06-01', 'masuk', 20),
(4, 2, NULL, 5, '2024-06-01', 'keluar', 20);

-- --------------------------------------------------------

--
-- Table structure for table `gas_keluar`
--

CREATE TABLE `gas_keluar` (
  `id_gas_keluar` int(11) NOT NULL,
  `id_tabung` int(11) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `id_supplier` int(11) NOT NULL,
  `tanggal_keluar` timestamp NOT NULL DEFAULT current_timestamp(),
  `jumlah_keluar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gas_keluar`
--

INSERT INTO `gas_keluar` (`id_gas_keluar`, `id_tabung`, `id_user`, `id_supplier`, `tanggal_keluar`, `jumlah_keluar`) VALUES
(1, 2, 5, 4, '2024-06-01 04:13:10', 20);

--
-- Triggers `gas_keluar`
--
DELIMITER $$
CREATE TRIGGER `after_gas_keluar_insert` AFTER INSERT ON `gas_keluar` FOR EACH ROW BEGIN
    INSERT INTO gas_history(
        id_tabung,
        tanggal,
        jenis_aktivitas,
        jumlah,
        id_user
    )
VALUES(
    NEW.id_tabung,
    NEW.tanggal_keluar,
    'keluar',
    NEW.jumlah_keluar,
    NEW.id_user
) ;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `decrese_stock` AFTER INSERT ON `gas_keluar` FOR EACH ROW BEGIN

SET @jmlh = NEW.jumlah_keluar;

UPDATE tabung SET tabung.total_stock = tabung.total_stock - @jmlh WHERE tabung.id_jenis_tabung = NEW.id_tabung AND tabung.id_supplier = NEW.id_supplier;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validate_stock` BEFORE INSERT ON `gas_keluar` FOR EACH ROW BEGIN

SET @jmlhkurang = NEW.jumlah_keluar;

SET @jumlahSekarang = (SELECT total_stock FROM tabung WHERE tabung.id_jenis_tabung = NEW.id_tabung AND tabung.id_supplier = NEW.id_supplier LIMIT 1);

IF @jmlhkurang > @jumlahSekarang THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Jumlah Stock Yang diinputkan melebihi jumlah stock sekarang';
END IF;


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
  `id_user` int(11) DEFAULT NULL,
  `id_supplier` int(11) NOT NULL,
  `tanggal_masuk` timestamp NOT NULL DEFAULT current_timestamp(),
  `jumlah_masuk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gas_masuk`
--

INSERT INTO `gas_masuk` (`id_gas_masuk`, `id_tabung`, `id_user`, `id_supplier`, `tanggal_masuk`, `jumlah_masuk`) VALUES
(2, 1, 3, 1, '2024-06-01 03:44:28', 80),
(3, 1, 5, 1, '2024-06-01 03:44:54', 20),
(4, 2, 5, 3, '2024-06-01 03:56:35', 10),
(6, 2, 5, 4, '2024-06-01 04:01:45', 20);

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
    NEW.id_supplier,
    NEW.jumlah_masuk,
    NEW.id_user
);
 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increase_stock` AFTER INSERT ON `gas_masuk` FOR EACH ROW BEGIN

SET @jmlh = NEW.jumlah_masuk;

UPDATE tabung SET tabung.total_stock = tabung.total_stock + @jmlh WHERE tabung.id_supplier =NEW.id_supplier AND tabung.id_jenis_tabung = NEW.id_tabung;

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
(3, 'Gudang1', 'gudangInv1@gmail.com', '25d55ad283aa400af464c76d713c07ad'),
(5, 'gudang2', 'gudangInv2@gmail.com', '1bbd886460827015e5d605ed44252251');

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
-- Table structure for table `tabung`
--

CREATE TABLE `tabung` (
  `id_tabung` int(11) NOT NULL,
  `nomor_tabung` varchar(255) NOT NULL,
  `id_jenis_tabung` int(11) DEFAULT NULL,
  `id_supplier` int(11) DEFAULT NULL,
  `kode_supplier` varchar(255) NOT NULL,
  `total_stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tabung`
--

INSERT INTO `tabung` (`id_tabung`, `nomor_tabung`, `id_jenis_tabung`, `id_supplier`, `kode_supplier`, `total_stock`) VALUES
(1, 'TAB001_SGI_AR100', 1, 1, 'SGI_AR100', 100),
(2, 'TAB002_SGI_AR97', 2, 1, 'SGI_AR97', 0),
(3, 'TAB003_SGI_AR82', 3, 1, 'SGI_AR82', 0),
(4, 'TAB004_SGI_O2', 4, 1, 'SGI_O2', 0),
(5, 'TAB005_SGI_CO2', 5, 1, 'SGI_CO2', 0),
(6, 'TAB006_SGI_NITRO', 6, 1, 'SGI_CO2', 0),
(7, 'TAB001_SIG_AR100', 1, 2, 'SIG_AR100', 0),
(8, 'TAB002_SIG_AR97', 2, 2, 'SIG_AR97', 0),
(9, 'TAB003_SIG_AR82', 3, 2, 'SIG_AR82', 0),
(10, 'TAB004_SIG_O2', 4, 2, 'SIG_O2', 0),
(11, 'TAB005_SIG_CO2', 5, 2, 'SIG_CO2', 0),
(12, 'TAB006_SIG_NITRO', 6, 2, 'SIG_CO2', 0),
(13, 'TAB001_LANG_AR100', 1, 3, 'LANGGENG_AR100', 0),
(14, 'TAB002_LANG_AR97', 2, 3, 'LANGGENG_AR97', 0),
(15, 'TAB003_LANG_AR82', 3, 3, 'LANGGENG_AR82', 0),
(16, 'TAB004_LANG_O2', 4, 3, 'LANGGENG_O2', 0),
(17, 'TAB005_LANG_CO2', 5, 3, 'LANGGENG_CO2', 0),
(18, 'TAB006_LANG_NITRO', 6, 3, 'LANGGENG_CO2', 0),
(19, 'TAB001_TIRA_AR100', 1, 4, 'TIRA_AR100', 0),
(20, 'TAB002_TIRA_AR97', 2, 4, 'TIRA_AR97', 0),
(21, 'TAB003_TIRA_AR82', 3, 4, 'TIRA_AR82', 0),
(22, 'TAB004_TIRA_O2', 4, 4, 'TIRA_O2', 0),
(23, 'TAB005_TIRA_CO2', 5, 4, 'TIRA_CO2', 0),
(24, 'TAB006_TIRA_NITRO', 6, 4, 'TIRA_CO2', 0),
(25, 'TAB001_SMTR_AR100', 1, 5, 'SAMATOR_AR100', 0),
(26, 'TAB002_SMTR_AR97', 2, 5, 'SAMATOR_AR97', 0),
(27, 'TAB003_SMTR_AR82', 3, 5, 'SAMATOR_AR82', 0),
(28, 'TAB004_SMTR_O2', 4, 5, 'SAMATOR_O2', 0),
(29, 'TAB005_SMTR_CO2', 5, 5, 'SAMATOR_CO2', 0),
(30, 'TAB006_SMTR_NITRO', 6, 5, 'SAMATOR_CO2', 0);

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
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `gas_keluar`
--
ALTER TABLE `gas_keluar`
  ADD PRIMARY KEY (`id_gas_keluar`),
  ADD KEY `id_tabung` (`id_tabung`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `gas_keluar_supp` (`id_supplier`);

--
-- Indexes for table `gas_masuk`
--
ALTER TABLE `gas_masuk`
  ADD PRIMARY KEY (`id_gas_masuk`),
  ADD KEY `id_tabung` (`id_tabung`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `gas_masuk_supp` (`id_supplier`);

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
  MODIFY `id_history` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `gas_keluar`
--
ALTER TABLE `gas_keluar`
  MODIFY `id_gas_keluar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `gas_masuk`
--
ALTER TABLE `gas_masuk`
  MODIFY `id_gas_masuk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `jenis_tabung`
--
ALTER TABLE `jenis_tabung`
  MODIFY `id_jenis_tabung` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id_supplier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  ADD CONSTRAINT `gas_history_ibfk_1` FOREIGN KEY (`id_tabung`) REFERENCES `gas_masuk` (`id_tabung`),
  ADD CONSTRAINT `gas_history_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `gas_masuk` (`id_supplier`),
  ADD CONSTRAINT `gas_history_ibfk_4` FOREIGN KEY (`id_user`) REFERENCES `gas_masuk` (`id_user`);

--
-- Constraints for table `gas_keluar`
--
ALTER TABLE `gas_keluar`
  ADD CONSTRAINT `gas_keluar_ibfk_1` FOREIGN KEY (`id_tabung`) REFERENCES `tabung` (`id_jenis_tabung`),
  ADD CONSTRAINT `gas_keluar_ibfk_3` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id_user`),
  ADD CONSTRAINT `gas_keluar_supp` FOREIGN KEY (`id_supplier`) REFERENCES `tabung` (`id_supplier`);

--
-- Constraints for table `gas_masuk`
--
ALTER TABLE `gas_masuk`
  ADD CONSTRAINT `gas_masuk_ibfk_1` FOREIGN KEY (`id_tabung`) REFERENCES `tabung` (`id_jenis_tabung`),
  ADD CONSTRAINT `gas_masuk_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id_user`),
  ADD CONSTRAINT `gas_masuk_supp` FOREIGN KEY (`id_supplier`) REFERENCES `tabung` (`id_supplier`);

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
