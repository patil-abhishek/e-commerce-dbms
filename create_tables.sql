/*JOIN QUERIES*/

/*LEFT OUTER join*/
SELECT
  laptops.product_name,
  laptops.product_price,
  supplier.company_name
FROM
  supplier
  RIGHT JOIN (
    SELECT
      category.category_name,
      product.idsupplier,
      product.product_name,
      product.product_price
    FROM
      product
      RIGHT JOIN category ON category.idcategory = product.idcategory
    WHERE
      category.category_name = 'Laptop'
  ) AS laptops ON laptops.idsupplier = supplier.idsupplier;

/*RIGHT OUTER join*/
SELECT
  supplier.company_name Company,
  laptops.product_name as model,
  laptops.product_price AS price,
  laptops.product_rating AS rating
FROM
  supplier
  RIGHT JOIN (
    SELECT
      category.category_name,
      product.idsupplier,
      product.product_name,
      product.product_price,
      product.product_rating
    FROM
      product
      RIGHT JOIN category ON category.idcategory = product.idcategory
    WHERE
      category.category_name = 'Laptop'
  ) AS laptops ON laptops.idsupplier = supplier.idsupplier;

/*INNER join*/
SELECT
  prod.order_date as `Order date`,
  prod.product_count as Quantity,
  product.product_name AS Product
from
  product
  INNER JOIN (
    SELECT
      order_product.idproduct,
      order_product.product_count,
      ord.order_date
    FROM
      order_product
      INNER JOIN (
        SELECT
          orders.idorder,
          orders.order_date
        FROM
          orders
          INNER JOIN customer ON customer.idcustomer = orders.idcustomer
        WHERE
          customer.fname = 'Patrick'
          AND customer.lname = 'Jane'
      ) AS ord ON ord.idorder = order_product.idorder
  ) AS prod ON prod.idproduct = product.idproduct;

/*JOIN*/
SELECT
  product.product_name as Name,
  product.product_price as Price,
  product.product_rating as Rating,
  supplier.company_name as Supplier
from
  product
  JOIN supplier ON supplier.idsupplier = product.idsupplier
WHERE
  product.product_rating > 4.5;

/*Aggregate functions*/
/*aggregate SUM*/
SELECT
  customer.fname,
  customer.lname,
  SUM(orders.order_price) AS `Total Spent`
FROM
  customer
  INNER JOIN orders ON customer.idcustomer = orders.idcustomer
GROUP BY
  orders.idcustomer;

/*aggregate AVG*/
SELECT
  category.category_name,
  AVG(product.product_price) AS `Average Price`
FROM
  product
  JOIN category ON category.idcategory = product.idcategory
GROUP BY
  product.idcategory;

/*aggregate COUNT*/
SELECT
  supplier.company_name AS Supplier,
  COUNT(product.idproduct) AS `Number of products supplied`
FROM
  product
  JOIN supplier ON supplier.idsupplier = product.idsupplier
GROUP BY
  supplier.idsupplier
ORDER BY
  supplier.company_name;

/*aggregate MAX*/
SELECT
  product.product_name AS `Product Name`,
  maxi.Category,
  maxi.`Max Price`
FROM
  product
  INNER JOIN(
    SELECT
      category.category_name AS Category,
      category.idcategory,
      MAX(product.product_price) AS `Max Price`
    FROM
      product
      INNER JOIN category ON category.idcategory = product.idcategory
    GROUP BY
      product.idcategory
    ORDER BY
      category.category_name
  ) AS maxi ON maxi.`Max Price` = product.product_price
  AND maxi.idcategory = product.idcategory;

/*SET OPERATORS*/
/*EXCEPT*/
SELECT
  customer.idcustomer,
  customer.fname,
  customer.lname
FROM
  customer NATURAL
  JOIN (
    (
      SELECT
        customer.idcustomer
      FROM
        customer
    )
    EXCEPT
      (
        SELECT
          orders.idcustomer
        FROM
          orders
      )
  ) AS not_ordered;

/*intersect*/
SELECT
  supplier.idsupplier,
  supplier.company_name,
  supplier.URL
FROM
  supplier NATURAL
  JOIN (
    (
      SELECT
        product.idsupplier
      FROM
        product
      WHERE
        product.idcategory IN (
          SELECT
            category.idcategory
          FROM
            category
          WHERE
            category.category_name = "Laptop"
        )
    )
    INTERSECT
    (
      SELECT
        product.idsupplier
      FROM
        product
      WHERE
        product.idcategory IN (
          SELECT
            category.idcategory
          FROM
            category
          WHERE
            category.category_name = "Smartphone"
        )
    )
  ) AS electronics;

/*UNION*/
SELECT
  product.idproduct,
  product.product_name
FROM
  product
WHERE
  product.idproduct NOT IN (
    SELECT
      order_product.idproduct
    FROM
      order_product
  )
