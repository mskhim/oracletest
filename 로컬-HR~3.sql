desc test;
drop table books;
SELECT * FROM BOOKS;

--프로시저
create or replace procedure book_price_proc(vid in books.id%type, incre in number, VMSG OUT VARCHAR2)
is
VBOOKS_RT BOOKS%ROWTYPE;
begin
update books set price=price+INCRE
where id=vid;
COMMIT;
SELECT * INTO VBOOKS_RT FROM BOOKS WHERE id=vid;
VMSG := VBOOKS_RT.ID||'번 책의 인상 금액은'||INCRE||'이고, 총 금액은 '|| VBOOKS_RT.PRICE||'입니다.';
DBMS_OUTPUT.PUT_LINE(VMSG);
end;
/
--함수

create or replace function books_fuc(vid in books.id%type)
return varchar2
is
VBOOKS_RT BOOKS%ROWTYPE;
VMSG varchar2(100);
begin
--update books set price=price+INCRE
--where id=vid;
SELECT * INTO VBOOKS_RT FROM BOOKS WHERE id=vid;
VMSG := VBOOKS_RT.ID||'번 책의, 총 금액은 '|| VBOOKS_RT.PRICE||'입니다.';
DBMS_OUTPUT.PUT_LINE(VMSG);
return VMSG;
end;
/

select  books_fuc(3,10000) from dual;


VARIABLE MSG VARCHAR2(100);
EXECUTE book_price_proc(3,10000,:MSG);

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




--------------------------------------------------------------------------학생정보
drop table student;
create table student2(
code number(5),
name varchar2(10),
birth date,
kor number(3),
math number(3),
eng number(3),
total number(3),
avg number(5,2),
rank number(3)
);
alter table student2 modify birth varchar2(30);
alter table student2 add constraint STUDENT2_CODE_PK primary key(code);
alter table student2 add rank number(3);
delete from student2;
insert into student2 values((select nvl(max(code),0)+1 from student2),dbms_random.string('U',3),round(dbms_random.value(1980,2000),0)||'/'||round(dbms_random.value(1,12),0)||'/'||round(dbms_random.value(1,30),0),round(dbms_random.value(1,100),0));
commit;
select code, name, birth, grade, Rank()over(order by grade) as g_rank from student2; 
select code, name, birth, grade, Rank()over(order by TO_DATE(birth,'YYYY/MM/DD')) as g_rank from student2;
call STU_CAL_PROC;
select code, name, birth, kor,math,eng,total,avg from student2 order by total desc;

--평균, 합계, 등수 전체적으로 지정해주는 프로시저
create or replace procedure STU_CAL_PROC
is
begin
update student2 set total=kor+eng+math, avg=(kor+eng+math)/3;
update student2 s set rank=(select rank_s from (select code, rank()over(order by (kor+math+eng) desc) as rank_s from student2) d where s.code=d.code) ;
end;
/
execute STU_CAL_PROC;

--삭제시 쓰레기통에 넣어주는 트리거
CREATE OR REPLACE TRIGGER STU_DEL_TRG
BEFORE DELETE
ON
STUDENT2
FOR EACH ROW
BEGIN
INSERT INTO STUDENT_GAR VALUES(:OLD.CODE,:OLD.NAME,:OLD.BIRTH,:OLD.KOR,:OLD.MATH,:OLD.ENG,:OLD.TOTAL,:OLD.AVG,:OLD.RANK,sysdate);
END;
/
SELECT * FROM STUDENT2;
DELETE FROM STUDENT2;
SELECT * FROM STUDENT_GAR;
commit;
delete from STUDENT_GAR;
alter table STUDENT_GAR add time date;
alter table STUDENT_GAR modify avg number(5,2);
