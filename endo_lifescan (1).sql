-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 24, 2026 at 05:54 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `endo_lifescan`
--

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`id`, `email`, `otp`, `expires_at`, `created_at`) VALUES
(8, 'ramesh@gmail.com', '738473', '2026-02-26 13:33:30', '2026-02-26 07:53:30'),
(10, 'balusuramesh74@gmail.com', '918237', '2026-02-28 10:43:00', '2026-02-28 05:03:00');

-- --------------------------------------------------------

--
-- Table structure for table `uploads`
--

CREATE TABLE `uploads` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `image_name` varchar(255) NOT NULL,
  `prediction` varchar(50) NOT NULL,
  `recommendation` varchar(100) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `uploads`
--

INSERT INTO `uploads` (`id`, `user_id`, `image_name`, `prediction`, `recommendation`, `uploaded_at`) VALUES
(1, 1, 'DSC00815.JPG', 'not_safe', 'Do not reuse', '2026-02-25 03:47:45'),
(2, 1, '6b2fd4ee-e917-4ec0-a184-be4641f07953_DSC00815.JPG,3d289002-48ac-46cc-b9b8-c6f835be1f33_DSC00717.JPG,91564bb6-0904-48c2-8310-d13064bb1d62_DSC00720.JPG', 'not_safe', 'Do not reuse', '2026-02-26 09:25:58'),
(3, 1, '1c4c3b7e-87bd-430b-ba95-6c0fd02cd34a_image1.jpg,8905e28b-fbf5-4c72-8fe8-718a7db47120_image2.jpg,67c6cdc4-fa6f-4f77-bd3a-e2c3802b7e90_image3.jpg', 'not_safe', 'Do not reuse', '2026-02-27 07:48:38'),
(14, 1, 'd89bc339-991b-4fc9-ae5d-a727d39ff8d7_DSC00717.JPG,1f3f15d6-a3f2-47af-981e-ab039407d587_DSC00809.JPG,28de478a-1813-440f-80d7-3dbac724455d_DSC00818.JPG', 'not_safe', 'Do not reuse', '2026-03-02 07:38:51'),
(15, 1, 'a12fe43d-9b0c-4271-b9a2-e957d1bfeb80_image_5310174454301482814.jpg,08d1311e-41cf-463c-9033-c1af8fdbcc3f_image_5534431818501337850.jpg,6113b23a-7034-4846-b040-6bb1bc8ade8a_image_6554485690250518016.jpg', 'safe', 'Safe to reuse', '2026-03-02 08:31:55'),
(16, 10, '14f9a6ce-f977-437c-bb7b-e6533ca31039_DSC00720.JPG,598149c8-b5e1-4464-96b9-1747d507b444_DSC00809.JPG,d58ae22c-6d8e-49b6-bc11-f5f00b161609_DSC00815.JPG', 'safe', 'Safe to reuse', '2026-03-03 05:26:12'),
(17, 1, '430b4ea8-45d8-46b1-a66b-06005dab9c9e_image_1167728394172423659.jpg,b64644ef-03b0-447d-8bc5-c9b50302b9d1_image_5152173399939593742.jpg,7a28ea87-1c31-48d8-b81a-a6e54c54460c_image_3125359932672972248.jpg', 'safe', 'Safe to reuse', '2026-03-04 05:23:59'),
(18, 1, '6c6e6693-30dd-4c67-be16-54dec17434ac_image_847171800802401268.jpg,2c03502e-fd30-435f-a984-0931c7a4d0d1_image_6677693866922089869.jpg,729f392f-32c4-44af-a7e7-9ff21face0d4_image_3422962970263206416.jpg', 'safe', 'Safe to reuse', '2026-03-04 07:48:06'),
(19, 1, '2806ce2c-81c9-441a-9f9a-ea8e17146fe0_image_884113989185391340.jpg,b5e9ee40-19c4-4b13-be71-ccbdff626315_image_7520120827249332511.jpg,1f02c30b-ed9d-4cf5-a05f-46279aff27f0_image_3670414616484926817.jpg', 'safe', 'Safe to reuse', '2026-03-04 08:36:15'),
(20, 1, '4e0a49ae-01a8-4a7f-a4f1-a37185850ae1_image_4780067373900529786.jpg,ce0f78eb-2b05-45da-8b24-5b4caeb77d13_image_209435332492161297.jpg,160250a5-7257-4d9a-889d-70d8f35ec933_image_5502999200332247395.jpg', 'safe', 'Safe to reuse', '2026-03-04 08:39:06'),
(21, 1, '5499e08e-06f2-4913-b8c0-a3a7abc43d7b_image_9175210708156443185.jpg,7526ac91-b272-4e57-910c-1b5133a92613_image_8431520686644494235.jpg,208a8832-c01d-43ae-8b17-910fd3aec2e3_image_2536300933392376068.jpg', 'not_safe', 'Do not reuse', '2026-03-04 08:55:57');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `reset_otp` varchar(6) DEFAULT NULL,
  `otp_expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password_hash`, `is_active`, `created_at`, `updated_at`, `reset_otp`, `otp_expires_at`) VALUES
