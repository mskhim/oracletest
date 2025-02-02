
DECLARE
NUM NUMBER(15);
SUM_SALARY NUMBER(15);
AVG_SALARY NUMBER(15,2);
BEGIN
SELECT COUNT(*), SUM(SALARY), ROUND(AVG(SALARY),2) INTO NUM, SUM_SALARY, AVG_SALARY FROM EMPLOYEES;
DBMS_OUTPUT.PUT_LINE('총 사원의 수 : '||NUM);
DBMS_OUTPUT.PUT_LINE('급여의 합 : '||SUM_SALARY);
DBMS_OUTPUT.PUT_LINE('급여의 평균 : '||AVG_SALARY);
END;
/

DECLARE
ROW_TABLE EMPLOYEES%ROWTYPE;
DNAME_TABLE DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
SELECT * INTO ROW_TABLE FROM EMPLOYEES WHERE FIRST_NAME ='Clara';
SELECT DEPARTMENT_NAME INTO DNAME_TABLE FROM DEPARTMENTS WHERE DEPARTMENT_ID=ROW_TABLE.DEPARTMENT_ID;
DBMS_OUTPUT.PUT_LINE('직무 : '|| ROW_TABLE.JOB_ID);
DBMS_OUTPUT.PUT_LINE('급여 : '|| ROW_TABLE.SALARY);
DBMS_OUTPUT.PUT_LINE('입사일자 : '|| ROW_TABLE.HIRE_DATE);
DBMS_OUTPUT.PUT_LINE('커미션 : '|| ROW_TABLE.COMMISSION_PCT);
DBMS_OUTPUT.PUT_LINE('부서명 : '|| DNAME_TABLE);
END;
/

BEGIN
FOR  I IN 2..9 LOOP
DBMS_OUTPUT.PUT_LINE('-------'||I||'단');
FOR J IN 1..9 LOOP
DBMS_OUTPUT.PUT_LINE(I||' X '||J||' = '||I*J);
END LOOP;
END LOOP;
END;
/

DECLARE
TYPE ROW_TABLE_TYPE IS TABLE OF DEPARTMENTS%ROWTYPE
INDEX BY BINARY_INTEGER;
ROW_TABLE ROW_TABLE_TYPE;
I NUMBER:=1;
CURSOR C1
IS
SELECT * FROM DEPARTMENTS;
BEGIN
OPEN C1;
LOOP
FETCH C1 INTO ROW_TABLE(I);
EXIT WHEN C1%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(ROW_TABLE(I).DEPARTMENT_ID||'/'||ROW_TABLE(I).DEPARTMENT_NAME);
I:=1+I;
END LOOP;
END;
/

--EMPLOYEES 테이블에서 요구한 부서별 정보를 커서에 저장하고 출력

DECLARE
TYPE DE_REC IS RECORD(
ROW_REC EMPLOYEES%ROWTYPE,
DEPARTMENT_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE
)
INDEX BY BINARY_INTEGER;
ROW_TABLE DE_REC;
CURSOR C1
IS
SELECT E.*,DEPARTMENT_NAME  FROM DEPARTMENTS D JOIN EMPLOYEES E ON E.DEPARTMENT_ID=D.DEPARTMENT_ID WHERE E.DEPARTMENT_ID=30;
BEGIN
FOR ROW_TABLE IN C1 LOOP
DBMS_OUTPUT.PUT_LINE(ROW_TABLE.EMPLOYEE_ID||'/'|| ROW_TABLE.FIRST_NAME||'/'||ROW_TABLE.DEPARTMENT_ID||'/'||ROW_TABLE.DEPARTMENT_NAME);
END LOOP;
END;
/


