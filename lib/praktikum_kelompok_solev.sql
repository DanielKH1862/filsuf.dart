-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 13 Okt 2024 pada 08.30
-- Versi server: 8.0.37
-- Versi PHP: 8.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `praktikum_kelompok_solev`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `agenda`
--

CREATE TABLE `agenda` (
  `kd_agenda` int NOT NULL,
  `judul_agenda` varchar(30) NOT NULL,
  `isi_agenda` text NOT NULL,
  `tgl_agenda` date NOT NULL,
  `tgl_post_agenda` date NOT NULL,
  `status_agenda` int NOT NULL,
  `kd_petugas` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `agenda`
--

INSERT INTO `agenda` (`kd_agenda`, `judul_agenda`, `isi_agenda`, `tgl_agenda`, `tgl_post_agenda`, `status_agenda`, `kd_petugas`) VALUES
(2, 'Rapat Bulanan', 'Rapat bulanan akan dilaksanakan pada tanggal 10 Oktober 2024.', '2024-10-10', '2024-10-01', 1, 1001),
(3, 'Kegiatan Bakti Sosial', 'Kegiatan bakti sosial untuk lingkungan sekolah akan diadakan pada tanggal 25 Oktober.', '2024-10-25', '2024-10-02', 1, 1002),
(4, 'Ujian Akhir Semester', 'Jadwal ujian akhir semester dimulai dari tanggal 15 November hingga 20 November.', '2024-11-15', '2024-10-03', 1, 1003),
(5, 'Pelatihan Guru', 'Pelatihan pengembangan kompetensi guru diadakan pada 20 Oktober.', '2024-10-20', '2024-09-28', 1, 1004),
(6, 'Kegiatan Outbound', 'Kegiatan outbound bagi siswa kelas 3 akan diadakan pada tanggal 30 Oktober.', '2024-10-30', '2024-09-30', 1, 1001),
(9, 'Aku Ganteng', 'BANGET', '2024-10-11', '2024-10-11', 1, 1),
(10, 'Aku Ganteng', 'BANGET', '2024-10-11', '2024-10-11', 1, 1),
(11, 'Data Mining', 'PAI', '2024-10-11', '2024-10-11', 1, 1),
(12, 'KELOMPOK SOLEV', 'PAI SHA ARYA DANIEL AKU', '2024-10-12', '2024-10-11', 1, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `galery`
--

CREATE TABLE `galery` (
  `kd_galery` int NOT NULL,
  `judul_galery` varchar(30) COLLATE utf8mb3_unicode_ci NOT NULL,
  `isi_galery` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `images` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tgl_post_galery` date NOT NULL,
  `status_galery` int NOT NULL,
  `kd_petugas` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data untuk tabel `galery`
--

INSERT INTO `galery` (`kd_galery`, `judul_galery`, `isi_galery`, `images`, `tgl_post_galery`, `status_galery`, `kd_petugas`) VALUES
(1, 'Kegiatan Upacara', 'Galeri foto kegiatan upacara bendera di sekolah pada bulan Agustus.', 'images (1).jpg', '2024-08-17', 1, 1001),
(2, 'Lomba 17 Agustus', 'Dokumentasi lomba 17 Agustus yang diadakan di sekolah.', 'aji-banner-resepdetail-ayamgeprekmawur-920x517._48d52f00287fc0c31a89df56abf60de9.png', '2024-08-18', 1, 1002),
(3, 'Pentas Seni', 'Galeri foto kegiatan pentas seni oleh siswa-siswi kelas 10.', 'sekolah.jpg', '2024-09-05', 1, 1003),
(4, 'Workshop Teknologi', 'Galeri foto workshop teknologi bagi siswa jurusan IT.', 'sekolah.jpg', '2024-09-12', 1, 1004),
(5, 'Study Tour', 'Dokumentasi kegiatan study tour ke museum nasional.', 'sekolah.jpg', '2024-09-20', 1, 1005),
(12, 'tes', '', 'shutterstock_1949306203-500x300.jpg', '2024-10-11', 0, 1),
(15, 'baruuu', '', '1728632408_IMG-20241008-WA0017.jpg', '2024-10-11', 0, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `informasi`
--

CREATE TABLE `informasi` (
  `kd_info` int NOT NULL,
  `judul_info` varchar(30) NOT NULL,
  `isi_info` text NOT NULL,
  `tgl_post_info` date NOT NULL,
  `status_info` int NOT NULL,
  `kd_petugas` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `informasi`
--

INSERT INTO `informasi` (`kd_info`, `judul_info`, `isi_info`, `tgl_post_info`, `status_info`, `kd_petugas`) VALUES
(2, 'Pengumuman Libur', 'Kegiatan belajar mengajar diliburkan selama seminggu.', '2024-10-01', 1, 1001),
(3, 'Jadwal Ujian', 'Ujian akhir semester akan dimulai pada tanggal 15 November.', '2024-10-05', 1, 1002),
(4, 'Pendaftaran Kelas Tambahan', 'Pendaftaran untuk kelas tambahan akan dibuka mulai 10 Oktober.', '2024-10-10', 0, 1),
(5, 'Perubahan Jam Operasional', 'Jam operasional sekolah akan berubah menjadi 07.30 - 15.00.', '2024-10-07', 1, 1004),
(6, 'Pelatihan Guru', 'Pelatihan guru akan diadakan pada 20 Oktober di ruang seminar.', '2024-09-25', 1, 1001);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `kd_user` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `foto_profile` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `kd_user`, `username`, `email`, `password`, `foto_profile`) VALUES
(1, 1, 'alif', 'alif@yahoo.com', 'alif', 'alif.jpg'),
(2, 2, 'pai', 'pai@yahoo.com', 'pai', 'pai.png'),
(3, 3, 'sha', 'sha@yahoo.com', 'sha', 'sha.jpg'),
(4, 4, 'arya', 'arya@yahoo.com', 'arya', 'arya.jpg'),
(5, 5, 'Muhammad Daniel Khaikal', 'danil@yahoo.com', 'danil', 'danil.jpg');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `agenda`
--
ALTER TABLE `agenda`
  ADD PRIMARY KEY (`kd_agenda`);

--
-- Indeks untuk tabel `galery`
--
ALTER TABLE `galery`
  ADD PRIMARY KEY (`kd_galery`);

--
-- Indeks untuk tabel `informasi`
--
ALTER TABLE `informasi`
  ADD PRIMARY KEY (`kd_info`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `agenda`
--
ALTER TABLE `agenda`
  MODIFY `kd_agenda` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `galery`
--
ALTER TABLE `galery`
  MODIFY `kd_galery` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `informasi`
--
ALTER TABLE `informasi`
  MODIFY `kd_info` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
