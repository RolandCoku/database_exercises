/*
 1. Te shkruhet DDL per ndertimin e tabelave dhe celesave te kesaj skeme duke ndertuar fillimits tabelat.
    Jepni DDL ku fusha email ne tabelen student te jete e paperseritshme.
 */


CREATE TABLE student(
    student_id NUMBER,
    emri VARCHAR2(30),
    mbiemri VARCHAR2(30),
    dt_lindje DATE,
    email VARCHAR2(100),
    grupi_id INTEGER NOT NULL,
    statusi VARCHAR2(1)
);

CREATE TABLE grupi(
    grupi_id INTEGER,
    emertimi VARCHAR2(20),
    viti NUMBER,
    statusi VARCHAR2(1)
);

CREATE TABLE lenda(
    kodi VARCHAR2(5),
    emertimi VARCHAR2(50),
    nr_kredite NUMBER,
    semestri VARCHAR2(2),
    statusi VARCHAR2(1)
);

CREATE TABLE studenti_lenda(
    studenti_id NUMBER NOT NULL,
    kodi VARCHAR2(5) NOT NULL,
    nota NUMBER,
    frekuentimi NUMBER,
    detyra VARCHAR2(2),
    laboratore VARCHAR2(2)
);

CREATE TABLE provimi_studenti(
    provimi_id INTEGER NOT NULL,
    studenti_id NUMBER NOT NULL,
    nota NUMBER,
    statusi VARCHAR2(1)
);

CREATE TABLE provimi(
    provimi_id INTEGER,
    grupi_id INTEGER,
    kodi VARCHAR2(5),
    data DATE,
    statusi VARCHAR2(1)
);

ALTER TABLE student ADD CONSTRAINT pk_student PRIMARY KEY (student_id);
ALTER TABLE lenda ADD CONSTRAINT pk_lenda PRIMARY KEY (kodi);
ALTER TABLE studenti_lenda ADD CONSTRAINT pk_studenti_lenda PRIMARY KEY (studenti_id, kodi);
ALTER TABLE provimi ADD CONSTRAINT pk_provimi PRIMARY KEY (provimi_id);
ALTER TABLE grupi ADD CONSTRAINT pk_grupi PRIMARY KEY (grupi_id);
ALTER TABLE provimi_studenti ADD CONSTRAINT pk_provimi_studenti PRIMARY KEY (provimi_id, studenti_id);

ALTER TABLE student
    ADD CONSTRAINT fk_studenti_grupi FOREIGN KEY (grupi_id) REFERENCES grupi(grupi_id);
ALTER TABLE provimi
    ADD CONSTRAINT fk_provimi_grupi FOREIGN KEY (grupi_id) REFERENCES grupi(grupi_id)
    ADD CONSTRAINT fk_provimi_lenda FOREIGN KEY (kodi) REFERENCES lenda (kodi);
ALTER TABLE studenti_lenda
    ADD CONSTRAINT fk_studenti_lenda_lenda FOREIGN KEY (kodi) REFERENCES lenda(kodi)
    ADD CONSTRAINT fk_studenti_lenda_studenti FOREIGN KEY (studenti_id) REFERENCES student(student_id);
ALTER TABLE provimi_studenti
    ADD CONSTRAINT fk_provimi_studenti_provimi FOREIGN KEY (provimi_id) REFERENCES provimi(provimi_id)
    ADD CONSTRAINT fk_provimi_studenti_student FOREIGN KEY (studenti_id) REFERENCES student(student_id);

ALTER TABLE student
    ADD CONSTRAINT c_email_unique UNIQUE (email);

/*
 2. Per secilen tabele gjeneroni SQL per popullimin e te dhenave me te pakten 3 rekorde per tabele dhe me pas te perditesohen notat per provimin per secilin student.
    Per provimi_id dhe per student_id te perdoret sekuence.
 */

CREATE SEQUENCE provimi_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE student_id_seq START WITH 1 INCREMENT BY 1;

INSERT INTO grupi (grupi_id, emertimi, viti, statusi)
VALUES (1, 'A', 1, '1');
INSERT INTO grupi (grupi_id, emertimi, viti, statusi)
VALUES (2, 'B', 1, '1');
INSERT INTO grupi (grupi_id, emertimi, viti, statusi)
VALUES (3, 'C', 1, '1');

INSERT INTO student (student_id, emri, mbiemri, dt_lindje, email, grupi_id, statusi)
VALUES (student_id_seq.nextval, 'Roland', 'Coku', TO_DATE('18-02-2002', 'DD-MM-YYYY'), 'rolandcoku@gmail.com', 3, '1');
INSERT INTO student (student_id, emri, mbiemri, dt_lindje, email, grupi_id, statusi)
VALUES (student_id_seq.nextval, 'TestName', 'TestSurname', TO_DATE('05-06-2004', 'DD-MM-YYYY'), 'test@test.com', 1, '1');
INSERT INTO student (student_id, emri, mbiemri, dt_lindje, email, grupi_id, statusi)
VALUES (student_id_seq.nextval, 'Test2Name', 'Test2Surname', TO_DATE('02-12-2005', 'DD-MM-YYYY'), 'test2@test.com', 2, '1');

