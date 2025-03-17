BEGIN;

-- CREATE FUNCTION add_numbers(a INT, b INT) RETURNS INT AS $$
-- BEGIN
-- RETURN a + b;
-- END;
-- $$ LANGUAGE plpgsql;


SELECT plan(x); -- Replace x with a number of assertions
-- Test function add_numbers exists
-- Test a few sum cases
SELECT * FROM finish();

ROLLBACK;