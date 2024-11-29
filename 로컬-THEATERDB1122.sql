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
insert into Customer values(0001, 'admin','admin','admin',null,null,0,sysdate,'admin');
alter table CUSTOMER modify right varchar2(10);
Commit;
SELECT COUNT(*) AS CHK FROM CUSTOMER WHERE ID = 'kon';
insert into CUSTOMER(no, NAME, ID, PWD, REGISTDATE) VALUES(to_char((select nvl(max(no),0)+1 from CUSTOMER),'FM00000'),DBMS_RANDOM.string('U',5),DBMS_RANDOM.string('U',10),DBMS_RANDOM.string('U',10),sysdate);
delete from HALL;
select * from customer;
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_NO_PK PRIMARY KEY(NO);
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_ID_UQ UNIQUE(ID);
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_PHONE_UQ UNIQUE(PHONE);
update customer set no ='00001' where name='admin';


DROP TABLE HALL;
CREATE TABLE HALL(            --상영관
NO CHAR(2),                   --PK
SEATS NUMBER(3) NOT NULL,     --좌석수
PRICE NUMBER(6) NOT NULL      --상영료
);
SELECT * FROM HALL;
alter table Hall modify rowcol number(3);
alter table Hall rename column  rowcol  to rowx;
alter table Hall add  coly number(3);

insert into hall values('01',100,15000,'10X10');
drop table seats;
delete from hall;
ALTER TABLE HALL ADD CONSTRAINT HALL_NO_PK PRIMARY KEY(NO);
insert into hall values(to_char((select nvl(max(no),0)+1 from HALL),'FM00'),100,15000,10,10);

create table seats(
PLAYING_NO CHAR(3),
HALL_NO CHAR(2),
X varCHAR2(3) NOT NULL,
Y varCHAR2(3) NOT NULL,
CUSTOMER_NO CHAR(5),
constraint SEATS_PLAYING_NO_PK PRIMARY KEY(PLAYING_NO,X,Y)
);
alter table seats add BOOKING_NO CHAR(5);
alter table seats add constraint SEATS_BOOKING_NO_FK FOREIGN KEY(BOOKING_NO) references BOOKING(no) on delete cascade;

alter table seats add constraint SEATS_HALL_NO_FK FOREIGN KEY(HALL_NO) references HALL(no) on delete cascade;
alter table seats add constraint SEATS_PLAYING_NO_FK FOREIGN KEY(PLAYING_NO) references PLAYING(no) on delete cascade;
alter table seats add constraint SEATS_CUSTOMER_NO_FK FOREIGN KEY(CUSTOMER_NO) references CUSTOMER(no) on delete set null;
commit;
delete from playing;

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
status char(1)        --현재상영여부
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
select * from playing;
select * from seats;
commit;
DELETE FROM PLAYING;
SELECT NO, HALL_NO,CINEMA_NO, TO_CHAR(STARTTIME,'MM/DD HH24:MI') AS STARTTIMESTAMP ,REMAIN,STATUS FROM PLAYING;
CALL PLAYING_STATUS_PROCEDURE();
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
SELECT * FROM seats;
DELETE FROM playing;
commit;
----------------------------------------------------------------------------------------------------------------------트리거 영역
--상영정보가 추가되면 그에 맞는 좌석을 SEATS에 세팅
CREATE OR REPLACE TRIGGER SEATS_UPDATE_TRIGGER
after insert
ON PLAYING
FOR EACH ROW
DECLARE
    X NUMBER(3);
    Y NUMBER(3);
    
BEGIN
-- HALL 테이블에서 XY 값을 가져옴
SELECT rowx, coly INTO X,Y FROM HALL WHERE NO = :NEW.HALL_NO;
    -- X와 Y 값을 추출

FOR i IN ASCII('A') .. (ASCII('A') + X - 1) LOOP
FOR j IN 1 .. Y LOOP
INSERT INTO SEATS VALUES (:NEW.NO, :NEW.HALL_NO, CHR(i), TO_CHAR(j,'FM00'), NULL,null);
END LOOP;
END LOOP;
END;
/
-- HALL이 추가됐을때 SEATS수를 조정
CREATE OR REPLACE TRIGGER HALL_U_I_TRG
BEFORE INSERT
ON HALL
FOR EACH ROW
BEGIN
:NEW.SEATS := :NEW.ROWX*:NEW.COLY;
END;
/

CREATE OR REPLACE TRIGGER HALL_I_U_TRG
BEFORE UPDATE
ON HALL
FOR EACH ROW
BEGIN
:NEW.SEATS := :NEW.ROWX*:NEW.COLY;
END;
/
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
select * from booking;
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
--booking에 모든 것 조인 합쳐진 뷰 생성
  CREATE OR REPLACE VIEW BOOKING_PLAYING_CINEMA_HALL_JOIN
  AS 
SELECT B.NO, playing_no,customer_no,code,amount,price,booking_date,P.NAME AS cinename,starttime,P.status,h.hno,cus.NAME AS cusname
FROM booking B 
JOIN (SELECT P.NO, C.NAME, P.status  FROM playing P JOIN cinema C ON C.NO=P.cinema_no) P  
ON B.playing_no= P.NO
JOIN (SELECT P.NO AS PNO, h.NO AS hno,starttime  FROM playing P JOIN hall h ON h.NO=P.hall_no) h
ON h.PNO=P.NO 
JOIN customer cus
ON cus.NO=B.customer_no
;


SELECT B.NO,h.PNO, playing_no,customer_no,code,amount,price,booking_date,NAME ,starttime
FROM booking B 
JOIN (SELECT P.NO, C.NAME  FROM playing P JOIN cinema C ON C.NO=P.cinema_no) P  
ON B.playing_no= P.NO
JOIN (SELECT P.NO AS PNO, h.NO AS hno,starttime  FROM playing P JOIN hall h ON h.NO=P.hall_no) h
ON h.PNO=P.NO 
; 
select DISTINCT S.PLAYING_NO, S.X, S.Y ,S.CUSTOMER_NO, b.no from seats s join Booking b on b.CUSTOMER_NO=S.CUSTOMER_NO WHERE S.CUSTOMER_NO = TO_CHAR(11,'FM00000') ;


COMMIT;