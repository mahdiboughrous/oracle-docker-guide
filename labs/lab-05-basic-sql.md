# Lab 05 : Requêtes SQL de base

## Objectifs

À la fin de ce lab, vous serez capable de :

- Créer un utilisateur et un schéma
- Créer des tables avec différents types de données
- Insérer des données
- Exécuter des requêtes SELECT (filtres, jointures)
- Mettre à jour et supprimer des données
- Utiliser des scripts SQL automatisés

---

## Prérequis

- SQL Developer installé et connecté (Lab 04)
- Connexion active à `FREEPDB1` avec l'utilisateur `SYSTEM`

---

## Étape 1 : Créer un utilisateur dédié

Par bonnes pratiques, évitons de travailler directement avec `SYSTEM`.

### 1.1 Ouvrir un SQL Worksheet avec SYSTEM

Dans SQL Developer :

1. Clic droit sur votre connexion `Oracle23c-FREEPDB1 (SYSTEM)`
2. Sélectionnez **Open SQL Worksheet**

### 1.2 Créer l'utilisateur `etudiant`

Copiez et exécutez ce script :

```sql
-- Créer un utilisateur nommé 'etudiant'
-- Le mot de passe contient un caractère spécial, il doit donc être entre guillemets
CREATE USER etudiant IDENTIFIED BY "Etudiant2024!";

-- Accorder le droit de connexion (privilège requis en Oracle 12c+)
GRANT CREATE SESSION TO etudiant;

-- Accorder les droits nécessaires pour les travaux pratiques
-- (création de tables, séquences, procédures, etc.)
GRANT RESOURCE TO etudiant;

-- Donner un quota illimité sur le tablespace USERS
ALTER USER etudiant QUOTA UNLIMITED ON USERS;

```

**Exécution** : Sélectionnez tout (`Ctrl + A`) puis cliquez sur l'icône "Run Script"  (ou `F5`)

**Résultat attendu** :

```
User ETUDIANT created.
Grant succeeded.
Grant succeeded.
User ETUDIANT altered.
```

✅ L'utilisateur `etudiant` est créé.

> Remarque pédagogique : le rôle `RESOURCE` est utilisé ici pour simplifier la gestion des droits dans un contexte de TP. En environnement de production, les privilèges sont généralement accordés de manière plus fine.

### 1.3 Créer une connexion pour `etudiant`

1. Cliquez sur **"+"** (New Connection)
2. Remplissez :

| Champ           | Valeur                 |
| --------------- | ---------------------- |
| Connection Name | `Oracle23c-Etudiant` |
| Username        | `etudiant`           |
| Password        | `Etudiant2024!`      |
| Hostname        | `localhost`          |
| Port            | `1521`               |
| Service name    | `FREEPDB1`           |

3. **Test** → **Save** → **Connect**

---

## Étape 2 : Créer un schéma de base de données

Nous allons créer un schéma simple pour gérer des **étudiants** et des **cours**.

### 2.1 Se connecter avec `etudiant`

- Double-cliquez sur `Oracle23c-Etudiant` pour vous connecter
- Ouvrez un SQL Worksheet

### 2.2 Créer la table `ETUDIANTS`

> **À observer pendant cette manipulation**
> Vous allez créer des objets (tables, données) dans Oracle.
> Après leur création, ces données seront stockées quelque part.
> Gardez en tête la notion de persistance vue précédemment.

```sql
-- Table des étudiants
CREATE TABLE etudiants (
    id_etudiant   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom           VARCHAR2(50) NOT NULL,
    prenom        VARCHAR2(50) NOT NULL,
    email         VARCHAR2(100) UNIQUE NOT NULL,
    date_naissance DATE,
    date_inscription DATE DEFAULT SYSDATE
);
```

**Explication** :

- `NUMBER GENERATED ALWAYS AS IDENTITY` : ID auto-incrémenté (comme AUTO_INCREMENT en MySQL)
- `PRIMARY KEY` : Clé primaire (unicité garantie)
- `NOT NULL` : Champ obligatoire
- `UNIQUE` : Valeur unique dans toute la table
- `DEFAULT SYSDATE` : Date du jour par défaut

**Exécution** : `Ctrl + Enter`

**Résultat attendu** :

```
Table ETUDIANTS created.
```

### 2.3 Créer la table `COURS`

