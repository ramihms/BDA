
-- TP5 - Exercice 1 : Atomicité d'une transaction

-- Étape 1 : Désactivation du commit automatique (à faire dans chaque session)
SET AUTOCOMMIT OFF;

-- Étape 2 : Création de la table (à exécuter dans S1)
CREATE TABLE transaction (
    idTransaction   VARCHAR2(44),
    valTransaction  NUMBER(10)
);

-- Étape 3 : Insertions, modification, suppression puis rollback (à exécuter dans S2)
INSERT INTO transaction VALUES ('T1', 100);
INSERT INTO transaction VALUES ('T2', 200);
UPDATE transaction SET valTransaction = 300 WHERE idTransaction = 'T1';
DELETE FROM transaction WHERE idTransaction = 'T2';
ROLLBACK;
SELECT * FROM transaction;

-- Étape 4 : Insertion suivie de quit (à exécuter dans S2, ne pas faire COMMIT)
INSERT INTO transaction VALUES ('T3', 500);
-- quitter ensuite avec la commande : QUIT;

-- Étape 5 : Insertion puis fermeture brutale de la session (à faire dans S1)
INSERT INTO transaction VALUES ('T4', 800);
-- fermer la session sans faire COMMIT

-- Étape 6 : Insertion + modification de structure + rollback (à faire dans une nouvelle session)
INSERT INTO transaction VALUES ('T5', 1000);
ALTER TABLE transaction ADD val2transaction NUMBER(10);
ROLLBACK;

-- Étape 7 : Vérification finale (dans n'importe quelle session)
SELECT * FROM transaction;

-- Conclusion : Une transaction est un ensemble d’opérations qui s’exécutent de manière atomique, c’est-à-dire que soit toutes les modifications sont validées par un COMMIT, soit elles sont annulées par un ROLLBACK. Une session correspond à une connexion unique entre l’utilisateur et la base, dans laquelle s’exécutent les transactions. Les modifications ne sont visibles par les autres sessions qu’après un COMMIT, tandis qu’un ROLLBACK annule tout changement non validé. En cas de déconnexion sans validation explicite, Oracle applique automatiquement un ROLLBACK, garantissant ainsi l'intégrité des données.
