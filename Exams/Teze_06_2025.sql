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

-- Duke perdorur records

CREATE

CREATE OR REPLACE FUNCTION
