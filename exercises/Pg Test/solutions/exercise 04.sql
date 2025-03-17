BEGIN;

CREATE TEMPORARY TABLE sales (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    amount DECIMAL(10, 2)
);

INSERT INTO sales (customer_id, product_id, sale_date, amount)
SELECT
    (RANDOM() * 10000)::INT,
    (RANDOM() * 1000)::INT,
    NOW() - (((RANDOM() * 365 * 5)::INT) ||' days')::INTERVAL,
    ROUND((RANDOM() * 1000)::numeric, 2)
FROM generate_series(1, 1000000);

-- CREATE INDEX idx_sales_date ON sales(sale_date);

SELECT plan(1); -- Replace x with a number of assertions
-- Test select under 15 milliseconds: SELECT * FROM sales WHERE sale_date = CURRENT_DATE - INTERVAL '30 days'
SELECT performs_within(
               'SELECT * FROM sales WHERE sale_date = CURRENT_DATE - INTERVAL ''30 days''',
               5,
               15,
               'Query should perform within 3-15ms'
       );

SELECT * FROM finish();

ROLLBACK;