(1, 'Dr Test User', 'testdoctor@gmail.com', 'scrypt:32768:8:1$KxAnNKn3MpGjv8TO$9cadc2c7a9702db962bced04b9afa0e97e66178ca44851330533f0f6975bc5a5bd20e08e1ee6aba223ca876594b68c13a9434adac15a54f4c0faeb06c6071a08', 1, '2026-02-18 10:33:34', NULL, NULL, NULL),
(2, 'Dr.Krishna', 'krishna@gmail.com', 'scrypt:32768:8:1$d6NhQXRgf2PWO9Kw$7c30537dc10675c7376988d2612ebfa5e8f1d738cbba174af14e1a566e221298a774828084eff610474e7113a3fcb3748ac1321a950c87237193a25923f05ec0', 1, '2026-02-25 02:56:01', '2026-02-25 03:27:16', NULL, NULL),
(3, 'Dr.Leela', 'leela@gmail.com', 'scrypt:32768:8:1$hcnoTLNLL8KPp7tI$8fe3f9a09237d0e6c6674ffdcce85c8d1081ab749ddca207d5c1105f8f3f23a58b1a541116151670f9d04442d12ea5a65e45abe955b5c7f1e93d74ead8fbf482', 1, '2026-02-25 03:27:57', NULL, NULL, NULL),
(4, 'Dr.Ramesh', 'ramesh@gmail.com', 'scrypt:32768:8:1$qkric0l1i0PiSxhf$739d83d6dd05db6a6b8eac6037fd9a07ab0928172b24b050eba553ccaf052492462a44006e0ca2021e2673e1d3c18086313622889707c73d23325475578d5b00', 1, '2026-02-25 08:16:55', NULL, NULL, NULL),
(5, 'navya', 'nsbalusu@gmail.com', 'scrypt:32768:8:1$aefJE2KwY9pTjmps$e9f93622ea4e63df551b4230d1da6b980d22620ad45cbe1d1bb223b525086d3b831293039a6f48a51091db2219d1814bf999c0b31970ad6fd988a902eda10f28', 1, '2026-02-26 08:08:38', '2026-02-26 08:12:22', NULL, NULL),
(6, 'Navya', 'balusunavya88@gmail.com', 'scrypt:32768:8:1$JFqrVxfXzVnc28fP$f8136b0aee29a1cd45612e893ea3eaa5818a39b5011a29def1788eefdf5f61cf2518f1a61cb01008d9e724841cfc18b924be86a2ab2a972d1cff400998951bda', 1, '2026-02-27 15:17:21', '2026-03-04 05:10:05', NULL, NULL),
(7, 'Ramesh', 'balusuramesh74@gmail.com', 'scrypt:32768:8:1$Kcg4taSVX12JuGDC$1f57e82dbb704b816a706194770c78a0ca5f13b170fccc44a6f37f2364caf98e577a4f880a7afa17b0c4e7b9453384c6959d71796c013ea553f307532a43f27c', 1, '2026-02-28 04:04:12', '2026-03-03 05:28:02', NULL, NULL),
(8, 'Nivi', 'balusunivi0@gmail.com', 'scrypt:32768:8:1$lQ7gvv9TAqDpIvu5$feb444e0cc6920923799c045f66c88a5483a1ed812e2e7efbe877b228c21d0223adfb0791d2bd6f37caa17b846e0119911e3b3e942c211438c07a4113470106f', 1, '2026-02-28 04:23:00', NULL, NULL, NULL),
(9, 'Dr Himaja', 'kotipallihimaja@gmail.com', 'scrypt:32768:8:1$37sQjxToQrElNTjQ$2f2b236f9d0454b5009621a9cedfa90167bad896635e3f0ecc65ee542b0f418e509934cd051b34cb9376c1511b7f999dcdc4a766fa9b8acb301e65a9665f3059', 1, '2026-03-02 07:45:20', NULL, NULL, NULL),
(10, 'Test User', 'testuser@gmail.com', 'scrypt:32768:8:1$jZmweDxlVKspRcxX$68ba24f06cef1e19a601b3d8371159096a8cf5e4686bd5736acaab72ece7029b07dbc820af1e4c8f8e04365b9ff4f2206402c143f0ba244cc0867c54f32ab98e', 1, '2026-03-03 05:24:14', '2026-03-03 05:28:49', NULL, NULL),
(11, 'NavyaSri', 'navyasribalusu1260.sse@saveetha.com', 'scrypt:32768:8:1$6icEEU10b25izUzo$26dc59733d86f345e728960d6cd721a1d72f3af335c446acf0b37c81a49cfe012b6bc16dcfe83b9e23f0882e6a9a69a496271fec8e483dc13aa4d7f339440dde', 1, '2026-03-23 03:37:08', NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `uploads`
--
ALTER TABLE `uploads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_uploads_user` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `uploads`
--
ALTER TABLE `uploads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `uploads`
--
ALTER TABLE `uploads`
  ADD CONSTRAINT `fk_uploads_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
