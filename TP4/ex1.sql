
SET SERVEROUTPUT ON;

-- 1. Procédure anonyme pour saisir deux entiers et afficher leur somme
DECLARE
  a NUMBER;
  b NUMBER;
  somme NUMBER;
BEGIN
  a := &Entier1;
  b := &Entier2;
  somme := a + b;
  DBMS_OUTPUT.PUT_LINE('La somme de ' || a || ' et ' || b || ' est : ' || somme);
END;
/

-- 2. Procédure anonyme qui affiche la table de multiplication d’un nombre
DECLARE
  n NUMBER := &Nombre;
  i NUMBER := 1;
BEGIN
  WHILE i <= 10 LOOP
    DBMS_OUTPUT.PUT_LINE(n || ' x ' || i || ' = ' || (n * i));
    i := i + 1;
  END LOOP;
END;
/

-- 3. Fonction récursive pour calculer x^n
CREATE OR REPLACE FUNCTION puissance(x IN NUMBER, n IN NUMBER) RETURN NUMBER IS
BEGIN
  IF n = 0 THEN
    RETURN 1;
  ELSE
    RETURN x * puissance(x, n - 1);
  END IF;
END;
/

-- Exemple d’appel de la fonction puissance
BEGIN
  DBMS_OUTPUT.PUT_LINE('2^5 = ' || puissance(2, 5));
END;
/

-- 4. Création de la table resultatFactoriel
CREATE TABLE resultatFactoriel (
  nombre NUMBER PRIMARY KEY,
  factoriel NUMBER
);

-- 4. Procédure anonyme pour calculer la factorielle d’un nombre et stocker dans la table
DECLARE
  n NUMBER := &Nombre;
  result NUMBER := 1;
  i NUMBER;
BEGIN
  IF n <= 0 THEN
    DBMS_OUTPUT.PUT_LINE('Erreur : le nombre doit être strictement positif.');
  ELSE
    FOR i IN 1..n LOOP
      result := result * i;
    END LOOP;
    INSERT INTO resultatFactoriel VALUES (n, result);
    DBMS_OUTPUT.PUT_LINE('Factorielle de ' || n || ' = ' || result);
  END IF;
END;
/

-- 5. Création de la table resultatsFactoriels
CREATE TABLE resultatsFactoriels (
  nombre NUMBER PRIMARY KEY,
  factoriel NUMBER
);

-- 5. Procédure pour calculer et insérer les factorielles de 1 à 20
DECLARE
  n NUMBER := 1;
  result NUMBER := 1;
BEGIN
  WHILE n <= 20 LOOP
    IF n > 1 THEN
      result := result * n;
    END IF;
    INSERT INTO resultatsFactoriels VALUES (n, result);
    n := n + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Insertion des factorielles de 1 à 20 terminée.');
END;
/
