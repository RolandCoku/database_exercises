/*
 1-Krijoni nje sekuence per rritjen e id ne tabelen Employees.
    --Nuk duhet te lejoje riperseritje vlerash
    --Vlera duhet gjeneruar vetem kur te kerkohet nga ne, jo para.
 */

    CREATE SEQUENCE EMPLOYEES_SEQ_2
    NOCYCLE;

SELECT EMPLOYEES_SEQ_2.NEXTVAL FROM DUAL;

/*
 2- Ndertoni nje view qe shfaq emrin dhe id e departamenteve.
 */

 CREATE OR REPLACE VIEW DEPARTMENTS_NAME_ID_VIEW AS
    SELECT DEPARTMENT_ID, DEPARTMENT_NAME
    FROM DEPARTMENTS;

SELECT * FROM DEPARTMENTS_NAME_ID_VIEW;


/*
 3-Ndertoni nje view qe afishon id,emrin,rrogen,id e departamentit dhe qytetin e punonjesve qe kane rrogen qe eshte sa minI rrogave te punonjesve
   qe kane fillur pune nga data January 1st, 2002 deri ne December 31st, 2003.
 */

 CREATE OR REPLACE VIEW EMPLOYEES_MIN_SALARY_VIEW AS
     SELECT E.EMPLOYEE_ID, E.FIRST_NAME || ' ' || E.LAST_NAME AS "emri", E.DEPARTMENT_ID, L.CITY
     FROM EMPLOYEES E
     JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
     JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
     WHERE E.SALARY =(
         SELECT MIN(EM.SALARY)
         FROM EMPLOYEES EM
         WHERE EM.HIRE_DATE BETWEEN TO_DATE('2002-01-01', 'YYYY-MM-DD') AND TO_DATE('2003-12-31', 'YYYY-MM-DD')
         );

SELECT * FROM EMPLOYEES_MIN_SALARY_VIEW;

/*
 4-Shto nje punonjes te ri ne tabelen Employees
 */

    INSERT INTO EMPLOYEES
        (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
        VALUES (EMPLOYEES_SEQ.nextval, 'Roland', 'Çoku', 'rolandcoku@gmail.com', '06827488', TO_DATE('2021-01-01', 'YYYY-MM-DD'), 'IT_PROG', 5000, 0.1, 100, 90);

SELECT * FROM EMPLOYEES WHERE FIRST_NAME = 'Roland';

/*
 5-Krijoni nje indeks ne tabelen Employees duke ditur qe na kerkohet shpesh info mbi perqindje e komisionit per nje punonjes
 */

 CREATE INDEX EMPLOYEES_COMMISSION_PCT_INDEX ON EMPLOYEES(COMMISSION_PCT);

SELECT * FROM ALL_INDEXES WHERE TABLE_NAME = 'EMPLOYEES';