```sql
-- Table des cours
CREATE TABLE cours (
    id_cours    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom_cours   VARCHAR2(100) NOT NULL,
    code_cours  VARCHAR2(10) UNIQUE NOT NULL,
    credits     NUMBER(2) CHECK (credits > 0),
    semestre    VARCHAR2(20)
);
```

**Explication** :

- `NUMBER(2)` : Nombre avec maximum 2 chiffres (0-99)
- `CHECK (credits > 0)` : Contrainte de validation (credits doit être positif)

**Exécution** : `Ctrl + Enter`

### 2.4 Créer la table de liaison `INSCRIPTIONS`

```sql
-- Table de liaison (relation many-to-many)
CREATE TABLE inscriptions (
    id_inscription NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_etudiant    NUMBER NOT NULL,
    id_cours       NUMBER NOT NULL,
    date_inscription DATE DEFAULT SYSDATE,
    note           NUMBER(4, 2),  -- Ex: 15.75
  
    -- Clés étrangères
    CONSTRAINT fk_etudiant FOREIGN KEY (id_etudiant) REFERENCES etudiants(id_etudiant),
    CONSTRAINT fk_cours FOREIGN KEY (id_cours) REFERENCES cours(id_cours),
  
    -- Un étudiant ne peut s'inscrire qu'une fois à un cours
    CONSTRAINT uk_etudiant_cours UNIQUE (id_etudiant, id_cours)
);
```

**Explication** :

- `NUMBER(4, 2)` : 4 chiffres au total, 2 après la virgule (ex : 15.75)
- `FOREIGN KEY` : Référence à une autre table (intégrité référentielle)
- `CONSTRAINT uk_etudiant_cours UNIQUE` : Contrainte d'unicité composite

**Exécution** : `Ctrl + Enter`

---

## Étape 3 : Insérer des données

### 3.1 Insérer des étudiants

```sql
-- Insertion avec toutes les colonnes
INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('B', 'Amine', 'b.amine@usms.ac.ma', DATE '2003-05-15');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('T', 'Rim', 't.rim@usms.ac.ma', DATE '2002-11-20');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('E', 'Hassan', 'e.hassan@usms.ac.ma', DATE '2003-01-10');

INSERT INTO etudiants (nom, prenom, email, date_naissance)
VALUES ('L', 'SAFAE', 'l.safae@usms.ac.ma', DATE '2004-03-25');

-- Valider les insertions
COMMIT;
```

**Explication** :

- `DATE '2003-05-15'` : Littéral de date au format ISO
- `COMMIT` : Valide définitivement les changements (important !)

**Exécution** : Sélectionnez tout (`Ctrl + A`) puis `F5` (Run Script)

**Résultat attendu** :

```
1 row inserted.
1 row inserted.
1 row inserted.
1 row inserted.
Commit complete.
```

### 3.2 Insérer des cours

```sql
INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Bases de données', 'BDD101', 6, 'S3');

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Programmation Java', 'JAVA201', 5, 'S4');

INSERT INTO cours (nom_cours, code_cours, credits, semestre)
VALUES ('Réseaux informatiques', 'NET301', 4, 'S5');

COMMIT;
```

### 3.3 Insérer des inscriptions

```sql
-- Amine suit BDD101
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (1, 1, 15.5);

-- Rim suit BDD101 et JAVA201
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (2, 1, 12.0);

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (2, 2, 14.25);

-- Hassan suit les 3 cours
INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (3, 1, 16.75);

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (3, 2, 18.0);

INSERT INTO inscriptions (id_etudiant, id_cours, note)
VALUES (3, 3, 15.0);

-- SAFAE suit JAVA201 (pas encore de note)
INSERT INTO inscriptions (id_etudiant, id_cours)
VALUES (4, 2);

COMMIT;
```

---

## Étape 4 : Interroger les données (SELECT)

### 4.1 Sélectionner tous les étudiants

```sql
SELECT * FROM etudiants;
```

**Résultat attendu** :

```
ID_ETUDIANT  NOM  PRENOM  EMAIL                  DATE_NAISSANCE  DATE_INSCRIPTION
-----------  ---  ------  ---------------------  --------------  ----------------
1            B    Amine   b.amine@usms.ac.ma     15/05/2003      05/02/2026
2            T    Rim     t.rim@usms.ac.ma       20/11/2002      05/02/2026
3            E    Hassan  e.hassan@usms.ac.ma    10/01/2003      05/02/2026
4            L    SAFAE   l.safae@usms.ac.ma     25/03/2004      05/02/2026
```

