/*(1)Student- Competition database*/

CREATE TABLE Student (
    sreg_no int PRIMARY KEY auto_increment,
    name varchar(30) NOT NULL,
    class varchar(10) NOT NULL
);

CREATE TABLE Competition (
    c_no int PRIMARY KEY auto_increment,
    name varchar(20) NOT NULL,
    type varchar(15),
    CONSTRAINT CHECK(type IN('academics', 'sports'))
);

CREATE TABLE Student_Competition (
    sreg_no int,
    c_no int,
    s_rank int,
    c_year year,
    FOREIGN KEY(sreg_no) REFERENCES Student(sreg_no),
    FOREIGN KEY(c_no) REFERENCES Competition(c_no),
    UNIQUE(sreg_no, c_no)
);

INSERT INTO
    Student(name, class)
VALUES
    ("Wallabh J.", "5th"),
    ("Yash K.", "7th"),
    ("Yash T.", "9th"),
    ("Saurabh S.", "5th"),
    ("Mahadev B.", "7th"),
    ("Sumit U.", "9th"),
    ("Kunal B.", "7th");

INSERT INTO
    Competition(name, type)
VALUES
    ("running race", "sports"),
    ("swimming race", "sports"),
    ("poster competition", "academics"),
    ("hackathon", "academics"),
    ("chess", "sports"),
    ("boxing", "sports");

INSERT INTO
    Student_Competition
VALUES
    (1, 1, 1, 2000),
    (1, 6, 1, 2001),
    (2, 3, 1, 2004),
    (2, 5, 4, 1996),
    (3, 4, 5, 1999),
    (3, 1, 1, 2000),
    (4, 3, 2, 2001),
    (6, 1, 3, 2004),
    (7, 1, 1, 2002),
    (1, 4, 1, 2004),
    (7, 3, 1, 1995),
    (4, 6, 1, 1995);

select * from Student;
 +---------+------------+-------+
 | sreg_no | name       | class |
 +---------+------------+-------+
 |       1 | Wallabh J. | 5th   |
 |       2 | Yash K.    | 7th   |
 |       3 | Yash T.    | 9th   |
 |       4 | Saurabh S. | 5th   |
 |       5 | Mahadev B. | 7th   |
 |       6 | Sumit U.   | 9th   |
 |       7 | Kunal B.   | 7th   |
 +---------+------------+-------+
 
select * from Student_Competition;
 +---------+------+--------+--------+
 | sreg_no | c_no | s_rank | c_year |
 +---------+------+--------+--------+
 |       1 |    1 |      1 |   2000 |
 |       1 |    6 |      1 |   2001 |
 |       2 |    3 |      1 |   2004 |
 |       2 |    5 |      4 |   1996 |
 |       3 |    4 |      5 |   1999 |
 |       3 |    1 |      1 |   2000 |
 |       4 |    3 |      2 |   2001 |
 |       6 |    1 |      3 |   2004 |
 |       7 |    1 |      1 |   2002 |
 |       1 |    4 |      1 |   2004 |
 |       7 |    3 |      1 |   1995 |
 |       4 |    6 |      1 |   1995 |
 +---------+------+--------+--------+
 
(a) Queries:  

 1. List out all the competitions held in the school.
select * from Competition;
 +------+--------------------+-----------+
 | c_no | name               | type      |
 +------+--------------------+-----------+
 |    1 | running race       | sports    |
 |    2 | swimming race      | sports    |
 |    3 | poster competition | academics |
 |    4 | hackathon          | academics |
 |    5 | chess              | sports    |
 |    6 | boxing             | sports    |
 +------+--------------------+-----------+
 
2.List the names of all the students who have secured 1st rank in running race from 1995 to 2005.

select s.name, c_year as competition_year
from Student s, Competition c, Student_Competition s_c
where
    s_c.s_rank = 1 and 1995 >= s_c.c_year <= 2005
    and c.name = "running race" and s.sreg_no = s_c.sreg_no
    and c.c_no = s_c.c_no;

 +----------+------------------+
 | name     | competition_year |
 +----------+------------------+
 | Yash T.  |             2000 |
 | Kunal B. |             2002 |
 +----------+------------------+
 
3. Give the name of a student who has won maximum number of competitions.

select s.name, s_c.sreg_no, count(s_c.sreg_no) as "competitions won"
from
    Student s, Student_Competition s_c
where s_c.sreg_no = s.sreg_no and s_c.s_rank = 1
group by s_c.sreg_no
order by count(s_c.sreg_no) desc limit 1;

 +------------+---------+------------------+
 | name       | sreg_no | competitions won |
 +------------+---------+------------------+
 | Wallabh J. |       1 |                3 |
 +------------+---------+------------------+
 
4. Find out the total number of competitions organized in the school for competition type  
 'sports'.

select count(*) as "Number of sports competitions"
from Competition where type = 'sports';

 +-------------------------------+
 | Number of sports competitions |
 +-------------------------------+
 |                             4 |
 +-------------------------------+


5. Find out the details of students participating in different competitions.

