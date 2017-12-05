DROP SCHEMA IF EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;

SET search_path TO quizschema;

CREATE TABLE students(
  student_id INT primary key NOT NULL,

  first_name VARCHAR(20) NOT NULL,
  
  last_name VARCHAR(20) NOT NULL,
  
  CHECK(student_id SIMILAR TO '[0-9]{10}')
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
  
  CHECK(class2 IS NULL OR ((SELECT teacher_id FROM classes WHERE class_id = class1) = (SELECT teacher_id FROM classes WHERE class_id = class2)))
);

CREATE TABLE attending(
  student_id INT NOT NULL,
  
  class_id INT NOT NULL
);