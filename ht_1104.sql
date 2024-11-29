CREATE TABLE EMP01 (
    NO NUMBER(4) NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    SALARY NUMBER(7,2) DEFAULT 1000.0,
    CONSTRAINT EMP01_NO_PK PRIMARY KEY (NO),
    CONSTRAINT EMP01_NAME_UK UNIQUE (NAME)
);
 DROP TABLE EMP01;
 
select * from tab;
--휴지통 보는법
select * from recyclebin;

SELECT COUNT(*) FROM EMPLOYEES;
--테이블복사(제약조건은 복사되지 않는다)
CREATE TABLE EMP02
AS 
SELECT * FROM EMPLOYEES;
DESC EMPLOYEES;
DESC EMP02;
--제약조건 걸기 primary key
ALTER table EMP02 ADD CONSTRAINT EMP02_emp_id_pk PRIMARY KEY(employee_id);
ALTER table EMP02 ADD CONSTRAINT EMP02_EMAIL_UQ UNIQUE(EMAIL);
--제약조건 삭제하기 unique
ALTER table EMP02 DROP CONSTRAINT EMP02_EMAIL_UQ;
--제약조건 검색 확인하기
select * from user_constraints;
select table_name, constraint_name,constraint_type from user_constraints where table_name = 'EMP02';
--컬럼 추가
ALTER TABLE emp01 ADD job varchar2(10) not null;
desc emp01;
--컬럼제거
alter table emp01 drop column job;
--컬럼변경(기존값이 존재할때 타입변경불가 사이즈는 큰것으로는 변경 가능.)
ALTER TABLE emp01 MODIFY job number(10) default 0;
--컬럼 이름 변경( create, alter, drop rename, truncate)
ALTER TABLE emp01 rename column job to job2;
--테이블 이름 변경
rename EMP01 to EMP10;
--실습
create table CUST(
code char(7) NOT NULL,
name VARCHAR2(10)NOT NULL,
gender CHAR(1) NOT NULL check(gender in('M','W')),
birth CHAR(8) NOT NULL,
pnum VARCHAR2(16),
email VARCHAR2(30),
point NUMBER(10)
);

alter table CUST ADD CONSTRAINT CUST_code_pk PRIMARY KEY(code);
alter table CUST ADD CONSTRAINT CUST_pnum_uk UNIQUE(pnum);
alter table CUST MODIFY gender CHAR(1) NOT NULL;
alter table CUST DROP CONSTRAINT SYS_C008372;
alter table CUST ADD CONSTRAINT CUST_gender_ck check(gender in('M','W'));
alter table CUST MODIFY point NUMBER(10) default 0;
desc CUST;

insert into CUST VALUES('1234567','kms','M','19960825',null,null,null);
insert into CUST(CODE,NAME,GENDER,BIRTH) VALUES('1234568','kmL','M','19960825');
update CUST set NAME='kkl' where code='1234567';

delete from CUST WHERE NAME='kms';
select * from CUST;
--department 테이블 생성
create table dept
AS
select * from DEPARTMENTS;
delete from dept;
ROLLBACK;
desc dept;
select * from dept;

insert into dept select * from departments;
--과제 학생테이블 만들기



create table STUDENT(
student_num NUMBER(8),--pk
name VARCHAR(5) NOT NULL,
korean NUMBER(3) default 0 NOT NULL,
english NUMBER(3) default 0 NOT NULL,
math NUMBER(3) default 0 NOT NULL,
sum NUMBER(3) default 0 NOT NULL,
avg NUMBER(3) default 0 NOT NULL
);
alter table STUDENT MODIFY name VARCHAR(15);
alter table STUDENT ADD dept_code number(4); --fk
alter table STUDENT ADD CONSTRAINT STUDENT_student_num_pk PRIMARY KEY(student_num);
alter table STUDENT ADD CONSTRAINT STUDENT_dept_code_fk FOREIGN KEY(dept_code) REFERENCES DEPARTMENT(dept_code);
alter table STUDENT DROP CONSTRAINT STUDENT_dept_code_fk;
alter table STUDENT ADD CONSTRAINT STUDENT_dept_code_fk FOREIGN KEY(dept_code) REFERENCES DEPARTMENT(dept_code) ON delete CASCADE;
insert into STUDENT VALUES(00000003,'김민석3',50,50,50,0,0,1);
insert into STUDENT(student_num, name, dept_code) VALUES(00000008,'김민석8',1);


drop TRIGGER UPDATE_dept_code;
--외래키 업데이트 트리거
--CREATE TRIGGER UPDATE_dept_code
--AFTER UPDATE ON DEPARTMENT
--FOR EACH ROW
--BEGIN
--    UPDATE STUDENT
--    SET dept_code = :NEW.dept_code
--    WHERE dept_code = :OLD.dept_code;
--END;



create table DEPARTMENT(
dept_code number(4)
);
alter table DEPARTMENT ADD dept_name VARCHAR(15) NOT NULL;


insert into DEPARTMENT VALUES(4,'물리학과');
delete from DEPARTMENT;
desc STUDENT;
desc DEPARTMENT;
select * from STUDENT;
select * from DEPARTMENT;

update DEPARTMENT SET dept_code=1 where dept_name='건축공학과';

select ST.STUDENT_NUM, ST.NAME, ST.dept_code, DP.dept_name ,ST.KOREAN+ST.ENGLISH+ST.MATH sumscore  from STUDENT ST
join DEPARTMENT DP ON ST.dept_code=DP.dept_code;

select EMPLOYEE_ID, FIRST_NAME, JOB_ID,DEPARTMENT_ID,DEPARTMENT_NAME,
CASE
WHEN DEPARTMENT_ID=20 THEN salary*1.05
WHEN DEPARTMENT_ID=30 THEN salary*1.10
WHEN DEPARTMENT_ID=40 THEN salary*1.15
WHEN DEPARTMENT_ID=60 THEN salary*1.20
else sALARY
END as salary

from EMPLOYEES
;
select * from EMPLOYEES;

