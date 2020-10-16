-- Function which calculate pesel's checksum and validate it.

CREATE OR REPLACE FUNCTION pesel_validation(pesel INTEGER[11])
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
    DECLARE
        checksum INTEGER := 0;
        validation_numbers INTEGER[4];
        validation_index INTEGER := 1;
        pesel_index INTEGER := 1;

    BEGIN
        validation_numbers[1] := 1;
        validation_numbers[2] := 3;
        validation_numbers[3] := 7;
        validation_numbers[4] := 9;
        WHILE pesel_index < 11 LOOP
            checksum := checksum + pesel[pesel_index] * validation_numbers[validation_index];
            pesel_index := pesel_index + 1;
            validation_index := validation_index + 1;
            IF validation_index > 4 THEN validation_index := 1; END IF;
        END LOOP;
        RAISE NOTICE 'checksum: % last_pesel_number %', checksum, pesel[pesel_index];

        IF mod(10 - mod(checksum, 10), 10) = pesel[pesel_index] THEN RETURN true; END IF;
        RETURN false;
END; $$;

-- should return false;
SELECT pesel_validation('{1,2,3,4,5,6,7,8,9,0,1}');
-- should return true;
SELECT pesel_validation('{1,2,3,4,5,6,7,8,9,0,3}');
-- should return false;
SELECT pesel_validation('{4,4,0,5,1,4,0,1,3,5,8}');
-- should return true;
SELECT pesel_validation('{4,4,0,5,1,4,0,1,3,5,9}');