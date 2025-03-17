BEGIN;

CREATE TEMPORARY TABLE users
(
    int        serial primary key,
    name       text not null,
    age        int,
    created_at timestamptz DEFAULT NULL
);


ALTER TABLE users
ADD CONSTRAINT check_age CHECK (age >= 18);

SELECT plan(2); -- Replace x with a number of assertions
SELECT has_table('users', 'Table users should exist');
SELECT throws_ok(
               'INSERT INTO users (name, age) VALUES (''Alice'', 17)',
               '23514', -- error code
               'new row for relation "users" violates check constraint "check_age"' -- error message
       );

SELECT * FROM finish();

ROLLBACK;
