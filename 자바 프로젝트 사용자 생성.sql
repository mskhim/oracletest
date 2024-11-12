create TABLESPACE firstdata--사용자가 정의한 테이블 스페이스
datafile 'C:\oraclexe\oradata\XE\first01.dbf' size 10M; 
ALTER TABLESPACE firstdata--용량이 부족한 테이블 스페이스 크기 확장
add datafile 'C:\oraclexe\oradata\XE\first02.dbf' size 10M;
ALTER database--용량이 부족한 테이블스페이스 용량늘리기
--용량 자동으로 늘어나도록 설정
datafile 'C:\oraclexe\oradata\XE\first02.dbf' resize 15M;
alter database
datafile 'C:\oraclexe\oradata\XE\first02.dbf'
autoextend on
next 1M
maxsize 20M;

--자바프로젝트를 위해서 사용자 만들기 계정, 테이블스페이스(javadata),파일명(app_data.dbflogmnr$key_gg_tabf_public) 생성
create TABLESPACE javadata
datafile 'C:\oraclexe\oradata\XE\app_data.dbf' size 20M
autoextend on
next 3M
MAXSIZE 500M;

--자바프로젝트 사용자 계정 생성하기
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
DROP USER JAVAUSER CASCADE; -- 기존 사용자 삭제
CREATE USER JAVAUSER IDENTIFIED BY 123456 -- 사용자 이름: Model, 비밀번호 : 1234
    DEFAULT TABLESPACE javadata
    TEMPORARY TABLESPACE TEMP;
GRANT connect, resource, dba TO JAVAUSER; -- 권한 부여

