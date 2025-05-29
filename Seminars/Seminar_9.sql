-- /*
--  2. Ndertoni nje procedure qe i jep te drejta select nje useri te dhene mbi te gjitha tabelat e nje useri te caktuar.
--     (userat merren nga perdoruesi)
--  */
--
-- CREATE OR REPLACE PROCEDURE GRANT_SELECT_PRIVILEGES (
--     p_grantee IN VARCHAR2,
--     p_owner IN VARCHAR2
-- ) AS
--     v_sql VARCHAR2(1000);
-- BEGIN
--     FOR rec IN (
--         SELECT table_name
--         FROM all_tables
--         WHERE owner = p_owner
--     ) LOOP
--         v_sql := 'GRANT SELECT ON ' || p_owner || '.' || rec.table_name || ' TO ' || p_grantee;
--         EXECUTE IMMEDIATE v_sql;
--     END LOOP;
--
--     DBMS_OUTPUT.PUT_LINE('SELECT privileges granted to ' || p_grantee || ' on all tables of ' || p_owner);
-- END GRANT_SELECT_PRIVILEGES;
--
-- -- Test the procedure
-- BEGIN
--     GRANT_SELECT_PRIVILEGES('HR_USER', 'HR');
-- END;
--
-- /*
--  3. Ndertoni nje trigger qe shton id nje numer 4-shifror per departeament_id te tables
--     departments sa here qe shtohet nje rekordi i ri ne table.
--  */
--
-- CREATE OR REPLACE TRIGGER DEPARTMENT_ID_TRIGGER
-- BEFORE INSERT ON DEPARTMENTS
-- FOR EACH ROW
-- DECLARE
--     v_new_id NUMBER;
-- BEGIN
--     SELECT DEPARTMENT_ID_SEQ.NEXTVAL
--     INTO v_new_id
--     FROM dual;
--
--     :NEW.DEPARTMENT_ID := v_new_id;
--     DBMS_OUTPUT.PUT_LINE('New DEPARTMENT_ID: ' || :NEW.DEPARTMENT_ID);
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
--         RAISE_APPLICATION_ERROR(-20001, 'Error generating DEPARTMENT_ID');
-- END;
--
--
-- /*
--  1. Ndertoni funksionin qe gjen mesataren e eksperiences te punonjesve te nje departamenti me department_id qe merret nga perdoruesi.
--  */
--
-- CREATE OR REPLACE FUNCTION GET_AVG_EXPERIENCE_BY_DEPARTMENT(
--     p_department_id DEPARTMENTS.DEPARTMENT_ID%TYPE
-- ) RETURN NUMBER
--     IS
--     avg_experience NUMBER := 0;
-- BEGIN
--     SELECT AVG(SYSDATE - HIRE_DATE)
--     INTO avg_experience
--     FROM EMPLOYEES
--     WHERE DEPARTMENT_ID = p_department_id;
--
--     RETURN ROUND(NVL(avg_experience, 0)/365, 2);
-- END;
--
-- DECLARE
--     avg_experience NUMBER := 0;
-- BEGIN
--     avg_experience := GET_AVG_EXPERIENCE_BY_DEPARTMENT(90);
--
--     DBMS_OUTPUT.PUT_LINE('Average experience for department 90: ' || avg_experience);
-- END;

/*
 2. Ndertoni procedure qe perditeson rrogen e punonjesve ne baze te performances. Rroga e re (salary*perqindje).
    Nese performance 1-> 100, 2-> 150, 3-> 200.
 */

-- CREATE OR REPLACE PROCEDURE UPDATE_SALARY(
--     p_employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
--     p_performance IN NUMBER
-- ) IS
--     v_old_salary NUMBER := 0;
--     v_new_salary NUMBER := 0;
-- BEGIN
--     SELECT SALARY
--     INTO v_old_salary
--     FROM HR.EMPLOYEES
--     WHERE EMPLOYEE_ID = p_employee_id;
--
--     IF p_performance = 1 THEN
--         v_new_salary := v_old_salary + (v_old_salary * 1);
--     ELSIF p_performance = 2 THEN
--         v_new_salary := v_old_salary + (v_old_salary * 1.5);
--     ELSIF p_performance = 3 THEN
--         v_new_salary := v_old_salary + (v_old_salary * 2);
--     END IF;
--
--     UPDATE HR.EMPLOYEES SET SALARY = v_new_salary WHERE EMPLOYEE_ID = p_employee_id;
-- END;
--
-- SELECT SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID = 101;
--
-- BEGIN
--     UPDATE_SALARY(101, 3);
-- END;

/*
 4. Ndertoni nje table audit qe mban te dhenat per ndryshimet qe behen ne tabelat e ndryshme.
    (audit_id, table_name, transaction_name, by_user, transaction_date).
    Ndertoni trigger per tabelen customers qe behet run sa here qe ka ndryshime ne table dhe I ruan te dhenat ne audit.
 */


CREATE OR REPLACE TRIGGER COSTUMER_AUDIT_TRIGGER
AFTER INSERT OR UPDATE OR DELETE ON CUSTOMERS
FOR EACH ROW
DECLARE
    v_transaction_name VARCHAR2(50);
BEGIN
    v_transaction_name := CASE
        WHEN INSERTING THEN 'INSERT'
        WHEN UPDATING THEN 'UPDATE'
        WHEN DELETING THEN 'DELETE'
    END;

    INSERT INTO CUSTOMERS_AUDIT (TABLE_NAME, TRANSACTION_NAME, BY_USER, TRANSACTION_DATE) VALUES ('CUSTOMERS', v_transaction_name, USER, SYSDATE);
END;

