CREATE DATABASE employee;

USE employee;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT
FROM emp_record_table;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
FROM emp_record_table
WHERE EMP_RATING<2;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
FROM emp_record_table
WHERE EMP_RATING>4;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;

SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT="FINANCE";

SELECT e.EMP_ID,CONCAT(e.FIRST_NAME,' ',e.LAST_NAME)
AS Employee_Name,m.MANAGER_ID,CONCAT(m.FIRST_NAME,' ',m.LAST_NAME)
AS Manager_Name,m.ROLE AS ROLE
FROM emp_record_table e JOIN emp_record_table m
ON e.MANAGER_ID = m.EMP_ID;

SELECT EMP_ID,FIRST_NAME,' ',LAST_NAME,DEPT AS Department
FROM emp_record_table
WHERE DEPT = "HEALTHCARE"
UNION
SELECT EMP_ID,FIRST_NAME,' ',LAST_NAME,DEPT AS Department
FROM emp_record_table
WHERE DEPT = "FINANCE";

SELECT EMP_ID,FIRST_NAME,LAST_NAME,ROLE,DEPT,EMP_RATING,MAX(EMP_RATING)
OVER(PARTITION BY DEPT)
AS "MAX_DEPT_RATING"
FROM emp_record_table
ORDER BY DEPT;

SELECT ROLE,MIN(SALARY) AS MIN_SAL,MAX(SALARY) AS MAX_SAL
FROM emp_record_table GROUP BY ROLE;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,ROLE,DEPT,EXP,
ROW_NUMBER() OVER(ORDER BY EXP DESC) AS Ranking
FROM emp_record_table;

CREATE VIEW employee_sal AS SELECT EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY,SALARY
FROM emp_record_table
WHERE SALARY > 6000;
SELECT * FROM employee.employee_sal;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP FROM emp_record_table
WHERE EMP_ID IN(SELECT MANAGER_ID FROM emp_record_table);

DELIMITER &&
CREATE PROCEDURE get_experience_details()
BEGIN
SELECT * FROM emp_record_table
WHERE EXP>3;
END &&
CALL get_experience_details();

DELIMITER $$
CREATE FUNCTION emp_job_profile(EXP int) RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
DECLARE emp_job_profile VARCHAR(40);
IF EXP <= 2 THEN SET emp_job_profile = 'JUNIOR DATA SCIENTIST';
ELSEIF EXP BETWEEN 2 AND 5 THEN SET emp_job_profile = 'ASSOCIATE DATA SCIENTIST';
ELSEIF EXP BETWEEN 5 AND 10 THEN SET emp_job_profile = 'SENIOR DATA SCIENTIST';
ELSEIF EXP BETWEEN 10 AND 12 THEN SET emp_job_profile = 'LEAD DATA SCIENTIST';
ELSEIF EXP BETWEEN 12 AND 16 THEN SET emp_job_profile = 'MANAGER';
END IF;
RETURN (emp_job_profile);
END $$
SELECT EMP_ID,FIRST_NAME,EXP,emp_job_profile(EXP) FROM emp_record_table;


CREATE INDEX idx_first_name
ON emp_record_table(FIRST_NAME(20));
EXPLAIN SELECT*FROM emp_record_table
WHERE FIRST_NAME='Eric';
show indexes from employee.emp_record_table;

SELECT EMP_ID, CONCAT(FIRST_NAME,' ',LAST_NAME) AS NAME, EMP_RATING,SALARY,(SALARY*.05)*EMP_RATING
AS BONUS FROM emp_record_table;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY,CONTINENT,AVG(SALARY)
FROM emp_record_table
GROUP BY COUNTRY,CONTINENT;