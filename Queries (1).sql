use rareBeauty;

-- creating a view showing the total number of purchases for each category 
  
DROP VIEW IF EXISTS category_order_counts;
CREATE VIEW category_order_counts AS
SELECT c.category_name, COUNT(od.order_id) AS total_orders
FROM categories c
JOIN products p ON c.category_name = p.category_name
JOIN orderdetails_online od ON p.product_id = od.product_id
GROUP BY c.category_name;

-- showing the content of the view 
SELECT * 
FROM category_order_counts
ORDER BY total_orders DESC;

-- QUERY N1
-- using the view, finding those category(ies) that has the maximum selling 
SELECT category_name, total_orders
FROM category_order_counts
WHERE total_orders = (
    SELECT MAX(total_orders)
    FROM category_order_counts
); 

-- QUERY N2
-- products having no shades or sizes
select p.product_id, p.product_name,p.category_name
from products p 
where p.product_id in(select s.product_id
from shades s
where s.shade_name = 'NA');

-- QUERY N3
-- customers who havent placed any orders 
SELECT c.*
FROM customers c LEFT JOIN orders_online o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- QUERY N4
-- customers who have placed multiple orders 
SELECT c.customer_id, c.customer_firstname,c.customer_lastname, multiple.quantity
FROM customers c
JOIN (
    SELECT o.customer_id, COUNT(DISTINCT o.order_id) as quantity
    FROM orders_online o 
    GROUP BY customer_id
    HAVING (quantity) > 1
) AS multiple ON c.customer_id = multiple.customer_id;

-- QUERY N5
-- Top 3 suppliers which products had the highest average rating among the customers
SELECT s.supplier_id, s.supplier_name, AVG(p.rating) AS average_rating
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id
ORDER BY average_rating DESC
LIMIT 3;

-- QUERY N6
-- Finding the information about the branches that have any shade of the product 'Liquid Touch Weightless Foundation'
SELECT d.distributor_name, b.branch_id, bp.shade_name
FROM branches b
JOIN branchproducts bp ON b.branch_id = bp.branch_id
JOIN products p ON bp.product_id = p.product_id
JOIN distributors d ON b.distributor_name = d.distributor_name
WHERE p.product_name = 'Liquid Touch Weightless Foundation';


-- QUERY N7
-- Finding the total revenue from physical orders for each branch
SELECT d.distributor_name, b.branch_id, SUM(p.price * od.quantity_ordered) AS total_revenue
FROM branches b
JOIN orders_physical o ON b.branch_id = o.branch_id
JOIN orderdetails_physical od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN distributors d ON b.distributor_name = d.distributor_name
GROUP BY  b.branch_id;

-- QUERY N8
-- Finding the customers who haven't placed any orders for the past month or at all
SELECT c.customer_id, c.customer_firstname, c.customer_lastname
FROM customers c
LEFT JOIN orders_online o ON c.customer_id = o.customer_id
WHERE o.order_date IS NULL OR o.order_date < DATE_SUB(CURDATE(), INTERVAL 1 MONTH);


-- QUERY N9
-- Finding the top 10 best selling products according to both online and physical orders
SELECT p.product_name, SUM(od.quantity_ordered) as total_quantity
FROM (
    SELECT product_id, quantity_ordered
    FROM orderdetails_online
    UNION ALL
    SELECT op.product_id, op.quantity_ordered
    FROM orderdetails_physical op
    JOIN orders_physical o ON o.order_id = op.order_id
) od
JOIN products p ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY total_quantity DESC
LIMIT 10;

-- QUERY N10
-- Finding the customers who had purchase in every category
-- The output is pretty much self-explanatory :D

SELECT c.customer_id, c.customer_firstname, c.customer_lastname
FROM customers c
WHERE NOT EXISTS (
    SELECT category_name
    FROM categories
    WHERE category_name NOT IN (
        SELECT DISTINCT p.category_name
        FROM products p
        JOIN orderdetails_online od ON p.product_id = od.product_id
        JOIN orders_online o ON od.order_id = o.order_id
        WHERE o.customer_id = c.customer_id
    )
);

