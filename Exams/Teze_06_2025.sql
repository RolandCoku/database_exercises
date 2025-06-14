/*
 1. Te shkruhet DDL per ndertimin e tabelave dhe celesave te kesaj skeme duke ndertuar fillimisht tabelat, ku tabela bileta dhe klienti
    jane fusha qe vete-gjenerohen. Jepni DDL ku fusha email ne tabelen klienti te behet e paperseritshme pas ndertimit te skemes.
    Fusha punonjesi_id tek tabela bileta te behet e detyrueshme.
 */

CREATE TABLE klienti(
    klienti_id INTEGER GENERATED ALWAYS AS IDENTITY,
    emri VARCHAR2(30),
    mbiemri VARCHAR2(30),
    email VARCHAR2(30),
    statusi CHAR(1)
);

CREATE TABLE filmi(
    filmi_id INTEGER,
    titulli VARCHAR2(200),
    viti INTEGER,
    kategoria VARCHAR2(30)
);

CREATE TABLE kinema(
    kinema_id INTEGER,
    emri VARCHAR2(50),
    adresa VARCHAR2(200)
);

CREATE TABLE salla(
    salla_id INTEGER,
    kinema_id INTEGER NOT NULL,
    kapaciteti INTEGER,
    nr_rreshta INTEGER
);

CREATE TABLE orar(
    orari_id INTEGER,
    filmi_id INTEGER NOT NULL,
    salla_id INTEGER NOT NULL,
    dt_fillimi DATE,
    dt_perfundimi DATE,
    ora INTEGER,
    kohezgjatja NUMBER(5,2),
    cmimi NUMBER(10,2)
);

CREATE TABLE bileta(
    bileta_id INTEGER GENERATED ALWAYS AS IDENTITY,
    orari_id INTEGER NOT NULL,
    klienti_id INTEGER,
    punonjesi_id INTEGER,
    data DATE,
    cmimi NUMBER(10, 2),
    rreshti INTEGER,
    rradhe INTEGER,
    rezervimi_online CHAR(1)
);

CREATE TABLE punonjesi(
    punonjesi_id INTEGER,
    kinema_id INTEGER NOT NULL,
    emri VARCHAR2(30),
    mbiemri VARCHAR2(30),
    statusi CHAR(1)
);

ALTER TABLE klienti
    ADD CONSTRAINT pk_klienti PRIMARY KEY (klienti_id);
ALTER TABLE filmi
    ADD CONSTRAINT pk_filmi PRIMARY KEY (filmi_id);
ALTER TABLE kinema
    ADD CONSTRAINT pk_kinema PRIMARY KEY (kinema_id);
ALTER TABLE salla
    ADD CONSTRAINT pk_salla PRIMARY KEY (salla_id);
ALTER TABLE orar
    ADD CONSTRAINT pk_orar PRIMARY KEY (orari_id)
    ADD CONSTRAINT fk_orari_filmi FOREIGN KEY (filmi_id) REFERENCES filmi(filmi_id)
    ADD CONSTRAINT fk_orari_salla FOREIGN KEY (salla_id) REFERENCES salla(salla_id);
ALTER TABLE punonjesi
    ADD CONSTRAINT pk_punonjesi PRIMARY KEY (punonjesi_id)
    ADD CONSTRAINT fk_punonjesi_kinema FOREIGN KEY (kinema_id) REFERENCES kinema(kinema_id);
ALTER TABLE bileta
    ADD CONSTRAINT pk_bileta PRIMARY KEY (bileta_id)
    ADD CONSTRAINT fk_bileta_orari FOREIGN KEY (orari_id) REFERENCES orar(orari_id)
    ADD CONSTRAINT fk_bileta_klienti FOREIGN KEY (klienti_id) REFERENCES klienti(klienti_id)
    ADD CONSTRAINT fk_bileta_punonjesi FOREIGN KEY (punonjesi_id) REFERENCES punonjesi(punonjesi_id);

ALTER TABLE klienti
    ADD CONSTRAINT c_email_unq UNIQUE (email);

