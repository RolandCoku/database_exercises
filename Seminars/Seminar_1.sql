-- 1. Afishoni emrin e plote te punonjesve si "full_name" qe kane rrogen me te madhe se 1000 dhe I fillon emri me A.

SELECT FIRST_NAME || ' ' || LAST_NAME AS full_name
FROM EMPLOYEES
WHERE SALARY > 1000
AND FIRST_NAME LIKE 'A%';

-- 2. Afishoni id e departamentit,rrogen dhe emrin e plote te punonjesve sipas id te departamentit qe ne emer nuk kane shkronjen M.

SELECT DEPARTMENT_ID, SALARY, FIRST_NAME || ' ' || LAST_NAME AS full_name
FROM EMPLOYEES
WHERE CONCAT(FIRST_NAME, LAST_NAME) NOT LIKE '%M%'
ORDER BY DEPARTMENT_ID;

-- 3. Afishoni emrin e punonjesve qe nuk punojne ne departamentin 70 apo 90.

SELECT FIRST_NAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID NOT IN (70, 90);

-- 4. Afishoni emrin, pagen dhe id e menaxherit per punonjesit qe kane menaxher.

SELECT E.FIRST_NAME, E.LAST_NAME, E.SALARY, E.MANAGER_ID
FROM EMPLOYEES E
WHERE E.MANAGER_ID IS NOT NULL;

-- 5. Afishoni id e departamentit dhe numrin totale te punonjesve per secilin departament.

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS numri_punonjesve
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- 6. Afishoni id e departamentit dhe rrogen me te larte te punonjesve per secilin departament.

SELECT DEPARTMENT_ID, MAX(SALARY) AS PAGA_MAKSIMALE
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- 7. Afishoni departamentet dhe rrogen mesatare te punonjesve per secilin prej tyre.

SELECT DEPARTMENT_NAME, AVG(SALARY) AS PAGA_MESATARE
FROM EMPLOYEES
LEFT JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME;

-- 8. Afishoni departamentet qe menaxheret kane me shume se 4 punonjes.

SELECT D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON D.MANAGER_ID = E.MANAGER_ID
GROUP BY D.MANAGER_ID, DEPARTMENT_NAME, D.DEPARTMENT_ID
HAVING COUNT(E.EMPLOYEE_ID) > 4;

-- 9. Afishoni job_id dhe rrogen mesatare per ato pune qe e kane rrogen deri ne 8000.

SELECT E.JOB_ID, AVG(SALARY) AS AVG_SALLARY
FROM EMPLOYEES E
WHERE SALARY <= 8000
GROUP BY JOB_ID;

-- 10. Afishoni departametet dhe sasine e punonjesve si numri i punonjesve qe kane me shume se 10 punonjes.

SELECT D.DEPARTMENT_NAME, COUNT(E.EMPLOYEE_ID) AS NUMRI_PUNONJESEVE
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(E.EMPLOYEE_ID) > 10;

-- 11. Afishoni rrogen maksimale per job_id ‘ST_CLERK’

SELECT MAX(SALARY) AS MAX_SALARY
FROM EMPLOYEES
WHERE JOB_ID LIKE 'ST_CLERK';

-- 12. Afishoni punet dhe sasine e punonjesve per punet qe kane me shume se 4 punonjes.

SELECT J.JOB_TITLE, COUNT(E.EMPLOYEE_ID) AS NUMRI_PUNONJESVE
FROM EMPLOYEES E
JOIN JOBS J ON E.JOB_ID = J.JOB_ID
GROUP BY J.JOB_ID, J.JOB_TITLE
HAVING COUNT(E.EMPLOYEE_ID) > 4;
