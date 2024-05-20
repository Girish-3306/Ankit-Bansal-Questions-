use namasteyoutube;

create table emp_compensation (
emp_id int,
salary_component_type varchar(20),
val int
);
insert into emp_compensation
values (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10)
, (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8)
, (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);

select * from emp_compensation;

-- SQL Convert Rows to Columns and Columns to Rows without using Pivot Functions
Select DISTINCT salary_component_type from emp_compensation
-- THIS IS PIVOT
Select 
emp_id,
sum(CASE WHEN salary_component_type = 'salary' then val END) salary
,sum(CASE WHEN salary_component_type = 'hike_percent' then val END) hike_percent
,sum(CASE WHEN salary_component_type = 'bonus' then val END) bonus
from emp_compensation
group by emp_id

-- NOW LET"S UNPIVOT

Select 
emp_id,
sum(CASE WHEN salary_component_type = 'salary' then val END) salary
,sum(CASE WHEN salary_component_type = 'hike_percent' then val END) hike_percent
,sum(CASE WHEN salary_component_type = 'bonus' then val END) bonus
INTO emp_compensation_pivot
from emp_compensation
group by emp_id


Select emp_id,'salary'  as salary_component_type, salary as val  from emp_compensation_pivot
UNION ALL
Select emp_id,'hike_percent'  as salary_component_type, hike_percent as val  from emp_compensation_pivot
UNION ALL
Select emp_id,'bonus'  as salary_component_type, bonus as val  from emp_compensation_pivot

-- Interview Questions 
create table emp1(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int,
    manager_id int,
    emp_age int
);


insert into emp1 values(1,'Ankit',100,10000,4,39);
insert into emp1 values(2,'Mohit',100,15000,5,48);
insert into emp1 values(3,'Vikas',100,10000,4,37);
insert into emp1 values(4,'Rohit',100,5000,2,16);
insert into emp1 values(5,'Mudit',200,12000,6,55);
insert into emp1 values(6,'Agam',200,12000,2,14);
insert into emp1 values(7,'Sanjay',200,9000,2,13);
insert into emp1 values(8,'Ashish',200,5000,2,12);
insert into emp1 values(9,'Mukesh',300,6000,6,51);
insert into emp1 values(10,'Rakesh',500,7000,6,50);
insert into emp1 values(1,'Rakesh',500,7000,6,50);
select * from emp1;



-- 1] How to find duplicates in given table 
Select emp_id ,COUNT(1) as no_of_records
from employee
group by emp_id
having COUNT(1) > 1;

Select emp_id,
ROW_NUMBER() over(partition by emp_id order by emp_id) as no_of_records
from employee

--2] How to delete duplicates
WITH CTE as(
Select  *,
ROW_NUMBER() over( partition by emp_id order by emp_id)as rn 
from employee)

DELETE FROM CTE where rn > 1 

select * from employee;

-- Q3 Difference between UNION and UNION ALL

 --Union all will give all the records from both the table
 -- It will keep the duplicates
 Select manager_id from employee 
 UNION ALL
 Select manager_id from emp1;

 -- UNIQUE will only give unique values 
 -- It removes the duplicate 
 Select manager_id from employee 
 UNION
 Select manager_id from emp1;

 -- Q4 Difference betwwen rank, row_number & dense_rank

 --Q5 Employee who are not present in department table 
 create table dept(
    dep_id int,
    dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');

select * from employee;
select * from dept;
-- Over here we can see that dept_id 500 is not there in dept table

Select *
from employee e
LEFT join dept d on e.dept_id = d.dep_id
where d.dep_id is NULL ;

Select * from employee
where dept_id not in (Select dep_id from dept);


-- Q6 Second highest salary in deptartment

select * from employee;
select * from dept;
WITH CTE AS(
Select  *,
DENSE_RANK() over(partition by dept_id order by salary DESC) as rnk
from employee e
LEFT join dept d on e.dept_id = d.dep_id)

Select * 
from CTE
where rnk = 2

--Q7 Find all transactions done by Shilpa
Select * from Orders
where UPPER(customer_name) LIKE 'SHILPA';

--Q8 Self join, Manager salary > emp salary

Select * from employee e1
inner join employee e2 on e1.manager_id = e2.emp_id;

Select e2.salary as manager_salary,e2.emp_name as manager,e1.emp_name as emp , e1.salary as emp_salary
from employee e1
inner join employee e2 on e1.manager_id = e2.emp_id
where e2.salary > e1.salary;

--Q10 Update query to swap genders 


---------------------------------------------------------------------------------------------------------------------------
-- How to Practise SQL withiut creating tables 

with employee as (
Select 1 as emp_id, 1000 as emp_salary, 1 as dep_id
UNION ALL Select 2 as emp_id, 2000 as emp_salary, 2 as dep_id
)

-----------------------------------------------------------------------------------------------------------------------
-- Find employee with salary more than their managers salary
Select * from employee;

Select e1.emp_name as employee, e1.salary as emp_salary, e2.emp_name as managers, e2.salary as managers_salary
from employee e1
inner join employee e2 on e1.manager_id = e2.emp_id
where e1.salary > e2.salary

------------------------------------------------------------------------------------------------------------------------
--SQL Cross Join | Use Cases | Master Data | Performance Data

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

create table colors (
color_id int,
color varchar(50)
);
insert into colors values (1,'Blue'),(2,'Green'),(3,'Orange');

create table sizes
(
size_id int,
size varchar(10)
);

insert into sizes values (1,'M'),(2,'L'),(3,'XL');

create table transactions
(
order_id int,
product_name varchar(20),
color varchar(10),
size varchar(10),
amount int
);
insert into transactions values (1,'A','Blue','L',300),(2,'B','Blue','XL',150),(3,'B','Green','L',250),(4,'C','Blue','L',250),
(5,'E','Green','L',270),(6,'D','Orange','L',200),(7,'D','Green','M',250);

-- CROSS JOIN 
Select * from products;
Select * from colors;


Select * 
from products,colors;

Select * 
from products p
inner join colors c on 1=1;

--use case 1 : prepare master data 


----------------------------------------------------------------------------------------------------------------------------

--interview questions : no of records with different kinds of joins when there are duplicate key values 

CREATE TABLE t1(
id1 int)
insert into t1 values (null);


CREATE TABLE t2(
id2 int)
insert into t2 values (null);


Select * from t1;
Select * from t2;

-- 
Select * 
from t1 
inner join t2 on t1.id1 = t2.id2;

Select * 
from t1 
LEFT join t2 on t1.id1 = t2.id2;

Select * 
from t1 
RIGHT join t2 on t1.id1 = t2.id2;

Select * 
from t1 
FULL OUTER join t2 on t1.id1 = t2.id2;


-- NULL not equal to NULL value 
----------------------------------------------------------------------------------------------
-- CALCULATE MODE USING SQL
create table mode 
(
id int
);

insert into mode values (1),(2),(2),(3),(3),(3),(3),(4),(5);
insert into mode values (4)
Select * from mode;

-- method using CTE 
WITH CTE AS (
Select id, COUNT(id) as total_count
from mode
group by id)

/*
Select id
from CTE
where total_count > 3 
*/
Select *
from CTE WHERE total_count=(Select MAX(total_count) from CTE)

-- METHOD 2 using RANK

WITH CTE AS (
Select id, COUNT(id) as total_count
from mode
group by id)
, rnk_cte as (
Select *,
RANK() over (order by total_count DESC) as rnk
from CTE)

Select * from rnk_cte
where rnk =1







