/*
    Insert the data from Quiz-data.txt to the database
*/

-- class: grade 8, room 120, Mr Higgins --
INSERT INTO teacher VALUES(1011, 'Mr Higgins');
INSERT INTO room VALUES(2021, 'room 120', 1011);
INSERT INTO class VALUES(3031, 2021, 8); 

-- class: grade 5, room 366, Miss Nyers --
INSERT INTO teacher VALUES(1010, 'Miss Nyers');
INSERT INTO room VALUES(2020, 'room 366', 1010);
INSERT INTO class VALUES(3030, 2020, 5);

-- Students who are in class: grade 8, room 120, Mr Higgins --
INSERT INTO student VALUES('0998801234', 'Lena', 'Headey');
INSERT INTO student_class VALUES('0998801234', 3031);
INSERT INTO student VALUES('0010784522', 'Peter', 'Dinklage');
INSERT INTO student_class VALUES('0010784522', 3031);
INSERT INTO student VALUES('0997733991', 'Emilia', 'Clarke');
INSERT INTO student_class VALUES('0997733991', 3031);
INSERT INTO student VALUES('5555555555', 'Kit', 'Harrington');
INSERT INTO student_class VALUES('5555555555', 3031);
INSERT INTO student VALUES('1111111111', 'Sophie', 'Turner');
INSERT INTO student_class VALUES('1111111111', 3031);

-- Students who are in class: grade 5, room 366, Miss Nyers" --
INSERT INTO student VALUES('2222222222', 'Maisie', 'Williams');
INSERT INTO student_class VALUES('2222222222', 3030);

-- QUESTIONS --
INSERT INTO question VALUES(
    782, 
    'What do you promise when you take the oath of citizenship?', 
    'To pledge your loyalty to the Sovereign, Queen Elizabeth II',
    'Multiple Choice'
);
INSERT INTO multiple_choice_options VALUES(782, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian', 'Think regally.');
INSERT INTO multiple_choice_options VALUES(782, 'To pledge your loyalty to Canada from sea to sea', NULL);

INSERT INTO question VALUES(
    566, 
    'The Prime Minister, Justin Trudeau, is Canada''s Head of State.',
    'FALSE',
    'True False'
);

INSERT INTO question VALUES(
    601,
    'During the "Quiet Revolution," Quebec experienced rapid change. In what decade did this occur? (Enter the year that began the decade, e.g., 1840.)',
    '1960',
    'Numeric'
);

INSERT INTO numeric_question_hints VALUES(601, 'The Quiet Revolution happened during the 20th Century.', 1800, 1900);
INSERT INTO numeric_question_hints VALUES(601, 'The Quiet Revolution happened some time ago.', 2000, 2010);
INSERT INTO numeric_question_hints VALUES(601, 'The Quiet Revolution has already happened!', 2020, 3000);

INSERT INTO question VALUES(
    625,
    'What is the Underground Railroad?',
    'A network used by slaves who escaped the United States into Canada',
    'Multiple Choice'
);

INSERT INTO multiple_choice_options VALUES(
    625,
    'The first railway to cross Canada',
    'The Underground Railroad was generally south to north, not east-west.'
);
INSERT INTO multiple_choice_options VALUES(
    625,
    'The CPR''s secret railway line',
    'The Underground Railroad was secret, but it had nothing to do with trains.'
);
INSERT INTO multiple_choice_options VALUES(
    625,
    'The TTC subway system',
    'The TTC is relatively recent; the Underground Railroad was in operation over 100 years ago.'
);

INSERT INTO question VALUES(
    790,
    'During the War of 1812 the Americans burned down the Parliament Buildings in York (now Toronto). What did the British and Canadians do in return?',
    'They burned down the White House in Washington D.C.',
    'Multiple Choice'
);

INSERT INTO multiple_choice_options VALUES(790, 'They attacked American merchant ships', NULL);
INSERT INTO multiple_choice_options VALUES(790, 'They expanded their defence system, including Fort York', NULL);
INSERT INTO multiple_choice_options VALUES(790, 'They captured Niagara Falls', NULL);

-- QUIZ --
INSERT INTO quiz VALUES('Pr1-220310', 
    'Citizenship Test Practise Questions', 
    '2017-10-01 1:30:00', 
    TRUE, 
    3031
);

-- QUIZ QUESTIONS --
INSERT INTO quiz_question VALUES('Pr1-220310', 601, 2);
INSERT INTO quiz_question VALUES('Pr1-220310', 566, 1);
INSERT INTO quiz_question VALUES('Pr1-220310', 790, 3);
INSERT INTO quiz_question VALUES('Pr1-220310', 625, 2);

-- STUDENT QUIZ RESPONSES
INSERT INTO quiz_response VALUES('0998801234', 'Pr1-220310', 601, '1950');
INSERT INTO quiz_response VALUES('0998801234', 'Pr1-220310', 566, 'FALSE');
INSERT INTO quiz_response VALUES('0998801234', 'Pr1-220310', 790, 'They expanded their defence system, including Fort York');
INSERT INTO quiz_response VALUES('0998801234', 'Pr1-220310', 625, 'A network used by slaves who escaped the United States into Canada');

INSERT INTO quiz_response VALUES('0010784522', 'Pr1-220310', 601, '1960');
INSERT INTO quiz_response VALUES('0010784522', 'Pr1-220310', 566, 'FALSE');
INSERT INTO quiz_response VALUES('0010784522', 'Pr1-220310', 790, 'They burned down the White House in Washington D.C.');
INSERT INTO quiz_response VALUES('0010784522', 'Pr1-220310', 625, 'A network used by slaves who escaped the United States into Canada');

INSERT INTO quiz_response VALUES('0997733991', 'Pr1-220310', 601, '1960');
INSERT INTO quiz_response VALUES('0997733991', 'Pr1-220310', 566, 'TRUE');
INSERT INTO quiz_response VALUES('0997733991', 'Pr1-220310', 790, 'They burned down the White House in Washington D.C.');
INSERT INTO quiz_response VALUES('0997733991', 'Pr1-220310', 625, 'The CPR''s secret railway line');

INSERT INTO quiz_response VALUES('5555555555', 'Pr1-220310', 601, NULL);
INSERT INTO quiz_response VALUES('5555555555', 'Pr1-220310', 566, 'FALSE');
INSERT INTO quiz_response VALUES('5555555555', 'Pr1-220310', 790, 'They captured Niagara Falls');
INSERT INTO quiz_response VALUES('5555555555', 'Pr1-220310', 625, NULL);

INSERT INTO quiz_response VALUES('1111111111', 'Pr1-220310', 601, NULL);
INSERT INTO quiz_response VALUES('1111111111', 'Pr1-220310', 566, NULL);
INSERT INTO quiz_response VALUES('1111111111', 'Pr1-220310', 790, NULL);
INSERT INTO quiz_response VALUES('1111111111', 'Pr1-220310', 625, NULL);