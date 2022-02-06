CREATE database online_auction;
use online_auction;
Create table cities(
ID INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(40) NOT NULL,
country_name VARCHAR(50) NOT NULL
);

Create table persons(
ID INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
middle_name VARCHAR(20),
last_name VARCHAR(50) NOT NULL,
birth_date Datetime NOT NULL,
city_id INT(11) UNSIGNED NOT NULL,
FOREIGN KEY (city_id) REFERENCES cities(ID)
);

Create table product_types(
ID INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(30) NOT NULL UNIQUE KEY
);

Create table products(
ID INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
description TEXT,
start_bid_price DECIMAL(15,2) NOT NULL,
sold_on DATETIME,
owner_id INT(11) UNSIGNED NOT NULL,
sold_city_id INT(11) UNSIGNED,
product_type_id INT(11) UNSIGNED NOT NULL,
FOREIGN KEY (owner_id) REFERENCES persons(ID),
FOREIGN KEY (sold_city_id) REFERENCES cities(ID),
FOREIGN KEY (product_type_id) REFERENCES product_types(ID)
);

Create table bids(
product_id INT(11) UNSIGNED NOT NULL,
person_id INT(11) UNSIGNED NOT NULL,
amount DECIMAL(15,2) NOT NULL,
date DATETIME NOT NULL,
FOREIGN KEY (person_id) REFERENCES persons(ID),
FOREIGN KEY (product_id) REFERENCES products(ID)
);

#Import the code from file dataset.txt
#...
#Queries 
#1
SELECT id, Concat_ws(' ',first_name, last_name) AS full_name,
YEAR(birth_date) AS birth_year FROM persons 
WHERE city_id=42 AND YEAR(birth_date)>1970 
ORDER BY YEAR(birth_date) ,  full_name;

#2
SELECT products.ID, name AS product_name, start_bid_price , first_name AS product_type 
FROM products JOIN product_types ON products.product_type_id=product_types.id 
WHERE sold_on IS NULL  AND first_name='antiques' 
ORDER BY start_bid_price DESC;

#3
SELECT products.ID, products.name AS product_name, persons.first_name, persons.last_name, cities.name AS city_name, cities.country_name 
FROM products JOIN persons ON products.owner_id=persons.ID JOIN cities ON products.sold_city_id=cities.ID 
WHERE persons.first_name LIKE 'Britni' AND country_name LIKE 'Germany' 
ORDER BY products.ID;

#4
SELECT persons.ID, persons.first_name, persons.last_name, cities.name , Count(products.ID) AS product_count 
FROM persons JOIN cities ON persons.city_id=cities.id 
JOIN products ON persons.ID=products.owner_id 
GROUP BY persons.ID ORDER BY product_count DESC, persons.first_name LIMIT 10;

#5
SELECT p.name AS products_name, c.name AS city_name ,
Count(p.name) AS bids_count, Max(b.amount) AS max_amount, Min(b.amount) AS min_amount 
FROM products as p INNER JOIN cities AS c 
ON p.sold_city_id=c.id 
INNER JOIN bids as b 
ON p.id=b.product_id 
WHERE c.country_name='Bulgaria' 
GROUP BY p.id 
ORDER BY bids_count DESC 
LIMIT 5;

#6
SELECT p.id, p.first_name, Max(b.amount) AS highest_bid , Min(b.amount) AS lowest_bid 
FROM persons AS p JOIN bids AS b 
ON p.id=b.person_id 
GROUP BY p.ID 
HAVING lowest_bid>30000 
ORDER BY highest_bid DESC;

#7
SELECT pt.first_name AS product_type , c.name AS city_name, Count(p.id) AS product_count 
FROM product_types AS pt JOIN products AS p 
ON pt.id=p.product_type_id 
JOIN cities AS c 
ON p.sold_city_id=c.id 
GROUP BY product_type, city_name 
ORDER BY product_count DESC, city_name 
LIMIT 10;

