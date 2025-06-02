/*
 1. Te shkruhet DDL per ndertimin e tabelave dhe celesave te kesaj skeme duke ndertuar fillimisht tabelat.
    Jepni DDL ku fusha email ne tabelen student te behet e paperseitshme pas ndertimit te skemes.
 */

CREATE TABLE STUDENTI (
    studenti_id INTEGER,
    emri VARCHAR2(50),
    mbiemri VARCHAR2(50),
    ditelindje DATE,
    email VARCHAR2(100),
    statusi CHAR(1),
    grupi_id INTEGER
);

CREATE TABLE GRUPI(
    grupi_id INTEGER,
    emertimi VARCHAR2(100),
    diploma_id VARCHAR2(10),
    viti NUMBER,
    statusi CHAR(1)
);

CREATE TABLE DIPLOMA(
    diploma_id VARCHAR2(10),
    emertimi VARCHAR2(100),
    cikli INTEGER,
    statusi CHAR(1)
);

CREATE TABLE PROVIMI(
    provimi_id INTEGER,
    data DATE,
    lenda_id INTEGER,
    grupi_id INTEGER,
    semestri INTEGER,
    komisioni VARCHAR2(100),
    statusi CHAR(1)
);

CREATE TABLE PROVIMI_STUDENTI(
    provimi_id INTEGER,
    studenti_id INTEGER,
    nota INTEGER,
    statusi CHAR(1)
);

CREATE TABLE LENDA(
    lenda_id INTEGER,
    emertimi VARCHAR2(50),
    diploma_id VARCHAR2(10),
    nr_kredite NUMBER(4, 2),
    semestri INTEGER,
    viti INTEGER,
    statusi CHAR(1)
);

CREATE TABLE STUDENTI_GJENDJA(
    studenti_id INTEGER,
    lenda_id INTEGER,
    frekuentimi CHAR(1),
    detyra CHAR(1),
    laboratore CHAR(1),
    nota INTEGER
);

ALTER TABLE STUDENTI ADD CONSTRAINT pk_studenti PRIMARY KEY (studenti_id);
ALTER TABLE GRUPI ADD CONSTRAINT pk_grupi PRIMARY KEY (grupi_id);
ALTER TABLE DIPLOMA ADD CONSTRAINT pk_diploma PRIMARY KEY (diploma_id);
ALTER TABLE PROVIMI ADD CONSTRAINT pk_provimi PRIMARY KEY (provimi_id);
ALTER TABLE LENDA ADD CONSTRAINT pk_lenda PRIMARY KEY (lenda_id);
ALTER TABLE PROVIMI_STUDENTI ADD CONSTRAINT pk_provimi_studenti PRIMARY KEY (provimi_id, studenti_id);
ALTER TABLE STUDENTI_GJENDJA ADD CONSTRAINT pk_studenti_gjendja PRIMARY KEY (studenti_id, lenda_id);

ALTER TABLE STUDENTI ADD CONSTRAINT fk_studenti_grupi
    FOREIGN KEY (grupi_id) REFERENCES GRUPI(grupi_id);
ALTER TABLE GRUPI ADD CONSTRAINT fk_grupi_diploma
    FOREIGN KEY (diploma_id) REFERENCES DIPLOMA(diploma_id);
ALTER TABLE PROVIMI ADD CONSTRAINT fk_provimi_lenda
    FOREIGN KEY (lenda_id) REFERENCES LENDA(lenda_id);
ALTER TABLE PROVIMI ADD CONSTRAINT fk_provimi_grupi
    FOREIGN KEY (grupi_id) REFERENCES GRUPI(grupi_id);
ALTER TABLE LENDA ADD CONSTRAINT fk_lenda_diploma
    FOREIGN KEY (diploma_id) REFERENCES DIPLOMA(diploma_id);
ALTER TABLE STUDENTI_GJENDJA ADD CONSTRAINT fk_studenti_gjendja_lenda
    FOREIGN KEY (lenda_id) REFERENCES LENDA(lenda_id);
ALTER TABLE STUDENTI_GJENDJA ADD CONSTRAINT fk_studenti_gjendja_studenti
    FOREIGN KEY (studenti_id) REFERENCES STUDENTI(studenti_id);
ALTER TABLE PROVIMI_STUDENTI ADD CONSTRAINT fk_provimi_studenti_provimi
    FOREIGN KEY (provimi_id) REFERENCES PROVIMI(provimi_id);
