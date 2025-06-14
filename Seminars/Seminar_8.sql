/*
 1. Printoni listen e menaxherve dhe emrave te departamenteve.
 */

DECLARE CURSOR manager_cursor IS
    SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS MANAGER_NAME, D.DEPARTMENT_NAME
    FROM DEPARTMENTS D
    JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID;
BEGIN
    FOR manager_record IN manager_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('Manager: ' || manager_record.MANAGER_NAME || ', Department: ' || manager_record.DEPARTMENT_NAME);
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
END;

/*
 Afishoni emrin dhe rrogen per secilin punonjes qe e ka rrogen me pak se nje rroge e dhene nga perdoruesi.
 */
DECLARE CURSOR employee_cursor IS
    SELECT FIRST_NAME, SALARY
    FROM EMPLOYEES
    WHERE SALARY < :salary_limit;
BEGIN
    FOR employee_record IN employee_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('Employee: ' || employee_record.FIRST_NAME || ', Salary: ' || employee_record.SALARY);
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
END;

/*
 3. Afishoni emrin e departamentit, drejtuesin e departamentit, qyetetin dhe numrin e punonjesve qe punojne aty.
 */

DECLARE
    CURSOR department_cursor IS
    SELECT D.DEPARTMENT_ID,
           D.DEPARTMENT_NAME,
           E.FIRST_NAME,
           E.LAST_NAME,
           L.CITY,
           COUNT(E.EMPLOYEE_ID) AS EMPLOYEE_COUNT
    FROM DEPARTMENTS D
    JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
    JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    GROUP BY D.DEPARTMENT_ID,
             D.DEPARTMENT_NAME,
             E.FIRST_NAME,
             E.LAST_NAME,
             L.CITY;

BEGIN
    FOR department_record IN department_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE('Department: ' || department_record.DEPARTMENT_NAME ||
                             ', Manager: ' || department_record.FIRST_NAME || ' ' || department_record.LAST_NAME ||
                             ', City: ' || department_record.CITY ||
                             ', Employee Count: ' || department_record.EMPLOYEE_COUNT);
    END LOOP;
END;

/*
 4. Ndertoni nje trigger qe sa here fshime nje record nga tablema employees e ruan veprimin ne nje table transaction history.
 */

CREATE TABLE TRANSACTION_HISTORY (
    transaction_id NUMBER(6) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    employee_id NUMBER(6),
    action VARCHAR2(50),
    action_date DATE
);

ALTER TABLE TRANSACTION_HISTORY ADD by_user VARCHAR2(50);

CREATE OR REPLACE TRIGGER EMPLOYEE_DELETE_TRIGGER
    BEFORE DELETE ON EMPLOYEES
    FOR EACH ROW
BEGIN
    INSERT INTO TRANSACTION_HISTORY (employee_id, action, action_date, by_user)
    VALUES (:OLD.EMPLOYEE_ID,
            'DELETE',
            SYSDATE,
            USER
            );
END;

-- Test the trigger

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (400, 'TEST', 'TEST', 'TEST', 'TEST', SYSDATE, 'IT_PROG', 5000, NULL, 100, 90);

DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = 400;

SELECT * FROM TRANSACTION_HISTORY;


/*
 5. Krijoni funksionin qe afishon eksperiencen mesatere te punonjesve per nje departament te dhene nga perdoruesi.
 */

CREATE OR REPLACE FUNCTION CALCULATE_AVG_EXPERIENCE(
    in_department_id DEPARTMENTS.DEPARTMENT_ID%TYPE
) RETURN NUMBER
IS
    v_avg NUMBER := 0;
BEGIN
    SELECT ROUND(AVG(SYSDATE - HIRE_DATE)/365, 2)
    INTO v_avg
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = in_department_id;

    RETURN v_avg;
END;

-- Test the function
DECLARE
v_avg_experience NUMBER;
BEGIN
    v_avg_experience := CALCULATE_AVG_EXPERIENCE(90);
    DBMS_OUTPUT.PUT_LINE('Average Experience in Department 90: ' || v_avg_experience);
END;



