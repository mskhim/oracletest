select *from tab;
--이 데이터 베이스의 테이블들
desc employees;
-- employees의 테이블 구조(멤버변수와 타입을 보여달라)
select * from employees;
--employees 속에 들어있는 records(객체들)를 보여달라.
select * from departments;
--departments 부분의 recoreds를 확인하자.
desc departments;
--departments 부분의구조를 확인하자.
select department_id, department_name from departments;
--departments_id,departments_name만 출력 되게
select department_id as "부서번호", department_name as "부서명" from departments;
select department_id as DEP_NO, department_name as DEP_NAME from departments;
select department_id as "DEP NO", department_name as "DEP NAME" from departments;
--필드명에 별칭 사용하기
select 5 + 5 from dual;
select 5 || 5 from dual;
desc dual;
select * from dual;
select 5 + 5 from employees;
select first_name, job_id from employees;
select first_name||'의 직급은 ' ||job_id||'입니다.' as "이름과 직급" from employees;
--+와 ||
select DISTINCT job_id from employees;
--중복되지 않게 보여주기 distinct
--<문제> EMPLOYEES 테이블의 모든 내용 출력 
SELECT * FROM EMPLOYEES;
--<문제> 사원의 이름과 급여와 입사일자 만을 출력하는 SQL 문을 작성해보자.
SELECT FIRST_NAME|| LAST_NAME AS NAME , SALARY, HIRE_DATE FROM EMPLOYEES;
--<문제>직원들이 어떤 부서에 소속되어 있는지 소속 부서번호(DEPARTMENT_ID) 출력하되 중복되지 않고 
--한번씩 출력하는 쿼리문을 작성하자. 