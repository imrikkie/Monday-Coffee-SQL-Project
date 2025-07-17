
-- Monday Coffee -- Data Analysis (MySQL-Compatible)

SELECT * FROM city;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;

-- Q1: Coffee Consumers Count
SELECT 
    city_name,
    ROUND((population * 0.25)/1000000, 2) AS coffee_consumers_in_millions,
    city_rank
FROM city
ORDER BY coffee_consumers_in_millions DESC;

-- Q2: Total Revenue from Coffee Sales in Q4 2023
SELECT 
    SUM(total) AS total_revenue
FROM sales
WHERE 
    YEAR(sale_date) = 2023 AND
    QUARTER(sale_date) = 4;

SELECT 
    ci.city_name,
    SUM(s.total) AS total_revenue
FROM sales AS s
JOIN customers AS c ON s.customer_id = c.customer_id
JOIN city AS ci ON ci.city_id = c.city_id
WHERE 
    YEAR(s.sale_date) = 2023 AND
    QUARTER(s.sale_date) = 4
GROUP BY ci.city_name
ORDER BY total_revenue DESC;

-- Q3: Sales Count for Each Product
SELECT 
    p.product_name,
    COUNT(s.sale_id) AS total_orders
FROM products AS p
LEFT JOIN sales AS s ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC;

-- Q4: Average Sales Amount per Customer per City
SELECT 
    ci.city_name,
    SUM(s.total) AS total_revenue,
    COUNT(DISTINCT s.customer_id) AS total_cx,
    ROUND(SUM(s.total) / COUNT(DISTINCT s.customer_id), 2) AS avg_sale_pr_cx
FROM sales AS s
JOIN customers AS c ON s.customer_id = c.customer_id
JOIN city AS ci ON ci.city_id = c.city_id
GROUP BY ci.city_name
ORDER BY total_revenue DESC;

-- Q5: City Population and Coffee Consumers (25%)
WITH city_table AS (
    SELECT 
        city_name,
        ROUND((population * 0.25)/1000000, 2) AS coffee_consumers
    FROM city
),
customers_table AS (
    SELECT 
        ci.city_name,
        COUNT(DISTINCT c.customer_id) AS unique_cx
    FROM sales AS s
    JOIN customers AS c ON c.customer_id = s.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name
)
SELECT 
    c.city_name,
    ct.coffee_consumers AS coffee_consumer_in_millions,
    c.unique_cx
FROM customers_table AS c
JOIN city_table AS ct ON c.city_name = ct.city_name;

-- Q6: Top 3 Selling Products by City
SELECT * 
FROM (
    SELECT 
        ci.city_name,
        p.product_name,
        COUNT(s.sale_id) AS total_orders,
        DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) AS rank
    FROM sales AS s
    JOIN products AS p ON s.product_id = p.product_id
    JOIN customers AS c ON c.customer_id = s.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name, p.product_name
) AS t1
WHERE rank <= 3;

-- Q7: Unique Customers Who Purchased Coffee Products
SELECT 
    ci.city_name,
    COUNT(DISTINCT c.customer_id) AS unique_cx
FROM city AS ci
LEFT JOIN customers AS c ON c.city_id = ci.city_id
JOIN sales AS s ON s.customer_id = c.customer_id
WHERE s.product_id BETWEEN 1 AND 14
GROUP BY ci.city_name;

-- Q8: Average Sale vs Rent
WITH city_table AS (
    SELECT 
        ci.city_name,
        SUM(s.total) AS total_revenue,
        COUNT(DISTINCT s.customer_id) AS total_cx,
        ROUND(SUM(s.total)/COUNT(DISTINCT s.customer_id), 2) AS avg_sale_pr_cx
    FROM sales AS s
    JOIN customers AS c ON s.customer_id = c.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name
),
city_rent AS (
    SELECT 
        city_name, 
        estimated_rent
    FROM city
)
SELECT 
    cr.city_name,
    cr.estimated_rent,
    ct.total_cx,
    ct.avg_sale_pr_cx,
    ROUND(cr.estimated_rent / ct.total_cx, 2) AS avg_rent_per_cx
FROM city_rent AS cr
JOIN city_table AS ct ON cr.city_name = ct.city_name
ORDER BY ct.avg_sale_pr_cx DESC;

-- Q9: Monthly Sales Growth
WITH monthly_sales AS (
    SELECT 
        ci.city_name,
        MONTH(sale_date) AS month,
        YEAR(sale_date) AS year,
        SUM(s.total) AS total_sale
    FROM sales AS s
    JOIN customers AS c ON c.customer_id = s.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name, MONTH(sale_date), YEAR(sale_date)
),
growth_ratio AS (
    SELECT
        city_name,
        month,
        year,
        total_sale AS cr_month_sale,
        LAG(total_sale) OVER(PARTITION BY city_name ORDER BY year, month) AS last_month_sale
    FROM monthly_sales
)
SELECT
    city_name,
    month,
    year,
    cr_month_sale,
    last_month_sale,
    ROUND(((cr_month_sale - last_month_sale) / last_month_sale) * 100, 2) AS growth_ratio
FROM growth_ratio
WHERE last_month_sale IS NOT NULL;

-- Q10: Market Potential Analysis
WITH city_table AS (
    SELECT 
        ci.city_name,
        SUM(s.total) AS total_revenue,
        COUNT(DISTINCT s.customer_id) AS total_cx,
        ROUND(SUM(s.total)/COUNT(DISTINCT s.customer_id), 2) AS avg_sale_pr_cx
    FROM sales AS s
    JOIN customers AS c ON s.customer_id = c.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name
),
city_rent AS (
    SELECT 
        city_name, 
        estimated_rent,
        ROUND((population * 0.25)/1000000, 3) AS estimated_coffee_consumer_in_millions
    FROM city
)
SELECT 
    cr.city_name,
    ct.total_revenue,
    cr.estimated_rent AS total_rent,
    ct.total_cx,
    cr.estimated_coffee_consumer_in_millions,
    ct.avg_sale_pr_cx,
    ROUND(cr.estimated_rent / ct.total_cx, 2) AS avg_rent_per_cx
FROM city_rent AS cr
JOIN city_table AS ct ON cr.city_name = ct.city_name
ORDER BY ct.total_revenue DESC;
