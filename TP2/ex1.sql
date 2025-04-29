-- TP2 - Exercice 1

-- 1. Nom du département ayant le plus grand budget
SELECT dept_name
FROM department
WHERE budget = (SELECT MAX(budget) FROM department);

-- 2. Enseignants gagnant plus que le salaire moyen
SELECT name, salary
FROM teacher
WHERE salary > (SELECT AVG(salary) FROM teacher);

-- 3. Étudiants ayant suivi plus de 2 cours avec un enseignant (HAVING)
SELECT te.name AS enseignant, s.name AS etudiant, COUNT(*) AS nb_cours
FROM teacher te
JOIN teaches th ON te.ID = th.ID
JOIN takes ta ON th.course_id = ta.course_id AND th.sec_id = ta.sec_id AND th.semester = ta.semester AND th.year = ta.year
JOIN student s ON ta.ID = s.ID
GROUP BY te.name, s.name
HAVING COUNT(*) >= 2;

-- 4. Même question sans HAVING
SELECT *
FROM (
    SELECT te.name AS enseignant, s.name AS etudiant, COUNT(*) AS nb_cours
    FROM teacher te
    JOIN teaches th ON te.ID = th.ID
    JOIN takes ta ON th.course_id = ta.course_id AND th.sec_id = ta.sec_id AND th.semester = ta.semester AND th.year = ta.year
    JOIN student s ON ta.ID = s.ID
    GROUP BY te.name, s.name
) t
WHERE t.nb_cours >= 2
ORDER BY t.enseignant;

-- 5. Étudiants n'ayant pas suivi de cours avant 2010
SELECT id, name
FROM student
MINUS
SELECT DISTINCT s.id, s.name
FROM student s
JOIN takes t ON s.id = t.id
WHERE t.year < 2010;

-- 6. Enseignants dont le nom commence par 'E'
SELECT *
FROM teacher
WHERE name LIKE 'E%';

-- 7. Enseignants avec le 4ème salaire le plus élevé
SELECT name
FROM teacher t1
WHERE 3 = (SELECT COUNT(DISTINCT salary) FROM teacher t2 WHERE t2.salary > t1.salary);

-- 8. Les 3 enseignants aux plus petits salaires
SELECT name, salary
FROM teacher t1
WHERE 2 >= (SELECT COUNT(DISTINCT salary) FROM teacher t2 WHERE t2.salary < t1.salary)
ORDER BY salary ASC;

-- 9. Étudiants ayant suivi un cours en Fall 2009 (IN)
SELECT name
FROM student s
WHERE ('Fall', 2009) IN (SELECT semester, year FROM takes WHERE id = s.id);

-- 10. Avec SOME
SELECT name
FROM student s
WHERE ('Fall', 2009) = SOME (SELECT semester, year FROM takes WHERE id = s.id);

-- 11. Avec NATURAL JOIN
SELECT DISTINCT s.name
FROM student s
NATURAL JOIN takes
WHERE semester = 'Fall' AND year = 2009;

-- 12. Avec EXISTS
SELECT name
FROM student s
WHERE EXISTS (
    SELECT 1 FROM takes t
    WHERE t.id = s.id AND t.semester = 'Fall' AND t.year = 2009
);

-- 13. Paires d'étudiants ayant suivi au moins un cours ensemble
SELECT A.name, B.name
FROM (student s1 NATURAL JOIN takes t1) A
JOIN (student s2 NATURAL JOIN takes t2) B
  ON A.course_id = B.course_id AND A.sec_id = B.sec_id AND A.semester = B.semester AND A.year = B.year
WHERE A.id < B.id;

-- 14. Nombre d'étudiants par enseignant (qui ont assuré un cours)
SELECT te.name, COUNT(*) AS nb_etudiants
FROM teacher te
JOIN teaches th ON te.ID = th.ID
JOIN takes ta ON th.course_id = ta.course_id AND th.sec_id = ta.sec_id AND th.semester = ta.semester AND th.year = ta.year
GROUP BY te.name
ORDER BY nb_etudiants DESC;

-- 15. Nombre d'étudiants par enseignant (même sans cours)
SELECT te.name, COUNT(ta.course_id) AS nb_etudiants
FROM teacher te
LEFT JOIN teaches th ON te.ID = th.ID
LEFT JOIN takes ta ON th.course_id = ta.course_id AND th.sec_id = ta.sec_id AND th.semester = ta.semester AND th.year = ta.year
GROUP BY te.name
ORDER BY nb_etudiants DESC;

-- 16. Nombre de grades A par enseignant
WITH mytakes AS (
  SELECT *
  FROM takes
  WHERE grade = 'A'
)
SELECT te.name, COUNT(mt.course_id) AS nb_A
FROM teacher te
LEFT JOIN teaches th ON te.ID = th.ID
LEFT JOIN mytakes mt ON th.course_id = mt.course_id AND th.sec_id = mt.sec_id AND th.semester = mt.semester AND th.year = mt.year
GROUP BY te.name
ORDER BY nb_A DESC;

-- 17. Paires enseignant-étudiant avec nombre de cours
SELECT te.name AS enseignant, s.name AS etudiant, COUNT(*) AS nb_cours
FROM teacher te
JOIN teaches th ON te.ID = th.ID
JOIN takes ta ON th.course_id = ta.course_id AND th.sec_id = ta.sec_id AND th.semester = ta.semester AND th.year = ta.year
JOIN student s ON ta.ID = s.ID
GROUP BY te.name, s.name;

-- 18. Paires enseignant-étudiant ayant eu au moins 2 cours ensemble
SELECT enseignant, etudiant
FROM (
    SELECT te.name AS enseignant, s.name AS etudiant, COUNT(*) AS nb_cours
    FROM teacher te
    JOIN teaches th ON te.ID = th.ID
    JOIN takes ta ON th.course_id = ta.course_id AND th.sec_id = ta.sec_id AND th.semester = ta.semester AND th.year = ta.year
    JOIN student s ON ta.ID = s.ID
    GROUP BY te.name, s.name
) t
WHERE nb_cours >= 2;
