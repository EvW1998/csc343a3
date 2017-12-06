DROP SCHEMA IF EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;
SET SEARCH_PATH TO quizschema;

CREATE OR REPLACE FUNCTION is_not_overlap(lower_bound integer, upper_bound integer, q_id integer)
	RETURNS integer AS
$func$
DECLARE
	rec RECORD;

BEGIN
	FOR rec IN SELECT * FROM numeric_question_hints WHERE id = q_id
	LOOP
		RAISE NOTICE '%', rec.upper_range;
		IF rec.lower_range = 1 THEN
			RETURN rec.lower_range;
		END IF;
	END LOOP;
	
	RETURN 1998;
END;
$func$ LANGUAGE plpgsql STABLE STRICT;

CREATE TABLE numeric_question_hints(
	-- ID of the question that the answer related to
    id INT NOT NULL,
	-- hint for this answer
    hint VARCHAR(1000),
	-- The lower range for this hint
    lower_range INT NOT NULL,
	-- The upper range
    upper_range INT NOT NULL,
	
	-- Make sure no two hints have same range in one question
    UNIQUE(id, lower_range, upper_range)
);