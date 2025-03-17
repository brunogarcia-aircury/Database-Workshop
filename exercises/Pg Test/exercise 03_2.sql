ROLLBACK;
BEGIN;

CREATE TEMPORARY TABLE users
(
    int        serial primary key,
    name       text not null,
    age        int,
    created_at timestamptz DEFAULT NULL
);

CREATE OR REPLACE FUNCTION set_current_date()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.created_at := CURRENT_DATE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_before_insert
    BEFORE INSERT
    ON users
    FOR EACH ROW
EXECUTE FUNCTION set_current_date();

SELECT plan(1);

-- Test the inserted results doesn't contain nulls on created_at

SELECT *
FROM finish();

ROLLBACK;
