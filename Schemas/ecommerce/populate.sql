-------------------------------
-- 1. Seed the EMPLOYEES table
-------------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO EMPLOYEES (
                EMPLOYEE_ID,
                FIRST_NAME,
                LAST_NAME,
                EMAIL,
                PHONE_NUMBER,
                HIRE_DATE,
                JOB_TITLE,
                MANAGER_ID
            )
            VALUES (
                       i,
                       'First' || i,
                       'Last'  || i,
                       'employee' || i || '@example.com',
                       '555-010' || LPAD(i,2,'0'),
                       SYSDATE - i,
                       'Job ' || i,
                       CASE WHEN i <= 5 THEN NULL
                            ELSE TRUNC(DBMS_RANDOM.VALUE(1, 5))
                           END
                   );
        END LOOP;
    COMMIT;
END;
/

--------------------------------
-- 2. Seed the CUSTOMERS table
--------------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO CUSTOMERS (
                CUSTOMER_ID,
                NAME,
                ADDRESS,
                WEBSITE,
                CREDIT_LIMIT
            )
            VALUES (
                       i,
                       'Customer ' || i,
                       'Address '  || i,
                       'www.customer' || i || '.com',
                       TRUNC(DBMS_RANDOM.VALUE(1000, 10000))
                   );
        END LOOP;
    COMMIT;
END;
/

------------------------------
-- 3. Seed the ORDERS table
------------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO ORDERS (
                ORDER_ID,
                COSTUMER_ID,  -- Note: same misspelling as in your schema
                STATUS,
                SALESMAN_ID,
                ORDER_DATE
            )
            VALUES (
                       i,
                       TRUNC(DBMS_RANDOM.VALUE(1, 51)),  -- Picks a random customer between 1 and 50
                       CASE WHEN MOD(i,2) = 0 THEN 'Processed' ELSE 'Pending' END,
                       TRUNC(DBMS_RANDOM.VALUE(1, 51)),  -- Picks a random employee (salesman)
                       SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 100))
                   );
        END LOOP;
    COMMIT;
END;
/

-----------------------------------------
-- 4. Seed the PRODUCT_CATEGORIES table
-----------------------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO PRODUCT_CATEGORIES (
                CATEGORY_ID,
                CATEGORY_NAME
            )
            VALUES (
                       i,
                       'Category ' || i
                   );
        END LOOP;
    COMMIT;
END;
/

-------------------------
-- 5. Seed the PRODUCTS table
-------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO PRODUCTS (
                PRODUCT_ID,
                PRODUCT_NAME,
                DESCRIPTION,
                STANDARD_COST,
                LIST_PRICE,
                CATEGORY_ID
            )
            VALUES (
                       i,
                       'Product ' || i,
                       'Description for Product ' || i,
                       TRUNC(DBMS_RANDOM.VALUE(50, 200)),     -- Standard cost between 50 and 200
                       TRUNC(DBMS_RANDOM.VALUE(201, 500)),    -- List price between 201 and 500
                       TRUNC(DBMS_RANDOM.VALUE(1, 51))          -- Random category (1-50)
                   );
        END LOOP;
    COMMIT;
END;
/

---------------------------
-- 6. Seed the ORDER_ITEMS table
---------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO ORDER_ITEMS (
                ORDER_ID,
                ITEM_ID,
                PRODUCT_ID,
                QUANTITY,
                UNIT_PRICE
            )
            VALUES (
                       TRUNC(DBMS_RANDOM.VALUE(1, 51)),         -- Random order id (1-50)
                       i,                                       -- Unique item id (1-50)
                       TRUNC(DBMS_RANDOM.VALUE(1, 51)),         -- Random product id (1-50)
                       TRUNC(DBMS_RANDOM.VALUE(1, 10)),         -- Quantity between 1 and 10
                       TRUNC(DBMS_RANDOM.VALUE(100, 500))         -- Unit price between 100 and 500
                   );
        END LOOP;
    COMMIT;
END;
/

--------------------------
-- 7. Seed the REGIONS table
--------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO REGIONS (
                REGION_ID,
                REGION_NAME
            )
            VALUES (
                       i,
                       'Region ' || i
                   );
        END LOOP;
    COMMIT;
END;
/

--------------------------
-- 8. Seed the COUNTRIES table
--------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO COUNTRIES (
                COUNTRY_ID,
                COUNTRY_NAME,
                REGION_ID
            )
            VALUES (
                       i,
                       'Country ' || i,
                       TRUNC(DBMS_RANDOM.VALUE(1, 51))  -- Random region id (1-50)
                   );
        END LOOP;
    COMMIT;
END;
/

--------------------------
-- 9. Seed the LOCATIONS table
--------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO LOCATIONS (
                LOCATION_ID,
                ADDRESS,
                POSTAL_CODE,
                CITY,
                STATE,
                COUNTRY_ID
            )
            VALUES (
                       i,
                       'Address ' || i,
                       LPAD(i, 5, '0'),
                       'City '    || i,
                       'State '   || i,
                       TRUNC(DBMS_RANDOM.VALUE(1, 51))  -- Random country id (1-50)
                   );
        END LOOP;
    COMMIT;
END;
/

---------------------------
-- 10. Seed the WAREHOUSES table
---------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO WAREHOUSES (
                WAREHOUSE_ID,
                WAREHOUSE_NAME,
                LOCATION_ID
            )
            VALUES (
                       i,
                       'Warehouse ' || i,
                       TRUNC(DBMS_RANDOM.VALUE(1, 51))  -- Random location id (1-50)
                   );
        END LOOP;
    COMMIT;
END;
/

---------------------------
-- 11. Seed the INVENTORIES table
---------------------------
BEGIN
    FOR i IN 1..50 LOOP
            INSERT INTO INVENTORIES (
                PRODUCT_ID,
                WAREHOUSE_ID,
                QUANTITY
            )
            VALUES (
                       TRUNC(DBMS_RANDOM.VALUE(1, 51)),  -- Random product id (1-50)
                       TRUNC(DBMS_RANDOM.VALUE(1, 51)),  -- Random warehouse id (1-50)
                       TRUNC(DBMS_RANDOM.VALUE(0, 500))   -- Random quantity between 0 and 500
                   );
        END LOOP;
    COMMIT;
END;
/
