/* 
    What constraints from the domain could not be enforced?
        - The restriction that each class must have at least 1 student couldn't be enforced.
        - The constraint that each student can only answer questions that they were assigned to was not enforced.
    
    What constraints that could have been enforced were not enforced? Why not?
*/

DROP SCHEMA IF EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;
SET SEARCH_PATH TO quizschema;


/*
    Create an enum to hold question types as there are only 3 types
*/
CREATE TYPE question_types AS ENUM(
    'True False',
    'Multiple Choice',
    'Numeric'
);


/*
    Create an function check whether the student id is all digit.
	Return true if it is, false if it isn't
*/
CREATE OR REPLACE FUNCTION is_in_class(student_id CHAR(10), quiz_id VARCHAR(50))
	RETURNS boolean AS
$func$
BEGIN
	RETURN student_id IN (SELECT student_id FROM student_class WHERE class_id = (SELECT id FROM quiz WHERE quiz.class = quiz_id));
END
$func$ LANGUAGE plpgsql STABLE STRICT;


/*
    Create an function check when we create hint for numeric question, whether the range of the hint will overlap.
	Return true if it is not, false if it is
*/
CREATE OR REPLACE FUNCTION is_not_overlap(lower_bound integer, upper_bound integer, q_id integer)
	RETURNS boolean AS
$func$
DECLARE
	rec RECORD;

BEGIN
	FOR rec IN SELECT * FROM numeric_question_hints WHERE id = q_id
	LOOP
		IF NOT (upper_bound < rec.lower_range OR lower_bound >= rec.upper_range) THEN
			RETURN false;
		END IF;
	END LOOP;
	
	RETURN true;
END;
$func$ LANGUAGE plpgsql STABLE STRICT;


/* 
    Students should be used in a classes table that represent the classes a student is in.
    Each student can be enrolled in 0 or more classes.
*/
CREATE TABLE student(
	-- ID of a student, a 10-digit number
    id CHAR(10) PRIMARY KEY,
	-- first name of student
    first_name VARCHAR(50) NOT NULL,
	-- last name
    last_name VARCHAR(50) NOT NULL
	
	-- Check if the id only contains numbers
	CONSTRAINT letter_in_id CHECK (id SIMILAR TO '[[:digit:]]{10}')
);


/*
    Use a separate table to store teacher to avoid redundancy when creating rooms
*/
CREATE TABLE teacher(
	-- ID of a teacher
    id INT PRIMARY KEY,
	-- teacher's name
    name VARCHAR(50)
);


/*
    Each room can only have 1 teacher so we reference it back to the teacher table
*/
CREATE TABLE room(
	-- ID of the room
    id INT PRIMARY KEY,
	-- The name of the room
    name VARCHAR(50) UNIQUE,
	-- Teacher who teach in this room
    teacher_id INT REFERENCES teacher(id) NOT NULL
);


/*
    Classes should be used in a classes table that represent the students in a class.
    *Each class has at least 1 student in it.

    Note that we do not directly enforce each class to have a student in the database, it
        is up to the user to ensure that.

    Each room also has an assigned teacher, which can be stored in a different table.
    Each room can only have 1 teacher, so we can infer teacher of a class from the room.
*/
CREATE TABLE class(
	-- ID for a class
    id INT PRIMARY KEY,
	-- Room that this class holds
    room_id INT REFERENCES room(id) NOT NULL,
	-- Which grade is this class
    grade INT NOT NULL
);


/*
    Hold the base info of all questions, and add any extra needed info for different questions
        into other tables.
*/
CREATE TABLE question(
	-- ID of this question
    id INT PRIMARY KEY,
	-- The question
    question_text VARCHAR(1000) UNIQUE NOT NULL,
	-- The right answer of this question
    question_answer VARCHAR(1000) NOT NULL,
	-- The type of this question
    question_type question_types NOT NULL
);


/*
    Holds extra information for multiple choice questions
*/
CREATE TABLE multiple_choice_options(
	-- ID of the question that the answer related to
    id INT REFERENCES question(id) NOT NULL,
	-- The answer
    question_answer VARCHAR(1000) NOT NULL,
	-- The hint for this answer
    hint VARCHAR(1000),
	
	-- Make user there are no same answers for one question
    UNIQUE(id, question_answer)
);


/*
    Holds extra information for numeric questions
	have to make sure no two hint range overlap!
*/
CREATE TABLE numeric_question_hints(
	-- ID of the question that the answer related to
    id INT REFERENCES question(id) NOT NULL,
	-- hint for this answer
    hint VARCHAR(1000),
	-- The lower range for this hint
    lower_range INT NOT NULL,
	-- The upper range
    upper_range INT NOT NULL,
	
	-- Make sure no two hints have same range in one question
    UNIQUE(id, lower_range, upper_range)
	-- have to make sure no two hint range overlap!
	CHECK(is_not_overlap(lower_range, upper_range, id))
);


/*
    Quiz table should store all base information about a quiz

    Each quiz has 1 or more questions, which will be stored in a separate table
    Each quiz will also be assigned to one class and one class only, so we can store
        that data in this relation.
*/
CREATE TABLE quiz(
	-- ID of a quiz
    id VARCHAR(50) PRIMARY KEY,
	-- Title of this quiz
    title VARCHAR(100) NOT NULL,
	-- The due date of the quiz
    due DATE NOT NULL,
	-- Whether show the hint
    show_hint BOOLEAN NOT NULL,
	-- The class which the quiz assigned to
    class INT REFERENCES class(id) NOT NULL
);



-- RELATION TABLES --

/*
    Relation to represent the classes students are enrolled in

    We satisfy the condition that students can be in 0 or more classes
    However, we don't satisfy the condition that each class must have
        at least 1 student.

    We also specify the data in this table must be unique because it
        is pointless to store the same student-class pair more than once.
*/
CREATE TABLE student_class(
	-- ID of student who take this class
    student_id CHAR(10) REFERENCES student(id) NOT NULL,
	-- ID of class which the student takes
    class_id INT REFERENCES class(id) NOT NULL,
	
	-- Make sure a student won't be in the same class twice
    UNIQUE(student_id, class_id)
);


/*
    Relation to represent the questions on a quiz

    This relation also stores the weight of a question on the relative quiz.

    There is also an extra constraint that we added to make sure that the same
        question doesn't appear twice on a quiz.
*/
CREATE TABLE quiz_question(
	-- The quiz id which the question assigned to
    quiz_id VARCHAR(50) REFERENCES quiz(id) NOT NULL,
	-- The question showed in the quiz
    question_id INT REFERENCES question(id) NOT NULL,
	-- The weight of the question in this quiz
    weight INT NOT NULL,
	
    PRIMARY KEY(quiz_id, question_id)
);


/*
    Relation to store the responses that students gave for a specific quiz

    Make sure that we don't allow many responses for the same question from
        the same student by making the ID combinations unique.
*/
CREATE TABLE quiz_response(
	-- The id of student who wrote the quiz
    student_id CHAR(10) REFERENCES student(id) NOT NULL,
	-- The id of quiz which wroted by student
    quiz_id VARCHAR(50) NOT NULL,
	-- The question of this
    question_id INT NOT NULL,
	-- What did the student answer
    answer VARCHAR(1000),
	
	-- Make sure the quiz is in the question
    FOREIGN KEY (quiz_id, question_id) REFERENCES quiz_question(quiz_id, question_id),
	-- Make sure not record the same thing twice
    UNIQUE(student_id, quiz_id, question_id,
	-- Make sure this student is in the class which this quiz assigned to
	CONSTRAINT range_overlap CHECK(is_in_class(student_id, quiz_id))
);
