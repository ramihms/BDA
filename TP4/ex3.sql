-- Supprimer d'abord si nécessaire
DROP TABLE client CASCADE CONSTRAINTS;
DROP PACKAGE pkg_client;

-- Création de la table client
CREATE TABLE client (
    id NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    adresse VARCHAR2(100),
    solde NUMBER(10, 2)
);

-- Package Specification
CREATE OR REPLACE PACKAGE pkg_client IS
    PROCEDURE ajouter_client(p_id NUMBER, p_nom VARCHAR2, p_adresse VARCHAR2, p_solde NUMBER);
    PROCEDURE ajouter_client(p_id NUMBER, p_nom VARCHAR2);
END pkg_client;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY pkg_client IS

    -- Procédure complète
    PROCEDURE ajouter_client(p_id NUMBER, p_nom VARCHAR2, p_adresse VARCHAR2, p_solde NUMBER) IS
    BEGIN
        INSERT INTO client VALUES (p_id, p_nom, p_adresse, p_solde);
        DBMS_OUTPUT.PUT_LINE('Client inséré avec succès (version complète).');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : identifiant client déjà existant.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inconnue : ' || SQLERRM);
    END;

    -- Version surchargée avec moins de paramètres
    PROCEDURE ajouter_client(p_id NUMBER, p_nom VARCHAR2) IS
    BEGIN
        INSERT INTO client (id, nom) VALUES (p_id, p_nom);
        DBMS_OUTPUT.PUT_LINE('Client inséré avec succès (version réduite).');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : identifiant client déjà existant.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inconnue : ' || SQLERRM);
    END;

END pkg_client;
/
