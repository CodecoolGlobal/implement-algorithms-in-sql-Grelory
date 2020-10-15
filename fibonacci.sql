-- Function which calculates n-th Fibonacci number

CREATE OR REPLACE FUNCTION fibonacci_number(
    n integer,
    out result INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    previousNumber INTEGER := 1;
    number INTEGER := 1;
    iteration INTEGER := 1;
BEGIN
    result := 1;
    ASSERT n > 0, 'Illegal Argument Error';
    WHILE iteration < n LOOP
        previousNumber := number;
        number := result;
        result := previousNumber + number;
        iteration := iteration + 1;
    END LOOP;
END $$;

CREATE OR REPLACE FUNCTION check_fibonacci()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    fib INTEGER;
BEGIN
    FOR iteration IN 1..15 LOOP
        fib := fibonacci_number(iteration);
        RAISE NOTICE '%', fib;
    END LOOP;
END $$;

SELECT * FROM check_fibonacci();
