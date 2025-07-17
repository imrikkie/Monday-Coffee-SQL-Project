
# ☕ Monday Coffee Sales Data Analysis (MySQL)

This project contains a series of SQL queries written for analyzing sales data related to coffee products across various cities. It has been fully adapted for **MySQL** and is structured to provide insights into consumer behavior, revenue trends, and market potential.

---

## 📁 Files Included

- `Monday_Coffee_Analysis_MySQL.sql` – All the queries required for analysis written in MySQL-compatible syntax.
- `README.md` – This documentation file.

---

## 📊 Datasets Overview

The project assumes the existence of the following tables:

1. **city**: Contains city information such as population, estimated rent, and ranking.
2. **products**: List of coffee products.
3. **customers**: Customer information with their associated cities.
4. **sales**: Sales data including customer ID, product ID, total sale amount, and sale date.

---

## 📌 Analysis Objectives

### Q1. Coffee Consumers Count
Estimate how many people in each city consume coffee, based on 25% of the population.

### Q2. Total Revenue from Coffee Sales
Calculate the total revenue from sales made in Q4 of 2023, both overall and city-wise.

### Q3. Sales Count for Each Product
Find how many times each coffee product has been sold.

### Q4. Average Sales per Customer per City
Compute the average sales amount per customer in each city.

### Q5. City Population vs. Coffee Consumers
Compare the estimated number of coffee drinkers with the number of actual customers.

### Q6. Top-Selling Products by City
Identify the top 3 selling coffee products in each city based on order count.

### Q7. Unique Coffee Customers per City
Count unique customers in each city who purchased coffee-related products.

### Q8. Average Sale vs. Rent per Customer
Analyze the relationship between average customer sale and estimated rent per customer.

### Q9. Monthly Sales Growth by City
Calculate the month-on-month sales growth rate for each city.

### Q10. Market Potential Analysis
Identify the top 3 cities based on a mix of total sales, rent cost, customer base, and coffee consumer estimate.

---

## ✅ Requirements

- MySQL 8.0+ (for `LAG()` and `DENSE_RANK()` window functions)
- Pre-loaded tables: `city`, `products`, `customers`, `sales`

---

## 🚀 How to Use

1. Ensure all required tables are present in your MySQL database.
2. Run the SQL script file `Monday_Coffee_Analysis_MySQL.sql` in MySQL Workbench or any MySQL client.
3. Review outputs and use insights for decision-making or reporting.

---

## 🧠 Insights & Recommendations

- Cities with low rent per customer and high revenue should be prioritized for marketing.
- Monthly trends can help in adjusting inventory and campaigns.
- Customer segmentation helps in personalized offerings and retention strategies.

---

## 📬 Contact

For questions or collaborations, feel free to reach out!

---

Happy Analyzing! ☕📈
