-- Create a view to get all students in the right class
-- No need to check teacher name because each room can only have 1 teacher
CREATE VIEW target_students_q4 AS 
    SELECT student_id AS id FROM student_class, class, room
        WHERE room.name = 'room 120' 
            AND class.room_id = room.id 
            AND class.grade = 8 
            AND student_class.class_id = class.id;
-- Find questions that were answered
CREATE VIEW answers AS
    SELECT student_id, question_id FROM quiz_response
        WHERE quiz_id = 'Pr1-220310'
            AND answer IS NOT NULL;
-- Create a view of all student-question permutations to remove from
CREATE VIEW student_answer_pairs AS
    SELECT target_students_q4.id AS student_id, question_id FROM target_students_q4, quiz_question
        WHERE quiz_id = 'Pr1-220310';
-- Remove answered questions from all permutations to get unanswered questions
CREATE VIEW unanswered AS
    SELECT * FROM student_answer_pairs
    EXCEPT
    SELECT * FROM answers;

-- Format the final view to include the right attributes
SELECT student_id, question_id, question_text FROM unanswered, question 
    WHERE unanswered.question_id = question.id;