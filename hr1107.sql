--
create table emp03
as
select * from employees;
select * from emp03;  
select * from DEPARTMENTS;
update emp03 set DEPARTMENT_ID='30';
ROllBACK;
update emp03 set salary=salary*1.1;
update emp03 set HIRE_DATE=sysdate;

update emp03 set DEPARTMENT_ID=30 where DEPARTMENT_ID=10;
update emp03 set SALARY=SALARY*1.1 WHERE SALARY>=3000;'

select e.FIRST_NAME, dp.DEPARTMENT_NAME, dp.department_id, 
case
when dp.DEPARTMENT_NAME='Marketing' then salary*1.05
when dp.DEPARTMENT_NAME='Purchasing' then salary*1.1
when dp.DEPARTMENT_NAME='Human Resources' then salary*1.15
when dp.DEPARTMENT_NAME='IT' then salary*1.20
else salary
end newsalary
,salary "기존 급여"
FROM employees e join DEPARTMENTS dp 
on e.DEPARTMENT_ID=dp.DEPARTMENT_ID
order by newsalary
;