ALTER TABLE PROVIMI_STUDENTI ADD CONSTRAINT fk_provimi_studenti_studenti
    FOREIGN KEY (studenti_id) REFERENCES STUDENTI(studenti_id);

-- Add a check constraint to ensure email is unique
ALTER TABLE STUDENTI ADD CONSTRAINT chk_email_unique UNIQUE (email);

/*
 2. Per secilen tabele gjeneroni SQL per popullimin e te dhenave me te pakten 2 rekorde per tabele dhe me pas te
    perditesohen notat per studente jo kalues. Per provimi_id te perdoret sekuence dhe me pas student_id eshte fushe qe vete gjenerohet gjithmon;
 */

-- Making student_id auto-incrementig:
-- Menyra 1: (Pa i bere drop kolones ekzistuese)
CREATE SEQUENCE studenti_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER studenti_id
BEFORE INSERT ON STUDENTI
FOR EACH ROW
BEGIN
    SELECT studenti_seq.nextval INTO :NEW.studenti_id FROM DUAL;
END;
/

-- Menyra 2: (Drop and recreate the studenti_id column)

ALTER TABLE PROVIMI_STUDENTI DROP CONSTRAINT fk_provimi_studenti_studenti;
ALTER TABLE STUDENTI_GJENDJA DROP CONSTRAINT fk_studenti_gjendja_studenti;

ALTER TABLE STUDENTI DROP COLUMN STUDENTI_ID;
ALTER TABLE STUDENTI ADD studenti_id INTEGER GENERATED ALWAYS AS IDENTITY;

ALTER TABLE STUDENTI ADD CONSTRAINT pk_studenti PRIMARY KEY (studenti_id);

ALTER TABLE PROVIMI_STUDENTI ADD CONSTRAINT fk_provimi_studenti_studenti
    FOREIGN KEY (studenti_id) REFERENCES STUDENTI(studenti_id);
ALTER TABLE STUDENTI_GJENDJA ADD CONSTRAINT fk_studenti_gjendja_studenti
    FOREIGN KEY (studenti_id) REFERENCES STUDENTI(studenti_id);

-- Sekuence per provimi_id
CREATE SEQUENCE provimi_id_seq START WITH 1 INCREMENT BY 1;


-- Populating the tables with sample data
INSERT INTO DIPLOMA (diploma_id, emertimi, cikli, statusi)
VALUES ('INF', 'Inxhinieri informatike', 1, '1');
INSERT INTO DIPLOMA (diploma_id, emertimi, cikli, statusi)
VALUES ('ELN', 'Inxhinieri Elektronike', 1, '1');

INSERT INTO LENDA (lenda_id, emertimi, diploma_id, nr_kredite, semestri, viti, statusi)
VALUES (1, 'Analize 1', 'INF', 6, 1, 1, '1');
INSERT INTO LENDA(lenda_id, emertimi, diploma_id, nr_kredite, semestri, viti, statusi)
VALUES (2, 'Analize 2', 'ELN', 6, 2, 1, '1');


INSERT INTO GRUPI(grupi_id, emertimi, diploma_id, viti, statusi)
VALUES (1, 'A', 'INF', 1, '1');
INSERT INTO GRUPI(grupi_id, emertimi, diploma_id, viti, statusi)
VALUES (2, 'B', 'ELN', 1, '1');

INSERT INTO STUDENTI (emri, mbiemri, ditelindje, email, statusi, grupi_id)
VALUES ('Roland', 'Çoku', TO_DATE('18-02-2002', 'DD-MM-YYYY'), 'rolandcoku@gmail.com', '1', 1);
INSERT INTO STUDENTI (emri, mbiemri, ditelindje, email, statusi, grupi_id)
VALUES ('Name', 'Surname', TO_DATE('20-12-2000', 'DD-MM-YYYY'), 'name@gmail.com', '1', 1);

INSERT INTO PROVIMI(provimi_id, data, lenda_id, grupi_id, semestri, komisioni, statusi)
VALUES (provimi_id_seq.nextval, TO_DATE('05-06-2025', 'DD-MM-YYYY'), 1, 1, 1, 'TEST, TEST', '1');
INSERT INTO PROVIMI (provimi_id, data, lenda_id, grupi_id, semestri, komisioni, statusi)
VALUES (provimi_id_seq.nextval, TO_DATE('05-06-2025', 'DD-MM-YYYY'), 2, 2, 1, 'test, test', '1');