ALTER TABLE bileta MODIFY punonjesi_id INTEGER NOT NULL;
-- Ose
ALTER TABLE bileta
    ADD CONSTRAINT c_punonjes_required CHECK ( punonjesi_id IS NOT NULL );

/*
 2. Per secilen table gjeneroni SQL per popullimin e te dheave me te pakten 2 rekorde per tabele dhe me pas te perditesohen
    titulli dhe viti i nje filmi. Per orari_id te perdoret sekuence.
 */

CREATE SEQUENCE orari_id_seq START WITH 1 INCREMENT BY 1;

INSERT INTO klienti VALUES (DEFAULT, 'klienti1N', 'klienti1M', 'klienti1@gmail.com', '1');
INSERT INTO klienti VALUES (DEFAULT, 'klienti2N', 'klienti2M', 'klienti2@gmail.com', '1');

INSERT INTO filmi VALUES (1, 'Filmi1', 2025, 'AKSION');
INSERT INTO filmi VALUES (2, 'Filmi2', 2024, 'MISTER');

INSERT INTO kinema VALUES (1, 'kinema1', 'kinema1_adresa');
INSERT INTO kinema VALUES (2, 'kinama2', 'kinema2_adresa');

INSERT INTO salla VALUES (1, 1, 50, 10);
INSERT INTO salla VALUES (2, 2, 100, 20);

INSERT INTO punonjesi VALUES (1, 1, 'Punonjes1N', 'Punonjes1M', '1');
INSERT INTO punonjesi VALUES (2, 2, 'Punonjes2N', 'Punonjes2M', '1');

INSERT INTO orar VALUES (orari_id_seq.nextval, 1, 1, TO_DATE('20-05-2025', 'DD-MM-YYYY'), TO_DATE('25-05-2025', 'DD-MM-YYYY'), 16, 2.5, 700);
INSERT INTO orar VALUES (orari_id_seq.nextval, 1, 2, TO_DATE('25-05-2025', 'DD-MM-YYYY'), TO_DATE('30-05-2025', 'DD-MM-YYYY'), 17, 2.5, 600);

INSERT INTO bileta VALUES (DEFAULT, 1, 1, 1, TO_DATE('22-05-2025', 'DD-MM-YYYY'), 700, 1, 1, 'N');
INSERT INTO bileta VALUES (DEFAULT, 2, 2, 2, TO_DATE('27-05-2025', 'DD-MM-YYYY'), 600, 2, 3, 'N');

COMMIT ;

/*
 3. Te listohen vetem njehere filmat qe jane shfaqur nga data 'A' ne daten 'B'
 */

SELECT DISTINCT f.filmi_id, f.titulli
FROM filmi f
JOIN orar o ON f.filmi_id = o.filmi_id
WHERE o.dt_fillimi BETWEEN TO_DATE('20-05-2025', 'DD-MM-YYYY') AND TO_DATE('30-05-2025', 'DD-MM-YYYY');

/*
 4. Per secilin film te shfaqen emrat e kinemave qe eshte dhene filmi me shume se 2 here ne te pakten 3 dite.
 */

SELECT f.filmi_id, f.titulli, k.kinema_id, k.emri
FROM filmi f
JOIN orar o ON f.filmi_id = o.filmi_id
JOIN salla s ON o.salla_id = s.salla_id
JOIN kinema k ON s.kinema_id = k.kinema_id
WHERE o.dt_perfundimi - o.dt_fillimi >= 3
GROUP BY f.filmi_id, f.titulli, k.kinema_id, k.emri
HAVING COUNT(o.orari_id) > 2;

/*
 5. Te ndertohet funksoni i cili merr si parametra klienti_id, daten dhe kthen filmat (filimi_id, kinema_id, salla_id) qe ai ka pare ne ate dite.
 */

CREATE OR REPLACE FUNCTION GET_CLIENT_MOVIES(
    p_klienti_id INTEGER,
    p_date DATE
) RETURN SYS_REFCURSOR
IS
    c_client_movies SYS_REFCURSOR;
