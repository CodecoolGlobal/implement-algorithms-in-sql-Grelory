-- SQL statements that are used to define the breadth-first search function
-- Include all your tried solutions in the SQL file
-- with commenting below the functions the execution times on the tested dictionaries.

CREATE OR REPLACE FUNCTION count_accepted_friends(personId INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS $$
    DECLARE
        friend_id INTEGER;
        actual_number INTEGER;
    BEGIN
        actual_number := (SELECT result FROM number_of_friends_table LIMIT 1);
        RAISE NOTIcE 'i''m inside calculation %', actual_number;
        IF (SELECT true FROM checked WHERE id = personId LIMIT 1) THEN
            RAISE NOTICE 'RETURN BECAUSE EXISTS';
            RETURN;
        END IF;
        UPDATE number_of_friends_table SET result=actual_number+1 WHERE result = actual_number;
        INSERT INTO checked VALUES (personId);
        FOR friend_id IN SELECT DISTINCT receiver AS id FROM friend_request
                                WHERE sender = personId AND status::text LIKE 'accepted'
                          UNION
                          SELECT DISTINCT sender AS id FROM friend_request
                                WHERE receiver = personId AND status::text LIKE 'accepted' LOOP
            PERFORM count_accepted_friends(friend_id);
        END LOOP;
END; $$;

CREATE OR REPLACE FUNCTION do_bft(personId INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
    BEGIN
        DROP TABLE IF EXISTS checked;
        CREATE TEMP TABLE checked(
            id INTEGER UNIQUE NOT NULL
        );
        DROP TABLE IF EXISTS number_of_friends_table;
        CREATE TEMP TABLE number_of_friends_table(
            result INTEGER UNIQUE NOT NULL
        );
        INSERT INTO number_of_friends_table VALUES (-1);
        PERFORM count_accepted_friends(personId);
        RETURN (SELECT result FROM number_of_friends_table LIMIT 1)::INTEGER;
END; $$;

SELECT do_bft(1);