INSERT INTO PROVIMI_STUDENTI(provimi_id, studenti_id, nota, statusi)
VALUES ((SELECT provimi_id
         FROM PROVIMI
         WHERE data = TO_DATE('05-06-2025', 'DD-MM-YYYY')
           AND lenda_id = 1
           AND grupi_id = 1
           AND semestri = 1
           AND statusi = '1'),
        (SELECT STUDENTI_ID
         FROM STUDENTI
         WHERE emri = 'Roland'
           AND mbiemri = 'Çoku'
           AND statusi = '1'),
        10,
        '1');
INSERT INTO PROVIMI_STUDENTI(provimi_id, studenti_id, nota, statusi)
VALUES ((SELECT provimi_id
         FROM PROVIMI
         WHERE data = TO_DATE('05_06_2025', 'DD-MM-YYYY')
           AND lenda_id = 2
           AND grupi_id = 2
           AND semestri = 1
           AND statusi = '1'),
        (SELECT studenti_id
         FROM STUDENTI
         WHERE email = 'name@gmail.com' AND statusi = '1'),
        4,
        '1');

INSERT INTO STUDENTI_GJENDJA (studenti_id, lenda_id, frekuentimi, detyra, laboratore, nota)
VALUES ((SELECT studenti_id
         FROM STUDENTI
         WHERE email = 'rolandcoku@gmail.com'
           AND statusi = '1'),
        1,
        '1',
        '1',
        '1',
        10
        );
INSERT INTO STUDENTI_GJENDJA (studenti_id, lenda_id, frekuentimi, detyra, laboratore, nota)
VALUES ((SELECT studenti_id
         FROM STUDENTI
         WHERE email = 'name@gmail.com'
           AND statusi = '1'),
        2,
        '1',
        '1',
        '1',
        4);

UPDATE PROVIMI_STUDENTI
SET NOTA = 5
WHERE NOTA = 4;

UPDATE STUDENTI_GJENDJA
SET NOTA = 5
WHERE NOTA = 4;

/*
 3. Te listohen vetem njehere lendet qe jane dhene provim nga data 'A' ne daten 'B'
 */

 SELECT DISTINCT L.lenda_id, L.emertimi
 FROM LENDA L
 JOIN PROVIMI P ON L.LENDA_ID = P.LENDA_ID
 WHERE P.data BETWEEN TO_DATE('01-06-2025', 'DD-MM-YYYY')
     AND TO_DATE('06-06-2025', 'DD-MM-YYYY')
     AND P.statusi = '1';

/*
 4. Per secilin student te shfaqen emrat e lendeve qe kane dhene provimin te pakten dy here.
 */

 SELECT s.emri, l.emertimi, COUNT(p.provimi_id) AS numri_hereve
 FROM STUDENTI s
 JOIN PROVIMI_STUDENTI ps ON s.studenti_id = ps.studenti_id
 JOIN PROVIMI p ON ps.provimi_id = p.provimi_id
 JOIN LENDA L ON p.lenda_id = L.lenda_id
 WHERE ps.statusi = '1'
 GROUP BY s.studenti_id, s.emri, l.emertimi, l.lenda_id
 HAVING COUNT(p.provimi_id) <= 2;

/*
 5. Te afishohen lenda/lendet qe kane kalueshmerine me te ulet (numer studentesh kalues) duke perfshire ne llogaritje
    vetem studetet pjesemarres ne provim (Statusi = '1')
 */

SELECT ln.lenda_id, ln.emertimi, COUNT(CASE WHEN PS.NOTA > 4 THEN PS.studenti_id END) AS NUMRI_STUDENTEVE_KALUES
FROM LENDA ln
JOIN PROVIMI P ON ln.lenda_id = P.lenda_id
JOIN PROVIMI_STUDENTI PS ON P.provimi_id = PS.provimi_id
WHERE P.statusi = '1'
AND PS.statusi = '1'
AND ln.statusi = '1'
GROUP BY ln.lenda_id, ln.emertimi
HAVING COUNT(CASE WHEN PS.NOTA > 4 THEN PS.studenti_id END) = (
    SELECT MIN(studentet_kalues)
    FROM (
        SELECT COUNT(CASE WHEN PS1.nota > 4 THEN PS1.studenti_id END) AS studentet_kalues
        FROM LENDA L
        JOIN PROVIMI P2 ON L.lenda_id = P2.lenda_id AND P2.statusi = '1'
        JOIN PROVIMI_STUDENTI PS1 ON P2.provimi_id = PS1.provimi_id AND PS1.statusi = '1'
        WHERE L.statusi = '1'
        GROUP BY l.lenda_id, l.emertimi
    )
);

