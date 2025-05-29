/*
 1. Ndertoni funksionin qe gjen numrin total te punonjesve pasi merr titullin e punes.
 */

CREATE OR REPLACE FUNCTION GET_EMPLOYEE_COUNT_BY_JOB_TITLE(
    p_job_title JOBS.JOB_TITLE%TYPE
) RETURN PLS_INTEGER
    IS
    v_employee_count PLS_INTEGER := 0;
BEGIN
    SELECT COUNT(E.EMPLOYEE_ID)
    INTO v_employee_count
    FROM EMPLOYEES E
    JOIN JOBS J ON E.JOB_ID = J.JOB_ID
    WHERE JOB_TITLE = p_job_title;

    RETURN v_employee_count;
END;

-- Test the function
DECLARE
    v_employee_count PLS_INTEGER := 0;
BEGIN
    v_employee_count := GET_EMPLOYEE_COUNT_BY_JOB_TITLE('Administration Vice President');
    DBMS_OUTPUT.PUT_LINE('Total employees with job title IT_PROG: ' || v_employee_count);
END;

/*
 2. Ndertoni nje funksion qe kthen  n punonjesit me rrogen me te larte.
 */

 CREATE OR REPLACE FUNCTION GET_HIGHEST_PAID_EMPLOYEES(
     p_number PLS_INTEGER
 ) RETURN  SYS_REFCURSOR
    IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM EMPLOYEES
        ORDER BY SALARY DESC
        FETCH FIRST p_number ROWS ONLY;

    RETURN v_cursor;
END;

-- Test the function
DECLARE
    v_cursor SYS_REFCURSOR;
    v_employee EMPLOYEES%ROWTYPE;
BEGIN
    v_cursor := GET_HIGHEST_PAID_EMPLOYEES(5);

    LOOP
        FETCH v_cursor INTO v_employee;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee.EMPLOYEE_ID || ', Name: ' || v_employee.FIRST_NAME || ' ' || v_employee.LAST_NAME || ', Salary: ' || v_employee.SALARY);
    END LOOP;

    CLOSE v_cursor;
END;

/*
 3. Ndertoni nje funksion qe kthen punonjesin me rrogen me te larte ne baze te departamentit.
 */

CREATE OR REPLACE FUNCTION GET_HIGHEST_PAID_IN_DEPARTMENT(
    p_department_id DEPARTMENTS.DEPARTMENT_ID%TYPE
) RETURN EMPLOYEES%ROWTYPE
IS
v_employees EMPLOYEES%ROWTYPE;
BEGIN
    SELECT *
    INTO v_employees
    FROM EMPLOYEES E
    WHERE E.SALARY = (
        SELECT MAX(EMP.SALARY)
        FROM EMPLOYEES EMP
        )
    AND DEPARTMENT_ID = p_department_id;

    RETURN v_employees;
END;

-- Test the function
DECLARE
    v_employee EMPLOYEES%ROWTYPE;
BEGIN
    v_employee := GET_HIGHEST_PAID_IN_DEPARTMENT(90);
    DBMS_OUTPUT.PUT_LINE('Highest paid employee in department 90: ' || v_employee.FIRST_NAME || ' ' || v_employee.LAST_NAME || ', Salary: ' || v_employee.SALARY);
END;

/*
 4. Ndertoni nje funksion qe kthen punonjesit qe kane te njejtin menaxher.
 */

CREATE OR REPLACE FUNCTION GET_EMPLOYEES_BY_MANAGER(
    p_manager_id EMPLOYEES.MANAGER_ID%TYPE
) RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
        FROM EMPLOYEES
        WHERE MANAGER_ID = p_manager_id;

    RETURN v_cursor;
END;

-- Test the function

DECLARE
    v_cursor SYS_REFCURSOR;
    v_employee EMPLOYEES%ROWTYPE;
BEGIN
    v_cursor := GET_EMPLOYEES_BY_MANAGER(101);

    LOOP
        FETCH v_cursor INTO v_employee;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee.EMPLOYEE_ID || ', Name: ' || v_employee.FIRST_NAME || ' ' || v_employee.LAST_NAME);
    END LOOP;

    CLOSE v_cursor;
END;

/*
 5. Ndertoni nje triger qe hedh exception nese shtohen punonjes me emra te dublikuara ne tabelen employees.
 */

CREATE OR REPLACE TRIGGER TRG_PREVENT_DUPLICATE_EMPLOYEES
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW
DECLARE
    v_count PLS_INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM EMPLOYEES
    WHERE FIRST_NAME = :NEW.FIRST_NAME
    AND LAST_NAME = :NEW.LAST_NAME;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Duplicate employee names are not allowed.');
    END IF;
END;

/*
 6. Afishoni per punonjesit  qe e kane  salary  me te madh se 3200  department_name, d.department_id, first_name, last_name, job_id, salary.(duke perdorur  kursorin)
 */

CREATE OR REPLACE PROCEDURE SHOW_EMPLOYEES_BY_SALARY(
    p_salary_threshold EMPLOYEES.SALARY%TYPE
) IS
    CURSOR employee_cursor IS
        SELECT D.DEPARTMENT_NAME,
               E.DEPARTMENT_ID,
               E.FIRST_NAME,
               E.LAST_NAME,
               E.JOB_ID,
               E.SALARY
        FROM EMPLOYEES E
        JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
        WHERE E.SALARY > p_salary_threshold;
BEGIN
    FOR employee_record IN employee_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Department: ' || employee_record.DEPARTMENT_NAME ||
                             ', Department ID: ' || employee_record.DEPARTMENT_ID ||
                             ', Employee: ' || employee_record.FIRST_NAME || ' ' || employee_record.LAST_NAME ||
                             ', Job ID: ' || employee_record.JOB_ID ||
                             ', Salary: ' || employee_record.SALARY);
    END LOOP;
END;

