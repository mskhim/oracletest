--테이블 설계하기(사원번호, 사원명, 급여):DDL
--class EMP01{
--public int no;
--public String name;
--public DOUBLE salary
--};
CREATE TABLE EMP01 (
    NO NUMBER(4) NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    SALARY NUMBER(7,2) DEFAULT 1000.0,
    CONSTRAINT EMP01_NO_PK PRIMARY KEY (NO),
    CONSTRAINT EMP01_NAME_UK UNIQUE (NAME)
);
--테이블 정보 구하기
SELECT * FROM  EMP01;