### 4.2 Filtrer avec WHERE

```sql
-- Étudiants nés après 2003
SELECT nom, prenom, date_naissance
FROM etudiants
WHERE date_naissance > DATE '2003-01-01';
```

### 4.3 Trier avec ORDER BY

```sql
-- Étudiants triés par nom puis prénom
SELECT nom, prenom, email
FROM etudiants
ORDER BY nom, prenom;
```

### 4.4 Compter avec COUNT

```sql
-- Nombre total d'étudiants
SELECT COUNT(*) AS nombre_etudiants
FROM etudiants;
```

**Résultat** :

```
NOMBRE_ETUDIANTS
----------------
4
```

---

## Étape 5 : Jointures (JOIN)

### 5.1 Afficher les inscriptions avec noms

```sql
-- Jointure entre étudiants et inscriptions
SELECT 
    e.nom,
    e.prenom,
    c.nom_cours,
    i.note
FROM etudiants e
INNER JOIN inscriptions i ON e.id_etudiant = i.id_etudiant
INNER JOIN cours c ON i.id_cours = c.id_cours
ORDER BY e.nom, c.nom_cours;
```

**Résultat attendu** :

```
NOM  PRENOM  NOM_COURS              NOTE
---  ------  ---------------------  ------
B    Amine   Bases de données       15.50
E    Hassan  Bases de données       16.75
E    Hassan  Programmation Java     18.00
E    Hassan  Réseaux informatiques  15.00
L    SAFAE   Programmation Java     (null)
T    Rim     Bases de données       12.00
T    Rim     Programmation Java     14.25
```

### 5.2 Moyenne par cours

```sql
-- Moyenne des notes par cours
SELECT 
    c.nom_cours,
    ROUND(AVG(i.note), 2) AS moyenne,
    COUNT(i.id_inscription) AS nb_inscrits
FROM cours c
LEFT JOIN inscriptions i ON c.id_cours = i.id_cours
GROUP BY c.nom_cours
ORDER BY moyenne DESC NULLS LAST;
```

**Explication** :

- `AVG(i.note)` : Moyenne des notes
- `ROUND(..., 2)` : Arrondi à 2 décimales
- `LEFT JOIN` : Inclut les cours sans inscriptions
- `GROUP BY` : Regroupe par cours
- `NULLS LAST` : Affiche les NULL en dernier

**Résultat** :

```
NOM_COURS              MOYENNE  NB_INSCRITS
---------------------  -------  -----------
Bases de données       14.75    3
Programmation Java     15.42    3
Réseaux informatiques  15.00    1
```

### 5.3 Étudiants avec leur nombre de cours

```sql
SELECT 
    e.nom,
    e.prenom,
    COUNT(i.id_cours) AS nb_cours,
    ROUND(AVG(i.note), 2) AS moyenne_generale
FROM etudiants e
LEFT JOIN inscriptions i ON e.id_etudiant = i.id_etudiant
GROUP BY e.id_etudiant, e.nom, e.prenom
ORDER BY moyenne_generale DESC NULLS LAST;
```

---

## Étape 6 : Modifier des données (UPDATE)

### 6.1 Mettre à jour une note

```sql
-- SAFAE a obtenu sa note en Java
UPDATE inscriptions
SET note = 13.5
WHERE id_etudiant = 4 AND id_cours = 2;

COMMIT;
```

**Vérification** :

```sql
SELECT e.nom, e.prenom, c.nom_cours, i.note
FROM inscriptions i
JOIN etudiants e ON i.id_etudiant = e.id_etudiant
JOIN cours c ON i.id_cours = c.id_cours
WHERE e.id_etudiant = 4;
```

### 6.2 Modifier plusieurs lignes

```sql
-- Augmenter toutes les notes de BDD de 1 point (rattrapage)
UPDATE inscriptions
SET note = note + 1
WHERE id_cours = 1 AND note IS NOT NULL;

COMMIT;
```

---

## Étape 7 : Supprimer des données (DELETE)

### 7.1 Supprimer une inscription

```sql
-- SAFAE abandonne le cours de Java
DELETE FROM inscriptions
WHERE id_etudiant = 4 AND id_cours = 2;

COMMIT;
```

### 7.2 Supprimer avec précaution

> ⚠️ **ATTENTION** : Toujours utiliser `WHERE` avec `DELETE` !

**Mauvais exemple (supprime TOUT)** :

