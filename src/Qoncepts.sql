create database Qoncepts;
use Qoncepts;

create Table Teacher
(
    TID             varchar(255),
    Name            varchar(255),
    Email           varchar(255),
    Password        varchar(255),

    primary key(TID)
);

insert into Teacher
values('1111', 'Shruti Patil', 'shruti.patil@sitpune.edu.in', 'sp');




create Table Student
(
    PRN             varchar(255),
    Name            varchar(255),
    Branch          varchar(255),
    Year            varchar(255),
    Email           varchar(255),
    Password        varchar(255),

    primary key(PRN)
);

insert into Student
values('15070121560', 'Sujata Dev', 'IT', '2015-19',
        'sujata.dev@sitpune.edu.in', 'abc');




create Table QuizDB
(
    TestNo          varchar(255),
    Branch          varchar(255),
    Year            varchar(255),
    Batch           varchar(255),
    Semester        varchar(10),
    Subject         varchar(255),
    MaxMarks        int,
    No_of_Questions int,
    SubmissionDate  date,
    TimeLimit       int,

    primary key(TestNo)
);

insert into QuizDB
values('11', 'IT', 'Third', '2015-19', 'IV', 'Cyber Security', 20, 5,
        '2017-10-05',45);




create Table QuizQuestionsDB
(
    TestNo          varchar(255),
    QNo             int,
    Question        text,
    Marks           int,

    foreign key(TestNo) references QuizDB(TestNo)
);

insert into QuizQuestionsDB
values('1', 1, 'Explain the process to prepare and present the Budget.', 3);

insert into QuizQuestionsDB
values('1', 2, 'What are simultaneous elections? Give its advantages.', 5);

insert into QuizQuestionsDB
values('11', 1, 'List the various cyber attacks.', 6);




delimiter //
create procedure QuizQuestionList(in prn varchar(255))
begin
    select distinct TestNo
    from QuizQuestionsDB natural join QuizDB
    where QuizDB.Branch in (select Branch from Student where PRN=prn) and
        QuizDB.Year in (select Year from Student where PRN=prn);
end //
delimiter ;

call QuizQuestionList('15070121560');




create Table QuizAnswersDB
(
    TestNo          varchar(255),
    PRN             varchar(255),
    QNo             int,
    Question        text not null,
    Answer          text not null,
    TotalMarks      int,
    AllotedMarks    float,
    status          varchar(255) default "Not Done",

    foreign key(TestNo) references QuizDB(TestNo),
    foreign key(PRN) references Student(PRN)

);

insert into QuizAnswersDB
values('1', '15070121560', 1,
        'Explain the process to prepare and present the Budget.',
        'A budget process refers to the process by which governments create and approve a budget, which is as follows: The Financial Service Department prepares worksheets to assist the department head in preparation of department budget estimates.',
        5, 3.5,'Done');
