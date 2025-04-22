/* 1. Ndertoni tabelat brands dhe cars qe permbajne fushat brand_id dhe brand_name dhe per cars car_id,car_name, brand_id dhe buy_price.
   Per primary key car_id ndertoni constraint me emrin pk_cars dhe buy_price duhet te jete pozitiv.
 */


 CREATE TABLE BRANDS (
     BRAND_ID NUMBER(6) PRIMARY KEY,
     BRAND_NAME VARCHAR2(20)
 );

CREATE TABLE CARS(
    CAR_ID NUMBER(6) CONSTRAINT pk_cars PRIMARY KEY,
    CAR_NAME VARCHAR2(20),
    BRAND_ID NUMBER(6),
    BUY_PRICE NUMBER(10) CONSTRAINT buy_price_positive CHECK (BUY_PRICE > 0),

    FOREIGN KEY (BRAND_ID) REFERENCES BRANDS(BRAND_ID)
);

INSERT INTO BRANDS (BRAND_ID, BRAND_NAME) VALUES (1, 'BMW');

INSERT INTO CARS (CAR_ID, CAR_NAME, BRAND_ID, BUY_PRICE) VALUES (1, 'X5', 1, 50000);

/* 2. Shtoni nje fushe te re cost ne tabelen cars.
   Pasi te jete shtuar fusha ndertoni constraints qe kjo fushe te jete pozitive dhe me e madhe ose e barabarte me buy_price.
 */

ALTER TABLE CARS ADD (
    COST NUMBER(10)
    );

ALTER TABLE CARS ADD CONSTRAINT cost_positive_and_greater_than_buy_price CHECK (COST > 0 AND COST >= BUY_PRICE);

-- Test the constraints
INSERT INTO CARS (CAR_ID, CAR_NAME, BRAND_ID, BUY_PRICE, COST) VALUES (2, 'X6', 1, 60000, 70000);

-- This should fail
INSERT INTO CARS (CAR_ID, CAR_NAME, BRAND_ID, BUY_PRICE, COST) VALUES (3, 'X7', 1, 70000, 60000);

/* 3. Ndertoni nje view qe shfaq emrin dhe id e makinave. */

CREATE VIEW CARS_VIEW AS
    SELECT CAR_ID, CAR_NAME
    FROM CARS;

-- Test the view
SELECT * FROM CARS_VIEW;

/* 4. Ndertoni nje view qe afishion id,emrin per makinat dhe marken e tyre. */

CREATE VIEW CARS_BRANDS_VIEW AS
    SELECT CARS.CAR_ID, CARS.CAR_NAME, BRANDS.BRAND_NAME
    FROM CARS
    JOIN BRANDS ON CARS.BRAND_ID = BRANDS.BRAND_ID;

--Test the view
SELECT * FROM CARS_BRANDS_VIEW;

/* 5. Ndertoni view qe shfaq emrin dhe mbiemrin e punonjesit si full_name dhe vitet qe ai ka ne kompani. */

CREATE OR REPLACE VIEW EMPLOYEE_EXPERIENCE_VIEW AS
    SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS "full_name",
           EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM E.HIRE_DATE) AS EXPERIENCE
    FROM EMPLOYEES E;

SELECT * FROM EMPLOYEE_EXPERIENCE_VIEW;

/* 6. Ndertoni read-only view qe shfaq id,emrin dhe limitin e krediteve per klientet. */

CREATE VIEW CUSTOMER_CREDITS AS
    SELECT CUSTOMER_ID, CUSTOMERS.NAME, CREDIT_LIMIT
    FROM CUSTOMERS;

/* 7. Ndertoni nje view qe shfaq klientet,vitin dhe sasine e shitjeve qe jane bere shipped.

   !!! Sasia eshte quantity * unit_price.

   */

CREATE VIEW CUSTOMER_SALES AS
    SELECT C.NAME, EXTRACT(YEAR FROM O.ORDER_DATE) AS "YEAR", COUNT(O.ORDER_ID) AS "SALES"
    FROM CUSTOMERS C
    JOIN ORDERS O ON C.CUSTOMER_ID = O.COSTUMER_ID
    WHERE O.STATUS = 'shipped'
    GROUP BY C.NAME, EXTRACT(YEAR FROM O.ORDER_DATE);

-- Test the view
SELECT * FROM CUSTOMER_SALES;