```sql
-- ❌ NE JAMAIS FAIRE CECI sans WHERE
DELETE FROM inscriptions;  -- Supprime toutes les inscriptions !
```

**Bon exemple** :

```sql
-- ✅ Toujours filtrer avec WHERE
DELETE FROM inscriptions
WHERE id_inscription = 7;
```

---

##  Étape 8 : Utiliser des scripts SQL

Les scripts SQL dans le dossier `sql/` permettent de recréer rapidement le schéma.

### 8.1 Examiner les scripts disponibles

Dans votre projet, le dossier `sql/` contient :

- `01_users.sql` : Création d'utilisateurs
- `02_schema.sql` : Création des tables
- `03_sample_data.sql` : Données de test

### 8.2 Exécuter un script depuis SQL Developer

1. Menu **File** > **Open**
2. Naviguez vers `sql/03_sample_data.sql`
3. Le script s'ouvre dans un nouvel onglet
4. Cliquez sur **Run Script** (F5)

**Ou en ligne de commande ( Powershell )** :

```bash
Get-Content ..\sql\03_sample_data.sql | docker exec -i oracle-db sqlplus etudiant/Etudiant2024!@FREEPDB1
```

---

##  Étape 9 : Nettoyer les données (TRUNCATE)

### TRUNCATE vs DELETE

| Commande     | Action                   | Rollback possible     | Vitesse      |
| ------------ | ------------------------ | --------------------- | ------------ |
| `DELETE`   | Supprime ligne par ligne | ✅ Oui (avant COMMIT) | Lent         |
| `TRUNCATE` | Vide la table entière   | ❌ Non                | Très rapide |

### Vider une table

```sql
-- Vider la table inscriptions (plus rapide que DELETE)
TRUNCATE TABLE inscriptions;
```

> ⚠️ **Attention** : `TRUNCATE` est **irréversible** et ignore les clés étrangères (peut causer des erreurs).

---

##  Récapitulatif SQL

| Opération          | Commande         | Exemple                                                |
| ------------------- | ---------------- | ------------------------------------------------------ |
| **Créer**    | `CREATE TABLE` | `CREATE TABLE users (id NUMBER, name VARCHAR2(50));` |
| **Insérer**  | `INSERT INTO`  | `INSERT INTO users (id, name) VALUES (1, 'Alice');`  |
| **Lire**      | `SELECT`       | `SELECT * FROM users WHERE id = 1;`                  |
| **Modifier**  | `UPDATE`       | `UPDATE users SET name = 'Bob' WHERE id = 1;`        |
| **Supprimer** | `DELETE`       | `DELETE FROM users WHERE id = 1;`                    |
| **Vider**     | `TRUNCATE`     | `TRUNCATE TABLE users;`                              |
| **Valider**   | `COMMIT`       | `COMMIT;`                                            |
| **Annuler**   | `ROLLBACK`     | `ROLLBACK;`                                          |

---

## ✅ Checklist de validation

Avant de passer au lab suivant, vérifiez :

- [ ] Vous avez créé l'utilisateur `etudiant`
- [ ] Vous avez créé les 3 tables (étudiants, cours, inscriptions)
- [ ] Vous avez inséré des données de test
- [ ] Vous avez exécuté des SELECT avec JOIN
- [ ] Vous avez modifié des données avec UPDATE
- [ ] Vous avez supprimé des données avec DELETE
- [ ] Vous comprenez la différence entre COMMIT et ROLLBACK

---

## Ce que vous avez appris

- ✅ Créer des utilisateurs et gérer les droits
- ✅ Créer des tables avec contraintes (PK, FK, UNIQUE, CHECK)
- ✅ Types de données Oracle (NUMBER, VARCHAR2, DATE)
- ✅ Insérer, lire, modifier et supprimer des données (CRUD)
- ✅ Jointures (INNER JOIN, LEFT JOIN)
- ✅ Fonctions d'agrégation (COUNT, AVG)
- ✅ Regroupement (GROUP BY)
- ✅ Transactions (COMMIT, ROLLBACK)

---

## Prochaine étape

Vous maîtrisez les bases du SQL !

** [Lab 06 : Nettoyer et réinitialiser l&#39;environnement](lab-06-cleanup-reset.md)**

---

## Pour aller plus loin

- [Oracle SQL Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/)
- [Oracle Database Concepts](https://docs.oracle.com/en/database/oracle/oracle-database/23/cncpt/)
- [SQL Tutorial W3Schools](https://www.w3schools.com/sql/)