UNION
SELECT
  product.idproduct,
  product.product_name
FROM
  product
WHERE
  product.product_rating < 4;

/*except*/
SELECT
  supplier.idsupplier,
  supplier.company_name,
  supplier.URL
FROM
  supplier NATURAL
  JOIN (
    (
      SELECT
        supplier.idsupplier
      FROM
        supplier
    )
    EXCEPT
      (
        SELECT
          product.idsupplier
        FROM
          product
      )
  ) AS supplier;

/*function*/
DELIMITER $ $ CREATE FUNCTION total_sales (ProductID VARCHAR(5)) RETURNS INT READS SQL DATA DETERMINISTIC BEGIN DECLARE sale_amount INT;

DECLARE total_sold INT;

DECLARE price INT;

SET
  total_sold = (
    SELECT
      SUM(product_count)
    FROM
      order_product
    WHERE
      idproduct = ProductID
  );

SET
  price = (
    SELECT
      product_price
    FROM
      product
    WHERE
      idproduct = ProductID
  );

SET
  sale_amount = total_sold * price;

RETURN sale_amount;

END;

$ $
/*calling the function*/
SELECT
  product_name,
  total_sales(idproduct) as `Total Sales`
FROM
  product
WHERE
  product.idsupplier = 'S0005';

/*procedure*/
DELIMITER $ $ CREATE PROCEDURE display_good_products(
  IN categoryname VARCHAR(45),
  IN rating DOUBLE
) BEGIN DECLARE categoryID VARCHAR(5);

SET
  categoryID = (
    SELECT
      idcategory
    FROM
      category
    WHERE
      category_name = categoryName
  );

SELECT
  product_name,
  product_price,
  product_rating
FROM
  product
WHERE
  idcategory = categoryID
  AND product_rating >= rating;

END;

$ $
/*trigger*/
DELIMITER $ $ CREATE TRIGGER update_product_rating BEFORE
INSERT
  ON `product` FOR EACH ROW BEGIN DECLARE error_msg VARCHAR(100);

SET
  error_msg = ('New product must have 0 rating');

IF NEW.product_rating > 0 THEN SIGNAL SQLSTATE '45000'
SET
  MESSAGE_TEXT = error_msg;

END IF;

END $ $
/*calling the trigger*/
INSERT INTO
  product
VALUES
  (
    'P0017',
    'C0003',
    'S0006',
    'Reebok Shoes',
    4000,
    10,
    4.0
  );


/*table creation and populating*/
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

/*insert customers*/
INSERT INTO
  customer
VALUES
  (
    'C0001',
    'Sherlock',
    'Holmes',
    'M',
    'sherlock@gmail.com',
    '11111'
  ),
  (
    'C0002',
    'Sheldon',
    'Cooper',
    'M',
    'sheldon@gmail.com',
    '22222'
  ),
  (
    'C0003',
    'Patrick',
    'Jane',
    'M',
    'patrick@gmail.com',
    '33333'
  ),
  (
    'C0004',
    'Red',
    'John',
    'M',
    'redjohn@gmail.com',
    '44444'
  ),
  (
    'C0005',
    'Rajesh',
    'Koothrapalli',
    'M',
    'rajesh@gmail.com',
    '55555'
  ),
  (
    'C0006',
    'Teresa',
    'Lisbon',
    'F',
    'lisbon@gmail.com',
    '66666'
  ),
  (
    'C0007',
    'Naruto',
    'Uzumaki',
    'M',
    'narutouzumaki@gmail.com',
    '99999'
  ),
  (
    'C0008',
    'Kakashi',
    'Hatake',
    'M',
    'kakashi00@gmail.com',
    '10101'
  );

/*insert suppliers*/
INSERT INTO
  supplier
VALUES
  (
    'S0001',
    'Lenovo',
    'www.lenovo.com',
    '1800-123-4545',
    'lenovo.care@gmail.com'
  ),
  (
    'S0002',
    'Dell',
    'www.dell.com',
    '1800-123-4569',
    'dell.care@gmail.com'
  ),
  (
    'S0003',
    'Adidas',
    'www.adidas.com',
    '1800-123-4200',
    'adidas.care@gmail.com'
  ),
  (
    'S0004',
    'Puma',
    'www.puma.com',
    '1800-123-4848',
    'puma.care@gmail.com'
  ),
  (
    'S0005',
    'Nike',
    'www.nike.com',
    '1800-123-4343',
    'nike.care@gmail.com'
  ),
  (
    'S0006',
    'Reebok',
    'www.reebok.com',
    '1800-123-4646',
    'reebok.care@gmail.com'
  ),
  (
    'S0007',
    'Apple',
    'www.apple.com',
    '1800-123-4567',
    'apple.care@gmail.com'
  );

/*insert categories*/
INSERT INTO
  category
