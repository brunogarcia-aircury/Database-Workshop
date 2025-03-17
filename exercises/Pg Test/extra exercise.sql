-- Exercise 1:
-- In this  exercise we are going to create a function using TDD, the function translate a user friendly text into a
-- combination of start and end timestamptz fields.

-- Test

ROLLBACK;
BEGIN;

SELECT plan(3);

-- Complete to test:
-- - On date_format_approach_1('yesterday') we expect to get a record with the dates from yesterday at 00:00:00 to 23:59:59.
-- - On date_format_approach_1('last hour') we expect to get a record with the the current date less one hour and the current date.
-- - On date_format_approach_1('last 2 hours') we expect to get a record with the the current date less two hours and the current date.

SELECT * FROM finish(true);

ROLLBACK;

-- FUNCTION

CREATE OR REPLACE FUNCTION date_format_approach_1(text) RETURNS RECORD AS $$
DECLARE
    -- Declare your helper variables
BEGIN
    -- Complete
END;
$$ LANGUAGE plpgsql;

