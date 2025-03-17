-- Exercise 1:
-- In this  exercise we are going to create a function using TDD, the function translate a user friendly text into a
-- combination of start and end timestamptz fields.

-- Test

ROLLBACK;
BEGIN;

SELECT plan(3);

-- Complete to test:
-- - On date_format_approach_1('yesterday') we expect to get a record with the dates from yesterday at 00:00:00 to 23:59:59.
SELECT row_eq(
               $$ SELECT * FROM date_format_approach_1('yesterday') $$,
               ROW((now() - '1 day'::interval)::date::timestamptz, ((now() - '1 day'::interval)::date + TIME '23:59:59')::timestamptz)
);
-- - On date_format_approach_1('last hour') we expect to get a record with the the current date less one hour and the current date.
SELECT row_eq(
               $$ SELECT * FROM date_format_approach_1('last hour') $$,
               ROW((now() - '1 hour'::interval), now())
);
-- - On date_format_approach_1('last 2 hours') we expect to get a record with the the current date less two hours and the current date.
SELECT row_eq(
               $$ SELECT * FROM date_format_approach_1('last 2 hour') $$,
               ROW((now() - '2 hour'::interval), now())
       );

SELECT * FROM finish(true);

ROLLBACK;

-- FUNCTION

CREATE OR REPLACE FUNCTION date_format_approach_1(expr text) RETURNS TABLE(start_date timestamptz, end_date timestamptz) AS $$
DECLARE
    start_date timestamptz;
    end_date timestamptz;
    interval interval;
BEGIN
    expr := TRIM(LOWER(expr));

    IF expr = 'yesterday' THEN
        start_date := (now() - '1 day'::interval)::date::timestamptz;
        end_date := start_date + '23 hours 59 min 59 seconds'::interval;
    ELSIF expr ~ 'last\s+((-?\d+)\s+)?(second|minute|hour|day|week|month|year)s?' THEN
        IF expr ~ 'last\s+(second|minute|hour|day|week|month|year)' THEN
            interval := ('1 ' || (regexp_match(expr, '^last\s+(second|minute|hour|day|week|month|year)$'))[1])::interval;
        ELSIF expr ~ 'last\s+((-?\d+)\s+(second|minute|hour|day|week|month|year)s?)' THEN
            interval := regexp_replace((regexp_match(expr, '^last\s+(-?\d+\s+(second|minute|hour|day|week|month|year)s?)$'))[1], '\s+', ' ', 'g')::interval;
        ELSE
            RAISE EXCEPTION 'Could not process the expression "%"', expr;
        END IF;

        start_date := now() - interval;
        end_date := now();
    ELSE
        RAISE EXCEPTION 'Could not process the expression "%"', expr;
    END IF;

    RETURN QUERY SELECT start_date, end_date;
END;
$$ LANGUAGE plpgsql;


SELECT regexp_match('last hour', '^last\s+(second|minute|hour|day|week|month|year)$');
