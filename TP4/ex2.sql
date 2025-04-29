-- TP4 - Exercice 2 : Gestion des employés avec PL/SQL

-- Création de la table emp
DROP TABLE emp CASCADE CONSTRAINTS;

CREATE TABLE emp (
    matr NUMBER(10) NOT NULL,
    nom VARCHAR2(50) NOT NULL,
    sal NUMBER(7,2),
    adresse VARCHAR2(96),
    dep NUMBER(10) NOT NULL,
    CONSTRAINT emp_pk PRIMARY KEY (matr)
);

-- Insertion initiale (valeurs d'exemple)
INSERT INTO emp VALUES (1, 'Ali', 2300, '10 rue Victor Hugo', 92000);
INSERT INTO emp VALUES (2, 'Sami', 2100, '15 avenue Mermoz', 75000);
INSERT INTO emp VALUES (3, 'Lina', 2700, '22 rue République', 92000);
COMMIT;

-- 1. Bloc anonyme pour insérer un nouvel employé
SET SERVEROUTPUT ON;
DECLARE
    v_employe emp%ROWTYPE;
BEGIN
    v_employe.matr := 4;
    v_employe.nom := 'Youcef';
    v_employe.sal := 2500;
    v_employe.adresse := 'avenue Anatole France';
    v_employe.dep := 92000;
    INSERT INTO emp VALUES v_employe;
    COMMIT;
END;
/

-- 2. Bloc anonyme pour supprimer tous les employés avec dep = 10
SET SERVEROUTPUT ON;
DECLARE
    v_nb_lignes NUMBER;
BEGIN
    DELETE FROM emp WHERE dep = 10;
    v_nb_lignes := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('v_nb_lignes : ' || v_nb_lignes);
    COMMIT;
END;
/

-- 3. Somme des salaires avec curseur et boucle LOOP
DECLARE
    v_salaire emp.sal%TYPE;
    v_total emp.sal%TYPE := 0;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
        END IF;
    END LOOP;
    CLOSE c_salaires;
    DBMS_OUTPUT.PUT_LINE('Total des salaires : ' || v_total);
END;
/

-- 4. Moyenne des salaires avec curseur et boucle LOOP
DECLARE
    v_salaire emp.sal%TYPE;
    v_total emp.sal%TYPE := 0;
    v_count NUMBER := 0;
    CURSOR c_salaires IS SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
            v_count := v_count + 1;
        END IF;
    END LOOP;
    CLOSE c_salaires;
    DBMS_OUTPUT.PUT_LINE('Moyenne des salaires : ' || ROUND(v_total / v_count, 2));
END;
/

-- 5. Somme et moyenne avec boucle FOR IN
-- a) Somme
DECLARE
    v_total emp.sal%TYPE := 0;
BEGIN
    FOR r IN (SELECT sal FROM emp) LOOP
        IF r.sal IS NOT NULL THEN
            v_total := v_total + r.sal;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total (FOR): ' || v_total);
END;
/

-- b) Moyenne
DECLARE
    v_total emp.sal%TYPE := 0;
    v_count NUMBER := 0;
BEGIN
    FOR r IN (SELECT sal FROM emp) LOOP
        IF r.sal IS NOT NULL THEN
            v_total := v_total + r.sal;
            v_count := v_count + 1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Moyenne (FOR): ' || ROUND(v_total / v_count, 2));
END;
/

-- 6. Curseur paramétré pour afficher les employés des départements 92000 et 75000
DECLARE
    CURSOR c(p_dep emp.dep%TYPE) IS
        SELECT dep, nom FROM emp WHERE dep = p_dep;
BEGIN
    FOR v_employe IN c(92000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 1 : ' || v_employe.nom);
    END LOOP;
    FOR v_employe IN c(75000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 2 : ' || v_employe.nom);
    END LOOP;
END;
/
