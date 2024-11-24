DROP TABLE CUSTOMER;
CREATE TABLE CUSTOMER(
NO CHAR(5),                          --PK
NAME VARCHAR2(10) NOT NULL,          --이름
ID VARCHAR2(20)NOT NULL,             --UQ 아이디
PWD VARCHAR2(20)NOT NULL,            --비밀번호
BIRTH DATE,                          --생년월일
PHONE VARCHAR2(20),                  --UQ핸드폰번호
BOOKCOUNT NUMBER(3) DEFAULT 0,       --예매횟수
REGISTDATE DATE NOT NULL             --회원가입 일자
);
Commit;
SELECT COUNT(*) AS CHK FROM CUSTOMER WHERE ID = 'kon';
insert into CUSTOMER(no, NAME, ID, PWD, REGISTDATE) VALUES(to_char((select nvl(max(no),0)+1 from CUSTOMER),'FM00000'),DBMS_RANDOM.string('U',5),DBMS_RANDOM.string('U',10),DBMS_RANDOM.string('U',10),sysdate);
delete from HALL;
select * from customer;
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_NO_PK PRIMARY KEY(NO);
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_ID_UQ UNIQUE(ID);
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_PHONE_UQ UNIQUE(PHONE);



DROP TABLE HALL;
CREATE TABLE HALL(            --상영관
NO CHAR(2),                   --PK
SEATS NUMBER(3) NOT NULL,     --좌석수
PRICE NUMBER(6) NOT NULL      --상영료
);



ALTER TABLE HALL ADD CONSTRAINT HALL_NO_PK PRIMARY KEY(NO);
insert into hall values(to_char((select nvl(max(no),0)+1 from HALL),'FM00'),100,15000);
select * from hall;

create or replace trigger HALL_UPDATE_TRG
AFTER UPDATE 
ON HALL
FOR EACH ROW
BEGIN
UPDATE PLAYING SET REMAIN = (REMAIN + :NEW.SEATS - :OLD.SEATS) WHERE :NEW.NO=HALL_NO;
END;
/



DROP TABLE CINEMA;
CREATE TABLE CINEMA(
no char(2),                     --PK
name varchar(30) not null,      --이름
runningtime number(3) not null, --러닝타임
status char(1) default 0        --현재상영여부
);

select * from cinema;
CALL CINEMA_STATUS_PROCEDURE();
insert into cinema(no,name,runningtime) values (TO_CHAR((select nvl(max(no),0)+1 from CINEMA),'FM00'),'test2',120);
ALTER TABLE CINEMA ADD CONSTRAINT CINEMA_NO_PK PRIMARY KEY(NO);

DROP TABLE PLAYING;
CREATE TABLE PLAYING(
no char(3),                     --PK상영작NO
hall_no char(2),                --FK상영관NO
cinema_no char(2),              --FK영화NO    
starttime date not null,        --시작시간
remain number(3) not null,      --잔여좌석
status char(1) default 0        --상영상태
);

commit;
DELETE FROM PLAYING WHERE NO = '05';
SELECT NO, HALL_NO,CINEMA_NO, TO_CHAR(STARTTIME,'MM/DD HH24:MI') AS STARTTIMESTAMP ,REMAIN,STATUS FROM PLAYING;
CALL PLAYING_STATUS_PROCEDURE();
UPDATE PLAYING SET HALL_NO = '02' WHERE NO = '003';
insert into PLAYING(no,hall_no,cinema_no,starttime,remain) values(TO_CHAR((select nvl(max(no),0)+1 from PLAYING),'FM000'),'01','02',TO_DATE('11/25 11:20','mm/dd HH24:MI'),(select seats from hall where no='01'));
ALTER TABLE PLAYING ADD CONSTRAINT PLAING_NO_PK PRIMARY KEY(NO);
ALTER TABLE PLAYING ADD CONSTRAINT PLAING_CINEMA_NO_FK FOREIGN KEY(CINEMA_NO) REFERENCES CINEMA(NO) ON DELETE SET NULL;
ALTER TABLE PLAYING ADD CONSTRAINT PLAING_HALL_NO_FK FOREIGN KEY(HALL_NO) REFERENCES HALL(NO) ON DELETE SET NULL;

