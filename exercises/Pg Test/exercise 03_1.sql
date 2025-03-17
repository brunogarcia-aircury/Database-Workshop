BEGIN;

-- CREATE TEMPORARY TABLE users
-- (
--     int        serial primary key,
--     name       text not null,
--     age        int,
--     created_at timestamptz DEFAULT NULL
-- );


-- ALTER TABLE users
-- ADD CONSTRAINT check_age CHECK (age >= 18);

SELECT plan(x); -- Replace x with a number of assertions

-- Test inserting a new user under 18 throws an exception.

SELECT * FROM finish();

ROLLBACK;
