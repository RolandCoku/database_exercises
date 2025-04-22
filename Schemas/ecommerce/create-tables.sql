-- Creating the table schema
CREATE TABLE EMPLOYEES (
                           EMPLOYEE_ID NUMBER(6) PRIMARY KEY,
                           FIRST_NAME VARCHAR2(20),
                           LAST_NAME VARCHAR2(25),
                           EMAIL VARCHAR2(25),
                           PHONE_NUMBER VARCHAR2(20),
                           HIRE_DATE DATE,
                           JOB_TITLE VARCHAR2(25),
                           MANAGER_ID NUMBER(6),

                           FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
);

CREATE TABLE CUSTOMERS(
                          CUSTOMER_ID NUMBER(6) PRIMARY KEY,
                          NAME VARCHAR2(25),
                          ADDRESS VARCHAR2(50),
                          WEBSITE VARCHAR2(50),
                          CREDIT_LIMIT NUMBER(10)
);

CREATE TABLE ORDERS (
                        ORDER_ID NUMBER(6) PRIMARY KEY,
                        COSTUMER_ID NUMBER(6),
                        STATUS VARCHAR2(25),
                        SALESMAN_ID NUMBER(6),
                        ORDER_DATE DATE,

                        FOREIGN KEY (COSTUMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),
                        FOREIGN KEY (SALESMAN_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
);

CREATE TABLE PRODUCT_CATEGORIES(
                                   CATEGORY_ID NUMBER(6) PRIMARY KEY,
                                   CATEGORY_NAME VARCHAR2(20)
);

CREATE TABLE PRODUCTS(
                         PRODUCT_ID NUMBER(6) PRIMARY KEY,
                         PRODUCT_NAME VARCHAR2(25),
                         DESCRIPTION VARCHAR2(200),
                         STANDARD_COST NUMBER(10),
                         LIST_PRICE NUMBER(10),
                         CATEGORY_ID NUMBER(6),

                         FOREIGN KEY (CATEGORY_ID) REFERENCES PRODUCT_CATEGORIES(CATEGORY_ID)
);

CREATE TABLE ORDER_ITEMS (
                             ORDER_ID NUMBER(6),
                             ITEM_ID NUMBER(6) PRIMARY KEY,
                             PRODUCT_ID NUMBER(6),
                             QUANTITY NUMBER(6),
                             UNIT_PRICE NUMBER(10),

                             FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID),
                             FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID)
);

CREATE TABLE REGIONS(
                        REGION_ID NUMBER(6) PRIMARY KEY,
                        REGION_NAME VARCHAR2(25)
);

CREATE TABLE COUNTRIES(
                          COUNTRY_ID NUMBER(6) PRIMARY KEY,
                          COUNTRY_NAME VARCHAR2(25),
                          REGION_ID NUMBER(6),

                          FOREIGN KEY (REGION_ID) REFERENCES REGIONS(REGION_ID)
);

CREATE TABLE LOCATIONS(
                          LOCATION_ID NUMBER(6) PRIMARY KEY,
                          ADDRESS VARCHAR2(50),
                          POSTAL_CODE VARCHAR2(10),
                          CITY VARCHAR2(20),
                          STATE VARCHAR2(20),
                          COUNTRY_ID NUMBER(6),

                          FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID)
);

CREATE TABLE WAREHOUSES(
                           WAREHOUSE_ID NUMBER(6) PRIMARY KEY,
                           WAREHOUSE_NAME VARCHAR2(20),
                           LOCATION_ID NUMBER(6),

                           FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(LOCATION_ID)
);

CREATE TABLE INVENTORIES(
                            PRODUCT_ID NUMBER(6),
                            WAREHOUSE_ID NUMBER(6),
                            QUANTITY NUMBER(10),

                            FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),
                            FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSES(WAREHOUSE_ID)
);

