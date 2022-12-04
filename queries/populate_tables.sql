/*insert customers*/
INSERT INTO customer VALUES
('C0001', 'Sherlock', 'Holmes', 'M', 'sherlock@gmail.com', '11111'),
('C0002', 'Sheldon', 'Cooper', 'M', 'sheldon@gmail.com', '22222'),
('C0003', 'Patrick', 'Jane', 'M', 'patrick@gmail.com', '33333'),
('C0004', 'Red', 'John', 'M', 'redjohn@gmail.com', '44444'),
('C0005', 'Rajesh', 'Koothrapalli', 'M', 'rajesh@gmail.com', '55555'),
('C0006', 'Teresa', 'Lisbon', 'F', 'lisbon@gmail.com', '66666'),
('C0007', 'Naruto', 'Uzumaki', 'M', 'narutouzumaki@gmail.com', '99999'),
('C0008', 'Kakashi', 'Hatake', 'M', 'kakashi00@gmail.com', '10101');

/*insert suppliers*/
INSERT INTO supplier VALUES
('S0001', 'Lenovo', 'www.lenovo.com', '1800-123-4545', 'lenovo.care@gmail.com'),
('S0002', 'Dell', 'www.dell.com', '1800-123-4569', 'dell.care@gmail.com'),
('S0003', 'Adidas', 'www.adidas.com', '1800-123-4200', 'adidas.care@gmail.com'),
('S0004', 'Puma', 'www.puma.com', '1800-123-4848', 'puma.care@gmail.com'),
('S0005', 'Nike', 'www.nike.com', '1800-123-4343', 'nike.care@gmail.com'),
('S0006', 'Reebok', 'www.reebok.com', '1800-123-4646', 'reebok.care@gmail.com'),
('S0007', 'Apple', 'www.apple.com', '1800-123-4567', 'apple.care@gmail.com');

/*insert categories*/
INSERT INTO category VALUES
('C0001', 'Laptop'),
('C0002', 'Smartphone'),
('C0003', 'Shoes'),
('C0004', 'Clothing');

/*insert address*/
INSERT INTO address VALUES
('C0001-1', 'C0001', '#221B', 'Baker Street', 'London', 'UK'),
('C0002-1', 'C0002', '#215S', 'Madison Ave', 'Pasadena', 'USA'),
('C0003-1', 'C0003', '#1309', 'Cedars Street', 'Malibu', 'USA '),
('C0003-2', 'C0003', '#3600', 'Riverside Blvd', 'Sacramento', 'USA'),
('C0004-1', 'C0004', '#14', 'Street 1', 'Napa', 'USA'),
('C0005-1', 'C0005', '#15', 'Madison Ave', 'Pasadena', 'USA'),
('C0006-1', 'C0006', '#3600', 'Riverside Blvd', 'Sacramento', 'USA'),
('C0007-1', 'C0007', '#02', 'Hokage Residence', 'Konohagakure', 'Japan'),
('C0008-1', 'C0008', '#25', 'Hokage Residence', 'Konohagakure', 'Japan');

/*insert products*/
INSERT INTO product VALUES
('P0001', 'C0001', 'S0001', 'Lenovo IdeaPad 330', 35000, 5, 3.5),
('P0002', 'C0001', 'S0001', 'Lenovo ThinkPad E14', 75000, 10, 4.0),
('P0003', 'C0001', 'S0002', 'Dell Inspiron 15', 40000, 15, 3.8),
('P0004', 'C0001', 'S0002', 'Dell G15 Gaming', 90000, 10, 4.5),
('P0005', 'C0001', 'S0002', 'Dell Latitude 9430', 200000, 5, 4.2),
('P0006', 'C0002', 'S0007', 'iPhone 13', 70000, 25, 4.6),
('P0007', 'C0002', 'S0007', 'iPhone 14', 90000, 25, 4.4),
('P0008', 'C0001', 'S0007', 'MacBook Pro 2022', 150000, 10, 4.8),
('P0009', 'C0003', 'S0005', 'Nike Air Force 1 Mid QS', 13000, 3, 4.0),
('P0010', 'C0003', 'S0005', 'Nike Air Jordan 1 Retro ', 16000, 5, 4.0),
('P0011', 'C0004', 'S0005', 'Nike Pro Dri-FIT Tshirt', 2000, 15, 3.5),
('P0012', 'C0004', 'S0005', 'Nike Dri-FIT Tshirt', 2000, 15, 3.9),
('P0013', 'C0003', 'S0004', 'Puma Redon Move Shoes', 6000, 5, 4.2),
('P0014', 'C0003', 'S0004', 'Puma Electron E Pro Shoes', 4500, 12, 4.4),
('P0015', 'C0004', 'S0003', 'Adidas Gameday Hoodie', 4800, 13, 4.5),
('P0016', 'C0004', 'S0003', 'Adidas TraceRocker Jacket', 5000, 18, 4.6);

/*insert order*/
INSERT INTO orders VALUES
('O0001', 'C0002', 'C0002-1', '2022-08-11', 110000),
('O0002', 'C0005', 'C0005-1', '2022-07-12', 9800),
('O0003', 'C0002', 'C0002-1', '2020-05-14', 22000),
('O0004', 'C0003', 'C0003-1', '2021-06-15', 200000),
('O0005', 'C0003', 'C0003-2', '2022-07-16', 4000),
('O0006', 'C0005', 'C0005-1', '2020-08-17', 8000),
('O0007', 'C0004', 'C0004-1', '2020-04-09', 70000);

/*insert order details*/
INSERT INTO order_product VALUES
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


LOAD DATA INFILE 'C:\\Users\\Abhishek Patil\\Downloads\\orders.csv'
INTO TABLE orders
FIELDS ENCLOSED BY '"'
TERMINATED BY ';'
ESCAPED BY '"'
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:\\Users\\Abhishek Patil\\Downloads\\order_product.csv'
INTO TABLE order_product
FIELDS ENCLOSED BY '"'
TERMINATED BY ';'
ESCAPED BY '"'
LINES TERMINATED BY '\n';