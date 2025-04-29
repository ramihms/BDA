-- TP1 - Exercice 2

-- 1. Structure et contenu de section
DESC section;
SELECT * FROM section;

-- 2. Tous les cours programmables
SELECT * FROM course;

-- 3. Titres des cours + départements
SELECT title, dept_name
FROM course;

-- 4. Noms des départements + budget
SELECT dept_name, budget
FROM department;

-- 5. Noms des enseignants + département
SELECT name, dept_name
FROM teacher;

-- 6. Enseignants avec salaire > 65000
SELECT name
FROM teacher
WHERE salary > 65000;

-- 7. Enseignants avec salaire entre 55000 et 85000
SELECT name
FROM teacher
WHERE salary BETWEEN 55000 AND 85000;

-- 8. Départements uniques depuis teacher
SELECT DISTINCT dept_name
FROM teacher;

-- 9. Enseignants en 'Comp. Sci.' avec salaire > 65000
SELECT name
FROM teacher
WHERE salary > 65000
  AND dept_name = 'Comp. Sci.';

-- 10. Cours proposés au printemps 2010
SELECT *
FROM section
WHERE semester = 'Spring' AND year = 2010;

-- 11. Cours 'Comp. Sci.' avec plus de 3 crédits
SELECT title
FROM course
WHERE dept_name = 'Comp. Sci.'
  AND credits > 3;

-- 12. Enseignants + départements + bâtiments
SELECT t.name, t.dept_name, d.building
FROM teacher t
JOIN department d ON t.dept_name = d.dept_name;

-- 13. Étudiants ayant suivi au moins un cours en informatique
SELECT DISTINCT s.name
FROM student s
JOIN takes ta ON s.ID = ta.ID
JOIN course c ON ta.course_id = c.course_id
WHERE c.dept_name = 'Comp. Sci.';

-- 14. Étudiants ayant suivi un cours donné par Einstein
SELECT DISTINCT s.name
FROM student s
JOIN takes ta ON s.ID = ta.ID
JOIN teaches te ON ta.course_id = te.course_id
  AND ta.sec_id = te.sec_id
  AND ta.semester = te.semester
  AND ta.year = te.year
JOIN teacher p ON te.ID = p.ID
WHERE p.name = 'Einstein';

-- 15. Identifiants des cours + enseignants
SELECT t.name, te.course_id
FROM teacher t
JOIN teaches te ON t.ID = te.ID;

-- 16. Nombre d'inscrits par cours (Spring 2010)
SELECT course_id, sec_id, semester, year, COUNT(*) AS nb_inscrits
FROM takes
WHERE semester = 'Spring' AND year = 2010
GROUP BY course_id, sec_id, semester, year;

-- 17. Salaire maximum par département
SELECT dept_name, MAX(salary) AS max_salary
FROM teacher
GROUP BY dept_name;

-- 18. Nombre d'inscrits par cours (global)
SELECT course_id, sec_id, semester, year, COUNT(*) AS nb_inscrits
FROM takes
GROUP BY course_id, sec_id, semester, year;

-- 19. Nombre de cours par bâtiment (Fall 2009 ou Spring 2010)
SELECT building, COUNT(*) AS nb_cours
FROM section
WHERE (semester = 'Fall' AND year = 2009)
   OR (semester = 'Spring' AND year = 2010)
GROUP BY building;

-- 20. Nombre de cours dispensés par département dans leur bâtiment
SELECT d.dept_name, COUNT(*) AS nb_cours
FROM section s
JOIN teaches te
  ON s.course_id = te.course_id
 AND s.sec_id = te.sec_id
 AND s.semester = te.semester
 AND s.year = te.year
JOIN teacher t ON te.ID = t.ID
JOIN department d ON t.dept_name = d.dept_name
WHERE d.building = s.building
GROUP BY d.dept_name;

-- 21. Titres des cours et enseignants
SELECT c.title, p.name
FROM section s
JOIN teaches t
  ON s.course_id = t.course_id
 AND s.sec_id = t.sec_id
 AND s.semester = t.semester
 AND s.year = t.year
JOIN teacher p ON t.ID = p.ID
JOIN course c ON s.course_id = c.course_id
ORDER BY c.title;

-- 22. Nombre total de cours par semestre
SELECT semester, COUNT(*) AS nb_cours
FROM section
GROUP BY semester;

-- 23. Crédits obtenus par étudiant hors de son département
SELECT s.name, SUM(c.credits) AS total_credits
FROM student s
JOIN takes ta ON s.ID = ta.ID
JOIN course c ON ta.course_id = c.course_id
WHERE s.dept_name != c.dept_name
GROUP BY s.name;

-- 24. Total des crédits par bâtiment
SELECT s.building, SUM(c.credits) AS total_credits
FROM section s
JOIN course c ON s.course_id = c.course_id
GROUP BY s.building;
