/*
 1. Te Shkruhet DDL per ndertimin e tabelave dhe celesave te kesaj skeme duke ndertuar fillimisht tabelat.
    Jepni DDL ku fusha nr_tel ne tabelen klienti te jete e paperseritshme.
 */

CREATE TABLE parkimi(
    parkimi_id INTEGER,
    cmimi_id INTEGER,
    targa VARCHAR2(10) NOT NULL,
    klienti_id INTEGER,
    karta_id INTEGER,
    vend_parkimi_id INTEGER NOT NULL,
    kohe_fillimi DATE,
    kohe_mbarimi DATE,
    afat_qendrimi NUMBER(10, 2),
    nr_ore INTEGER,
    vlera NUMBER(10, 2),
    statusi CHAR(1)
);

CREATE TABLE mjeti(
    targa VARCHAR2(10) NOT NULL,
    marka VARCHAR2(50),
    modeli VARCHAR2(50),
    ngjyra VARCHAR2(20),
    statusi CHAR(1)
);

CREATE TABLE klienti(
    klienti_id NUMBER NOT NULL,
    emri VARCHAR2(50) NOT NULL,
    mbiemri VARCHAR2(50) NOT NULL,
    nr_tel varchar2(30),
    karta_id INTEGER NOT NULL,
    statusi CHAR(1)
);

CREATE TABLE karta(
    karta_id INTEGER NOT NULL,
    date_leshimi DATE,
    date_vlefshmeri DATE,
    statusi CHAR(1)
);

CREATE TABLE vend_parkimi(
    vend_parkimi_id INTEGER,
    adresa VARCHAR2(100),
    nr_vende INTEGER,
    statusi CHAR(1)
);

CREATE TABLE cmimi(
    cmimi_id INTEGER,
    vend_parkimi_id INTEGER NOT NULL,
    nr_ore_min NUMBER(10, 2),
    nr_ore_max NUMBER(10, 2),
    cmimi NUMBER(10, 2),
    statusi CHAR(1)
);

ALTER TABLE parkimi ADD CONSTRAINT pk_parkimi PRIMARY KEY (parkimi_id);
ALTER TABLE mjeti ADD CONSTRAINT pk_mjeti PRIMARY KEY (targa);
ALTER TABLE vend_parkimi ADD CONSTRAINT pk_vend_parkimi PRIMARY KEY (vend_parkimi_id);
ALTER TABLE cmimi ADD CONSTRAINT pk_cmimi PRIMARY KEY (cmimi_id);
ALTER TABLE klienti ADD CONSTRAINT pk_klienti PRIMARY KEY (klienti_id);
ALTER TABLE karta ADD CONSTRAINT pk_karta PRIMARY KEY (karta_id);

ALTER TABLE parkimi
    ADD CONSTRAINT fk_parkimi_mjeti FOREIGN KEY (targa) REFERENCES mjeti(targa)
    ADD CONSTRAINT fk_parkimi_cmimi FOREIGN KEY (cmimi_id) REFERENCES cmimi(cmimi_id)
    ADD CONSTRAINT fk_parkimi_vend_parkimi FOREIGN KEY (vend_parkimi_id) REFERENCES vend_parkimi(vend_parkimi_id)
    ADD CONSTRAINT fk_parkimi_klienti FOREIGN KEY (klienti_id) REFERENCES klienti(klienti_id)
    ADD CONSTRAINT fk_parkimi_karta FOREIGN KEY (karta_id) REFERENCES karta(karta_id);

ALTER TABLE klienti
    ADD CONSTRAINT fk_klienti_karta FOREIGN KEY (karta_id) REFERENCES karta(karta_id);

ALTER TABLE cmimi
    ADD CONSTRAINT fk_cmimi_vend_parkimi FOREIGN KEY (vend_parkimi_id) REFERENCES vend_parkimi(vend_parkimi_id);


ALTER TABLE klienti ADD CONSTRAINT c_nr_tel_unique UNIQUE (nr_tel);

/*
 2. Per secilen tabele gjeneroni SQL per popullimin e te dhenave me te pakten 3 rekorde per tabele dhe me pas te perditesohet
    statusi i parkimit per klientin me ID 100. Per parkimi_id te perdoret sekuence, ndersa klienti_id eshte identity.
 */

CREATE SEQUENCE parkimi_id_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE klienti_id_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_klienti_id
BEFORE INSERT ON klienti
FOR EACH ROW
BEGIN
    SELECT klienti_id_seq.nextval INTO :NEW.klienti_id FROM DUAL;
END;


