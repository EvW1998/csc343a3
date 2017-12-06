-- No need to check teacher name because each room can only have 1 teacher
CREATE VIEW target_students AS 
    SELECT student_id AS id
	FROM student_class, class, room
    WHERE room.name = 'room 120' 
            AND class.room_id = room.id 
            AND class.grade = 8 
            AND student_class.class_id = class.id;

-- Create a view to represent all the questions where students took
CREATE VIEW responses AS 
    SELECT target_students.id AS student_id, quiz_id, question_id, answer
	FROM quiz_response, target_students 
    WHERE quiz_response.student_id = target_students.id;

-- Create a view to represent the grade of each question
CREATE VIEW marks AS 
    SELECT student_id, CASE WHEN answer = question_answer THEN weight
							ELSE 0 END AS mark
	FROM (responses JOIN question ON responses.question_id = question.id) r
					JOIN quiz_question ON quiz_question.question_id = r.question_id;
			
-- Use a left join because we might have left out people who scored a 0 using previous views
CREATE VIEW total AS 
    SELECT marks.student_id, SUM(mark) AS grade 
        FROM marks LEFT JOIN target_students ON marks.student_id = target_students.id 
            GROUP BY marks.student_id;

-- Format the final answer with the correct attributes
SELECT student_id, last_name, grade AS total_grade FROM total JOIN student ON total.student_id = student.id;