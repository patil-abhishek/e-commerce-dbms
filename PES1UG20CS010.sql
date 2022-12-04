-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 28, 2022 at 11:59 AM
-- Server version: 8.0.31
-- PHP Version: 7.4.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `e-commerce_database_010`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `display_good_products` (IN `categoryname` VARCHAR(45), IN `rating` DOUBLE)   BEGIN
	DECLARE categoryID VARCHAR(5);
    SET categoryID = (SELECT idcategory FROM category 
                      WHERE category_name = categoryName);
	SELECT product_name, product_price, product_rating FROM product
    WHERE idcategory = categoryID AND product_rating >= rating;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `total_sales` (`ProductID` VARCHAR(5)) RETURNS INT DETERMINISTIC READS SQL DATA BEGIN
    DECLARE sale_amount INT;
    DECLARE total_sold INT;
    DECLARE price INT;
    SET total_sold  = (SELECT SUM(product_count) FROM order_product 
    					WHERE idproduct = ProductID);
	SET price = (SELECT product_price FROM product
                 WHERE idproduct = ProductID);
	SET sale_amount = total_sold * price;
    RETURN sale_amount;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `idaddress` varchar(7) COLLATE utf8mb4_general_ci NOT NULL,
  `idcustomer` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `building_number` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `street` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country` varchar(45) COLLATE utf8mb4_general_ci DEFAULT 'India'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`idaddress`, `idcustomer`, `building_number`, `street`, `city`, `country`) VALUES
('C0001-1', 'C0001', '#221B', 'Baker Street', 'London', 'UK'),
('C0002-1', 'C0002', '#215S', 'Madison Ave', 'Pasadena', 'USA'),
('C0003-1', 'C0003', '#1309', 'Cedars Street', 'Malibu', 'USA '),
('C0004-1', 'C0004', '#14', 'Street 1', 'Napa', 'USA'),
('C0005-1', 'C0005', '#15', 'Madison Ave', 'Pasadena', 'USA'),
('C0006-1', 'C0006', '#3600', 'Riverside Blvd', 'Sacramento', 'USA'),
('C0007-1', 'C0007', '#02', 'Hokage Residence', 'Konohagakure', 'Japan'),
('C0008-1', 'C0008', '#25', 'Hokage Residence', 'Konohagakure', 'Japan');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `idcategory` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `category_name` varchar(45) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`idcategory`, `category_name`) VALUES
('C0001', 'Laptop'),
('C0002', 'Smartphone'),
('C0003', 'Shoes'),
('C0004', 'Clothing');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `idcustomer` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `fname` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `lname` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gender` char(1) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(10) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`idcustomer`, `fname`, `lname`, `gender`, `email`, `phone`) VALUES
('C0001', 'Sherlock', 'Holmes', 'M', 'holmes@gmail.com', '11111'),
('C0002', 'Sheldon', 'Cooper', 'M', 'sheldon@gmail.com', '22222'),
('C0003', 'Patrick', 'Jane', 'M', 'patrick@gmail.com', '33333'),
('C0004', 'Red', 'John', 'M', 'redjohn@gmail.com', '44444'),
('C0005', 'Rajesh', 'Koothrapalli', 'M', 'rajesh@gmail.com', '55555'),
('C0006', 'Teresa', 'Lisbon', 'F', 'lisbon@gmail.com', '66666'),
('C0007', 'Naruto', 'Uzumaki', 'M', 'narutouzumaki@gmail.com', '99999'),
('C0008', 'Kakashi', 'Hatake', 'M', 'kakashi00@gmail.com', '10101'),
('C0020', 'Abhishek', 'Patil', 'M', 'abhijpatil2003@gmail.com', '9632714472');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `idorder` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `idcustomer` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `idaddress` varchar(7) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `order_date` date NOT NULL,
  `order_price` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`idorder`, `idcustomer`, `idaddress`, `order_date`, `order_price`) VALUES
('O0001', 'C0002', 'C0002-1', '2022-08-11', 110000),
('O0002', 'C0005', 'C0005-1', '2022-07-12', 9800),
('O0003', 'C0002', 'C0002-1', '2020-05-14', 22000),
('O0004', 'C0003', 'C0003-1', '2021-06-15', 200000),
('O0005', 'C0003', NULL, '2022-07-16', 4000),
('O0006', 'C0005', 'C0005-1', '2020-08-17', 8000),
('O0007', 'C0004', 'C0004-1', '2020-04-09', 70000);

-- --------------------------------------------------------

--
-- Table structure for table `order_product`
--

CREATE TABLE `order_product` (
  `idorder` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `idproduct` varchar(5) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `product_count` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_product`
--

INSERT INTO `order_product` (`idorder`, `idproduct`, `product_count`) VALUES
('O0001', 'P0001', 1),
('O0001', 'P0002', 1),
('O0002', 'P0015', 1),
('O0002', 'P0016', 1),
('O0003', 'P0010', 1),
('O0003', 'P0013', 1),
('O0004', 'P0005', 1),
('O0005', 'P0011', 2),
('O0006', 'P0012', 4),
('O0007', 'P0006', 1);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `idproduct` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `idcategory` varchar(5) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idsupplier` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `product_name` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `product_price` int NOT NULL,
  `product_count` int NOT NULL,
  `product_rating` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`idproduct`, `idcategory`, `idsupplier`, `product_name`, `product_price`, `product_count`, `product_rating`) VALUES
