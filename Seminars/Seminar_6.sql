/*
 1. Afishoni emrin e produktit dhe price_list ne rendin zbrites ne baze te cmimit.
 */

DECLARE
    CURSOR product_cursor IS
        SELECT PRODUCT_NAME, LIST_PRICE
        FROM PRODUCTS
        ORDER BY LIST_PRICE
                DESC;
BEGIN
    FOR product_record IN product_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('Product Name: ' || product_record.PRODUCT_NAME || ', Price List: ' ||
                                 product_record.LIST_PRICE);
        END LOOP;
END;

/*
 2. Afishoni emrin dhe cmimin e produkteve te ndara ne mass products per ato qe kane cmimin midis 220000,250000
    dhe luxury products qe e kane cmimin midis 260000,341000.
 */

DECLARE
    CURSOR mass_product_cursor IS
        SELECT PRODUCT_NAME, LIST_PRICE
        FROM PRODUCTS
        WHERE LIST_PRICE BETWEEN 220 AND 250;
    CURSOR luxury_product_cursor IS
        SELECT PRODUCT_NAME, LIST_PRICE
        FROM PRODUCTS
        WHERE LIST_PRICE BETWEEN 260 AND 341;

BEGIN

    DBMS_OUTPUT.PUT_LINE('Mass Products:');
    FOR mass_product_record IN mass_product_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('Product Name: ' || mass_product_record.PRODUCT_NAME || ', List Price: ' ||
                                 mass_product_record.LIST_PRICE);
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('-----------------------------------');

    DBMS_OUTPUT.PUT_LINE('Luxury Products:');
    FOR luxury_product_record IN luxury_product_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('Product Name: ' || luxury_product_record.PRODUCT_NAME || ', List Price: ' ||
                                 luxury_product_record.LIST_PRICE);
        END LOOP;

END;

/*
3. Ndertoni kursorin qe ben update kreditet e klienteve ne baze te blerjeve qe ata kane nese ato kredite jane me te medhe se zero.
   Nese kane me shume se pese produkte shtoni 5, nese kane me pak se pese dhe me shume se dy shtoni 2 ne te kundert shtoni 1.
 */


DECLARE
    CURSOR product_cursor IS
        SELECT CUSTOMER_ID, CREDIT_LIMIT
        FROM CUSTOMERS
        WHERE CREDIT_LIMIT > 0
            FOR UPDATE OF CREDIT_LIMIT;
    total_product_count NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Old credit limit: ');
    FOR product_record IN product_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE(product_record.CUSTOMER_ID || ': ' || product_record.CREDIT_LIMIT);
        END LOOP;

    FOR product_record IN product_cursor
        LOOP

            SELECT NVL(SUM(QUANTITY), 0)
            INTO total_product_count
            FROM ORDERS
                     JOIN ORDER_ITEMS ON ORDERS.ORDER_ID = ORDER_ITEMS.ORDER_ID
            WHERE COSTUMER_ID = product_record.CUSTOMER_ID;

            IF total_product_count > 5 THEN
                UPDATE CUSTOMERS
                SET CREDIT_LIMIT = CREDIT_LIMIT + 5
                WHERE CUSTOMER_ID = product_record.CUSTOMER_ID;
            ELSIF total_product_count > 2 THEN
                UPDATE CUSTOMERS
                SET CREDIT_LIMIT = CREDIT_LIMIT + 2
                WHERE CUSTOMER_ID = product_record.CUSTOMER_ID;
            ELSE
                UPDATE CUSTOMERS
                SET CREDIT_LIMIT = CREDIT_LIMIT + 1
                WHERE CUSTOMER_ID = product_record.CUSTOMER_ID;
            END IF;

            DBMS_OUTPUT.PUT_LINE('Updated customer: ' || product_record.CUSTOMER_ID || ' based on ' ||
                                 total_product_count || ' products purchased');
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('New credit limit: ');
    FOR product_record IN product_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE(product_record.CUSTOMER_ID || ': ' || product_record.CREDIT_LIMIT);
        END LOOP;

END;

/*
 4. Krijoni nje procedure qe rregullon cmimin per produktet qe merr id nga perdoruesi.
    Cmimi i ri eshte cmimi i vjeter + cmimi i vjeter ne perqindje.
 */

CREATE OR REPLACE PROCEDURE ADJUST_PRICE(
    in_product_id IN PRODUCTS.PRODUCT_ID%TYPE,
    in_percent IN NUMBER
) IS
    old_price NUMBER;
    new_price NUMBER;
BEGIN
    SELECT LIST_PRICE
    INTO old_price
    FROM PRODUCTS
    WHERE PRODUCTS.PRODUCT_ID = in_product_id;

    new_price := old_price + (old_price * in_percent / 100);

    UPDATE PRODUCTS
    SET LIST_PRICE = new_price
    WHERE PRODUCTS.PRODUCT_ID = in_product_id;

    DBMS_OUTPUT.PUT_LINE('Product ID: ' || in_product_id || ', Old Price: ' || old_price || ', New Price: ' || new_price);

END ADJUST_PRICE;

-- Call the procedure
BEGIN
    ADJUST_PRICE(1, 10);
END;

/*
 5. Ndertoni proceduren qe afishon klientet qe kane credit limit me te madh se nje vlere e dhene nga perdoruesi.
 */

CREATE OR REPLACE PROCEDURE SHOW_CUSTOMERS_BY_CREDIT_LIMIT(
    in_credit_limit IN CUSTOMERS.CREDIT_LIMIT%TYPE
) IS
BEGIN
    FOR customer_record IN (SELECT CUSTOMER_ID, NAME, CREDIT_LIMIT
                            FROM CUSTOMERS
                            WHERE CREDIT_LIMIT > in_credit_limit) LOOP
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_record.CUSTOMER_ID || ', Name: ' || customer_record.NAME || ', Credit Limit: ' || customer_record.CREDIT_LIMIT);
    END LOOP;
END;

-- Call the procedure
BEGIN
    SHOW_CUSTOMERS_BY_CREDIT_LIMIT(5000);
END;

/*
 6. Ndertoni funksionin qe llogarit shitjet total ne baze te vitit.
 */
CREATE OR REPLACE FUNCTION CALCULATE_SALES_BY_YEAR(
    in_year PLS_INTEGER
) RETURN NUMBER
    IS
total_sales NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(UNIT_PRICE * QUANTITY), 0)
        INTO total_sales
        FROM ORDER_ITEMS
        JOIN ORDERS ON ORDER_ITEMS.ORDER_ID = ORDERS.ORDER_ID
        WHERE STATUS = 'Processed'
        AND EXTRACT(YEAR FROM ORDER_DATE) = in_year;

        RETURN total_sales;
    END;

-- Call the function
DECLARE
    total_sales NUMBER;
BEGIN
    total_sales := CALCULATE_SALES_BY_YEAR(2023);
    DBMS_OUTPUT.PUT_LINE('Total sales for the year 2023: ' || '$' || total_sales);
END;



