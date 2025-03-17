# Introduction to PostgreSQL Testing

Testing is a critical part of database development to ensure data integrity, query performance, and reliability.
PostgreSQL provides powerful extensions and tools that help developers write, automate, and execute tests efficiently.
These extensions enable unit testing, performance analysis, and data validation, making PostgreSQL a robust choice for
production environments.

## Testing Extensions

### • [pgTAP](#h-pgTAP)

Unit testing for SQL functions, triggers, and schemas.</br>
Provides over 100 assertion functions for database testing.
[Learn more.](https://pgtap.org/)

### • [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html#PGSTATSTATEMENTS)

Tracks execution statistics for SQL queries.</br>
Helps identify slow or inefficient queries for performance testing.

### • [pg_mockable](https://github.com/bigsmoke/pg_mockable)

Allows mocking of functions for isolated testing.</br>
Useful for testing stored procedures without external dependencies.

### • [pg_faker](https://github.com/jbranchaud/pg_faker)

Generates realistic fake data for testing purposes.</br>
Helps populate tables with dummy data for simulations.

### • [pgcrypto](https://www.postgresql.org/docs/current/pgcrypto.html)

Encrypts and decrypts data for security testing.</br>
Ensures sensitive information is correctly handled in tests.

___

<a id="h-pgTAP"></a>

## **pgTAP**

### **Installation**

To install pgTAP, run:

```PostgreSQL
CREATE EXTENSION pgtap;
```

### **Usage**

Let's start with a simple test:

```PostgreSQL
BEGIN;

SELECT plan(1);
SELECT ok(1 = 1, 'Basic test should pass');
SELECT *
FROM finish();

ROLLBACK;
```

> [!IMPORTANT]
> Run always your tests within a transaction

At first step is necessary to select how many/assertion tests do we expect.</br>
After that we proceed to do the necessary assertions.</br>
Finally, we finalize the test, and we collate the result.

Let's see another example, this time lets check the database model:

```PostgreSQL
BEGIN;

SELECT plan(2);
SELECT has_table('users', 'Table users should exist');
SELECT col_hasnt_default('users', 'email', 'Email column should not have a default');
SELECT *
FROM finish();

ROLLBACK;
```

In the case the test fails `SELECT * FROM finish();` is going to return how many assertions has failed.

| finish                               |
|:-------------------------------------|
| # Looks like you failed 2 tests of 2 |

Now is time to practice, let's jump into the first exercise:

#### **Exercise 01**

Create a test:
- Schema `app` exists
- Table `app.user` exists
- Table `app.user` has a primary key with the column `email`
- Table `app.user` has a column `username`

Once the test is created, create the table and check the test pass.

<details>

<summary>Hint create table</summary>

```PostgreSQL
CREATE SCHEMA app;
CREATE TABLE app.user (
  email text not null,
  username text,
  primary key (email)
);
```

</details>

<details>

<summary>Solution</summary>

```PostgreSQL
BEGIN;

CREATE SCHEMA app;
CREATE TABLE app.user (
                          email text not null,
                          username text,
                          primary key (email)
);

insert into app.user(email, username) values ('foo@gmail.com', '@foo');

-- check schema, check table, check a primary key, check username
SELECT plan(4);
SELECT has_schema('app');
SELECT has_table('app'::name, 'user'::name);
-- SELECT has_pk('app'::name, 'user'::name);
SELECT col_is_pk('app'::name, 'user'::name, 'email'::name);
SELECT has_column('app', 'user', 'username', 'Has username column');

SELECT * FROM finish();

ROLLBACK;
```

</details>

#### **Exercise 02**
Let's raise the difficulty level and test custom PostgreSQL functions.

Using TDD, create and test a function `add_numbers` that receives two integers `a` and `b` and returns `a+b`.

```PostgreSQL
-- Create function syntax: 
CREATE FUNCTION function_name(argument_1 TEXT) RETURNS INT AS
$$
BEGIN
    -- logic
END;
$$ LANGUAGE plpgsql;
```

<details>

<summary>Solution</summary>

```PostgreSQL
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
```

</details>

### **Testing triggers and constraints**

Let's do another example using triggers and constrains:

**Step 1: create table**
```PostgreSQL
CREATE TEMPORARY TABLE users
(
    int        serial primary key,
    name       text not null,
    age        int,
    created_at timestamptz DEFAULT NULL
);
```

**Step 2: create constraint**
```PostgreSQL
ALTER TABLE users
ADD CONSTRAINT check_age CHECK (age >= 18);
```

**Step 3: create trigger**
```PostgreSQL
CREATE FUNCTION set_created_at() RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_before_insert
    BEFORE INSERT ON users
    FOR EACH ROW EXECUTE FUNCTION set_created_at();
```

**Test:**
```PostgreSQL
BEGIN;

SELECT plan(3);
SELECT has_table('users', 'Table users should exist');

SELECT throws_ok(
               'INSERT INTO users (name, age) VALUES (''Alice'', 17)',
               '23514', -- error code
               'new row for relation "users" violates check constraint "check_age"' -- error message
       );

DO $$
    DECLARE
        result timestamptz;
    BEGIN
        INSERT INTO users (name, age) VALUES ('Bob', 25) RETURNING created_at INTO result;

        CREATE TEMP TABLE insert_results AS SELECT result AS created_at;
    END $$;

SELECT results_ne(
               'SELECT * FROM insert_results',
               ARRAY[NULL::timestamptz]
       );

SELECT * FROM finish();

ROLLBACK;
```

### **Testing performance**

Another important aspect of testing is performance.

In the following example we are going to test the performance of a simple select query with and without an index.

```PostgreSQL
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
```
First, let's test the query performance without an index on the sale_date column.
This will show how the query performs with a full table scan, which is less efficient
for date-based filtering on large datasets.


```PostgreSQL
BEGIN;

SELECT plan(1);

SELECT performs_within(
    'SELECT * FROM sales WHERE sale_date = CURRENT_DATE - INTERVAL ''30 days''',
    5,
    15,
    'Query should perform within 3-15ms'
);

SELECT * FROM finish();

ROLLBACK;
```

> [!NOTE]
> This test is expected to fail because the query is performing a full table scan without an index on the `sale_date` column. Full table scans on large datasets (1 million rows in this case) typically take much longer than 15ms, as the database needs to check every single row to find matches. Adding an index on `sale_date` would significantly improve query performance by allowing the database to quickly locate the relevant rows.


#### **Exercise 02**

Now it's your turn! Create an index on the `sale_date` column and verify that the query performance improves significantly.

<details>

<summary>Hint</summary>

```PostgreSQL
CREATE INDEX idx_sales_date ON sales(sale_date);
```

</details>