DROP TABLE BOOKING;
CREATE TABLE BOOKING(
no char(5),                          --PK 
playing_no char(3),                  --FK상영작NO
customer_no char(5),                 --FK고객NO 
code char(15),                       --UQ예매 코드 생성 고객NO-상영작NO-예매NO로생성
amount number(2) not null,           --합계인원
price number(7),                     --합계가격
booking_date date not null           --예매날짜
);
UPDATE BOOKING SET AMOUNT =9 WHERE NO='00001';
INSERT INTO BOOKING(NO,PLAYING_NO,CUSTOMER_NO,AMOUNT,BOOKING_DATE) VALUES(TO_CHAR((select nvl(max(no),0)+1 from BOOKING),'FM00000'),'003','00001',3,SYSDATE);
ALTER TABLE BOOKING ADD CONSTRAINT BOOKING_NO_PK PRIMARY KEY(NO);
ALTER TABLE BOOKING ADD CONSTRAINT BOOKING_PLAYING_NO_FK FOREIGN KEY(PLAYING_NO) REFERENCES PLAYING(NO) ON DELETE CASCADE;
ALTER TABLE BOOKING ADD CONSTRAINT BOOKING_CUSTOMER_NO_FK FOREIGN KEY(CUSTOMER_NO) REFERENCES CUSTOMER(NO) ON DELETE CASCADE;
ALTER TABLE BOOKING ADD CONSTRAINT BOOKING_CODE_UQ UNIQUE(CODE);
ALTER TABLE BOOKING DROP CONSTRAINT BOOKING_CUSTOMER_NO_FK;
SELECT * FROM BOOKING;
DELETE FROM BOOKING;


----------------------------------------------------------------------------------------------------------------------트리거 영역
--BOOKING이 인서트 되면 CUSTOMER의 COUNT와 PLAYING의 REMAIN을 조절해주는 트리거.

create or replace trigger BOOKING_INSERT_TRG
BEFORE INSERT
ON BOOKING
FOR EACH ROW
DECLARE
pr number;
BEGIN
select price into pr from hall where no=(select hall_no from playing where no =:new.PLAYING_no);
UPDATE CUSTOMER SET BOOKCOUNT = nvl(BOOKCOUNT,0)+:NEW.AMOUNT WHERE NO=:NEW.CUSTOMER_NO;
UPDATE PLAYING SET REMAIN =decode(sign(REMAIN-:NEW.amount),-1,0,1,REMAIN-:NEW.amount,0) where no= :new.playing_no;
:NEW.PRICE := :NEW.AMOUNT*pr;
:NEW.CODE := :NEW.CUSTOMER_no||'-'||:NEW.PLAYING_NO||'-'||:NEW.no;
END;
/
--BOOKING이 업데이트 되면 CUSTOMER의 COUNT와 PLAYING의 REMAIN을 조절해주는 트리거. BOOKING은 업데이트시 인원수만 수정할 예정 . 예매 취소는 AMOUNT를 0으로 업데이트시 PLAYING도 바꾸려면 추가 필요.
create or replace trigger BOOKING_UPDATE_TRG
BEFORE UPDATE
ON BOOKING
FOR EACH ROW
DECLARE
pr number;
BEGIN
select price into pr from hall where no=(select hall_no from playing where no =:new.PLAYING_no);
UPDATE CUSTOMER SET BOOKCOUNT = DECODE(SIGN(nvl(BOOKCOUNT,0)-(:OLD.AMOUNT-:NEW.AMOUNT)),-1,0,1,nvl(BOOKCOUNT,0)-(:OLD.AMOUNT-:NEW.AMOUNT),0) WHERE NO=:NEW.CUSTOMER_NO;
UPDATE PLAYING SET REMAIN =decode(sign(REMAIN+(:OLD.AMOUNT-:NEW.amount)),-1,0,1,REMAIN+(:OLD.AMOUNT-:NEW.amount),0) where no= :new.playing_no;
:NEW.CODE := :NEW.CUSTOMER_no||'-'||:NEW.PLAYING_NO||'-'||:NEW.no;
:NEW.PRICE := :NEW.AMOUNT*pr;
END;
/

