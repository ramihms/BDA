-- 1. Création des tables (à faire dans une session S1)
CREATE TABLE vol (
    idVol VARCHAR2(44),
    capaciteVol NUMBER(10),
    nbrPlacesReserveesVol NUMBER(10)
);

CREATE TABLE client (
    idClient VARCHAR2(44),
    prenomClient VARCHAR2(11),
    nbrPlacesReserveesCleint NUMBER(10)
);

-- 2. Insertion initiale (dans une session quelconque)
INSERT INTO vol VALUES ('AF001', 100, 0);
INSERT INTO client VALUES ('C1', 'Ali', 0);
INSERT INTO client VALUES ('C2', 'Lina', 0);
COMMIT;

-- 3. Réservation dans S1 (T1), sans commit
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 2 WHERE idVol = 'AF001';
-- Ne pas faire COMMIT encore

-- 4. Vérification depuis la session S2 (T2)
SELECT * FROM vol WHERE idVol = 'AF001';
SELECT * FROM client WHERE idClient = 'C1';
-- Aucune des modifications de S1 ne sera visible

-- 5. ROLLBACK dans la session S1 (T1)
ROLLBACK;
-- Les modifications sont annulées. S2 ne verra rien de T1.

-- 6. COMMIT et validation 
-- Dans S1
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 2 WHERE idVol = 'AF001';
COMMIT;
-- Dans S2
SELECT * FROM vol;
-- Les changements sont maintenant visibles

-- 7. Mise à jour concurrente : problème d’incohérence
-- S1 : sélection vol et client
SELECT * FROM vol WHERE idVol = 'AF001';
SELECT * FROM client WHERE idClient = 'C1';
-- S2 : sélection vol et client
SELECT * FROM vol WHERE idVol = 'AF001';
SELECT * FROM client WHERE idClient = 'C2';
-- S1 : update
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C1';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 2 WHERE idVol = 'AF001';
COMMIT;
-- S2 : update (données obsolètes)
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 3 WHERE idClient = 'C2';
UPDATE vol SET nbrPlacesReserveesVol = nbrPlacesReserveesVol + 3 WHERE idVol = 'AF001';
COMMIT;
-- Résultat : les clients auront bien réservé 2 + 3 = 5 places, mais la table vol ne montrera que 3 (les 2 premières mises à jour sont écrasées par T2 -> mise à jour perdue).

-- 8. Prévention : forcer le mode d’isolation SERIALIZABLE
-- Dans chaque session avant toute transaction :
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Répétez la même alternance que ci-dessus (en 7.) -> une des transactions sera rejetée ou bloquée, assurant ainsi la cohérence.

-- Conclusion : Oracle utilise un algorithme basé sur le verrouillage à deux phases (2PL) combiné à un système de versioning (multi-version concurrency control). Le niveau d’isolation par défaut (READ COMMITTED) n’empêche pas toutes les anomalies (comme les mises à jour perdues). Pour garantir la cohérence forte, il faut utiliser SERIALIZABLE – au prix de possibles blocages ou rejets.
