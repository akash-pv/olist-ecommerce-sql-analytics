# Brazilian E-Commerce Sales & Customer Analytics using MySQL

## Project Overview

This project analyses the Brazilian E-Commerce Public Dataset by Olist using MySQL 8.0.

The objective is to explore e-commerce sales performance, customer purchasing behaviour, product category performance, seller revenue, payment patterns, customer reviews, and delivery performance.

The analysis uses SQL queries to identify business trends, investigate operational issues, and generate insights that can support data-driven business decisions.

## Business Objectives

- Analyse overall sales revenue and freight performance.
- Identify top-performing product categories and products.
- Understand customer spending and repeat purchasing behaviour.
- Evaluate seller revenue performance.
- Compare average order value across customer cities.
- Analyse payment methods and payment values.
- Monitor monthly revenue trends.
- Identify customer review and delivery performance issues.

## Dataset

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Source:** [Kaggle – Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains information about customers, orders, order items, payments, products, sellers, reviews, and product categories.

**Dataset period:** 2016–2018 (data ends on 17 October 2018).

## Tools & Technologies

- MySQL 8.0
- MySQL Workbench
- SQL
- GitHub

## Database Tables

| Table | Description |
|---|---|
| customers | Customer information and location |
| orders | Order details and order status |
| order_items | Products purchased in each order |
| payments | Payment methods and payment values |
| products | Product information |
| sellers | Seller information and location |
| reviews | Customer review scores |
| category_translation | Portuguese-to-English category names |

## Analysis & SQL Concepts

The project contains 21 business questions organised into four levels.

### 1. Beginner Analysis (Q01–Q05)

SQL concepts: SELECT, WHERE, ORDER BY, LIMIT, aggregate functions.

- Q01: List customers from a specific city.
- Q02: Identify orders placed in the last 30 days of the dataset.
- Q03: Find the 10 most expensive products.
- Q04: Retrieve delivered orders and calculate their total count.
- Q05: Identify customers whose first recorded order was in 2017.

### 2. Intermediate Analysis (Q06–Q11)

SQL concepts: JOIN, GROUP BY, HAVING, aggregate functions, subqueries.

- Q06: Calculate total revenue and freight from delivered orders.
- Q07: Identify the product categories with the highest units sold.
- Q08: Find the top five customers by total spending.
- Q09: Identify sellers generating more than R$10,000 in revenue.
- Q10: Calculate average order value by customer city.
- Q11: Analyse order counts and average payment values by payment type.

### 3. Advanced SQL Analysis (Q12–Q16)

SQL concepts: CTEs, window functions, subqueries, views, stored procedures.

- Q12: Rank products by revenue within each category.
- Q13: Identify customers spending more than the average customer.
- Q14: Identify repeat customers with more than two orders.
- Q15: Create a monthly sales summary view.
- Q16: Create a stored procedure to retrieve a customer's order history.

### 4. Additional Business Analysis (Q17–Q21)

- Q17: Identify customer cities generating the highest delivered item sales.
- Q18: Investigate orders without matching order items.
- Q19: Analyse month-over-month revenue growth using LAG().
- Q20: Identify product categories with the lowest customer review scores.
- Q21: Calculate late delivery percentage and average delivery days.

## Business Metrics

The analysis focuses on the following metrics:

| Metric | Purpose |
|---|---|
| Total Revenue | Measure delivered item sales |
| Total Freight | Understand shipping charges |
| Units Sold | Measure product category demand |
| Average Order Value | Evaluate order spending |
| Repeat Customers | Understand customer retention |
| Monthly Revenue Growth | Monitor sales trends |
| Average Review Score | Evaluate customer satisfaction |
| Late Delivery Percentage | Monitor delivery performance |

## Key Findings

*To be updated after executing and validating the SQL queries.*

- Total delivered revenue: [Add result]
- Top-performing product category: [Add result]
- Highest-revenue seller: [Add result]
- Average order value: [Add result]
- Repeat customer findings: [Add result]
- Month-over-month revenue trend: [Add result]
- Late delivery percentage: [Add result]

## Business Recommendations

Recommendations will be finalised based on the actual query results. Areas to investigate include:

1. **Sales optimisation:** Prioritise high-performing categories and products.
2. **Customer retention:** Develop targeted loyalty campaigns for repeat and high-value customers.
3. **Seller performance:** Identify high-performing sellers and investigate opportunities to improve weaker seller performance.
4. **Delivery improvement:** Investigate late deliveries and identify opportunities to improve logistics.
5. **Customer satisfaction:** Review categories with lower customer ratings and investigate potential product or service issues.

## Repository Structure

```text
olist-ecommerce-sql-analytics/
│
├── queries/
│   ├── 01_beginner_queries.sql
│   ├── 02_intermediate_queries.sql
│   ├── 03_advanced_queries.sql
│   └── 04_business_analysis_queries.sql
│
├── screenshots/
├── er-diagram/
├── README.md
└── dataset_source.md
```

## Important Analysis Assumptions

- Revenue is calculated using item price from delivered orders.
- Freight value is reported separately from item revenue.
- Customer identity is analysed using `customer_unique_id`, because `customer_id` is associated with individual orders.
- The dataset does not provide a customer signup date. First recorded order date is used as a proxy where required.
- The dataset is historical and ends on 17 October 2018. Results should not be interpreted as current market performance.

## Author

**Akash PV**

GitHub: [akash-pv](https://github.com/akash-pv)

---

*This project demonstrates practical SQL skills, relational data analysis, business problem-solving, and data-driven decision-making using a real-world e-commerce dataset.*
