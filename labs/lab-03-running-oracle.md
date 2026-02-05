# Lab 03 : Démarrer Oracle Database

## Objectifs

À la fin de ce lab, vous aurez :

- Démarré votre première instance Oracle avec Docker Compose
- Compris les logs de démarrage
- Vérifié que la base de données est prête
- Testé la connexion basique
- Appris à arrêter et redémarrer Oracle proprement

---

## Prérequis

- Docker Desktop lancé et fonctionnel
- Fichier `docker-compose.yml` configuré (Lab 02)
- Terminal ouvert dans le dossier du projet

---

## Étape 1 : Se placer dans le bon dossier

Ouvrez un terminal et naviguez vers le dossier `docker` :

```bash
cd docker
```

Vérifiez que le fichier `docker-compose.yml` est présent :

### Windows (PowerShell)

```powershell
ls
```

### macOS / Linux

```bash
ls -la
```

**Résultat attendu** :

```
docker-compose.yml
```

---

## Étape 2 : Démarrer Oracle (premier lancement)

### Commande

```bash
docker compose up -d
```

**Explication des options** :

- `up` : Crée et démarre les conteneurs
- `-d` : Mode détaché (détached = en arrière-plan)

### Ce qui se passe (premier lancement)

```
[+] Running 3/3
 ✔ Network docker_oracle-network  Created
 ✔ Volume "docker_oracle-data"    Created
 ✔ Container oracle-db            Started
```

**Étapes détaillées** :

1. **Téléchargement de l'image** (si absente)

   ```
   Pulling oracle-db (gvenzl/oracle-free:23.4-slim)...
   [====================>] 725.9MB/725.9MB
   ```

   ⏱️ **Durée** : 5-30 minutes (selon votre connexion)
2. **Création du réseau et du volume**

   ```
   Network docker_oracle-network  Created
   Volume docker_oracle-data      Created
   ```
3. **Démarrage du conteneur**

   ```
   Container oracle-db  Started
   ```

> 💡 **Note** : Au premier lancement, Oracle doit créer la base de données (CDB + PDB). Cela prend **5 à 10 minutes**.

> **Prenez un moment pour observer**
>
> - Le temps nécessaire au premier démarrage sur votre machine
> - Les différentes étapes affichées pendant la création de la base
> - Notez l'heure de début et de fin du processus

---

## Étape 3 : Suivre les logs de démarrage

Pour voir ce qui se passe en temps réel :

```bash
docker compose logs -f
```

**Explication** :

- `logs` : Affiche les logs du conteneur
- `-f` : Mode suivi (follow) en temps réel

### Logs attendus (extraits)

```
oracle-db  | CONTAINER: starting up...
oracle-db  | CONTAINER: first database startup, initializing...
oracle-db  | CONTAINER: creating database...
oracle-db  | 
oracle-db  | SQL*Plus: Release 23.0.0.0.0 - Production
oracle-db  | 
oracle-db  | Database created.
oracle-db  | 
oracle-db  | CONTAINER: creating pluggable database FREEPDB1...
oracle-db  | Pluggable database created.
oracle-db  | 
oracle-db  | CONTAINER: configuring...
oracle-db  | CONTAINER: starting database...
oracle-db  | 
oracle-db  | DATABASE IS READY TO USE!
```

### Points clés à observer

| Message dans les logs           | Signification                  |
| ------------------------------- | ------------------------------ |
| `first database startup`      | Premier lancement détecté    |
| `creating database`           | Création de la CDB (FREE)     |
| `creating pluggable database` | Création de la PDB (FREEPDB1) |
| `DATABASE IS READY TO USE!`   | ✅ Oracle est prêt !          |

> 💡 **À retenir**
> Le message exact indiquant que la base est opérationnelle est important.
> Observez attentivement les logs : certains messages confirment que la base est prête à accepter des connexions.

**Pour quitter le suivi des logs** : `Ctrl + C`

> ⚠️ **Important** : `Ctrl + C` quitte seulement le suivi des logs, le conteneur continue de tourner.

> **Expérience à tester**
> Après ce premier démarrage, essayez d'arrêter puis de redémarrer le conteneur :
>
> ```bash
> docker compose down
> docker compose up -d
> docker compose logs -f
> ```
>
> Observez la différence de temps. Pourquoi le deuxième démarrage est-il plus rapide ?

---

## Étape 4 : Vérifier l'état du conteneur

### Commande

```bash
docker compose ps
```

**Résultat attendu** :

```
NAME        IMAGE                            STATUS        PORTS
oracle-db   gvenzl/oracle-free:23.4-slim     Up 5 minutes  0.0.0.0:1521->1521/tcp, 0.0.0.0:5500->5500/tcp
```

### Statuts possibles

| Status                              | Signification                                     |
| ----------------------------------- | ------------------------------------------------- |
| `Up X minutes`                    | ✅ Conteneur actif                                |
| `Up X minutes (healthy)`          | ✅ Conteneur actif ET base prête                 |
| `Up X minutes (health: starting)` | 🟡 Conteneur actif, Oracle en cours de démarrage |
| `Exited (X)`                      | ❌ Conteneur arrêté (erreur possible)           |

