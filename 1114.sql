select first_name, hire_Date,department_name
from employees e
join departments d
using(department_id)
where department_id=30;

select department_name, first_name,SALARY
from employees e 
join departments d
on e.department_id=d.department_id
where salary = (select max(salary) from employees c where e.department_id=c.department_id);

select * from employees