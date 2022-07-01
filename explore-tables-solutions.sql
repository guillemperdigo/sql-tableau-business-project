/*
GOAL: solve questions of "Explore the tables" section
DESCRIPTION: 
	Provide a simple solution for the questions on the section "Explore the tables"
    https://platform.wbscodingschool.com/courses/data-science/8738/
*/
USE magist;
-- How many orders are there in the dataset?
SELECT 
    COUNT(*) AS orders_count
FROM
    orders;

/* Are orders actually delivered?

 Look at columns in the orders table: one of them is called order_status.
 Most orders seem to be delivered, but some aren't. 
 Find out how many orders are delivered and how many are cancelled, 
 unavailable or in any other status by selecting a count and aggregating by this column. 

*/

SELECT 
    order_status, 
    COUNT(*) AS orders
FROM
    orders
GROUP BY order_status;

/*
Is Magist having user growth? 
A platform losing users left and right isn’t going to be very useful to us. 
It would be a good idea to check for number of orders grouped by year and month. 
Tip: you can use the functions YEAR() and MONTH() 
to separate the year and the month of the order_purchase_timestamp.
*/

SELECT 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ , month_;


-- How many different products are in the products table?
SELECT COUNT( DISTINCT product_id) AS products_count
FROM products;

/*
How many products are there in the products table? 

(By “different” here we mean “unique”, 
so you should make sure that there are no duplicate products.)
*/
SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;



/* Which are the categories with most products? 

Since this is an external database and has been partially anonymised, 
we do not have the names of the products. But we do know to which categories 
do products belong. This is the closest we can get to knowing what are sellers 
offering in the Magist marketplace. By counting the rows in the products table 
and grouping them by categories, we will know how many products per category
exist in Magist's catalog. Note that this is not the same as knowing how many 
products are actually sold (we would have to combine multiple tables to find this, 
which we will do in the next lesson).

*/
SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS n_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

/*
How many of those products were present in actual transactions?
 
The products table is the catalog of all the available products. 
Have all these products been involved in orders? 
Check out the order_items table to find out!
*/

SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;


-- What’s the price for the most expensive and cheapest products?
-- Check the option for MIN() and MAX()
-- simple solution:
SELECT 
    MIN(price) AS cheapest, 
    MAX(price) AS most_expensive
FROM 
	order_items;

SELECT 
	product_id,
    MIN(AVG(price)) AS avg_price
FROM order_items
GROUP BY product_id;

-- fancy solution:
(SELECT product_id, AVG(price) AS avg_price
FROM order_items
GROUP BY product_id
ORDER BY AVG(price)
LIMIT 1)
UNION
(SELECT product_id, AVG(price) AS avg_price
FROM order_items
GROUP BY product_id
ORDER BY AVG(price) DESC
LIMIT 1);

-- What are the highest and lowest payment values?
-- SELECT * FROM order_payments

SELECT 
	MAX(payment_value) as highest,
    MIN(payment_value) as lowest
FROM
	order_payments;

(SELECT order_id, AVG(payment_value) AS min_payment_value
FROM order_payments
GROUP BY order_id
ORDER BY AVG(payment_value) DESC
LIMIT 1)
UNION
(SELECT order_id, AVG(payment_value) AS min_payment_value
FROM order_payments
GROUP BY order_id
ORDER BY AVG(payment_value)
LIMIT 1);