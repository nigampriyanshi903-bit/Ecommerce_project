#task1:Total number of customers per state
SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;
#task2:Total number of customers per city
SELECT customer_city, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;
#task3:Customer distribution by zip code prefix
SELECT customer_zip_code_prefix, COUNT(*) AS num_customers
FROM customers
GROUP BY customer_zip_code_prefix
ORDER BY num_customers DESC
LIMIT 10;
#task4:Average number of customers per city
SELECT customer_state, AVG(customer_count) AS avg_customers_per_city
FROM (
    SELECT customer_state, customer_city, COUNT(*) AS customer_count
    FROM customers
    GROUP BY customer_state, customer_city
) AS city_counts
GROUP BY customer_state
ORDER BY avg_customers_per_city DESC;
#task5:Geolocation (latitude, longitude) per zip code
SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng
FROM geolocation
ORDER BY geolocation_zip_code_prefix
LIMIT 10;
#task6:Number of customers mapped with geolocation
SELECT c.customer_state, COUNT(*) AS num_customers
FROM customers c
JOIN geolocation g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY c.customer_state
ORDER BY num_customers DESC;

#task7:Top 10 cities with maximum customers
SELECT customer_city, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;
#task8:Top 10 zip codes with maximum customers
SELECT customer_zip_code_prefix, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_zip_code_prefix
ORDER BY total_customers DESC
LIMIT 10;
#task9:States with maximum geolocation points
SELECT geolocation_state, COUNT(*) AS num_points
FROM geolocation
GROUP BY geolocation_state
ORDER BY num_points DESC;
#task10:Average latitude and longitude per state
SELECT geolocation_state, AVG(geolocation_lat) AS avg_lat, AVG(geolocation_lng) AS avg_lng
FROM geolocation
GROUP BY geolocation_state
ORDER BY geolocation_state;
#task11:Total orders per order status
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
#task12:Total orders per state
SELECT c.customer_state, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;
#task13:Orders per city
SELECT c.customer_city, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC
LIMIT 10;
#Orders per day (daily trend)
SELECT DATE(order_purchase_timestamp) AS order_date, COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date;
#Orders per month
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;
#Average delivery time (in days) per state
SELECT c.customer_state, AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days;
#task17:Orders delayed beyond estimated delivery date
SELECT COUNT(*) AS delayed_orders
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;

#task18:Top 10 customers by number of orders
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

#Average number of orders per customer
SELECT AVG(order_count) AS avg_orders_per_customer
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) AS customer_orders;
#task20:Orders approved vs pending vs delivered ratio
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;
#task21:Total revenue per payment type
SELECT payment_type, SUM(payment_value) AS total_revenue
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;
#task22:Average payment value per payment type
SELECT payment_type, AVG(payment_value) AS avg_payment
FROM payments
GROUP BY payment_type
ORDER BY avg_payment DESC;

#task23:Total revenue per order
SELECT order_id, SUM(payment_value) AS total_order_value
FROM payments
GROUP BY order_id
ORDER BY total_order_value DESC
LIMIT 10;
#Total revenue per customer
SELECT o.customer_id, SUM(p.payment_value) AS total_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;
#25Average revenue per customer
SELECT AVG(total_revenue) AS avg_revenue_per_customer
FROM (
    SELECT o.customer_id, SUM(p.payment_value) AS total_revenue
    FROM payments p
    JOIN orders o ON p.order_id = o.order_id
    GROUP BY o.customer_id
) AS customer_revenue;

#26:Total revenue per state
SELECT c.customer_state, SUM(p.payment_value) AS total_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
#27:Total revenue per city
SELECT c.customer_city, SUM(p.payment_value) AS total_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_revenue DESC
LIMIT 10;
#28:Revenue per month
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month, SUM(p.payment_value) AS monthly_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
GROUP BY month
ORDER BY month;
#29:Revenue per day of week
SELECT DAYNAME(order_purchase_timestamp) AS day_of_week, SUM(p.payment_value) AS revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
#30:Total revenue per number of installments
SELECT payment_installments, SUM(payment_value) AS total_revenue
FROM payments
GROUP BY payment_installments
ORDER BY total_revenue DESC;
#Product & Category Analysis
#31:Total number of products per category
SELECT product_category_name, COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC;
#32:Average product weight per category
SELECT product_category_name, AVG(product_weight_g) AS avg_weight_g
FROM products
GROUP BY product_category_name
ORDER BY avg_weight_g DESC;
#33:Average product dimensions per category (length x height x width)
SELECT product_category_name,
       AVG(product_length_cm) AS avg_length,
       AVG(product_height_cm) AS avg_height,
       AVG(product_width_cm) AS avg_width
FROM products
GROUP BY product_category_name
ORDER BY product_category_name;
#34:Top 10 products by total sales quantity
SELECT p.product_id, SUM(oi.price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sales DESC
LIMIT 10;
#35:Total revenue per product category
SELECT p.product_category_name, SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;

#36:Total number of products sold per category
SELECT p.product_category_name, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_quantity_sold DESC;

#37:Average sales price per product category
SELECT p.product_category_name, AVG(oi.price) AS avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC;
#38:Top 10 products by number of orders
SELECT oi.product_id, COUNT(DISTINCT oi.order_id) AS num_orders
FROM order_items oi
GROUP BY oi.product_id
ORDER BY num_orders DESC
LIMIT 10;
#39:Total revenue per seller
SELECT s.seller_id, SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;
#40:Total quantity sold per seller
SELECT s.seller_id, SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_quantity DESC
LIMIT 10;

#41:Average review score per product
SELECT oi.product_id, AVG(r.review_score) AS avg_review_score
FROM reviews r
JOIN order_items oi ON r.order_id = oi.order_id
GROUP BY oi.product_id
ORDER BY avg_review_score DESC
LIMIT 10;

#42:Average review score per product category
SELECT p.product_category_name, AVG(r.review_score) AS avg_review_score
FROM reviews r
JOIN order_items oi ON r.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_review_score DESC;

#43:Total number of reviews per product category
SELECT p.product_category_name, COUNT(r.review_id) AS total_reviews
FROM reviews r
JOIN order_items oi ON r.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_reviews DESC;

#44:Average review score per customer
SELECT o.customer_id, AVG(r.review_score) AS avg_review_score
FROM reviews r
JOIN orders o ON r.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY avg_review_score DESC
LIMIT 10;

#45:Number of reviews per customer
SELECT o.customer_id, COUNT(r.review_id) AS total_reviews
FROM reviews r
JOIN orders o ON r.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY total_reviews DESC
LIMIT 10;

#46:Orders with review score 5 (positive feedback)
SELECT COUNT(*) AS positive_feedback_orders
FROM reviews
WHERE review_score = 5;

#47:Orders with review score 1 (negative feedback)
SELECT COUNT(*) AS negative_feedback_orders
FROM reviews
WHERE review_score = 1;

#48:Average review score per state
SELECT c.customer_state, AVG(r.review_score) AS avg_review_score
FROM reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_review_score DESC;

#49:Average review score per city
SELECT c.customer_city, AVG(r.review_score) AS avg_review_score
FROM reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY avg_review_score DESC
LIMIT 10;

#50:Average review score per seller
SELECT s.seller_id, AVG(r.review_score) AS avg_review_score
FROM reviews r
JOIN order_items oi ON r.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY avg_review_score DESC
LIMIT 10;