INSERT INTO karta (karta_id, date_leshimi, date_vlefshmeri, statusi)
VALUES (1, SYSDATE, SYSDATE + INTERVAL '12' MONTH, '1');
INSERT INTO karta (karta_id, date_leshimi, date_vlefshmeri, statusi)
VALUES (2, TO_DATE('20-05-2025', 'DD-MM-YYYY'), TO_DATE('20-05-2025', 'DD-MM-YYYY') + INTERVAL '12' MONTH, '1');
INSERT INTO karta(karta_id, date_leshimi, date_vlefshmeri, statusi)
VALUES (3, TO_DATE('25-05-2025', 'DD-MM-YYYY'), TO_DATE('25-05-2025', 'DD-MM-YYYY') + INTERVAL '6' MONTH, '1');

INSERT INTO klienti (emri, mbiemri, nr_tel, karta_id, statusi)
VALUES ('Roland', 'Çoku', '23112321421', 1, '1');
INSERT INTO klienti (emri, mbiemri, nr_tel, karta_id, statusi)
VALUES ('Test1', 'Test1', '213124214', 2, '1');
INSERT INTO klienti (emri, mbiemri, nr_tel, karta_id, statusi)
VALUES ('Test2', 'Test2', '21421431221', 3, '3');

INSERT INTO vend_parkimi (vend_parkimi_id, adresa, nr_vende, statusi)
VALUES (1, 'Rruga e Dibrës', 100, '1');
INSERT INTO vend_parkimi (vend_parkimi_id, adresa, nr_vende, statusi)
VALUES (2, 'Rruga e Elbasanit', 50, '1');
INSERT INTO vend_parkimi (vend_parkimi_id, adresa, nr_vende, statusi)
VALUES (3, 'Rruga e Kavajës', 75, '1');


INSERT INTO cmimi (cmimi_id, vend_parkimi_id, nr_ore_min, nr_ore_max, cmimi, statusi)
VALUES (1, 1, 0, 2, 100, '1');
INSERT INTO cmimi (cmimi_id, vend_parkimi_id, nr_ore_min, nr_ore_max, cmimi, statusi)
VALUES (2, 1, 2, 4, 150, '1');
INSERT INTO cmimi (cmimi_id, vend_parkimi_id, nr_ore_min, nr_ore_max, cmimi, statusi)
VALUES (3, 2, 0, 1, 50, '1');

INSERT INTO mjeti (targa, marka, modeli, ngjyra, statusi)
VALUES ('AA123BB', 'Toyota', 'Corolla', 'Blu', '1');
INSERT INTO mjeti (targa, marka, modeli, ngjyra, statusi)
VALUES ('BB456CC', 'Honda', 'Civic', 'E bardhë', '1');
INSERT INTO mjeti (targa, marka, modeli, ngjyra, statusi)
VALUES ('CC789DD', 'Ford', 'Focus', 'E zezë', '1');

INSERT INTO parkimi (parkimi_id, cmimi_id, targa, klienti_id, karta_id, vend_parkimi_id, kohe_fillimi, kohe_mbarimi, afat_qendrimi, nr_ore, vlera, statusi)
VALUES (parkimi_id_seq.NEXTVAL, 1, 'BB456CC', (
    SELECT klienti_id
    FROM klienti
    WHERE emri = 'Roland' AND mbiemri = 'Çoku' AND nr_tel = '23112321421'
    ), 1, 1, SYSDATE - INTERVAL '2' HOUR, SYSDATE, 1.5, 2, 100, 'A');
INSERT INTO parkimi (parkimi_id, cmimi_id, targa, klienti_id, karta_id, vend_parkimi_id, kohe_fillimi, kohe_mbarimi, afat_qendrimi, nr_ore, vlera, statusi)
VALUES (parkimi_id_seq.NEXTVAL, 2, 'BB456CC', (
    SELECT klienti_id
    FROM klienti
    WHERE emri = 'Test1' AND mbiemri = 'Test1' AND nr_tel = '213124214'
    ), 2, 2, SYSDATE - INTERVAL '3' HOUR, SYSDATE, 3.0, 4, 150, 'A');
INSERT INTO parkimi (parkimi_id, cmimi_id, targa, klienti_id, karta_id, vend_parkimi_id, kohe_fillimi, kohe_mbarimi, afat_qendrimi, nr_ore, vlera, statusi)
VALUES (parkimi_id_seq.NEXTVAL, 1, 'CC789DD', (
    SELECT klienti_id
    FROM klienti
    WHERE emri = 'Test2' AND mbiemri = 'Test2' AND nr_tel = '21421431221'
    ), 3, 3, SYSDATE - INTERVAL '1' HOUR, SYSDATE, 2.0, 2, 50, 'A');

