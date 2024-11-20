desc test;
drop table books;
CREATE TABLE books (
id number(4), 
title varchar2(50), 
publisher varchar2(30), 
year varchar2(10), 
price number(6)
);
alter table books add constraint BOOKS_ID_PK primary key(id);
desc books;

create sequence BOOKS_ID_SEQ
START WITH 1
INCREMENT BY 1;
select * from books;
INSERT INTO books VALUES (bookS_id_seq.nextval, 'Operating System Concepts', 'Wiley', '2003',30700);
INSERT INTO books VALUES (bookS_id_seq.nextval, 'Head First PHP and MYSQL', 'OReilly', '2009', 58000);
INSERT INTO books VALUES (bookS_id_seq.nextval, 'C Programming Language', 'Prentice-Hall', '1989', 35000);
INSERT INTO books VALUES (bookS_id_seq.nextval, 'Head First SQL', 'OReilly', '2007', 43000);
commit;
drop table student;
create table student2(
code number(5),
name varchar2(10),
birth date,
grade number(3)
);
alter table student2 add constraint STUDENT2_CODE_PK primary key(code);
alter table student2 add rank number(3);
delete from student2;
insert into student2 values((select nvl(max(code),0)+1 from student2),dbms_random.string('U',3),round(dbms_random.value(1980,2000),0)||'/'||round(dbms_random.value(1,12),0)||'/'||round(dbms_random.value(1,30),0),round(dbms_random.value(1,100),0));
commit;
select code, name, birth, grade, Rank()over(order by grade) as g_rank from student2; 
select code, name, birth, grade, Rank()over(order by TO_DATE(birth,'YYYY/MM/DD')) as g_rank from student2;
call STU_CAL_PROC;
select code, name, birth, kor,math,eng,total,avg from student2 order by total desc;
create or replace procedure STU_CAL_PROC
is

begin
update student2 set total=kor+eng+math, avg=(kor+eng+math)/3;
update student2 s set rank=(select rank_s from (select code, rank()over(order by (kor+math+eng) desc) as rank_s from student2) d where s.code=d.code) ;
end;
/
select code, rank()over(order by total desc) as rank_s from student2;
execute STU_CAL_PROC;
insert into student2(code,name,birth,kor,math,eng) values((select nvl(max(code),0)+1 from student2),dbms_random.string('U',3),round(dbms_random.value(1980,2000),0)||'/'||round(dbms_random.value(1,12),0)||'/'||round(dbms_random.value(1,30),0),round(dbms_random.value(1,100),0),round(dbms_random.value(1,100),0),round(dbms_random.value(1,100),0));
select * from student2;
select code, name, birth, kor,math,eng,total,avg, Rank()over(order by total desc) as g_rank from student2;
select code, name, birth, kor,math,eng,total,avg, Rank()over(order by code) as g_rank from student2;