('P0001', 'C0001', 'S0001', 'Lenovo IdeaPad 330', 35000, 5, 3.5),
('P0002', 'C0001', 'S0001', 'Lenovo ThinkPad E14', 75000, 10, 4),
('P0003', 'C0001', 'S0002', 'Dell Inspiron 15', 40000, 15, 3.8),
('P0004', 'C0001', 'S0002', 'Dell G15 Gaming', 90000, 10, 4.5),
('P0005', 'C0001', 'S0002', 'Dell Latitude 9430', 200000, 5, 4.2),
('P0006', 'C0002', 'S0007', 'iPhone 13', 70000, 25, 4.6),
('P0007', 'C0002', 'S0007', 'iPhone 14', 90000, 25, 4.4),
('P0008', 'C0001', 'S0007', 'MacBook Pro 2022', 150000, 10, 4.8),
('P0009', 'C0003', 'S0005', 'Nike Air Force 1 Mid QS', 13000, 3, 4),
('P0010', 'C0003', 'S0005', 'Nike Air Jordan 1 Retro ', 16000, 5, 4),
('P0011', 'C0004', 'S0005', 'Nike Pro Dri-FIT Tshirt', 2000, 15, 3.5),
('P0012', 'C0004', 'S0005', 'Nike Dri-FIT Tshirt', 2000, 15, 3.9),
('P0013', 'C0003', 'S0004', 'Puma Redon Move Shoes', 6000, 5, 4.2),
('P0014', 'C0003', 'S0004', 'Puma Electron E Pro Shoes', 4500, 12, 4.4),
('P0015', 'C0004', 'S0003', 'Adidas Gameday Hoodie', 4800, 13, 4.5),
('P0016', 'C0004', 'S0003', 'Adidas TraceRocker Jacket', 5000, 18, 4.6);

--
-- Triggers `product`
--
DELIMITER $$
CREATE TRIGGER `update_product_rating` BEFORE INSERT ON `product` FOR EACH ROW BEGIN 
    DECLARE error_msg VARCHAR(100);
    SET error_msg = ('New product must have 0 rating');
    IF NEW.product_rating > 0 THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_msg;
    END IF; 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `idsupplier` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `company_name` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `URL` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `customer_care` varchar(13) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `complaint_email` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`idsupplier`, `company_name`, `URL`, `customer_care`, `complaint_email`) VALUES
('S0001', 'Lenovo', 'www.lenovo.com', '1800-123-4545', 'lenovo.care@gmail.com'),
('S0002', 'Dell', 'www.dell.com', '1800-123-4569', 'dell.care@gmail.com'),
('S0003', 'Adidas', 'www.adidas.com', '1800-123-4200', 'adidas.care@gmail.com'),
('S0004', 'Puma', 'www.puma.com', '1800-123-4848', 'puma.care@gmail.com'),
('S0005', 'Nike', 'www.nike.com', '1800-123-4343', 'nike.care@gmail.com'),
('S0006', 'Reebok', 'www.reebok.com', '1800-123-4646', 'reebok.care@gmail.com'),
('S0007', 'Apple', 'www.apple.com', '1800-123-4567', 'apple.care@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`idaddress`),
  ADD UNIQUE KEY `idaddress` (`idaddress`),
  ADD KEY `idcustomer` (`idcustomer`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`idcategory`),
  ADD UNIQUE KEY `idcategory` (`idcategory`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`idcustomer`),
  ADD UNIQUE KEY `idcustomer` (`idcustomer`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`idorder`),
  ADD UNIQUE KEY `idorder` (`idorder`),
  ADD KEY `idcustomer` (`idcustomer`),
  ADD KEY `idaddress` (`idaddress`);

--
-- Indexes for table `order_product`
--
ALTER TABLE `order_product`
  ADD KEY `idorder` (`idorder`),
  ADD KEY `idproduct` (`idproduct`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`idproduct`),
  ADD UNIQUE KEY `idproduct` (`idproduct`),
  ADD KEY `idcategory` (`idcategory`),
  ADD KEY `idsupplier` (`idsupplier`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`idsupplier`),
  ADD UNIQUE KEY `idsupplier` (`idsupplier`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `address_ibfk_1` FOREIGN KEY (`idcustomer`) REFERENCES `customer` (`idcustomer`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`idcustomer`) REFERENCES `customer` (`idcustomer`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`idaddress`) REFERENCES `address` (`idaddress`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `order_product`
--
ALTER TABLE `order_product`
  ADD CONSTRAINT `order_product_ibfk_1` FOREIGN KEY (`idorder`) REFERENCES `orders` (`idorder`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_product_ibfk_2` FOREIGN KEY (`idproduct`) REFERENCES `product` (`idproduct`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`idcategory`) REFERENCES `category` (`idcategory`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`idsupplier`) REFERENCES `supplier` (`idsupplier`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