BEGIN

    OPEN c_client_movies FOR
        SELECT o.filmi_id, s.kinema_id, s.salla_id
        FROM bileta b
        JOIN orar o ON b.orari_id = o.orari_id
        JOIN salla s ON o.salla_id = s.salla_id
        WHERE b.klienti_id = p_klienti_id AND TRUNC(b.data) = TRUNC(p_date);

    RETURN c_client_movies;
END;

-- Zgjidhja duke perdorur records
CREATE OR REPLACE TYPE movie_record AS OBJECT (
    filmi_id INTEGER,
    kinema_id INTEGER,
    salla_id INTEGER
);

CREATE OR REPLACE TYPE movie_record_array AS TABLE OF movie_record;

CREATE OR REPLACE FUNCTION GET_CLIENT_MOVIES_ARRAY(
    p_klienti_id INTEGER,
    p_date DATE
) RETURN movie_record_array
IS
    v_movies movie_record_array;
BEGIN
    SELECT movie_record(o.filmi_id, s.kinema_id, s.salla_id)
    BULK COLLECT INTO v_movies
    FROM bileta b
    JOIN orar o ON b.orari_id = o.orari_id
    JOIN salla s ON o.salla_id = s.salla_id
    WHERE b.klienti_id = p_klienti_id AND TRUNC(b.data) = TRUNC(p_date);

    RETURN v_movies;
END;

-- Thirrje funksionit
DECLARE
    v_movies movie_record_array;
BEGIN
    v_movies := GET_CLIENT_MOVIES_ARRAY(1, TO_DATE('22-05-2025', 'DD-MM-YYYY'));

    FOR i IN 1 .. v_movies.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Filmi ID: ' || v_movies(i).filmi_id || ', Kinema ID: ' || v_movies(i).kinema_id || ', Salla ID: ' || v_movies(i).salla_id);
    END LOOP;
END;

/*
 6. Te ndertohet nje rol dhe perdorues menaxher qe administron te dhenat e kinemave, sallave, punonjes, filmave dhe orareve
    dhe nje rol Punonjes i cili ploteson klientet dhe biletat.
    Perdoruesit e rolit punonjes te mos leohet te presin bileta per nje orar qe ka me shume se 10 minuta qe ka filluar filmi.
 */

CREATE ROLE menaxher;
GRANT CONNECT TO menaxher;

GRANT ALL ON kinema TO menaxher;
GRANT ALL ON salla TO menaxher;
GRANT ALL ON filmi TO menaxher;
GRANT ALL ON orar TO menaxher;
GRANT ALL ON punonjesi TO menaxher;

CREATE USER menaxher_user IDENTIFIED BY menaxher_password;
GRANT menaxher TO menaxher_user;

CREATE ROLE punonjes;
GRANT CONNECT TO punonjes;

GRANT INSERT, UPDATE ON klienti TO punonjes;
GRANT SELECT, INSERT, UPDATE ON bileta TO punonjes;
GRANT SELECT ON orar TO punonjes;
GRANT SELECT ON punonjesi TO punonjes;

CREATE OR REPLACE TRIGGER prevent_ticket_booking_after_10_minutes
BEFORE INSERT ON bileta
FOR EACH ROW
DECLARE
    v_ora INTEGER;
    v_movie_start_time DATE;
BEGIN

    SELECT ora
    INTO v_ora
    FROM orar
    WHERE orari_id = :NEW.orari_id;

    v_movie_start_time := :NEW.data + (v_ora / 24);

    IF 'punonjes' IN (SELECT ROLE FROM SESSION_ROLES) THEN
        -- Check if the user is a 'punonjes'
        IF v_movie_start_time < SYSDATE - INTERVAL '10' MINUTE THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nuk lejohet te presin bileta per nje orar qe ka me shume se 10 minuta qe ka filluar filmi.');
        END IF;

    END IF;
END prevent_ticket_booking_after_10_minutes;
/