---

## Étape 5 : Vérifier le health check

Docker peut vous indiquer si Oracle est vraiment prêt.

```bash
docker ps
```

**Résultat attendu** :

```
CONTAINER ID   IMAGE                            STATUS                    PORTS
abc123def456   gvenzl/oracle-free:23.4-slim     Up 8 minutes (healthy)    0.0.0.0:1521->1521/tcp
```

**Statut "healthy"** :

- ✅ Oracle est pleinement opérationnel
- ✅ Vous pouvez vous connecter avec un client SQL

**Si statut "(health: starting)"** :

- 🟡 Oracle démarre encore
- ⏱️ Attendez 2-3 minutes supplémentaires

---

## Étape 6 : Inspecter les détails du conteneur

Pour voir tous les détails techniques :

```bash
docker inspect oracle-db
```

**Informations utiles** (extraits) :

```json
{
  "State": {
    "Status": "running",
    "Running": true,
    "Paused": false,
    "Health": {
      "Status": "healthy"
    }
  },
  "NetworkSettings": {
    "Ports": {
      "1521/tcp": [{"HostPort": "1521"}],
      "5500/tcp": [{"HostPort": "5500"}]
    }
  }
}
```

---

## Étape 7 : Tester la connexion (test rapide)

Testons la connectivité réseau au port 1521.

### Windows (PowerShell)

```powershell
Test-NetConnection -ComputerName localhost -Port 1521
```

**Résultat attendu** :

```
TcpTestSucceeded : True
```

### macOS / Linux

```bash
nc -zv localhost 1521
```

**Résultat attendu** :

```
Connection to localhost port 1521 [tcp/*] succeeded!
```

✅ Le port est accessible, Oracle écoute sur le port 1521.

---

## Étape 8 : Se connecter à Oracle (test SQL)

Nous allons nous connecter directement depuis le conteneur pour tester.

### Commande

```bash
docker exec -it oracle-db sqlplus system/OraclePass123@FREEPDB1
```

**Explication** :

- `docker exec` : Exécute une commande dans un conteneur actif
- `-it` : Mode interactif avec terminal
- `oracle-db` : Nom du conteneur
- `sqlplus` : Client SQL en ligne de commande
- `system/OraclePass123` : Utilisateur et mot de passe
- `@FREEPDB1` : Connexion à la PDB

### Résultat attendu

```
SQL*Plus: Release 23.0.0.0.0 - Production

Connected to:
Oracle Database 23c Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free

SQL>
```

✅ **Succès !** Vous êtes connecté à Oracle.

### Améliorer l'affichage avec le formatage

Par défaut, SQL*Plus affiche les colonnes sur plusieurs lignes. Pour un affichage plus lisible :

```sql
-- Formater la colonne 'name' sur 20 caractères
COLUMN name FORMAT A20

-- Formater la colonne 'open_mode' sur 15 caractères
COLUMN open_mode FORMAT A15
```

**Explication des commandes de formatage** :

| Commande | Signification |
|----------|---------------|
| `COLUMN name` | Cible la colonne nommée "name" |
| `FORMAT A20` | Format Alphabétique sur 20 caractères |
| `FORMAT A15` | Format Alphabétique sur 15 caractères |

> 💡 **Le format `A` suivi d'un nombre** définit la largeur maximale d'affichage pour une colonne texte.
> Par exemple : `A20` = 20 caractères maximum.

### Tester une requête simple

```sql
-- Interroger les bases de données pluggables
SELECT name, open_mode FROM v$pdbs;
```

**Résultat attendu** :

```
NAME                 OPEN_MODE
-------------------- ---------------
FREEPDB1             READ WRITE
```

> 💡 **Où est `PDB$SEED` ?** : La base modèle `PDB$SEED` n'est visible que pour l'utilisateur SYS. Avec SYSTEM, vous voyez uniquement les PDBs utilisables.

### Voir toutes les PDBs (avec SYSDBA)

Pour voir également `PDB$SEED`, connectez-vous en tant que SYS :

**Quitter SQL*Plus** :

```sql
EXIT;
```

**Se connecter en tant que SYSDBA** :

```bash
docker exec -it oracle-db sqlplus sys/OraclePass123@FREE as sysdba
```

**Explication** :
- `sys` : Utilisateur administrateur suprême
- `@FREE` : Connexion à la CDB (Container Database)
- `as sysdba` : Avec les privilèges d'administrateur système

**Requête** :

```sql
-- Formater les colonnes
COLUMN name FORMAT A20
COLUMN open_mode FORMAT A15

-- Voir toutes les PDBs
SELECT name, open_mode FROM v$pdbs;
```

**Résultat attendu** :

```
NAME                 OPEN_MODE
-------------------- ---------------
PDB$SEED             READ ONLY
FREEPDB1             READ WRITE
```

