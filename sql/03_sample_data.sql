-- ============================================================================
-- Script : 03_sample_data.sql
-- Description : Insertion de données de test
-- Auteur : Guide pratique Oracle 23c avec Docker
-- Connexion : etudiant sur FREEPDB1
-- ============================================================================

-- Note : Exécutez ce script en étant connecté avec l'utilisateur ETUDIANT

PROMPT ========================================
PROMPT Insertion de données de test
PROMPT ========================================

-- ============================================================================
-- 1. Insertion des étudiants
-- ============================================================================

PROMPT
PROMPT [1/3] Insertion des étudiants...

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('B', 'Amine', 'b.amine@usms.ac.ma', DATE '2003-05-15');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('T', 'Rim', 't.rim@usms.ac.ma', DATE '2002-11-20');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('E', 'Hassan', 'e.hassan@usms.ac.ma', DATE '2003-01-10');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('L', 'SAFAE', 'l.safae@usms.ac.ma', DATE '2004-03-25');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('K', 'Youssef', 'k.youssef@usms.ac.ma', DATE '2003-08-12');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('M', 'Fatima', 'm.fatima@usms.ac.ma', DATE '2002-09-05');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('A', 'Karim', 'a.karim@usms.ac.ma', DATE '2003-12-18');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('H', 'Salma', 'h.salma@usms.ac.ma', DATE '2004-02-28');

PROMPT ✓ 8 étudiants insérés

-- ============================================================================
-- 2. Insertion des cours
-- ============================================================================

PROMPT
PROMPT [2/3] Insertion des cours...

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Bases de données', 'BDD101', 6, 'S3');

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Programmation Java', 'JAVA201', 5, 'S4');

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Réseaux informatiques', 'NET301', 4, 'S5');

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Développement Web', 'WEB102', 5, 'S3');

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Systèmes d''exploitation', 'SYS202', 6, 'S4');

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Intelligence Artificielle', 'IA401', 7, 'S6');

PROMPT ✓ 6 cours insérés

-- ============================================================================
-- 3. Insertion des inscriptions
-- ============================================================================

PROMPT
PROMPT [3/3] Insertion des inscriptions...

-- Amine B (id=1) : BDD, JAVA, WEB
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (1, 1, 15.5);   -- BDD

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (1, 2, 14.0);   -- JAVA

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (1, 4, 16.25);  -- WEB

-- Rim T (id=2) : BDD, JAVA, SYS
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (2, 1, 12.0);   -- BDD

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (2, 2, 14.25);  -- JAVA

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (2, 5, 13.5);   -- SYS

-- Hassan E (id=3) : BDD, JAVA, NET, IA
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (3, 1, 16.75);  -- BDD

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (3, 2, 18.0);   -- JAVA

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (3, 3, 15.0);   -- NET

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (3, 6, 17.5);   -- IA

-- SAFAE L (id=4) : JAVA, WEB (pas encore de notes)
INSERT INTO inscriptions (id_etudiant, id_cours)
VALUES (4, 2);         -- JAVA (note NULL)

INSERT INTO inscriptions (id_etudiant, id_cours)
VALUES (4, 4);         -- WEB (note NULL)

-- Youssef K (id=5) : BDD, WEB, SYS
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (5, 1, 14.5);   -- BDD

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (5, 4, 15.75);  -- WEB

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (5, 5, 16.0);   -- SYS

-- Fatima M (id=6) : NET, IA
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (6, 3, 13.25);  -- NET

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (6, 6, 14.0);   -- IA

-- Karim A (id=7) : BDD, JAVA
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (7, 1, 17.0);   -- BDD

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (7, 2, 16.5);   -- JAVA

-- Salma H (id=8) : WEB, SYS
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (8, 4, 12.75);  -- WEB

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (8, 5, 11.5);   -- SYS

PROMPT ✓ 21 inscriptions insérées

-- ============================================================================
-- 4. Validation
-- ============================================================================

COMMIT;

PROMPT
PROMPT ========================================
PROMPT Données insérées avec succès !
PROMPT ========================================

-- ============================================================================
-- 5. Statistiques
-- ============================================================================

PROMPT
PROMPT Statistiques :

SELECT 'Étudiants' AS table_name, COUNT(*) AS nb_lignes FROM etudiants
UNION ALL
SELECT 'Cours', COUNT(*) FROM cours
UNION ALL
SELECT 'Inscriptions', COUNT(*) FROM inscriptions;

PROMPT
PROMPT ========================================
PROMPT Exemples de requêtes
PROMPT ========================================
PROMPT
PROMPT -- Lister tous les étudiants
PROMPT SELECT * FROM etudiants;
PROMPT
PROMPT -- Étudiants avec leurs cours
PROMPT SELECT e.nom, e.prenom, c.nom_cours, i.note
PROMPT FROM etudiants e
PROMPT JOIN inscriptions i ON e.id_etudiant = i.id_etudiant
PROMPT JOIN cours c ON i.id_cours = c.id_cours
PROMPT ORDER BY e.nom, c.nom_cours;
PROMPT
PROMPT -- Moyenne par cours
PROMPT SELECT c.nom_cours, ROUND(AVG(i.note), 2) AS moyenne
PROMPT FROM cours c
PROMPT LEFT JOIN inscriptions i ON c.id_cours = i.id_cours
PROMPT GROUP BY c.nom_cours
PROMPT ORDER BY moyenne DESC NULLS LAST;
PROMPT
PROMPT ========================================