/*
 7. Ndertoni nje procedure e cila do te beje rezervimin per nje film_id, nje orar_id dhe nje numer biletash te caktuar.
    Rezevimi do te bejet duke mundesuar qe shperndarja ne rreshta dhe ne rradhe te salles te jene bashke dhe nese nuk eshte e mundur te mos beje rezervim.
 */

CREATE OR REPLACE PROCEDURE rezervim_bilete(
    p_filmi_id IN INTEGER,
    p_orari_id IN INTEGER,
    p_numri_biletave IN INTEGER
) IS
    v_salla_id INTEGER;
    v_kapaciteti INTEGER;
    v_nr_rreshta INTEGER;
    v_rezervuar INTEGER;
    v_rreshti INTEGER;
    v_rradh INTEGER;
    v_seats_per_row INTEGER;
    v_cmimi NUMBER(10,2);
    v_found_seats BOOLEAN := FALSE;

    no_consecutive_seats EXCEPTION;
BEGIN
    SELECT s.salla_id, s.kapaciteti, s.nr_rreshta, o.cmimi
    INTO v_salla_id, v_kapaciteti, v_nr_rreshta, v_cmimi
    FROM orar o
             JOIN salla s ON o.salla_id = s.salla_id
    WHERE o.orari_id = p_orari_id AND o.filmi_id = p_filmi_id;

    -- Calculate seats per row (assuming equal distribution)
    v_seats_per_row := CEIL(v_kapaciteti / v_nr_rreshta);

    -- Check total available capacity
    SELECT COUNT(*)
    INTO v_rezervuar
    FROM bileta
    WHERE orari_id = p_orari_id;

    IF (v_rezervuar + p_numri_biletave) > v_kapaciteti THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nuk ka vend të mjaftueshëm në sallë. ' ||
                                        'Kapaciteti: ' || v_kapaciteti || ', Rezervuar: ' || v_rezervuar ||
                                        ', Kërkuar: ' || p_numri_biletave);
    END IF;

    -- Find consecutive seats
    FOR current_row IN 1..v_nr_rreshta
        LOOP
            -- Check if we can fit all seats in this row
            IF p_numri_biletave <= v_seats_per_row THEN
                -- Try to find consecutive seats in current row
                FOR start_seat IN 1..(v_seats_per_row - p_numri_biletave + 1)
                    LOOP
                        -- Check if all seats from start_seat to start_seat + p_numri_biletave - 1 are free
                        SELECT COUNT(*)
                        INTO v_rezervuar
                        FROM bileta
                        WHERE orari_id = p_orari_id
                          AND rreshti = current_row
                          AND rradhe BETWEEN start_seat AND (start_seat + p_numri_biletave - 1);

                        -- If no seats are occupied in this range, we found our spots
                        IF v_rezervuar = 0 THEN
                            v_rreshti := current_row;
                            v_rradh := start_seat;
                            v_found_seats := TRUE;
                            EXIT;
                        END IF;
                    END LOOP;

                IF v_found_seats THEN
                    EXIT;
                END IF;
            END IF;
        END LOOP;

    IF NOT v_found_seats THEN
        RAISE no_consecutive_seats;
    END IF;

    FOR i IN 0..(p_numri_biletave - 1) LOOP
            INSERT INTO bileta (
                orari_id,
                data,
                cmimi,
                rreshti,
                rradhe,
                rezervimi_online
            )
            VALUES (
                p_orari_id,
                SYSDATE,
                v_cmimi,
                v_rreshti,
                v_rradh + i,
                'Y'
            );
        END LOOP;

    COMMIT;

EXCEPTION
    WHEN no_consecutive_seats THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002,
                                'Nuk mund të gjenden ' || p_numri_biletave || ' vende të njëpasnjëshme në sallë.');

    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003,
                                'Orari ose filmi i specifikuar nuk ekziston.');

    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004,
                                'Gabim gjatë rezervimit: ' || SQLERRM);
END rezervim_bilete;
/
