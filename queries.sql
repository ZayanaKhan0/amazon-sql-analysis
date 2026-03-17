CREATE DATABASE amazon_analysis;

USE amazon_analysis;

CREATE TABLE amazon_products (
product_id TEXT,
product_name TEXT,
category TEXT,
discounted_price TEXT,
actual_price TEXT,
discount_percentage TEXT,
rating TEXT,
rating_count TEXT
);

SELECT * FROM amazon_products
LIMIT 10;

--Which products generate the highest revenue?
SELECT 
product_name,
SUM(discounted_price * rating_count) AS estimated_revenue
FROM amazon_products
GROUP BY product_name
ORDER BY estimated_revenue DESC
LIMIT 10;

--Which products have the highest number of reviews?
SELECT 
product_name,
rating_count
FROM amazon_products
ORDER BY rating_count DESC
LIMIT 10;

--Which product categories generate the highest estimated revenue?
SELECT 
category,
SUM(discounted_price * rating_count) AS total_revenue
FROM amazon_products
GROUP BY category
ORDER BY total_revenue DESC;

--Which products have high ratings but low review counts?
SELECT 
product_name,
rating,
rating_count
FROM amazon_products
WHERE rating >= 4.5
AND rating_count < 100
ORDER BY rating DESC;

--Do higher discounts affect product ratings?
SELECT 
discount_percentage,
AVG(rating) AS avg_rating
FROM amazon_products
GROUP BY discount_percentage
ORDER BY discount_percentage;

--What are the top 5 highest rated products in each category?
SELECT *
FROM (
    SELECT 
    product_name,
    category,
    rating,
    ROW_NUMBER() OVER(PARTITION BY category ORDER BY rating DESC) AS rank_in_category
    FROM amazon_products
) ranked
WHERE rank_in_category <= 5;

--How are products distributed across price ranges?
SELECT 
CASE
WHEN discounted_price < 500 THEN 'Budget'
WHEN discounted_price BETWEEN 500 AND 2000 THEN 'Mid Range'
ELSE 'Premium'
END AS price_range,

COUNT(*) AS total_products
FROM amazon_products
GROUP BY price_range;

--Which products have high discounts but poor ratings?
SELECT 
product_name,
discount_percentage,
rating
FROM amazon_products
WHERE discount_percentage > 50
AND rating < 3.5
ORDER BY discount_percentage DESC;

--Do expensive products tend to have higher ratings?
SELECT 
CASE
WHEN actual_price < 500 THEN 'Low Price'
WHEN actual_price BETWEEN 500 AND 2000 THEN 'Medium Price'
ELSE 'High Price'
END AS price_category,

AVG(rating) AS avg_rating
FROM amazon_products
GROUP BY price_category;

--Which products have both high ratings and a large number of reviews?
SELECT 
product_name,
rating,
rating_count
FROM amazon_products
WHERE rating >= 4.5
AND rating_count > 5000
ORDER BY rating DESC, rating_count DESC;

