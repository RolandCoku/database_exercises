/* 1. Afishoni  id e departamentit,emrn dhe job_id per punonjesit qe punojne ne departamentin e finances. */

SELECT E.DEPARTMENT_ID, E.FIRST_NAME, E.JOB_ID
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = (
    SELECT DEPARTMENT_ID
    FROM DEPARTMENTS
    WHERE DEPARTMENT_NAME = 'Finance'
    );

/* 2. Afishoni emrin,id dhe job_id per punonjesit qe e kane departamentin ne ‘Toronto’. */

SELECT E.FIRST_NAME, E.EMPLOYEE_ID, E.JOB_ID
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID IN (
    SELECT D.DEPARTMENT_ID
    FROM DEPARTMENTS D
    JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    WHERE CITY = 'Toronto'
    );

/* 3. Afishoni id,emrin e plote(emri dhe mbiiemri),rrogen,AvgCompare(rroga – rrogen mesatere)
      dhe SalaryStatus qe mban high dhe low per punonjesit qe e kane rrogen me te madhe dhe me te vogel se rroga mesatere e punonjesve.
 */

 SELECT E.EMPLOYEE_ID,
        E.FIRST_NAME || ' ' || E.LAST_NAME AS EMRI,
        E.SALARY,
        E.SALARY - A.avg_salary AS "AvgCompare",
        CASE
            WHEN E.SALARY > A.avg_salary THEN 'high'
            WHEN E.SALARY < A.avg_salary THEN 'low'
        END AS "SalaryStatus"
 FROM EMPLOYEES E
 CROSS JOIN (SELECT ROUND(AVG(EM.SALARY), 0) AS avg_salary FROM EMPLOYEES EM) A;


/* 4. Afishoni emrin,mbiemrin e punonjeve qe kane nje menaxher qe qendron ne ‘US’. */

SELECT E.FIRST_NAME, E.LAST_NAME
FROM EMPLOYEES E
WHERE E.MANAGER_ID IN (
    SELECT EM.EMPLOYEE_ID
    FROM EMPLOYEES EM
        JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = EM.DEPARTMENT_ID
        JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
        JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID
    WHERE C.COUNTRY_ID = 'US'
    );

/* 5. Afishoni id,emrin,mbiemri,rrogen,id e departamentit dh qytetin e punonjesve qe kane rrogen qe eshte sa max I rrogave te punonjesve qe
      kane fillur pune nga data January 1st, 2002 deri ne December 31st, 2003.
 */

 SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY, E.DEPARTMENT_ID, L.CITY
 FROM EMPLOYEES E
 JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
 WHERE E.SALARY = (
     SELECT MAX(EM.SALARY)
     FROM EMPLOYEES EM
     WHERE EM.HIRE_DATE BETWEEN TO_DATE('01-01-2002', 'DD-MM-YYYY') AND TO_DATE('31-12-2003', 'DD-MM-YYYY')
     );

/* 6. Afishoni id,emrin dhe id e departementit te punonjesve qe fitojne me shume se rroga me e madhe e departamentit me id 40. */

SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.DEPARTMENT_ID
FROM EMPLOYEES E
WHERE E.SALARY > (
    SELECT MAX(EM.SALARY)
    FROM EMPLOYEES EM
    WHERE EM.DEPARTMENT_ID = 40
    );

/* 7. Afishoni emrin,mbiemrin,rrogen dhe departementin per punonjesit qe punojne ne te njejtin department me punonjesin me id 201 */

SELECT E.FIRST_NAME, E.LAST_NAME, E.SALARY, E.DEPARTMENT_ID
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = (
    SELECT EM.DEPARTMENT_ID
    FROM EMPLOYEES EM
    WHERE EM.EMPLOYEE_ID = 201
    );

/* 8. Afishoni emrin,mbiemrin,rrogen dhe id e departamentit per punojesit qe fitojne me pak se rroga mesater dhe kane punonjes me emrin ‘Laura’. */

SELECT E.FIRST_NAME, E.LAST_NAME, E.SALARY, E.DEPARTMENT_ID
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID IN (
    SELECT EM.DEPARTMENT_ID
    FROM EMPLOYEES EM
    WHERE EM.FIRST_NAME LIKE '%Laura%'
    )
AND E.SALARY < (
    SELECT AVG(EM.SALARY)
    FROM EMPLOYEES EM
    );


