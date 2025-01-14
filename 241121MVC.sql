SELECT * FROM STUDENT;
DROP TABLE STUDENT;
CREATE TABLE STUDENT3(
    NO NUMBER(4),
    NAME VARCHAR2(20) NOT NULL,
    KOR NUMBER(4) NOT NULL,
    ENG NUMBER(4)NOT NULL,
    MAT NUMBER(4)NOT NULL,
    TOTAL NUMBER(4),
    AVE NUMBER(5,1),
    RANK NUMBER(4)
);
 
ALTER TABLE STUDENT3 ADD CONSTRAINT STUDENT3_NO_PK PRIMARY KEY(NO);
insert
DROP SEQUENCE STUDENT3_STUNUM_SEQ;
CREATE SEQUENCE STUDENT3_NO_SEQ
START WITH 1
INCREMENT BY 1;
commit;



SELECT * FROM STUDENT3;

-- 성적을 입력하면 총점과 평균이 자동 계산되어 입력되는 트리거
CREATE OR REPLACE TRIGGER STUDENT3_INSERT_TRIGGER
BEFORE INSERT ON STUDENT3
FOR EACH ROW
BEGIN
    :NEW.TOTAL := :NEW.KOR + :NEW.ENG + :NEW.MAT;
    :NEW.AVE := ROUND((:NEW.KOR + :NEW.ENG + :NEW.MAT) / 3, 1);
END;
/

-- 성적을 수정하면 총점과 평균이 같이 변하는 트리거
CREATE OR REPLACE TRIGGER STUDENT3_update_TRIGGER
BEFORE UPDATE ON STUDENT3
FOR EACH ROW
BEGIN
    :NEW.TOTAL := :NEW.KOR + :NEW.ENG + :NEW.MAT;
    :NEW.AVE := ROUND((:NEW.KOR + :NEW.ENG + :NEW.MAT) / 3, 1);
END;
/

-- 등수를 처리하는 저장 프로시저 생성
CREATE OR REPLACE PROCEDURE STUDENT3_RANK_PROC
IS 
    VSTUDENT_RT STUDENT3%ROWTYPE; 
    CURSOR C1 IS
    SELECT NO, NAME, TOTAL, RANK() OVER(ORDER BY TOTAL DESC) RANK FROM STUDENT3 ORDER BY TOTAL DESC; 
BEGIN
    FOR  VSTUDENT_RT IN C1 LOOP
        UPDATE STUDENT3 SET RANK = VSTUDENT_RT.RANK WHERE NO =  VSTUDENT_RT.NO; 
        COMMIT;
    END LOOP;
    COMMIT;
END;
/
SELECT * FROM STUDENT3 ORDER BY RANK;
EXECUTE STUDENT_RANK_PROC;
