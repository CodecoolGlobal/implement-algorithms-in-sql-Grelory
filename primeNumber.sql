-- Function which calculates n-th prime number;

CREATE OR REPLACE FUNCTION is_prime(number INTEGER)
RETURNS boolean
LANGUAGE plpgsql
AS $$
BEGIN
    ASSERT number > 0, 'Illegal Argument';
    IF number = 1 THEN RETURN true; END IF;
    FOR iteration IN 2..number LOOP
        IF iteration = number THEN RETURN true;
            ELSEIF MOD(number, iteration) = 0 THEN RETURN FALSE;
            END IF;
    END LOOP;
END $$;

CREATE OR REPLACE FUNCTION prime_number(
    n INTEGER,
    OUT result INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    currentNumber INTEGER := 1;
    iteration INTEGER := 0;
BEGIN
    result := 1;
    ASSERT n > 0, 'Illegal Argument';
    IF n = 1 THEN RETURN; END IF;
    WHILE iteration < n LOOP
        IF is_prime(currentNumber) THEN
            iteration := iteration + 1;
            result := currentNumber;
            currentNumber := currentNumber + 1;
            ELSE currentNumber := currentNumber + 1;
            END IF;
    END LOOP;
END $$;
