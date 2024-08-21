create database projects;

USE projects;

SELECt * from hr;

ALTER TABLE hr
CHANGE column ï»¿id emp_id varchar(20) null;

describe hr;

select birthdate from hr;

set sql_safe_updates = 0;

update hr
set birthdate = case
when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'), '%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
else null
End;

Alter table hr
modify column birthdate date;



select birthdate from hr;

update hr
set hire_date = case
when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'), '%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'), '%Y-%m-%d')
else null
End;

select hire_date from hr;

select termdate from hr;

update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
where termdate is null and termdate != '';

select termdate from hr;

Alter table hr
modify column hire_date date;

describe hr;


UPDATE hr
SET termdate = IF(termdate IS NULL OR termdate = '', '0000-00-00', DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')))
WHERE termdate IS NULL OR termdate != '';

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL OR termdate = '';

UPDATE hr
SET termdate = NULL
WHERE termdate IS NULL OR termdate = '';


SELECT @@sql_mode;

SET sql_mode = '';

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL OR termdate = '';



select termdate from hr;


alter table hr
modify column termdate date;

desc hr;

SET sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';

SELECT * FROM hr;

ALTER TABLE hr ADD COLUMN age INT;

SELECT * FROM hr;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age from hr;

SELECT 
	MIN(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*) from hr where age < 18;

-- Questions

-- 1. What is the Gender breakdown for employees in the company ?
SELECT gender, count(*) AS count
From hr
where age >=18 and termdate = '0000-00-00'
group by gender;

-- What is the race/ethnicity breakdown of employees in the company ?
Select race, count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by race
order by count(*) desc;

-- What is the age distribution of employees in the company ?
Select 
	min(age) AS youngest,
    max(age) as oldest
from hr
where age >=18 and termdate = '0000-00-00';

select
	case
    when age >= 18 and age<=24 then '18-24'
    when age >= 25 and age<=34 then '25-34'
    when age >= 35 and age<=44 then '35-44'
    when age >= 45 and age<= 55 then '45-54'
    when age >= 55 and age <= 65 then '55-64'
    else'65+'
end as age_group,
 count(*) as count
 From hr
where age >=18 and termdate = '0000-00-00'
group by age_group
order by age_group;

select
	case
    when age >= 18 and age<=24 then '18-24'
    when age >= 25 and age<=34 then '25-34'
    when age >= 35 and age<=44 then '35-44'
    when age >= 45 and age<= 55 then '45-54'
    when age >= 55 and age <= 65 then '55-64'
    else'65+'
end as age_group,gender,
 count(*) as count
 From hr
where age >=18 and termdate = '0000-00-00'
group by age_group, gender
order by age_group,gender;

-- How many employees work in headquaters versus remote locations ?
select location, count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by location;

-- 5. Average length of employment for employees who have been terminated ?
select 
	round(avg(datediff(termdate, hire_date))/365,0) as avg_length_employment
from hr
where termdate <= curdate() and termdate <> '0000-00-00' and age >=18;

-- How does gender distribution vary across departments and job titles ?
select department, gender, count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by department, gender
order by department;

-- 7. What is the distribution of job titles across company ?
SELECT jobtitle, count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;

-- 8. Which department has highest turnover rates ?
select department, 
	total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
from (
  select department,
  count(*) AS total_count,
  sum(Case when termdate<> '0000-00-00' and termdate <= curdate() Then 1 Else 0 End) as terminated_count
  From hr
  where age >= 18
  group by department
  )As subquery
order by termination_rate desc;


-- 9. What is the distribution of employees across locations by city and state ?
select location_state, count(*) as count
from hr
where age >=18 and termdate = '0000-00-00'
group by location_state
order by count desc;

-- 10. How has company employee count changes over time based on hire and term dates ?
select
  year,
  hires,
  terminations,
  hires - terminations as net_change,
  round((hires - terminations)/hires * 100, 2) as net_change_percent
from(
	Select year(hire_date) As year,
    count(*) as hires,
    sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
    from hr
    where age >= 18
    group by year(hire_date)
    ) as subquery
order by year asc;

-- What is the tenure distribution for each department ?
Select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate <> '0000-00-00' and age >= 18
group by department;