-- Shorter solution

SELECT ln.lenda_id, ln.emertimi, COUNT(ps.provimi_id)
FROM PROVIMI p
JOIN LENDA ln ON p.lenda_id = ln.lenda_id
JOIN PROVIMI_STUDENTI ps ON p.provimi_id = ps.provimi_id AND ps.nota <= 4
GROUP BY ln.lenda_id, ln.emertimi
HAVING COUNT(ps.provimi_id) = (
    SELECT MAX(COUNT(ps2.provimi_id))
    FROM PROVIMI p2
    JOIN LENDA L ON p2.lenda_id = L.lenda_id
    JOIN PROVIMI_STUDENTI ps2 ON p2.provimi_id = ps2.provimi_id AND ps2.nota <= 4
    GROUP BY L.lenda_id
    );

/*
 6. Te ndertohet nje funksion qe kthen mesataren e studentit (vetem notat kaluese, nese nuk ka nota kaluese kthen 0) me
    pas kjo kjo te perdoret ne nje select.
 */

CREATE OR REPLACE FUNCTION GET_STUDENT_AVG(
    p_student_id INTEGER
) RETURN NUMBER IS
    v_avg NUMBER := 0;
BEGIN
    SELECT AVG(nota)
    INTO v_avg
    FROM STUDENTI_GJENDJA
    WHERE nota > 4
    AND studenti_id = p_student_id
    AND nota IS NOT NULL;

    RETURN NVL(v_avg, 0);
END;

SELECT emri, mbiemri, GET_STUDENT_AVG(STUDENTI.studenti_id) AS mesatarja
FROM STUDENTI
JOIN STUDENTI_GJENDJA SG ON STUDENTI.studenti_id = SG.studenti_id;

/*
 7. Ndertoni nje procedure e cila te beje regjistrimin e nje studenti ne tabelen student, por me kushtin qe kur nje student
    me te njejtin emer dhe mbiemer ekziston vetem nese thirret e njejta kerkese(procedura) per regjistrim brenda 5 minutash
    (forme konfirmimi) (skema mund te ndryshohet nese duhet)
 */

CREATE TABLE REGISTRATION_ATTEMPTS(
    registration_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emri VARCHAR2(50),
    mbiemri VARCHAR2(50),
    ditelindja DATE,
    email VARCHAR2(100),
    statusi CHAR(1),
    grupi_id INTEGER,
    attempt_time TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE OR REPLACE PROCEDURE REGISTER_STUDENT(
    p_emri IN VARCHAR2,
    p_mbiemri IN VARCHAR2,
    p_ditelindje IN DATE,
    p_email IN VARCHAR2,
    p_statusi IN CHAR,
    p_grupi_id IN INTEGER
) IS
    v_same_name_surname INTEGER;
    v_registration_attempt_in_5_min INTEGER;
BEGIN
    SELECT NVL(COUNT(*), 0)
    INTO v_same_name_surname
    FROM STUDENTI
    WHERE UPPER(emri) = UPPER(p_emri)
    AND UPPER(mbiemri) = UPPER(p_mbiemri)
    AND statusi = '1';

    IF v_same_name_surname > 0 THEN
        SELECT NVL(COUNT(*), 0)
        INTO v_registration_attempt_in_5_min
        FROM REGISTRATION_ATTEMPTS
        WHERE emri = p_emri
        AND mbiemri = p_mbiemri
        AND ditelindja = p_ditelindje
        AND email = p_email
        AND grupi_id = p_grupi_id
        AND attempt_time >= (SYSTIMESTAMP - INTERVAL '5' MINUTE);

        IF v_registration_attempt_in_5_min = 0 THEN
            INSERT INTO REGISTRATION_ATTEMPTS (emri, mbiemri, ditelindja, email, statusi, grupi_id)
            VALUES (p_emri, p_mbiemri, p_ditelindje, p_email, p_statusi, p_grupi_id);
            COMMIT;

            RAISE_APPLICATION_ERROR(-20020, 'A student with the same name and surname exists! ' ||
                                            'Try again if you want to continue with the registration.');
        END IF;
    END IF;

    INSERT INTO STUDENTI (emri, mbiemri, ditelindje, email, statusi, grupi_id)
    VALUES (p_emri, p_mbiemri, p_ditelindje, p_email, p_statusi, p_grupi_id);

    COMMIT;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20021, 'A student with the same email already exists.');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20022, 'An error occurred: ' || SQLERRM);
