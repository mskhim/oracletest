DECLARE
TYPE NAME_TABLE_TYPE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE
INDEX BY BINARY_INTEGER;
TYPE JOB_TABLE_TYPE IS TABLE OF EMPLOYEES.JOB_ID%TYPE
INDEX BY BINARY_INTEGER;
TYPE DEPNO_TABLE_TYPE IS TABLE OF EMPLOYEES.DEPARTMENT_ID%TYPE
INDEX BY BINARY_INTEGER;
NAME_TABLE NAME_TABLE_TYPE;
JOB_TABLE JOB_TABLE_TYPE;
DEPNO_TABLE DEPNO_TABLE_TYPE; 
ROW_TABLE EMPLOYEES%ROWTYPE;
I BINARY_INTEGER:=1;
BEGIN
FOR ROW_TABLE IN (SELECT * FROM EMPLOYEES) LOOP
NAME_TABLE(I) := ROW_TABLE.FIRST_NAME;
JOB_TABLE(I) := ROW_TABLE.JOB_ID;
DEPNO_TABLE(I) := ROW_TABLE.DEPARTMENT_ID;
DBMS_OUTPUT.PUT_LINE(I||'번째/'||NAME_TABLE(I)||'/'||JOB_TABLE(I)||'/'||DEPNO_TABLE(I));
I:=I+1;
END LOOP;
END;
/
--수잔이름을 갖는 사원의사원번호와 사원명과 부서번호 출력
DECLARE
VEMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
VNAME EMPLOYEES.FIRST_NAME%TYPE;
VDEPARTMENY_ID EMPLOYEES.DEPARTMENT_ID%TYPE;
BEGIN
SELECT EMPLOYEE_ID, FIRST_NAME,DEPARTMENT_ID INTO VEMPLOYEE_ID,VNAME,VDEPARTMENY_ID FROM EMPLOYEES WHERE FIRST_NAME ='Susan';
DBMS_OUTPUT.PUT_LINE(VEMPLOYEE_ID||'/'||VNAME||'/'||VDEPARTMENY_ID);
END;
/
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 