CREATE VIEW mc_hints AS
	SELECT id, count(hint) AS hints
	FROM extra_multiple_choice_options
	GROUP BY id;

CREATE VIEW num_hints AS
	SELECT id, count(hint) AS hints
	FROM numeric_question_hints
	GROUP BY id;

CREATE VIEW mc_table AS
	SELECT question.id, question_text, hints
	FROM question, mc_hints
	WHERE question.id = mc_hints.id;

CREATE VIEW num_table AS
	SELECT question.id, question_text, hints
	FROM question, num_hints
	WHERE question.id = num_hints.id;

CREATE VIEW tf_table AS
	SELECT id, question_text, NULL AS hints
	FROM question
	WHERE question_type = 'True False';

SELECT * FROM num_table UNION SELECT * FROM mc_table UNION SELECT * FROM tf_table;