-- Update the status of the parking for client with ID 100
UPDATE parkimi SET statusi = '0'
WHERE klienti_id = 100
AND statusi = '1';

/*
 3. Te listohen vetem njehere klientet ne baze te emrit dhe mbiemrit qe kane parkuar te pakten njehere nga data 'A' ne daten 'B'.
 */

SELECT DISTINCT k.emri, k.mbiemri
FROM klienti k
JOIN parkimi p ON k.klienti_id = p.klienti_id
WHERE kohe_fillimi BETWEEN TO_DATE('20-05-2025', 'DD-MM-YYYY') AND SYSDATE;

/*
 4. Per secilin vend parkimi te shfaqen emrat e klienteve qe kane parkuar te pakten 5 here brenda nje date.
 */

SELECT k.klienti_id, k.emri, k.mbiemri, TRUNC(p.kohe_fillimi) AS data_parkimi, 
       v.vend_parkimi_id
FROM klienti k 
JOIN parkimi p ON p.klienti_id = k.klienti_id
JOIN vend_parkimi v ON p.vend_parkimi_id = v.vend_parkimi_id 
GROUP BY k.klienti_id, k.emri, k.mbiemri, TRUNC(p.kohe_fillimi), v.vend_parkimi_id
HAVING COUNT(*) >= 5;

/*
 5. Shtoni mundesine qe nje mjet mund te kete disa kliente dsi dhe nje klient te kete disa mjete dhe karta,
    por asnjehere nje mjet nuk mund te parkohet me me shume se dy karta.
 */

CREATE TABLE klienti_mjeti(
    klienti_id INTEGER NOT NULL,
    targa VARCHAR2(10) NOT NULL,

    CONSTRAINT pk_klienti_mjeti PRIMARY KEY (klienti_id, targa),
    CONSTRAINT fk_klienti_mjeti FOREIGN KEY (klienti_id) REFERENCES klienti(klienti_id),
    CONSTRAINT fk_mjeti_klienti FOREIGN KEY (targa) REFERENCES mjeti(targa)
);

ALTER TABLE klienti DROP CONSTRAINT fk_klienti_karta;

ALTER TABLE karta
    ADD klienti_id INTEGER
    ADD CONSTRAINT fk_karta_klienti FOREIGN KEY (klienti_id) REFERENCES klienti(klienti_id) ON DELETE CASCADE;

-- Nese kerkohet te ruhet lidhja mes kartave ekzistuese
CREATE OR REPLACE PROCEDURE set_klient_id_for_existing_cards
IS
CURSOR c_klients IS
    SELECT klienti_id, karta_id
    FROM klienti;
BEGIN

    FOR klient IN c_klients LOOP
        UPDATE karta
        SET klienti_id = klient.klienti_id
        WHERE karta_id = klient.karta_id;
    END LOOP;
END;

ALTER TABLE klienti
    DROP COLUMN karta_id;

CREATE OR REPLACE TRIGGER check_karte_mjeti
BEFORE INSERT ON PARKIMI
FOR EACH ROW
    DECLARE
        v_distinct_cards NUMBER := 0;
BEGIN

    IF :NEW.karta_id IS NOT NULL THEN
        SELECT COUNT(DISTINCT karta_id)
        INTO v_distinct_cards
        FROM PARKIMI
        WHERE targa = :NEW.targa
        AND karta_id != :NEW.karta_id;

        IF v_distinct_cards >= 2 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Mjeti eshte parkuar me pare duke perdorur dy karta te ndryshme. ' ||
                                            'Nuk mund te parkohet me nje te re!');
        END IF;
    END IF;
END;


/*
 6. Te afishohen vend parkimi i cili ka numerin me te madh te parkimeve (jo vend parkime) per automjetet te cilat nuk kane
    klient te percaktuar.
 */

--Metoda Luisit

SELECT vp.vend_parkimi_id, vp.adresa, COUNT(p.parkimi_id) AS NUMRI_PARKIMEVE
FROM vend_parkimi vp
JOIN parkimi p ON p.vend_parkimi_id = vp.vend_parkimi_id
WHERE p.klienti_id IS NULL
GROUP BY vp.vend_parkimi_id, vp.adresa
ORDER BY NUMRI_PARKIMEVE DESC
FETCH FIRST 1 ROWS ONLY;

--Metode e pergjithshme duke marre parasysh vende parkimi te cilat kane te njejten numer maksimal parkimesh