select s.sreg_no, s.name, class, c.name as "participated in", c_year
from Student s, Competition c, Student_Competition s_c
where s.sreg_no = s_c.sreg_no and c.c_no = s_c.c_no;

 +---------+------------+-------+--------------------+--------+
 | sreg_no | name       | class | participated in    | c_year |
 +---------+------------+-------+--------------------+--------+
 |       1 | Wallabh J. | 5th   | running race       |   2000 |
 |       3 | Yash T.    | 9th   | running race       |   2000 |
 |       6 | Sumit U.   | 9th   | running race       |   2004 |
 |       7 | Kunal B.   | 7th   | running race       |   2002 |
 |       2 | Yash K.    | 7th   | poster competition |   2004 |
 |       4 | Saurabh S. | 5th   | poster competition |   2001 |
 |       3 | Yash T.    | 9th   | hackathon          |   1999 |
 |       1 | Wallabh J. | 5th   | hackathon          |   2004 |
 |       2 | Yash K.    | 7th   | chess              |   1996 |
 |       1 | Wallabh J. | 5th   | boxing             |   2001 |
 +---------+------------+-------+--------------------+--------+


(b) Stored Functions: 
 
a) Write a function which accepts a competition type and returns the total no of competitions held  
 under that type. 

delimiter $$ 
create function noOfCompetitions(t varchar(15)) returns int 
deterministic 
begin 
    declare number_of_competitions int;
    select count(*) into number_of_competitions
    from Competition
    where type = t;

    return number_of_competitions;
end $$

select noOfCompetitions("academics");


 +-------------------------------+
 | noOfCompetitions("academics") |
 +-------------------------------+
 |                             2 |
 +-------------------------------+
 

 b) Write a function which accepts a name of students and returns the total no of prizes won by that  
 student in the year 2001. 

delimiter $$ 
create function prizesWon(n varchar(30)) returns int 
deterministic 
begin 
    declare prizes_won int;
    select count(*) into prizes_won
    from Student s, Student_Competition s_c
    where s.sreg_no = s_c.sreg_no and s.name = n and s_c.c_year = 2001;
return prizes_won;
end $$

select prizesWon("Wallabh J.");
 +-------------------------+
 | prizesWon("Wallabh J.") |
 +-------------------------+
 |                       1 |
 +-------------------------+


(d) Cursors: 

a) Write a procedure using cursor which will list all the competitions in which students studing in the 5th std have won 1st prize in 1995.

delimiter $$ drop procedure if exists getCompetitions;
CREATE PROCEDURE getCompetitions()
BEGIN 
    declare comp varchar(20);
    declare class varchar(10);
    declare s_rank int;
    declare c_year year;
    declare cur cursor for
    
    select c.name, s.class, s_c.s_rank, s_c.c_year
    from Student_Competition s_c, Student s, Competition c
    where s.sreg_no = s_c.sreg_no and c.c_no = s_c.c_no;

    open cur;
    loop fetch cur into comp, class, s_rank, c_year;
        if class = '5th' and s_rank = 1 and c_year = 1995 then
            select comp, class, s_rank, c_year;
        end if;
    end loop;
    close cur;
END $$ 

call getCompetitions();

 +--------+-------+--------+--------+
 | comp   | class | s_rank | c_year |
 +--------+-------+--------+--------+
 | boxing | 5th   |      1 |   1995 |
 +--------+-------+--------+--------+

b) Write a procedure using cursor to give competition wise 1st or 2nd rank holders for all the  
 competitions held in the year 2001 

delimiter $$
drop procedure if exists rankHolders;
CREATE PROCEDURE rankHolders()
BEGIN 
    declare cno int;
    declare cname varchar(20);
    declare srank int;
    declare sname varchar(30);
    declare yr int;
    declare cur cursor for 
        select c.c_no, c.name, s_rank, s.name, c_year from Student_Competition s_c, Student s, Competition c 
        where s_c.sreg_no = s.sreg_no and s_c.c_no = c.c_no;
    open cur;
    loop fetch cur into cno, cname, srank, sname, yr;
        if yr = 2001 and (srank = 1 or srank = 2) then
            select cno, cname, srank, sname;
        end if;
    end loop;
    close cur;
END $$ 

call rankHolders();
+------+--------------------+-------+------------+
| cno  | cname              | srank | sname      |
+------+--------------------+-------+------------+
|    3 | poster competition |     2 | Saurabh S. |
+------+--------------------+-------+------------+
1 row in set (0.00 sec)

+------+--------+-------+------------+
| cno  | cname  | srank | sname      |
+------+--------+-------+------------+
|    6 | boxing |     1 | Wallabh J. |
+------+--------+-------+------------+
1 row in set (0.00 sec)


(e) Triggers:  

a) Write a trigger before insertion on the relationship table. if the year entered is greater than 
 current year, it should be changed to current year.*/

DROP TRIGGER IF EXISTS check_year;
DELIMITER $$
    CREATE TRIGGER check_year BEFORE INSERT ON `Student_Competition`
    FOR EACH ROW BEGIN
      IF (NEW.c_year > year(curdate())) THEN
        set NEW.c_year = year(curdate());
      END IF;
    END$$
