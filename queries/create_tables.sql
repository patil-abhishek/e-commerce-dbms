/*customer*/
CREATE TABLE `e-commerce_database_010`.`customer` (
  `idcustomer` varchar(5) NOT NULL UNIQUE,
  `fname` varchar(45) NOT NULL,
  `lname` varchar(45) DEFAULT NULL,
  `gender` char(1) NOT NULL,
  `email` varchar(45) NOT NULL,
  `phone` varchar(10) NOT NULL,
  PRIMARY KEY (`idcustomer`)
);

/*supplier*/
CREATE TABLE `e-commerce_database_010`.`supplier` (
  `idsupplier` VARCHAR(5) NOT NULL UNIQUE,
  `company_name` VARCHAR(45) NOT NULL,
  `URL` VARCHAR(45) DEFAULT NULL,
  `customer_care` VARCHAR(13) DEFAULT NULL,
  `complaint_email` VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY (`idsupplier`)
);

/*category*/
CREATE TABLE `e-commerce_database_010`.`category` (
  `idcategory` VARCHAR(5) NOT NULL UNIQUE,
  `category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcategory`)
);

/*address*/
CREATE TABLE `e-commerce_database_010`.`address` (
  `idaddress` VARCHAR(7) NOT NULL UNIQUE,
  `idcustomer` VARCHAR(5) NOT NULL,
  `building_number` VARCHAR(10) DEFAULT NULL,
  `street` VARCHAR(45) DEFAULT NULL,
  `city` VARCHAR(45) DEFAULT NULL,
  `country` VARCHAR(45) DEFAULT "India",
  PRIMARY KEY (`idaddress`),
  FOREIGN KEY (`idcustomer`) REFERENCES `customer` (`idcustomer`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*product*/
CREATE TABLE `e-commerce_database_010`.`product` (
  `idproduct` VARCHAR(5) NOT NULL UNIQUE,
  `idcategory` VARCHAR(5),
  `idsupplier` VARCHAR(5) NOT NULL,
  `product_name` VARCHAR(45) NOT NULL,
  `product_price` INT NOT NULL,
  `product_count` INT NOT NULL,
  `product_rating` DOUBLE DEFAULT 0,
  PRIMARY KEY (`idproduct`),
  FOREIGN KEY (`idcategory`) REFERENCES `category` (`idcategory`) ON DELETE
  SET
    NULL ON UPDATE
  SET
    NULL,
    FOREIGN KEY (`idsupplier`) REFERENCES `supplier` (`idsupplier`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*order*/
CREATE TABLE `e-commerce_database_010`.`orders` (
  `idorder` VARCHAR(5) NOT NULL UNIQUE,
  `idcustomer` VARCHAR(5) NOT NULL,
  `idaddress` VARCHAR(7),
  `order_date` DATE NOT NULL,
  `order_price` INT NOT NULL,
  PRIMARY KEY (`idorder`),
  FOREIGN KEY (`idcustomer`) REFERENCES `customer` (`idcustomer`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`idaddress`) REFERENCES `address` (`idaddress`) ON DELETE
  SET
    NULL ON UPDATE
  SET
    NULL
);

/*order_product*/
CREATE TABLE `e-commerce_database_010`.`order_product` (
  `idorder` VARCHAR(5) NOT NULL,
  `idproduct` VARCHAR(5),
  `product_count` INT NOT NULL,
  FOREIGN KEY (`idorder`) REFERENCES `orders` (`idorder`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`idproduct`) REFERENCES `product` (`idproduct`) ON DELETE
  SET
    NULL ON UPDATE
  SET
    NULL
);
