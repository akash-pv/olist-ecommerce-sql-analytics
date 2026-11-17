# Brazilian E-Commerce Sales & Customer Analytics using MySQL

## Project Overview

This project analyses the Brazilian E-Commerce Public Dataset by Olist using MySQL 8.0.

The objective is to evaluate e-commerce sales performance, customer purchasing behaviour, product category performance, seller revenue, payment patterns, customer reviews, and delivery operations.

The project uses SQL to investigate business questions, identify trends, and develop recommendations that support data-driven decisions.

## Business Objectives

- Analyse sales revenue and freight performance.
- Identify top-performing product categories and products.
- Understand customer spending and repeat purchasing behaviour.
- Evaluate seller revenue performance.
- Compare average order value across customer cities.
- Analyse payment methods and payment values.
- Monitor monthly revenue trends.
- Investigate customer satisfaction and delivery performance.

## Dataset

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Source:** [Kaggle – Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Dataset period:** 2016–2018 (data ends on 17 October 2018).

The dataset contains information about customers, orders, order items, payments, products, sellers, reviews, and product categories.

### Database Tables

| Table | Records |
|---|---:|
| customers | 99,441 |
| orders | 99,441 |
| order_items | 112,650 |
| payments | 103,886 |
| products | 32,951 |
| sellers | 3,095 |
| reviews | 99,224 |
| category_translation | 71 |

## Tools & Technologies

- MySQL 8.0
- MySQL Workbench
- SQL
- GitHub

## SQL Analysis

The project contains 21 business questions organised into four sections.

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
- Q07: Identify product categories with the highest units sold.
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

## Key Business Findings

The following findings were calculated from the uploaded Olist dataset.

### Sales Performance

| Metric | Result |
|---|---:|
| Delivered item revenue | R$13,221,498.11 |
| Freight value | R$2,198,275.64 |
| Payments received on delivered orders | R$15,422,461.77 |

Payment totals are not assumed to equal item revenue plus freight exactly.

### Product Performance

- Bed, Bath & Table was the highest-selling category by units, with **10,953 units sold**.
- Health & Beauty generated the highest item revenue, approximately **R$1.23 million**.
- Watches & Gifts generated approximately **R$1.17 million** in item revenue.

### Customer Analysis

- The five highest-spending customers were identified using `customer_unique_id`.
- **252 customers** placed more than two orders.
- The average delivered item spend per customer was approximately **R$141.62**.

### Geographic Sales Performance

- São Paulo generated the highest delivered item sales, approximately **R$1.86 million**.
- Rio de Janeiro ranked second, generating approximately **R$955,573.97**.

### Seller Performance

- **282 sellers** generated more than R$10,000 in delivered item revenue.
- The highest-revenue seller generated approximately **R$226,987.93**.

### Customer Satisfaction

- Office Furniture had the lowest average review score among categories with at least 100 reviews, at approximately **3.65 out of 5**.

### Delivery Performance

| Metric | Result |
|---|---:|
| Delivered orders with both delivery dates available | 96,470 |
| Late deliveries | 7,826 |
| Late delivery rate | 8.1% |
| Average delivery time | 12.1 days |

### Operational Finding

A total of **775 orders** had no matching order items:

- Unavailable: 603
- Canceled: 164
- Created: 5
- Invoiced: 2
- Shipped: 1

This demonstrates why order status and order-item records should be considered when analysing sales.

## Business Recommendations

Based on the findings:

1. **Sales optimisation:** Prioritise inventory and promotional planning for high-volume categories such as Bed, Bath & Table.
2. **Revenue growth:** Investigate the strong revenue contribution from Health & Beauty and Watches & Gifts.
3. **Customer retention:** Develop loyalty campaigns for repeat and high-value customers.
4. **Seller management:** Study the performance of high-revenue sellers to identify practices that can be shared with other sellers.
5. **Customer satisfaction:** Investigate the causes of lower Office Furniture review scores and identify opportunities to improve product and service quality.
6. **Delivery improvement:** Investigate late deliveries and identify opportunities to improve logistics and estimated delivery accuracy.
7. **Order monitoring:** Monitor canceled and unavailable orders separately from completed sales.

## Important Analysis Assumptions

- Revenue is calculated using item price from delivered orders.
- Freight value is reported separately from item revenue.
- Customer identity is analysed using `customer_unique_id`, because `customer_id` is associated with individual orders.
- The dataset does not provide a customer signup date. First recorded order date is used as a proxy where required.
- Delivery performance excludes delivered orders with missing actual or estimated delivery dates.
- The dataset is historical and ends on 17 October 2018. Results should not be interpreted as current market performance.

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

## Author

**Akash PV**

GitHub: [akash-pv](https://github.com/akash-pv)

---