INSERT INTO lenda (kodi, emertimi, nr_kredite, semestri, statusi)
VALUES ('12345', 'Analize 2', 6, 'II', '1');
INSERT INTO lenda (kodi, emertimi, nr_kredite, semestri, statusi)
VALUES ('14352', 'Analize 1', 6, 'I', '1');
INSERT INTO lenda (kodi, emertimi, nr_kredite, semestri, statusi)
VALUES ('12342', 'Databaze', 6, 'II', '1');

INSERT INTO provimi (provimi_id, grupi_id, kodi, data, statusi)
VALUES (provimi_id_seq.nextval, 1, '12345', TO_DATE('05-06-2025', 'DD-MM-YYYY'), '1');
INSERT INTO provimi (provimi_id, grupi_id, kodi, data, statusi)
VALUES (provimi_id_seq.nextval, 2, '14352', TO_DATE('12-09-2024', 'DD-MM-YYYY'), '1');
INSERT INTO provimi (provimi_id, grupi_id, kodi, data, statusi)
VALUES (provimi_id_seq.nextval, 3, '12342', TO_DATE('20-09-2025', 'DD-MM-YYYY'), '1');

INSERT INTO provimi_studenti (provimi_id, studenti_id, nota, statusi)
VALUES (4, 1, 9, '1');
INSERT INTO provimi_studenti (provimi_id, studenti_id, nota, statusi)
VALUES (1, 2, 6, '1');
INSERT INTO provimi_studenti (provimi_id, studenti_id, nota, statusi)
VALUES (8, 1, 8, '1');

INSERT INTO studenti_lenda (studenti_id, kodi, nota, frekuentimi, detyra, laboratore)
VALUES (1, '12345', 10, 1, '1', '1');
INSERT INTO studenti_lenda (studenti_id, kodi, nota, frekuentimi, detyra, laboratore)
VALUES (2, '14352', 6, 1, '1', '1');
INSERT INTO studenti_lenda (studenti_id, kodi, nota, frekuentimi, detyra, laboratore)
VALUES (1, '12342', 6, 1, '1', '1');

COMMIT;

/*
 3. Te listohen vetem njehere studentet ne baze te emrit dhe mbiemrit qe kane marre pjese ne provimet nga data 'A' ne daten 'B'.
 */

SELECT s.emri, s.mbiemri
FROM student s
JOIN provimi_studenti ps ON ps.studenti_id = s.student_id AND ps.statusi = '1'
JOIN provimi p ON ps.provimi_id = p.provimi_id
WHERE data BETWEEN TO_DATE('01-06-2025', 'DD-MM-YYYY') AND TO_DATE('30-06-2025', 'DD-MM-YYYY');

/*
 4. Per secilen lende te shfaqen emrat e studenteve qe kane dhene provimin te pakten 2 here.
 */

SELECT DISTINCT s.emri, s.mbiemri
FROM student s
JOIN provimi_studenti ps ON ps.studenti_id = s.student_id AND ps.statusi = '1'
JOIN provimi p ON ps.provimi_id = p.provimi_id
GROUP BY ps.studenti_id, s.emri, s.mbiemri, p.kodi
HAVING COUNT(ps.provimi_id) >= 2;

/*
 5. Shtoni mundesine e provimeve ne data te ndryshme per nje lende me mundesi zgjidhje nga studenti (Ndryshime ne DDL),
    beni nje SQL qe ben CRUD e nevojshme per nje rast.
 */

ALTER TABLE provimi DROP COLUMN data;

ALTER TABLE provimi_studenti
    ADD data_provimit DATE;

INSERT INTO provimi (provimi_id, grupi_id, kodi, statusi)
VALUES (provimi_id_seq.nextval, 1, 12345, '1');

INSERT INTO provimi_studenti (provimi_id, studenti_id, nota, data_provimit, statusi)
VALUES (9, 1, NULL, TO_DATE('20-06-2025', 'DD-MM-YYYY'), '0');
INSERT INTO provimi_studenti(provimi_id, studenti_id, nota, data_provimit, statusi)
VALUES (9, 2, NULL, TO_DATE('22-06-2025', 'DD-MM-YYYY'), '0');

SELECT l.emertimi, ps.data_provimit
FROM lenda l
JOIN provimi p ON p.kodi = l.kodi
JOIN provimi_studenti ps ON ps.provimi_id = p.provimi_id
GROUP BY l.emertimi, ps.data_provimit, l.kodi;

UPDATE provimi_studenti SET nota = 7 WHERE provimi_id = 9 AND studenti_id = 1;

DELETE provimi_studenti WHERE studenti_id = 2 AND provimi_id = 9;

