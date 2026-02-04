-- ============================================================================
-- Script : 01_users.sql
-- Description : Création des utilisateurs pour le TP Oracle
-- Auteur : Guide pratique Oracle 23c avec Docker
-- Connexion : SYSTEM sur FREEPDB1
-- ============================================================================

-- Note : Exécutez ce script en étant connecté avec l'utilisateur SYSTEM

PROMPT ========================================
PROMPT Création des utilisateurs
PROMPT ========================================

-- ============================================================================
-- 1. Créer l'utilisateur ETUDIANT
-- ============================================================================

PROMPT
PROMPT [1/3] Création de l'utilisateur ETUDIANT...

-- Supprimer l'utilisateur s'il existe déjà (pour réexécution du script)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER etudiant CASCADE';
    DBMS_OUTPUT.PUT_LINE('✓ Utilisateur existant supprimé');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN  -- ORA-01918: user does not exist
            RAISE;
        END IF;
END;
/

-- Créer l'utilisateur
CREATE USER etudiant IDENTIFIED BY Etudiant2024!
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

PROMPT ✓ Utilisateur ETUDIANT créé

-- ============================================================================
-- 2. Accorder les privilèges
-- ============================================================================

PROMPT
PROMPT [2/3] Attribution des privilèges...

-- Privilèges de connexion
GRANT CREATE SESSION TO etudiant;

-- Privilèges de création d'objets
GRANT CREATE TABLE TO etudiant;
GRANT CREATE VIEW TO etudiant;
GRANT CREATE SEQUENCE TO etudiant;
GRANT CREATE PROCEDURE TO etudiant;
GRANT CREATE TRIGGER TO etudiant;

-- Privilèges sur le tablespace
GRANT UNLIMITED TABLESPACE TO etudiant;

-- Rôle RESOURCE (simplifie la gestion)
GRANT RESOURCE TO etudiant;

PROMPT ✓ Privilèges accordés

-- ============================================================================
-- 3. Vérification
-- ============================================================================

PROMPT
PROMPT [3/3] Vérification de la création...

SELECT username, account_status, default_tablespace, created
FROM dba_users
WHERE username = 'ETUDIANT';

PROMPT
PROMPT ========================================
PROMPT Script terminé avec succès !
PROMPT ========================================
PROMPT
PROMPT Vous pouvez maintenant vous connecter avec :
PROMPT   Username: etudiant
PROMPT   Password: Etudiant2024!
PROMPT   Service:  FREEPDB1
PROMPT ========================================
