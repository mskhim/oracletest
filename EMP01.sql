--테이블 설계하기(사원번호, 사원명, 급여):DDL
--class EMP01{
--public int no;
--public String name;
--public DOUBLE salary
--};
CREATE TABLE EMP01 (
    NO NUMBER(4) NOT NULL,
    NAME VARCHAR2(20) DEFAULT 'KMS',
    SALARY NUMBER(7,2) DEFAULT 1000.0,
    CONSTRAINT EMP01_NO_PK PRIMARY KEY (NO),
    CONSTRAINT EMP01_NAME_UK UNIQUE (NAME),
    CONSTRAINT EMP01_SALARY_UK UNIQUE (SALARY)
);
DESC EMP01;