VALUES
  ('C0001', 'Laptop'),
  ('C0002', 'Smartphone'),
  ('C0003', 'Shoes'),
  ('C0004', 'Clothing');

/*insert address*/
INSERT INTO
  address
VALUES
  (
    'C0001-1',
    'C0001',
    '#221B',
    'Baker Street',
    'London',
    'UK'
  ),
  (
    'C0002-1',
    'C0002',
    '#215S',
    'Madison Ave',
    'Pasadena',
    'USA'
  ),
  (
    'C0003-1',
    'C0003',
    '#1309',
    'Cedars Street',
    'Malibu',
    'USA '
  ),
  (
    'C0003-2',
    'C0003',
    '#3600',
    'Riverside Blvd',
    'Sacramento',
    'USA'
  ),
  (
    'C0004-1',
    'C0004',
    '#14',
    'Street 1',
    'Napa',
    'USA'
  ),
  (
    'C0005-1',
    'C0005',
    '#15',
    'Madison Ave',
    'Pasadena',
    'USA'
  ),
  (
    'C0006-1',
    'C0006',
    '#3600',
    'Riverside Blvd',
    'Sacramento',
    'USA'
  ),
  (
    'C0007-1',
    'C0007',
    '#02',
    'Hokage Residence',
    'Konohagakure',
    'Japan'
  ),
  (
    'C0008-1',
    'C0008',
    '#25',
    'Hokage Residence',
    'Konohagakure',
    'Japan'
  );

/*insert products*/
INSERT INTO
  product
VALUES
  (
    'P0001',
    'C0001',
    'S0001',
    'Lenovo IdeaPad 330',
    35000,
    5,
    3.5
  ),
  (
    'P0002',
    'C0001',
    'S0001',
    'Lenovo ThinkPad E14',
    75000,
    10,
    4.0
  ),
  (
    'P0003',
    'C0001',
    'S0002',
    'Dell Inspiron 15',
    40000,
    15,
    3.8
  ),
  (
    'P0004',
    'C0001',
    'S0002',
    'Dell G15 Gaming',
    90000,
    10,
    4.5
  ),
  (
    'P0005',
    'C0001',
    'S0002',
    'Dell Latitude 9430',
    200000,
    5,
    4.2
  ),
  (
    'P0006',
    'C0002',
    'S0007',
    'iPhone 13',
    70000,
    25,
    4.6
  ),
  (
    'P0007',
    'C0002',
    'S0007',
    'iPhone 14',
    90000,
    25,
    4.4
  ),
  (
    'P0008',
    'C0001',
    'S0007',
    'MacBook Pro 2022',
    150000,
    10,
    4.8
  ),
  (
    'P0009',
    'C0003',
    'S0005',
    'Nike Air Force 1 Mid QS',
    13000,
    3,
    4.0
  ),
  (
    'P0010',
    'C0003',
    'S0005',
    'Nike Air Jordan 1 Retro ',
    16000,
    5,
    4.0
  ),
  (
    'P0011',
    'C0004',
    'S0005',
    'Nike Pro Dri-FIT Tshirt',
    2000,
    15,
    3.5
  ),
  (
    'P0012',
    'C0004',
    'S0005',
    'Nike Dri-FIT Tshirt',
    2000,
    15,
    3.9
  ),
  (
    'P0013',
    'C0003',
    'S0004',
    'Puma Redon Move Shoes',
    6000,
    5,
    4.2
  ),
  (
    'P0014',
    'C0003',
    'S0004',
    'Puma Electron E Pro Shoes',
    4500,
    12,
    4.4
  ),
  (
    'P0015',
    'C0004',
    'S0003',
    'Adidas Gameday Hoodie',
    4800,
    13,
    4.5
  ),
  (
    'P0016',
    'C0004',
    'S0003',
    'Adidas TraceRocker Jacket',
    5000,
    18,
    4.6
  );

/*insert order*/
INSERT INTO
  orders
VALUES
  (
    'O0001',
    'C0002',
    'C0002-1',
    '2022-08-11',
    110000
  ),
  ('O0002', 'C0005', 'C0005-1', '2022-07-12', 9800),
  ('O0003', 'C0002', 'C0002-1', '2020-05-14', 22000),
  (
    'O0004',
    'C0003',
    'C0003-1',
    '2021-06-15',
    200000
  ),
  ('O0005', 'C0003', 'C0003-2', '2022-07-16', 4000),
  ('O0006', 'C0005', 'C0005-1', '2020-08-17', 8000),
  ('O0007', 'C0004', 'C0004-1', '2020-04-09', 70000);

/*insert order details*/
INSERT INTO
  order_product
VALUES
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

LOAD DATA INFILE 'C:\\Users\\Abhishek Patil\\Downloads\\orders.csv' INTO TABLE orders FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:\\Users\\Abhishek Patil\\Downloads\\order_product.csv' INTO TABLE order_product FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' LINES TERMINATED BY '\n';