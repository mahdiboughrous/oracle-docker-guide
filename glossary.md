# Glossaire

Définitions des termes techniques utilisés dans ce guide.

---

## A

### ACID
Propriétés garantissant la fiabilité des transactions : **Atomicity** (atomicité), **Consistency** (cohérence), **Isolation** (isolation), **Durability** (durabilité).

### ALTER
Commande SQL pour modifier la structure d'un objet (table, utilisateur, etc.).  
Exemple : `ALTER TABLE etudiants ADD telephone VARCHAR2(20);`

---

## B

### Bridge (réseau)
Type de réseau Docker qui permet aux conteneurs sur un même hôte de communiquer entre eux tout en restant isolés de l'extérieur.

---

## C

### CDB (Container Database)
Base de données racine dans l'architecture multi-tenant d'Oracle. Elle héberge une ou plusieurs PDB.  
Dans ce guide : `FREE`

### Client SQL
Application permettant de se connecter à une base de données pour exécuter des requêtes.  
Exemples : Oracle SQL Developer, DBeaver, SQL*Plus.

### COMMIT
Commande SQL qui valide définitivement les modifications apportées à la base de données.  
Exemple : `INSERT INTO ... ; COMMIT;`

### Compose (Docker Compose)
Outil pour définir et gérer des applications Docker multi-conteneurs via un fichier YAML (`docker-compose.yml`).

### Constraint (contrainte)
Règle de validation sur une colonne ou table.  
Types : `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK`.

### Conteneur (Container)
Instance en cours d'exécution d'une image Docker. Processus isolé avec son propre système de fichiers, réseau et espace mémoire.

---

## D

### Database
Base de données. Ensemble structuré de données organisées en tables, vues, index, etc.

### DBMS (Database Management System)
Système de gestion de base de données. Logiciel qui permet de créer, gérer et interroger des bases de données.  
Exemple : Oracle Database, MySQL, PostgreSQL.

### Docker
Plateforme de conteneurisation qui permet d'empaqueter des applications et leurs dépendances dans des conteneurs portables.

### Docker Desktop
Application graphique pour gérer Docker sur Windows et macOS. Inclut Docker Engine et Docker Compose.

