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
select DISTINCT DEPARTMENT_ID from employees;
--2008년 이후에 입사한 직원조사
select * from employees where HIRE_DATE<=TO_DATE('2008/01/01','YYYY/MM/DD HH24:MI:SS') order by HIRE_DATE;
-------------------------------------------------------------------------------
select * from employees where  LAST_NAME LIKE 'A%' OR LIKE 'B%' OR LIKE 'C%');


-------------------------------------------------------------------------------
select '사번 : '||employee_id||', 이름 : '||first_name||last_name 샘, salary from employees where salary >=3000;
--<문제> EMPLOYEES 테이블에서 부서번호가 110번인 직원에 관한 모든 정보만 출력하라.
select * from employees where employee_id ='110';
--<문제> EMPLOYEES 테이블에서 급여가 5000미만이 되는 직원의 정보 중에서 사번과 이름, 급여를 출력 
--하라. 
select EMPLOYEE_ID,FIRST_NAME,LAST_NAME ,SALARY from employees where salary<5000;
--<문제> 이름이 John인 사람의 직원번호와 직원명과 직급을 출력하라. 
select EMPLOYEE_ID,FIRST_NAME,LAST_NAME,JOB_ID from employees where First_NAME='John';
--<문제>급여가 5000에서 10000이하 직원 정보 출력 
select * from employees where salary>=5000 AND salary <=10000;
--<문제> 직원번호가 134이거나 201이거나 107인 직원 정보 출력
select * from employees where EMPLOYEE_ID=134 OR EMPLOYEE_ID=201 OR EMPLOYEE_ID=107;
--<문제> 급여가 2500에서 4500까지의 범위에 속한 직원의 직원번호, 이름, 급여를 출력하라. 
--(AND 연산자와 BETWEEN AND 연산자 사용 두개모두 사용해서 보여줄것) 
select EMPLOYEE_ID,FIRST_NAME,SALARY from employees where salary BETWEEN 2500 AND 4500;
--<문제> 이름에 a를 포함하지 않은 직원의 직원번호, 이름을 출력하라. 
select EMPLOYEE_ID,FIRST_NAME,last_name from employees where first_name not like'%a%';
--<문제> 자신의 직속상관이 없는 직원의 전체 이름과 직급과 직원번호을 출력하라 
select EMPLOYEE_ID,FIRST_NAME,last_name,JOB_ID from employees where manager_id is null;
--<문제> 직원번호, 이름, 급여를 급여가 높은 순으로 출력하라.
select EMPLOYEE_ID,FIRST_NAME,last_name,salary from employees order by salary desc;
--<문제> 입사일이 가장 최근인 직원 순으로 직원번호, 이름, 입사일을 출력하라. 
select EMPLOYEE_ID,FIRST_NAME,last_name,HIRE_DATE from employees order by HIRE_DATE;
desc employees;

