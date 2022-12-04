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

DELIMITER $$ 
CREATE FUNCTION total_sales (ProductID VARCHAR(5)) RETURNS INT READS SQL DATA DETERMINISTIC BEGIN DECLARE sale_amount INT;
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
END;$$

/*calling the function*/
SELECT
    product_name,
    total_sales(idproduct) as `Total Sales`
FROM
    product
WHERE
    product.idsupplier = 'S0005';




/*procedure*/

DELIMITER $$
CREATE PROCEDURE display_good_products(
    IN categoryname VARCHAR(45),
    IN rating DOUBLE
) 
BEGIN 
    DECLARE categoryID VARCHAR(5);
    SET categoryID = (
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
END;$$




/*trigger*/

DELIMITER $$ 
CREATE TRIGGER update_product_rating 
BEFORE INSERT
ON `product` FOR EACH ROW 
BEGIN 
    DECLARE error_msg VARCHAR(100);
    SET error_msg = ('New product must have 0 rating');
    IF NEW.product_rating > 0 THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_msg;
    END IF; 
END $$

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
    