### Docker Hub
Registre public d'images Docker. Permet de télécharger et partager des images.  
URL : [hub.docker.com](https://hub.docker.com)

### DML (Data Manipulation Language)
Langage de manipulation de données. Commandes SQL pour modifier les données : `INSERT`, `UPDATE`, `DELETE`, `SELECT`.

### DDL (Data Definition Language)
Langage de définition de données. Commandes SQL pour créer/modifier la structure : `CREATE`, `ALTER`, `DROP`, `TRUNCATE`.

---

## E

### EM Express (Enterprise Manager Express)
Interface web intégrée à Oracle pour l'administration basique de la base de données.  
Accessible sur le port 5500.

---

## F

### Foreign Key (clé étrangère)
Contrainte qui établit une relation entre deux tables en référençant la clé primaire d'une autre table.  
Exemple : `FOREIGN KEY (id_etudiant) REFERENCES etudiants(id_etudiant)`

---

## G

### GRANT
Commande SQL pour accorder des privilèges à un utilisateur.  
Exemple : `GRANT SELECT ON etudiants TO appuser;`

---

## H

### Health Check
Mécanisme Docker qui vérifie périodiquement si un conteneur est en bon état de fonctionnement.

### Hostname
Nom ou adresse IP de la machine hôte.  
Dans ce guide : `localhost` ou `127.0.0.1`

---

## I

### Image (Docker)
Modèle en lecture seule contenant une application et toutes ses dépendances. Sert de base pour créer des conteneurs.  
Exemple : `gvenzl/oracle-free:23.4-slim`

### Index
Structure de données qui améliore la vitesse de recherche dans une table.  
Exemple : `CREATE INDEX idx_nom ON etudiants(nom);`

### INSERT
Commande SQL pour ajouter des données dans une table.  
Exemple : `INSERT INTO etudiants (nom, prenom) VALUES ('Dupont', 'Marie');`

---

## J

### JOIN
Opération SQL qui combine les lignes de deux tables ou plus en fonction d'une condition.  
Types : `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`.

### JDBC (Java Database Connectivity)
API Java pour se connecter et interagir avec des bases de données.

---

## L

### Listener (Oracle Listener)
Processus Oracle qui écoute les demandes de connexion sur un port (par défaut : 1521).  
Commande : `lsnrctl status`

---

## M

### Multi-tenant
Architecture Oracle qui permet d'héberger plusieurs bases de données (PDB) dans une seule instance (CDB).

---

## N

### Network (réseau Docker)
Réseau virtuel permettant la communication entre conteneurs ou entre conteneurs et l'hôte.

### NOT NULL
Contrainte qui oblige une colonne à toujours contenir une valeur (interdiction de NULL).

---

## O

### Oracle Database
Système de gestion de base de données relationnelle (SGBDR) développé par Oracle Corporation.

### ORA-XXXXX
Format des codes d'erreur Oracle.  
Exemple : `ORA-12514` signifie que le listener ne connaît pas le service demandé.

---

## P

### PDB (Pluggable Database)
Base de données "branchée" dans une CDB. C'est l'espace de travail utilisateur dans l'architecture multi-tenant.  
Dans ce guide : `FREEPDB1`

### Port
Numéro identifiant un service réseau sur une machine.  
Exemple : 1521 (SQL*Net), 5500 (EM Express), 80 (HTTP).

### PRIMARY KEY (clé primaire)
Contrainte qui identifie de manière unique chaque ligne d'une table. Implique `UNIQUE` et `NOT NULL`.

### Privilège
Droit accordé à un utilisateur pour effectuer une action.  
Exemples : `CREATE TABLE`, `SELECT`, `INSERT`, `UPDATE`.

---

## R

### ROLLBACK
Commande SQL qui annule toutes les modifications non validées (non COMMITées) depuis le début de la transaction.

### Réseau bridge
Voir **Bridge (réseau)**.

---

## S

### Schema (schéma)
Ensemble d'objets de base de données (tables, vues, index, etc.) appartenant à un utilisateur.  
Dans Oracle, chaque utilisateur a son propre schéma.

### SELECT
Commande SQL pour interroger (lire) des données.  
Exemple : `SELECT nom, prenom FROM etudiants WHERE id_etudiant = 1;`

### Service Name
Identifiant d'une base de données Oracle utilisé lors de la connexion.  
Dans ce guide : `FREEPDB1`

### SID (System Identifier)
Ancien mode d'identification d'une base Oracle (remplacé par Service Name).

### SQL (Structured Query Language)
Langage standardisé pour interagir avec les bases de données relationnelles.

### SQL Developer
Client graphique gratuit d'Oracle pour gérer et interroger des bases de données Oracle.

### SQL*Net
Protocole réseau propriétaire d'Oracle pour les connexions client-serveur (port 1521).

### SQL*Plus
Client SQL en ligne de commande d'Oracle, intégré à toutes les installations Oracle.

### SYSTEM
Utilisateur administrateur par défaut dans Oracle. Possède des privilèges élevés.

### SYS
Utilisateur super-administrateur d'Oracle. Propriétaire du dictionnaire de données. Connexion souvent avec rôle SYSDBA.

---

## T

### Table
Structure de base de données qui stocke des données sous forme de lignes et colonnes.

### Tablespace
Espace de stockage logique dans Oracle. Regroupe un ou plusieurs fichiers de données physiques.  
Exemples : `SYSTEM`, `USERS`, `TEMP`.

### Transaction
Ensemble d'opérations SQL traitées comme une unité atomique. Validée par `COMMIT` ou annulée par `ROLLBACK`.

### TRUNCATE
Commande SQL qui vide une table rapidement (plus rapide que `DELETE`, mais non réversible).

---

## U

### UNIQUE
Contrainte qui garantit que toutes les valeurs d'une colonne sont uniques dans la table.

### UPDATE
Commande SQL pour modifier des données existantes.  
Exemple : `UPDATE etudiants SET email = 'nouveau@mail.fr' WHERE id_etudiant = 1;`

---

## V

### VARCHAR2
Type de données Oracle pour stocker des chaînes de caractères de longueur variable.  
Exemple : `VARCHAR2(100)` = maximum 100 caractères.

### View (vue)
Requête SQL enregistrée qui apparaît comme une table virtuelle.  
Exemple : `CREATE VIEW etudiants_actifs AS SELECT * FROM etudiants WHERE statut = 'Actif';`

### Volume (Docker)
Mécanisme de persistance des données dans Docker. Stocke les données en dehors du cycle de vie du conteneur.  
Dans ce guide : `oracle-data`

---

## W

### WHERE
Clause SQL pour filtrer les résultats.  
Exemple : `SELECT * FROM etudiants WHERE nom = 'Dupont';`

### Worksheet (SQL Developer)
Fenêtre dans SQL Developer où vous écrivez et exécutez des requêtes SQL.

### WSL2 (Windows Subsystem for Linux 2)
Couche de compatibilité Linux dans Windows. Utilisée par Docker Desktop sur Windows.

---

## Symboles et abréviations

### *
Symbole SQL signifiant "toutes les colonnes".  
Exemple : `SELECT * FROM etudiants;`

### --
Commentaire sur une ligne en SQL.  
Exemple : `-- Ceci est un commentaire`

### /* ... */
Commentaire multi-lignes en SQL.  
Exemple :
```sql
/*
  Ceci est un commentaire
  sur plusieurs lignes
*/
```

### CRUD
Acronyme pour les opérations de base : **Create** (INSERT), **Read** (SELECT), **Update** (UPDATE), **Delete** (DELETE).

### YAML
Format de fichier de configuration lisible par l'humain. Utilisé par Docker Compose.  
Exemple : `docker-compose.yml`

---

## 🔗 Voir aussi

- [architecture.md](architecture.md) : Schéma de l'infrastructure
- [troubleshooting.md](troubleshooting.md) : Résolution de problèmes
- [README.md](README.md) : Page principale du guide

---

**👉 Retour au [README.md](README.md)**