**Explication des résultats** :

| PDB | Mode | Description |
|-----|------|-------------|
| `PDB$SEED` | READ ONLY | Base modèle (template) pour créer de nouvelles PDBs |
| `FREEPDB1` | READ WRITE | Votre base de données de travail |

### Quitter SQL*Plus

```sql
EXIT;
```

---

## Étape 9 : Arrêter Oracle proprement

Pour arrêter Oracle de manière propre :

```bash
docker compose down
```

**Ce qui se passe** :

```
[+] Running 2/2
 ✔ Container oracle-db            Removed
 ✔ Network docker_oracle-network  Removed
```

**Important** :

- Le conteneur est supprimé
- Le réseau est supprimé
- ✅ **Le volume est conservé** (vos données persistent)

### Vérifier que le conteneur est arrêté

```bash
docker compose ps
```

**Résultat attendu** :

```
NAME   IMAGE   COMMAND   SERVICE   CREATED   STATUS   PORTS
```

(Aucun conteneur actif)

---

## Étape 10 : Redémarrer Oracle (démarrages suivants)

### Commande

```bash
docker compose up -d
```

**Différence avec le premier lancement** :

- ❌ Pas de téléchargement d'image (déjà présente)
- ❌ Pas de création de base de données (volume existe)
- ✅ Démarrage en **1-2 minutes** seulement

### Logs du redémarrage

```bash
docker compose logs -f
```

```
oracle-db  | CONTAINER: starting up...
oracle-db  | CONTAINER: database already initialized, starting database...
oracle-db  | DATABASE IS READY TO USE!
```

⏱️ **Durée** : 1 à 2 minutes (beaucoup plus rapide !)

---

##  Récapitulatif des commandes essentielles

| Commande                                  | Action                             |
| ----------------------------------------- | ---------------------------------- |
| `docker compose up -d`                  | Démarrer Oracle en arrière-plan  |
| `docker compose down`                   | Arrêter Oracle proprement         |
| `docker compose ps`                     | Voir l'état du conteneur          |
| `docker compose logs -f`                | Suivre les logs en temps réel     |
| `docker exec -it oracle-db sqlplus ...` | Se connecter via SQL*Plus          |
| `docker ps`                             | État détaillé avec health check |

---

##  Dépannage

### Problème : "Error response from daemon: pull access denied"

**Cause** : Impossible de télécharger l'image.

**Solution** :

1. Vérifiez votre connexion Internet
2. Vérifiez que Docker Desktop est lancé
3. Essayez : `docker pull gvenzl/oracle-free:23.4-slim`

### Problème : Le conteneur redémarre en boucle

**Diagnostic** :

```bash
docker compose logs
```

**Causes possibles** :

- Pas assez de RAM (minimum 2 Go requis)
- Port 1521 déjà utilisé

**Solutions** :

- Augmentez la RAM dans Docker Desktop (Settings > Resources)
- Changez le port dans `docker-compose.yml` : `"1522:1521"`

### Problème : "DATABASE IS READY" n'apparaît jamais

**Cause** : L'initialisation prend plus de temps que prévu.

**Solution** :

1. Soyez patient (peut prendre jusqu'à 15 minutes)
2. Vérifiez les logs : `docker compose logs -f`
3. Vérifiez l'utilisation CPU/RAM dans Docker Desktop

### Problème : "ORA-12514: TNS:listener does not currently know of service"

**Cause** : Oracle démarre encore, le listener n'est pas prêt.

**Solution** :

- Attendez 2-3 minutes supplémentaires
- Vérifiez le health check : `docker ps`

---

## ✅ Checklist de validation

Avant de passer au lab suivant, vérifiez :

- [ ] `docker compose up -d` a démarré le conteneur
- [ ] Les logs montrent "DATABASE IS READY TO USE!"
- [ ] `docker ps` affiche le statut "(healthy)"
- [ ] La connexion avec `sqlplus` fonctionne
- [ ] `docker compose down` arrête proprement le conteneur
- [ ] Le redémarrage est beaucoup plus rapide (1-2 min)

---

##  Ce que vous avez appris

- ✅ Démarrer et arrêter Oracle avec Docker Compose
- ✅ Interpréter les logs de démarrage
- ✅ Vérifier l'état de santé d'un conteneur
- ✅ Tester la connectivité réseau
- ✅ Se connecter à Oracle via SQL*Plus
- ✅ Comprendre la différence entre premier démarrage et redémarrages

---

##  Prochaine étape

Oracle est prêt ! Passons maintenant à un client SQL graphique.

** [Lab 04 : Installer et configurer SQL Developer](lab-04-sql-client.md)**

---

##  Pour aller plus loin

- [Docker Compose CLI Reference](https://docs.docker.com/compose/reference/)
- [Oracle Database Startup](https://docs.oracle.com/en/database/oracle/oracle-database/23/admin/starting-up-and-shutting-down.html)
- [Health checks Docker](https://docs.docker.com/engine/reference/builder/#healthcheck)
