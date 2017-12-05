DROP SCHEMA IF EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;

SET search_path TO quizschema;

CREATE TYPE q_type AS ENUM(
	'true-false', 'multiple choice', 'numeric');
	
CREATE OR REPLACE FUNCTION is_same_teacher(class1 integer, class2 integer)
	RETURNS boolean AS
$func$
BEGIN
	RETURN (SELECT teacher_id FROM classes WHERE class_id = class1) = (SELECT teacher_id FROM classes WHERE class_id = class2);
END
$func$ LANGUAGE plpgsql STABLE STRICT;

CREATE TABLE students(
	student_id CHAR(10) primary key NOT NULL,

	first_name VARCHAR(20) NOT NULL,
  
	last_name VARCHAR(20) NOT NULL,
  
	CONSTRAINT letter_in_id CHECK (student_id SIMILAR TO '[[:digit:]]{10}')
);

CREATE TABLE teachers(
	teacher_id INT primary key NOT NULL,

	title VARCHAR(20) NOT NULL,
  
	last_name VARCHAR(20) NOT NULL
);

CREATE TABLE classes(
    class_id INT primary key NOT NULL,
  
    grade VARCHAR(20) NOT NULL,
  
    teacher_id INT NOT NULL
);

CREATE TABLE rooms(
    room_id INT primary key NOT NULL,
  
    class1 INT NOT NULL,
  
    class2 INT
  
    CHECK(class2 IS NULL OR is_same_teacher(class1, class2))
);

CREATE TABLE attending(
    student_id INT NOT NULL,
  
    class_id INT NOT NULL
);

CREATE TABLE questions(
    question_id INT PRIMARY KEY NOT NULL,
  
    question_type q_type NOT NULL,
  
    question VARCHAR(100) NOT NULL
);

CREATE TABLE multiple_choice_answers(
    answer_id INT PRIMARY KEY NOT NULL,
  
    question_id INT NOT NULL,
  
    answer VARCHAR(100) NOT NULL
);