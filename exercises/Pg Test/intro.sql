-- Pg Test: Introduction
-- PSQL has the PgTag extension that allows to create tests, a very powerful tool to develop custom psql functions,
-- processes or triggers.

-- How PgTag works?
-- First is recommended to run each test in a transaction.
-- Plan how many test are you going to execute
-- Use PgTag functions to test your code: https://pgtap.org/documentation.html
-- Finish the tests and clean up: SELECT * FROM finish();

-- Example

ROLLBACK;
BEGIN;

CREATE TEMPORARY TABLE test_users
(
    id   integer primary key,
    name text
) ON COMMIT DELETE ROWS;

INSERT INTO test_users (id, name)
values (1, 'Jake'),
       (2, 'Sarah'),
       (3, 'Emily')
;

SELECT plan(count(*)::integer)
FROM test_users;


SELECT row_eq(
               $$ SELECT * FROM test_users WHERE id = 1 $$,
               ROW (1, 'Jake')::test_users,
               'User with id equal to 1 must be Jake'
       );
SELECT row_eq(
               $$ SELECT * FROM test_users WHERE id = 2 $$,
               ROW (2, 'Sarah')::test_users,
               'User with id equal to 2 must be Jake'
       );
--Expected to fail
SELECT row_eq(
               $$ SELECT * FROM test_users WHERE id = 3 $$,
               ROW (3, 'Emil')::test_users,
               'User with id equal to 3 must be Emil'
       );

SELECT *
FROM finish(true);

ROLLBACK;