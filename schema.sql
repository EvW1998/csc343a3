DROP SCHEMA IF EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;

SET search_path TO quizschema;

CREATE TABLE student(
  sid INT primary key NOT NULL,

  first_name VARCHAR(20) NOT NULL,
  
  last_name VARCHAR(20) NOT NULL
);

CREATE TABLE teachers(
  tid INT primary key NOT NULL,

  title VARCHAR(20) NOT NULL,
  
  last_name VARCHAR(20) NOT NULL
);

CREATE TABLE classes(
  cid INT primary key NOT NULL,

  room VARCHAR(20) NOT NULL,
  
  grade VARCHAR(20) NOT NULL
  
  tid INT NOT NULL
);

CREATE TABLE attending(
  sid INT NOT NULL,
  
  cid INT NOT NULL
);