DELIMITER ;

insert into Student_Competition values(7,6,3,2025);
select * from Student_Competition where sreg_no = 7 and c_no=6;

+---------+------+--------+--------+
| sreg_no | c_no | s_rank | c_year |
+---------+------+--------+--------+
|       7 |    6 |      3 |   2022 |
+---------+------+--------+--------+

b) Create a new table ‘tot_prize’ containing the fields stud_reg_no and no_of_prizes. 
Write a trigger after insert into the relationship table between student and Competition. It should  
increment the no_of_prizes in the table ‘tot_prize’ for the NEW stud_reg_no by 1. 

create table tot_prize (
    stud_reg_no int,
    no_of_prizes int,
    foreign key(stud_reg_no) references Student(sreg_no)
);


DROP TRIGGER IF EXISTS inc_no_of_prizes;
DELIMITER $$
    CREATE TRIGGER inc_no_of_prizes AFTER INSERT ON `Student_Competition`
    FOR EACH ROW BEGIN
        IF EXISTS(SELECT stud_reg_no from tot_prize where stud_reg_no = NEW.sreg_no) THEN
            UPDATE tot_prize SET no_of_prizes = no_of_prizes + 1 where stud_reg_no = NEW.sreg_no;
        ELSE
            INSERT INTO tot_prize VALUES(NEW.sreg_no, 1);
        END IF;
    END$$
DELIMITER ;

insert into Student_Competition values(6,2,2,1998);
Query OK, 1 row affected (0.19 sec)

mysql> select * from Student_Competition;;
+---------+------+--------+--------+
| sreg_no | c_no | s_rank | c_year |
+---------+------+--------+--------+
|       1 |    1 |      1 |   2000 |
|       1 |    6 |      1 |   2001 |
|       2 |    3 |      1 |   2004 |
|       2 |    5 |      4 |   1996 |
|       3 |    4 |      5 |   1999 |
|       3 |    1 |      1 |   2000 |
|       4 |    3 |      2 |   2001 |
|       6 |    1 |      3 |   2004 |
|       7 |    1 |      1 |   2002 |
|       1 |    4 |      1 |   2004 |
|       7 |    3 |      1 |   1995 |
|       4 |    6 |      1 |   1995 |
|       7 |    6 |      3 |   2022 |
|       6 |    2 |      2 |   1998 |
+---------+------+--------+--------+
14 rows in set (0.00 sec)


mysql> select * from tot_prize;
+-------------+--------------+
| stud_reg_no | no_of_prizes |
+-------------+--------------+
|           6 |            1 |
+-------------+--------------+
1 row in set (0.00 sec)

mysql> insert into Student_Competition values(6,3,1,1999);
Query OK, 1 row affected (0.11 sec)

mysql> select * from tot_prize;
+-------------+--------------+
| stud_reg_no | no_of_prizes |
+-------------+--------------+
|           6 |            2 |
+-------------+--------------+
1 row in set (0.00 sec)


(f) Views: 
 
a) Create a view over the competition table which contains only competition name and its type and it  
 should be sorted on type.

CREATE OR REPLACE VIEW competition_view AS
SELECT name, type from Competition order by type;

select * from competition_view;

 +--------------------+-----------+
 | name               | type      |
 +--------------------+-----------+
 | poster competition | academics |
 | hackathon          | academics |
 | running race       | sports    |
 | swimming race      | sports    |
 | chess              | sports    |
 | boxing             | sports    |
 +--------------------+-----------+

 b) Create a view containing student name, class, competition name, rank and year. the list should be  
 sorted by student name. 

CREATE OR REPLACE VIEW student_comp_view AS
SELECT s.name, s.class, c.name as competition, s_c.s_rank, s_c.c_year
FROM Student s, Competition c, Student_Competition s_c
WHERE s.sreg_no = s_c.sreg_no and c.c_no = s_c.c_no 
ORDER BY s.name;

select * from student_comp_view;

+------------+-------+--------------------+--------+--------+
| name       | class | competition        | s_rank | c_year |
+------------+-------+--------------------+--------+--------+
| Kunal B.   | 7th   | running race       |      1 |   2002 |
| Kunal B.   | 7th   | poster competition |      1 |   1995 |
| Saurabh S. | 5th   | poster competition |      2 |   2001 |
| Saurabh S. | 5th   | boxing             |      1 |   1995 |
| Sumit U.   | 9th   | running race       |      3 |   2004 |
| Wallabh J. | 5th   | running race       |      1 |   2000 |
| Wallabh J. | 5th   | hackathon          |      1 |   2004 |
| Wallabh J. | 5th   | boxing             |      1 |   2001 |
| Yash K.    | 7th   | poster competition |      1 |   2004 |
| Yash K.    | 7th   | chess              |      4 |   1996 |
| Yash T.    | 9th   | running race       |      1 |   2000 |
| Yash T.    | 9th   | hackathon          |      5 |   1999 |
+------------+-------+--------------------+--------+--------+
 
