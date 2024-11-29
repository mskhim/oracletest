select * from user_constraints where table;
--월급이 13000 이상인 사람의 부서
select department_name from departments 
where department_id in (select department_id from employees where salary>=13000 );
SELECT FIRST_NAME, JOB_ID, SALARY 
FROM EMPLOYEES 
WHERE SALARY IN ( SELECT SALARY 
FROM EMPLOYEES 
WHERE FIRST_NAME IN ('Susan', 'Lex')) AND 
(FIRST_NAME <> 'Susan' AND FIRST_NAME <> 'Lex'); 

--한명이상으로부터 보고를 받을수 있는 직원은 직원번호 이름, 업무, 부서번호
select *from employees;
select employee_id, JOB_ID,first_name,department_id from employees
where employee_id in (select manager_id from employees);
--문제 2 Accouumting 부서에서 근무하는 직원의 같은 업무를 하는 직원의 이름
select First_name, JOB_ID ,department_id from employees 
where DEPARTMENT_ID=(select department_id from departments where UPPER(department_name)=UPPER('sales'));


select * from departments ;

select First_name, JOB_ID ,department_id from employees 
where JOB_ID in (select job_id from employees where department_id = (select department_id from departments where UPPER(department_name)=UPPER('Accounting')));

--문제3 
select first_name, salary from employees 
where salary >= any(select salary from employees where upper(job_id)=upper('ST_MAN')) 
and department_id<>20;
--문제 4
select * from EMPLOYEES 
where SALARY = (select salary from employees where first_name='Valli') 
and JOB_ID = (select JOB_ID from employees where first_name='Valli')
and first_name<>'Valli';

--문제5
select department_id, first_name, salary from employees 
where salary > (select avg(salary) from employees where department_id= (select department_id from employees where first_name='Valli')); 

SELECT * 
FROM DEPARTMENTS d
WHERE EXISTS ( SELECT * 
FROM EMPLOYEES e
WHERE  d.DEPARTMENT_ID = e.DEPARTMENT_ID); 


drop table dep11;
create table dep11
as 
select*from departments
where 1=0;
insert into dep11 
select * from departments
;
select * from dep11;
update dep11 set Location_ID=300;

update dep11
set department_name = (select department_name from dep11 where department_id=30),
    LOCATiON_ID= (select LOCATiON_ID from dep11 where department_id=30)
    where department_id = 20;
    
-------------------------------------과제
--샘플 문제 1
select first_name||' '||last_name Name , JOB_ID,SALARY from employees 
where salary > (select salary from employees where last_name='Tucker');
--문제 1 업무별 최소 급여 도출 혹은 업무별로 최소급여 받고있는 사람 출력

select first_name||' '||last_name Name , job_id, salary, hire_date from employees e
where salary in(select min(salary) from employees d where e.job_id=d.job_id) ;

select E.first_name||' '||E.last_name Name , E.job_id, E.salary, E.hire_date from employees E
JOIN (SELECT C.JOB_ID,min(C.salary) AS min_salary FROM EMPLOYEES C GROUP BY C.JOB_ID) D
ON E.JOB_ID=D.JOB_ID
WHERE E.SALARY=D.min_salary;

WHERE E.SALARY=D.min(salary) AND E.JOB_ID=D.JOB_ID (SELECT JOB_ID,min(salary) FROM EMPLOYEES GROUP BY JOB_ID) AS D

--문제2
select first_name||' '||last_name Name ,salary,department_id,job_id from employees e
where salary > (select avg(salary) from employees d where e.department_id=d.department_id);

--문제3
select  first_name||' '||last_name Name ,job_id,salary,department_id, (select round(avg(salary),2) from employees d where e.department_id=d.department_id) "department Avg Salary" 
from employees e;

SELECT first_name, last_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM departments d
    WHERE e.department_id = d.department_id
);