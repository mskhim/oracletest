--사용자이름을 패턴으로 검색한뒤 해당하는 사용자 정보를 보여주세요

CREATE OR REPLACE PROCEDURE EMPPROC
IS
CURSOR C1(ALP VARCHAR)
IS
SELECT * FROM EMPLOYEES WHERE UPPER(FIRST_NAME) LIKE'%'||ALP||'%';
ALP VARCHAR2(1);
ROW_TABLE EMPLOYEES%ROWTYPE;
BEGIN
ALP:=DBMS_RANDOM.STRING('U',1);
DBMS_OUTPUT.PUT_LINE('알파벳 '||ALP||'가 들어가는 직원의 정보.');
FOR ROW_TABLE IN C1(ALP) LOOP
DBMS_OUTPUT.PUT_LINE(ROW_TABLE.FIRST_NAME||'/'||ROW_TABLE.EMPLOYEE_ID||'/'||ROW_TABLE.SALARY);
END LOOP;
END;
/
EXECUTE EMPPROC;
--프로시저를 통해서 사원번호를 입력하면 사원 이름, 월급, 직책 매개변수를 통해서 전달.
CREATE OR REPLACE PROCEDURE EMPPROC2(
VEMPNO IN EMPLOYEES.EMPLOYEE_ID%TYPE,
VNAME OUT EMPLOYEES.FIRST_NAME%TYPE,
VSALARY OUT EMPLOYEES.SALARY%TYPE,
VJOB OUT EMPLOYEES.JOB_ID%TYPE
)
IS

BEGIN
SELECT FIRST_NAME, SALARY, JOB_ID INTO VNAME,VSALARY,VJOB FROM EMPLOYEES WHERE EMPLOYEE_ID = VEMPNO;

END;
/
DECLARE
TYPE RT IS TABLE OF EMPLOYEES%ROWTYPE
INDEX BY BINARY_INTEGER;
   REMP RT;
BEGIN
EMPPROC2(
100,
REMP(1).FIRST_NAME,
REMP(1).SALARY,
REMP(1).JOB_ID
);
DBMS_OUTPUT.PUT_LINE(REMP(1).FIRST_NAME||'/'||REMP(1).SALARY||'/'||REMP(1).JOB_ID);
END;
/

VARIABLE VNAME1 VARCHAR2(100)
VARIABLE VSALARY1 NUMBER
VARIABLE VJOBID1 VARCHAR2(100)
VARIABLE VJOBID2 VARCHAR2(100)
EXECUTE EMPPROC2(100,:VNAME1,:VSALARY1,:VJOBID1);
PRINT VNAME1;
CREATE OR REPLACE PROCEDURE INOUT_PROC(VSALARY IN OUT VARCHAR2)
IS
BEGIN
VSALARY:=TO_CHAR(VSALARY,'$999,999,999');
END;

DECLARE
SALARY VARCHAR2(100);
BEGIN
SALARY:='1234567';
INOUT_PROC(SALARY);
DBMS_OUTPUT.PUT_LINE(SALARY);
END;
/