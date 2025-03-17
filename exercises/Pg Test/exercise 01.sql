BEGIN;

-- CREATE SCHEMA app;
-- CREATE TABLE app.user (
--   email text not null,
--   username text,
--   primary key (email)
-- );

SELECT plan(4);
-- Test schema `app` exists.
-- Test table `app.table` exists.
-- Test column `app.table(email)` is a primary key.
-- Test column `app.table(username)` exists.
SELECT * FROM finish();

ROLLBACK;