SELECT vp.vend_parkimi_id, vp.adresa, COUNT(p.parkimi_id) AS numri_parkimeve
FROM vend_parkimi vp
JOIN parkimi p ON p.vend_parkimi_id = vp.vend_parkimi_id
WHERE klienti_id IS NULL
GROUP BY vp.vend_parkimi_id, vp.adresa
HAVING COUNT(p.parkimi_id) = (
    SELECT MAX(COUNT(p2.parkimi_id))
    FROM parkimi p2
    WHERE p2.klienti_id IS NULL
    GROUP BY p2.vend_parkimi_id
    );

/*
 7. Te afishohet marka e makinave qe parkojne me shpesh ne secilin vend parkimi.
 */

SELECT vp.vend_parkimi_id, vp.adresa, m.marka, COUNT(p.targa) AS times_parked
FROM mjeti m
JOIN parkimi p ON p.targa = m.targa
JOIN vend_parkimi vp ON p.vend_parkimi_id = vp.vend_parkimi_id
GROUP BY vp.vend_parkimi_id, vp.adresa, m.marka
HAVING COUNT(p.targa) = (
    SELECT MAX(COUNT(p2.targa))
    FROM parkimi p2
    JOIN mjeti m2 ON p2.targa = m2.targa
    WHERE p2.vend_parkimi_id = vp.vend_parkimi_id
    GROUP BY p2.vend_parkimi_id, m2.marka
    );

/*
 8. Te ndertohet nje rol dhe perdorues administrator qe administron te dhenat dhe nje rol punonjesi i cili ploteson kliente,
    kartat dhe menaxhon procesin e parkimit. Perdoruesit e rolit punonjes mund te kene te drejtat vetem ne orarin e turnit (6-14 ose 14-22).
 */

CREATE ROLE perdorues_administrator;

GRANT CONNECT TO perdorues_administrator;
GRANT SELECT, INSERT, UPDATE ON  klienti TO perdorues_administartor;
GRANT SELECT, INSERT, UPDATE ON  karta TO perdorues_administartor;
GRANT SELECT, INSERT, UPDATE ON  parkimi TO perdorues_administartor;
GRANT SELECT, INSERT, UPDATE ON  mjeti TO perdorues_administartor;
GRANT SELECT, INSERT, UPDATE ON  vend_parkimi TO perdorues_administartor;
GRANT SELECT, INSERT, UPDATE ON  cmimi TO perdorues_administartor;

CREATE ROLE punonjes;

GRANT CONNECT TO punonjes;

GRANT SELECT, INSERT, UPDATE ON klienti TO punonjes;
GRANT SELECT, INSERT, UPDATE ON karta TO punonjes;
GRANT SELECT, INSERT, UPDATE ON mjeti TO punonjes;
GRANT SELECT, INSERT, UPDATE ON parkimi TO punonjes;

GRANT SELECT ON vend_parkimi TO punonjes;
GRANT SELECT ON cmimi TO punonjes;

GRANT SELECT ON klienti_id_seq TO punonjes;

CREATE OR REPLACE TRIGGER check_punonjes_actions_trg
AFTER LOGON ON DATABASE
BEGIN
    IF 'punonjes' IN (SELECT DBA_ROLE_PRIVS.GRANTED_ROLE FROM DBA_ROLE_PRIVS) THEN
        DECLARE
            v_current_time NUMBER := EXTRACT(HOUR FROM SYSDATE);
        BEGIN
            IF (v_current_time < 6 || v_current_time > 22) THEN
                RAISE_APPLICATION_ERROR(-20001, 'Punonjesi nuk mund te kryeje veprime ne kete ore');
            END IF;
        END;
    END IF;
END;

/*
 9. Shkruani nje procedure e cila do te indentifikoje te gjithe klientet te cilet kane perdorur karten ne nje vend parkim
    te ndryshem gjate kohes kur nje mjet eshte i parkuar me ate karte.
 */

CREATE OR REPLACE PROCEDURE indentifiko_perdorimin_e_kartes_disa_here
IS
    CURSOR c_klientet IS
        SELECT k.emri, k.mbiemri, k.nr_tel
        FROM klienti k
        JOIN parkimi p1 ON k.klienti_id = p1.klienti_id
        JOIN parkimi p2 ON k.klienti_id = p2.klienti_id
        WHERE p1.karta_id = p2.karta_id
        AND p1.targa != p2.targa
        AND p1.parkimi_id != p2.parkimi_id
        AND ( (p2.kohe_fillimi <= p1.kohe_mbarimi)
            OR (p1.kohe_mbarimi <= p2.kohe_fillimi));
BEGIN
    FOR klient IN c_klientet LOOP
            DBMS_OUTPUT.PUT_LINE(klient.emri || ' ' || klient.mbiemri || ' ' || klient.nr_tel);
    END LOOP;
END;

