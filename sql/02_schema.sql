-- ============================================================================
-- Script : 02_schema.sql
-- Description : Création du schéma de base de données pour le TP
-- Auteur : Guide pratique Oracle 23c avec Docker
-- Connexion : etudiant sur FREEPDB1
-- ============================================================================

-- Note : Exécutez ce script en étant connecté avec l'utilisateur ETUDIANT

PROMPT ========================================
PROMPT Création du schéma de base de données
PROMPT ========================================

-- ============================================================================
-- 1. Suppression des tables existantes (si réexécution du script)
-- ============================================================================

PROMPT
PROMPT [1/4] Suppression des tables existantes (si présentes)...

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE inscriptions CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('✓ Table INSCRIPTIONS supprimée');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN  -- ORA-00942: table does not exist
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE cours CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('✓ Table COURS supprimée');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE etudiants CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('✓ Table ETUDIANTS supprimée');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

PROMPT ✓ Nettoyage terminé

-- ============================================================================
-- 2. Création de la table ETUDIANTS
-- ============================================================================

PROMPT
PROMPT [2/4] Création de la table ETUDIANTS...

CREATE TABLE etudiants (
    id_etudiant      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom              VARCHAR2(50) NOT NULL,
    prenom           VARCHAR2(50) NOT NULL,
    email            VARCHAR2(100) UNIQUE NOT NULL,
    date_naissance   DATE,
    date_inscription DATE DEFAULT SYSDATE,
    
    -- Contraintes
    CONSTRAINT ck_email_format CHECK (email LIKE '%@%.%'),
    CONSTRAINT ck_date_naissance CHECK (date_naissance < SYSDATE)
);

-- Commentaires sur la table
COMMENT ON TABLE etudiants IS 'Table des étudiants inscrits';
COMMENT ON COLUMN etudiants.id_etudiant IS 'Identifiant unique auto-généré';
COMMENT ON COLUMN etudiants.email IS 'Email unique de l''étudiant';
COMMENT ON COLUMN etudiants.date_inscription IS 'Date d''inscription (par défaut : date du jour)';

PROMPT ✓ Table ETUDIANTS créée

-- ============================================================================
-- 3. Création de la table COURS
-- ============================================================================

PROMPT
PROMPT [3/4] Création de la table COURS...

CREATE TABLE cours (
    id_cours    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom_cours   VARCHAR2(100) NOT NULL,
    code_cours  VARCHAR2(10) UNIQUE NOT NULL,
    credits     NUMBER(2) NOT NULL CHECK (credits > 0 AND credits <= 12),
    semestre    VARCHAR2(20),
    
    -- Contraintes
    CONSTRAINT ck_semestre CHECK (semestre IN ('S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'))
);

-- Commentaires sur la table
COMMENT ON TABLE cours IS 'Table des cours disponibles';
COMMENT ON COLUMN cours.code_cours IS 'Code unique du cours (ex: BDD101)';
COMMENT ON COLUMN cours.credits IS 'Nombre de crédits ECTS (1-12)';
COMMENT ON COLUMN cours.semestre IS 'Semestre de dispensation (S1 à S8)';

PROMPT ✓ Table COURS créée

-- ============================================================================
-- 4. Création de la table INSCRIPTIONS (relation many-to-many)
-- ============================================================================

PROMPT
PROMPT [4/4] Création de la table INSCRIPTIONS...

CREATE TABLE inscriptions (
    id_inscription   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_etudiant      NUMBER NOT NULL,
    id_cours         NUMBER NOT NULL,
    date_inscription DATE DEFAULT SYSDATE,
    note             NUMBER(4, 2),
    
    -- Clés étrangères
    CONSTRAINT fk_etudiant FOREIGN KEY (id_etudiant) 
        REFERENCES etudiants(id_etudiant) ON DELETE CASCADE,
    
    CONSTRAINT fk_cours FOREIGN KEY (id_cours) 
        REFERENCES cours(id_cours) ON DELETE CASCADE,
    
    -- Contraintes
    CONSTRAINT uk_etudiant_cours UNIQUE (id_etudiant, id_cours),
    CONSTRAINT ck_note CHECK (note IS NULL OR (note >= 0 AND note <= 20))
);

-- Commentaires sur la table
COMMENT ON TABLE inscriptions IS 'Table de liaison entre étudiants et cours';
COMMENT ON COLUMN inscriptions.note IS 'Note sur 20 (NULL si pas encore notée)';

PROMPT ✓ Table INSCRIPTIONS créée

-- ============================================================================
-- 5. Création d'index pour améliorer les performances
-- ============================================================================

PROMPT
PROMPT [5/5] Création des index...

CREATE INDEX idx_inscriptions_etudiant ON inscriptions(id_etudiant);
CREATE INDEX idx_inscriptions_cours ON inscriptions(id_cours);
CREATE INDEX idx_etudiants_nom ON etudiants(nom, prenom);

PROMPT ✓ Index créés

-- ============================================================================
-- 6. Vérification
-- ============================================================================

PROMPT
PROMPT ========================================
PROMPT Vérification des tables créées
PROMPT ========================================

SELECT table_name, num_rows, comments
FROM user_tab_comments
WHERE table_name IN ('ETUDIANTS', 'COURS', 'INSCRIPTIONS')
ORDER BY table_name;

PROMPT
PROMPT ========================================
PROMPT Schéma créé avec succès !
PROMPT ========================================
PROMPT
PROMPT Tables créées :
PROMPT   - ETUDIANTS (id_etudiant, nom, prenom, email, ...)
PROMPT   - COURS (id_cours, nom_cours, code_cours, credits, ...)
PROMPT   - INSCRIPTIONS (id_inscription, id_etudiant, id_cours, note, ...)
PROMPT
PROMPT Vous pouvez maintenant insérer des données avec 03_sample_data.sql
PROMPT ========================================
