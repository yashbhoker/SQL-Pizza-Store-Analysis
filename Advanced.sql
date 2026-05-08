-- Q21. Find the second highest priced pizza.
SELECT DISTINCT
    pizza_id,
    pizza_type_id,
    size_,
    price
FROM pizzas
ORDER BY price DESC
LIMIT 1 OFFSET 1;

-- Q22. Find the category that generated the highest revenue.
SELECT
    pt.category,
    SUM(p.price * od.quantity) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC
LIMIT 1;

-- Q23. Find the most ordered pizza in each category.
SELECT
    category,
    pizza_id,
    total_qty
FROM (
    SELECT
        pt.category,
        od.pizza_id,
        SUM(od.quantity) AS total_qty,
        RANK() OVER (
            PARTITION BY pt.category
            ORDER BY SUM(od.quantity) DESC
        ) AS rnk
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, od.pizza_id
) ranked
WHERE rnk = 1;

-- Q24. Find orders that contain more than one type of pizza.
SELECT
    od.order_id,
    COUNT(DISTINCT p.pizza_type_id) AS type_count
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
HAVING COUNT(DISTINCT p.pizza_type_id) > 1;
-- 25. Show cumulative revenue over time.
SELECT
    o.date_,
    SUM(p.price * od.quantity) AS daily_revenue,
    SUM(SUM(p.price * od.quantity)) OVER (ORDER BY o.date_) AS running_total
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date_
ORDER BY o.date_;

-- 26. Use a Common Table Expression to calculate daily revenue and display it.
WITH daily_revenue AS (
    SELECT
        o.date_,
        SUM(p.price * od.quantity) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY o.date_
)
SELECT
    date_,
    revenue
FROM daily_revenue
ORDER BY date_;

-- 27. Find the top 3 pizzas generating highest revenue using a CTE.
WITH pizza_revenue AS (
    SELECT
        od.pizza_id,
        SUM(p.price * od.quantity) AS revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY od.pizza_id
)
SELECT
    pizza_id,
    revenue
FROM pizza_revenue
ORDER BY revenue DESC
LIMIT 3;

-- 28. Rank pizzas based on revenue from highest to lowest using CTE.
WITH pizza_revenue AS (
    SELECT
        od.pizza_id,
        SUM(p.price * od.quantity) AS revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY od.pizza_id
)
SELECT
    pizza_id,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM pizza_revenue
ORDER BY revenue_rank;

-- 29. Calculate average revenue per order using a CTE.
WITH order_revenue AS (
    SELECT
        od.order_id,
        SUM(p.price * od.quantity) AS order_total
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
)
SELECT
    ROUND(AVG(order_total)::NUMERIC, 2) AS avg_order_value
FROM order_revenue;
-- 30. Find percentage contribution of each category in total revenue using CTE.
WITH cat_revenue AS (
    SELECT
        pt.category,
        SUM(p.price * od.quantity) AS revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category
),
total_revenue AS (
    SELECT
        SUM(revenue) AS grand_total
    FROM cat_revenue
)
SELECT
    c.category,
    ROUND(c.revenue::NUMERIC, 2) AS revenue,
    ROUND((c.revenue * 100.0 / t.grand_total)::NUMERIC, 2) AS contribution_pct
FROM cat_revenue c
CROSS JOIN total_revenue t
ORDER BY contribution_pct DESC;