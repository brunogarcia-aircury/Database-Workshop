BEGIN;

CREATE SCHEMA app;
CREATE TABLE app.user (
  email text not null,
  username text,
  primary key (email)
);

-- Test schema `app` exists.
-- Test table `app.table` exists.
-- Test column `app.table(email)` is a primary key.
-- Test column `app.table(username)` exists.
SELECT plan(4);
SELECT has_schema('app');
SELECT has_table('app'::name, 'user'::name);
-- SELECT has_pk('app'::name, 'user'::name);
SELECT col_is_pk('app'::name, 'user'::name, 'email'::name);
SELECT has_column('app', 'user', 'username', 'Has username column');

SELECT * FROM finish();

ROLLBACK;
