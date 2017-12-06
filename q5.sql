-- Find all questions on the right quiz
CREATE VIEW want_questions AS
    SELECT question_id FROM quiz_question 
        WHERE quiz_id = 'Pr1-220310';
-- Find all students in the right classroom
CREATE VIEW want_students AS 
    SELECT student_id AS id FROM student_class, class, room
        WHERE room.name = 'room 120' 
            AND class.room_id = room.id 
            AND class.grade = 8 
            AND student_class.class_id = class.id;
-- Find all the right answers for the questions
CREATE VIEW right_answers AS
    SELECT question_id, question_answer FROM want_questions, question
        WHERE question_id = question.id;
-- Find all the responses from the right students
CREATE VIEW want_responses AS
    SELECT quiz_response.student_id, question_id, answer FROM want_students, quiz_response
        WHERE quiz_response.student_id = want_students.id
        AND quiz_response.quiz_id = 'Pr1-220310';
-- Find all the responses that were not answered
CREATE VIEW no_answer AS
    SELECT question_id, count(*) AS no_respons FROM want_responses
        WHERE answer IS NULL
		GROUP BY question_id;
-- Find all the responses that were wrong
CREATE VIEW wrong_answer AS
    SELECT want_responses.question_id, count(*) AS wrong_respons FROM want_responses, right_answers
        WHERE want_responses.question_id = right_answers.question_id
        AND want_responses.answer <> right_answers.question_answer
		GROUP BY want_responses.question_id;
-- Find all the responses that were right
CREATE VIEW right_answer AS
    SELECT want_responses.question_id, count(*) AS right_respons FROM want_responses, right_answers 
        WHERE want_responses.question_id = right_answers.question_id
        AND want_responses.answer = right_answers.question_answer
		GROUP BY want_responses.question_id;

SELECT question_id, right_respons, wrong_respons, no_respons FROM (no_answer NATURAL JOIN wrong_answer) NATURAL JOIN right_answer;