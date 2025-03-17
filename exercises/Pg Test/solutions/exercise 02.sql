BEGIN;

CREATE FUNCTION add_numbers(a INT, b INT) RETURNS INT AS $$
BEGIN
RETURN a + b;
END;
$$ LANGUAGE plpgsql;


SELECT plan(2);
SELECT has_function('add_numbers', 'Function add_numbers should exist');
SELECT results_eq('SELECT add_numbers(2, 3)', 'SELECT 5', '2 + 3 should be 5');
SELECT * FROM finish();

ROLLBACK;