END;

BEGIN
    REGISTER_STUDENT(
    'Roland',
    'Çoku',
    TO_DATE('18-02-2002', 'DD-MM-YYYY'),
    'rolandcoku1@gmail.com',
    '1',
    1
    );
END;

/*
 8. Te ndertohet nje rol dhe perdorues sekretaria qe administron te dhenat e studenteve, grupeve dhe lendeve dhe nje rol
    Petagog i cili ploteson provimet. Perdoruesit e rolit sekretaria mund te percaktojne grupin e studentit vetem para muajit shkurt.
 */

CREATE ROLE SEKRETARIA;

GRANT SELECT, INSERT, DELETE, UPDATE ON STUDENTI TO SEKRETARIA;
GRANT SELECT, INSERT, DELETE, UPDATE ON GRUPI TO SEKRETARIA;
GRANT SELECT, INSERT, DELETE, UPDATE ON LENDA TO SEKRETARIA;
GRANT SELECT, INSERT, DELETE, UPDATE ON STUDENTI_GJENDJA TO SEKRETARIA;
GRANT SELECT, INSERT, DELETE, UPDATE ON PROVIMI_STUDENTI TO SEKRETARIA;
GRANT SELECT ON DIPLOMA TO SEKRETARIA;
GRANT SELECT ON PROVIMI TO SEKRETARIA;

CREATE USER SEKRETARIA_USER IDENTIFIED BY sekretariapass;

GRANT SEKRETARIA TO SEKRETARIA_USER;

CREATE ROLE PETAGOG;

GRANT INSERT, UPDATE ON PROVIMI TO PETAGOG;
GRANT SELECT ON LENDA TO PETAGOG;
GRANT SELECT ON GRUPI TO PETAGOG;

CREATE OR REPLACE TRIGGER TRG_PREVENT_GROUP_UPDATE
BEFORE UPDATE OF grupi_id ON STUDENTI
FOR EACH ROW
DECLARE
    v_role NUMBER;
BEGIN
    SELECT NVL(COUNT(*), 0)
    INTO v_role
    FROM SESSION_ROLES
    WHERE ROLE = 'SEKRETARIA';

    IF v_role > 0 THEN
        IF EXTRACT(MONTH FROM SYSDATE) BETWEEN 2 AND 6 THEN
            RAISE_APPLICATION_ERROR(-20020, 'Grup_id cannot be changed after february!');
        END IF;
    END IF;
END;

/*
 9. Shkruani nje procedure e cila do te plotesoje nje flete provimi (pa nota) bazuar ne rezultatet e studentit ku semestri,
    lenda dhe grupi merren si parametra.
 */
CREATE OR REPLACE PROCEDURE FLETE_PROVIMI(
    p_semestri IN NUMBER,
    p_lenda_id IN INTEGER,
    p_grupi_id IN INTEGER
) IS
    CURSOR c_students IS
        SELECT s.studenti_id
        FROM STUDENTI s
        LEFT JOIN STUDENTI_GJENDJA sg ON s.studenti_id = sg.studenti_id
        WHERE sg.lenda_id = p_lenda_id
        AND sg.frekuentimi = '1'
        AND sg.laboratore = '1'
        AND sg.detyra = '1'
        AND s.grupi_id = p_grupi_id;
    v_provimi_id INTEGER;
BEGIN
    INSERT INTO PROVIMI (provimi_id, data, lenda_id, grupi_id, semestri, komisioni, statusi)
    VALUES (provimi_id_seq.nextval, TO_DATE('20-06-2025', 'DD-MM-YYYY'), p_lenda_id, p_grupi_id, p_semestri, 'Komisioni', '1')
    RETURNING PROVIMI_ID INTO v_provimi_id;

    FOR rec IN c_students LOOP
        INSERT INTO PROVIMI_STUDENTI (provimi_id, studenti_id, nota, statusi)
        VALUES (v_provimi_id, rec.studenti_id, NULL, '1');
    END LOOP;
END;