--PLAYING이 업데이트 시에 상영관이 바뀌면 바뀐 상영관에 맞춰서 잔여 좌석수를 조절해주는 트리거 
create or replace Trigger PLAYING_UPDATE_TRG
BEFORE UPDATE 
ON PLAYING
FOR EACH ROW
when(old.Hall_no!= new.Hall_no)
DECLARE
NEWSEATS NUMBER;
OLDSEATS NUMBER;
BEGIN
SELECT SEATS INTO NEWSEATS FROM HALL WHERE :NEW.HALL_NO=NO;
SELECT SEATS INTO OLDSEATS FROM HALL WHERE :OLD.HALL_NO=NO;
:NEW.REMAIN := :OLD.REMAIN+NEWSEATS-OLDSEATS;
END;
/
delete from booking where no = '002';
--playing이 추가되면 해당 상영관에 맞춰서 잔여 좌석수를 넣어주는 트리거
DROP TRIGGER PLAYING_INSERT_TRIGGER;
create or replace trigger PLAYING_INSERT_TRIGGER
BEFORE INSERT
on playing
for each row
declare
newseats number;
begin
select seats into newseats from HALL where no=:new.no;
:new.remain := newseats;
end;
/
insert into playing() values
----------------------------------------------------------------------------------------------------------------------------------------프로시저 영역

--PLAYING의 시작시간+영화러닝타임이 SYSDATE 보다 커지면 STATUS를 NULL로 바꿔주는 프로시저, 그에따라 NULL이 되는 BOOKING또한 삭제
SELECT TO_CHAR(TO_DATE('11:20','HH24:MI')+120/24/60,'HH24:MI') FROM DUAL;
DROP PROCEDURE PLAYING_DELETE_PROCEDURE;
CALL PLAYING_STATUS_PROCEDURE();
CREATE OR REPLACE PROCEDURE PLAYING_STATUS_PROCEDURE
IS
BEGIN
UPDATE PLAYING P SET STATUS=NULL WHERE STARTTIME+((SELECT RUNNINGTIME FROM CINEMA WHERE P.CINEMA_NO= NO)/24/60)<=SYSDATE;
UPDATE PLAYING P SET STATUS=0 WHERE STARTTIME+((SELECT RUNNINGTIME FROM CINEMA WHERE P.CINEMA_NO= NO)/24/60)>=SYSDATE;
UPDATE PLAYING P SET STATUS=1 WHERE STARTTIME<=SYSDATE and STARTTIME+((SELECT RUNNINGTIME FROM CINEMA WHERE P.CINEMA_NO= NO)/24/60)>=SYSDATE;
END;
/
select * from PLAYiNG;
select * from user_constraints;
alter table playing drop constraint SYS_C008646;
--PLAYING TABLE에 null 이 아닌 데이터중에 해당 영화의 CODE가 존재하지 않으면 STATUS를 NULL로 바꿔주는 프로시저
CREATE OR REPLACE PROCEDURE CINEMA_STATUS_PROCEDURE
IS
BEGIN
UPDATE CINEMA C SET STATUS=NULL WHERE NOT EXISTS (SELECT * FROM PLAYING WHERE C.NO=CINEMA_NO and status is not null);
UPDATE CINEMA C SET STATUS=0 WHERE EXISTS (SELECT * FROM PLAYING WHERE C.NO=CINEMA_NO and status is not null);
END;
/
------------------------------------------------------------------------------------------------------ 뷰영역
--booking, hall, playing. cinema가 합쳐진 뷰 생성
CREATE or replace VIEW BOOKING_PLAYING_CINEMA_HALL_JOIN AS
select b.NO,h.pno, PLAYING_NO,CUSTOMER_NO,CODE,AMOUNT,PRICE,BOOKING_DATE,NAME,starttime
from Booking b 
join (SELECT p.no, C.NAME  FROM PLAYING P join cinema C On C.NO=P.CINEMA_NO) p  
on b.PLAYING_NO= p.no
join (SELECT p.no as pno, H.NO as hno,STARTTIME  FROM PLAYING P join HALL h On h.NO=p.HALL_NO) H
on h.pno=p.no 
; 

SELECT p.no C.NAME  FROM PLAYING P join cinema C On C.NO=P.CINEMA_NO  ORDER BY NO;

select b.NO,h.pno, PLAYING_NO,CUSTOMER_NO,CODE,AMOUNT,PRICE,BOOKING_DATE,NAME ,starttime
from Booking b 
join (SELECT p.no, C.NAME  FROM PLAYING P join cinema C On C.NO=P.CINEMA_NO) p  
on b.PLAYING_NO= p.no
join (SELECT p.no as pno, H.NO as hno,STARTTIME  FROM PLAYING P join HALL h On h.NO=p.HALL_NO) H
on h.pno=p.no 
; 

COMMIT;