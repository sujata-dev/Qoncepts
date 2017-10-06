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
values('15070121560', 'Sujata Dev', 'IT', '2015-19', 'sujata.dev@sitpune.edu.in', 'abc');


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

    primary key(TestNo)
);

insert into QuizDB
values('11','IT','Third','2015-19','IV','Cyber Security',20,5,'2017-10-05');


create Table QuizQuestionsDB
(
    TestNo          varchar(255),
    Question        text,
    Marks           int,

    foreign key(TestNo) references QuizDB(TestNo)
);
insert into QuizQuestionsDB
values('1','Explain the process to prepare and present the Budget.',3);

insert into QuizQuestionsDB
values('1','What are simultaneous elections? Give its advantages.',5);

insert into QuizQuestionsDB
values('11','List the various cyber attacks.',6);


delimiter //
create procedure QuizQuestionList(in Tno varchar(255))
begin
select Question,Marks from QuizQuestionsDB, QuizDB where QuizDB.TestNo=QuizQuestionsDB.TestNo and QuizQuestionsDB.TestNo=Tno;
end //
delimiter ;

call QuizQuestionList(1);