/*
 6. Te afishohen lendet qe kane kalushmerine me te larte (numer studentesh kalues) duke perfshire ne llogaritje vetem studentet
    pjesemarres ne provim.
 */

SELECT l.emertimi, COUNT(DISTINCT ps.studenti_id) AS numri_studenteve_kalues
FROM lenda l
JOIN provimi p ON p.kodi = l.kodi
JOIN provimi_studenti ps ON ps.provimi_id = p.provimi_id
                                AND nota > 4 AND ps.statusi = '1'
GROUP BY l.emertimi, l.kodi
HAVING COUNT(DISTINCT ps.studenti_id) = (
    SELECT MAX(COUNT(DISTINCT s.studenti_id))
    FROM lenda l
    JOIN provimi p2 ON l.kodi = p2.kodi
    JOIN provimi_studenti s ON p2.provimi_id = s.provimi_id AND s.nota > 4 AND s.statusi = '1'
    GROUP BY l.emertimi, l.kodi
    );

/*
 7. Te afishohet grupi me mesataren me te larte te vleresimeve.
 */

SELECT g.grupi_id, g.emertimi, g.viti, AVG(sl.nota) AS mesatarja_grupit
FROM grupi g
JOIN student s ON g.grupi_id = s.grupi_id AND s.statusi = '1'
JOIN studenti_lenda sl ON sl.studenti_id = s.student_id
GROUP BY g.grupi_id, g.emertimi, g.viti
HAVING AVG(sl.nota) = (
    SELECT MAX(AVG(SL2.nota))
    FROM student s2
    JOIN studenti_lenda sl2 ON sl2.studenti_id = s2.student_id
    WHERE s2.statusi = '1'
    GROUP BY s2.grupi_id
    );

/*
 8. Te ndertohet nje rol dhe nje perdorues sekretaria qe administron te dhenat e studenteve, grupeve dhe lendeve dhe nje rol
    Petagog i cili ploteson provimet. Perdoruesit e rolit pedagog mund te kene te drejta vetem ne muajt shkurt, qershor dhe shtator.
 */

CREATE ROLE SEKRETARIA;

GRANT SELECT, INSERT, UPDATE, DELETE ON student TO SEKRETARIA;
GRANT SELECT, INSERT, UPDATE, DELETE ON lenda TO SEKRETARIA;
GRANT SELECT, INSERT, UPDATE, DELETE ON studenti_lenda TO SEKRETARIA;
GRANT SELECT, INSERT, UPDATE, DELETE ON provimi_studenti TO SEKRETARIA;
GRANT SELECT ON PROVIMI TO SEKRETARIA;

CREATE USER sekretaria_user IDENTIFIED BY sekretariapass;

GRANT SEKRETARIA TO sekretaria_user;

CREATE ROLE pedagog;

GRANT SELECT ON lenda TO pedagog;
GRANT SELECT ON grupi TO pedagog;
GRANT SELECT, INSERT, UPDATE, DELETE ON provimi TO pedagog;

CREATE OR REPLACE TRIGGER chck_valid_month_trg
BEFORE INSERT OR UPDATE OR DELETE ON provimi
BEGIN

    IF 'pedagog' IN (SELECT ROLE FROM SESSION_ROLES) THEN
        IF EXTRACT(MONTH FROM SYSDATE) NOT IN (2, 6, 9) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Veprimet mund te kryhen vetem gjate muajve shkurt, qershor dhe shtator');
        END IF;
    END IF;
END;

/*
 9. Shkruani nje procedure e cila do te listoje te gjithe studentet dhe vitin ne baze te krediteve te grumbulluara per vitin e ri akademik.
    Nese ka plotesuar 180 kredite te cilesohet i diplomuar.
 */

CREATE OR REPLACE PROCEDURE GET_STUDENTS_CURRENT_YEAR
IS
    CURSOR c_students IS
        SELECT s.emri,
               s.mbiemri,
               SUM(l.nr_kredite) AS numri_krediteve
        FROM student s
        JOIN grupi g ON s.grupi_id = g.grupi_id
        JOIN studenti_lenda sl ON sl.studenti_id = s.student_id
        JOIN lenda l ON sl.kodi = l.kodi
        WHERE s.statusi = '1' AND sl.nota > 4
        GROUP BY s.emri, s.mbiemri;
    v_viti VARCHAR2(20);
BEGIN

    FOR std IN c_students LOOP

        CASE
            WHEN std.numri_krediteve BETWEEN 0 AND 29 THEN v_viti := '1';
            WHEN std.numri_krediteve BETWEEN 30 AND 79 THEN v_viti := '2';
            WHEN std.numri_krediteve BETWEEN 80 AND 179 THEN v_viti := '3';
            WHEN std.numri_krediteve = 180 THEN v_viti := 'Diplomuar';
        END CASE;

        DBMS_OUTPUT.PUT_LINE(std.emri || ' ' || std.mbiemri || ': Viti ' || v_viti);
    END LOOP;

END;


BEGIN
    GET_STUDENTS_CURRENT_YEAR();
END;

