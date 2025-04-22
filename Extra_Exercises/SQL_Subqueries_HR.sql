/* 1. Write a SQL query to find those employees who receive a higher salary than the employee with ID 163.
      Return first name, last name.
 */

SELECT E.FIRST_NAME, E.LAST_NAME
FROM EMPLOYEES E
WHERE E.SALARY > (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 163
    );

/* 2. Write a SQL query to find out which employees have the same designation as the employee whose ID is 169.
      Return first name, last name, department ID and job ID.
 */

SELECT E.FIRST_NAME, E.LAST_NAME, E.DEPARTMENT_ID, E.JOB_ID
FROM EMPLOYEES E
WHERE E.JOB_ID = (
    SELECT EM.JOB_ID
    FROM EMPLOYEES EM
    WHERE EM.EMPLOYEE_ID = 169
    );


/* 3. Write a SQL query to find those employees whose salary matches the lowest salary of any of the departments.
      Return first name, last name and department ID.
 */

 SELECT E.FIRST_NAME, E.LAST_NAME, E.DEPARTMENT_ID
 FROM EMPLOYEES E
 WHERE E.SALARY IN (
     SELECT MIN(SALARY)
     FROM EMPLOYEES
     GROUP BY DEPARTMENT_ID
     );

/* 4. Write a SQL query to find those employees who earn more than the average salary.
   Return employee ID, first name, last name.
 */

 SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME
 FROM EMPLOYEES E
 WHERE E.SALARY > (
     SELECT AVG(SALARY)
     FROM EMPLOYEES
     );

/* 5. Write a SQL query to find those employees who report to that manager whose first name is ‘Payam’.
      Return first name, last name, employee ID and salary.
 */

 SELECT E.FIRST_NAME, E.LAST_NAME, E.EMPLOYEE_ID, E.SALARY
 FROM EMPLOYEES E
 WHERE E.MANAGER_ID IN (
     SELECT EMPLOYEE_ID
     FROM EMPLOYEES
     WHERE FIRST_NAME LIKE 'Payam'
     );

/* 6. Write a  SQL query to find all those employees who work in the Finance department.
      Return department ID, name (first), job ID and department name.
 */

 SELECT E.DEPARTMENT_ID, E.FIRST_NAME, E.JOB_ID, D.DEPARTMENT_NAME
 FROM EMPLOYEES E
 JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 WHERE E.DEPARTMENT_ID = (
     SELECT DEPARTMENT_ID
     FROM DEPARTMENTS
     WHERE DEPARTMENT_NAME = 'Finance'
     );

/* 7. Write a SQL query to find the employee whose salary is 3000 and reporting person’s ID is 121.
      Return all fields.
*/

SELECT *
FROM EMPLOYEES
WHERE SALARY = 3000 AND MANAGER_ID = 121;

/* 8. Write a SQL query to find those employees whose ID matches any of the numbers 134, 159 and 183.
   Return all the fields.
*/

SELECT *
FROM EMPLOYEES E
WHERE E.EMPLOYEE_ID IN (134, 159, 183);

/* 9. Write a SQL query to find those employees whose salary is in the range of 1000, and 3000 (Begin and end values have included.)
      Return all the fields.
 */

 SELECT *
 FROM EMPLOYEES
 WHERE SALARY BETWEEN 500 AND 3000;




/* ============================================================================================= */

SELECT SYSDATE, LAST_DAY(SYSDATE), LAST_DAY(SYSDATE) - SYSDATE
FROM DUAL;


SELECT *
FROM EMPLOYEES
WHERE SALARY = (
    SELECT MAX(E.SALARY)
    FROM EMPLOYEES E
    );

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID
    FROM EMPLOYEES
    WHERE FIRST_NAME LIKE '%t%'
    );

