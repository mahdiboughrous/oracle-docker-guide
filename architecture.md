# Architecture de l'environnement

Ce document explique comment les différents composants de votre environnement interagissent.

---

## Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────┐
│                    Votre machine (hôte)                     │
│                                                             │
│  ┌─────────────────┐              ┌──────────────────┐    │
│  │  SQL Developer  │              │  Navigateur Web  │    │
│  │   (client SQL)  │              │   (optionnel)    │    │
│  └────────┬────────┘              └────────┬─────────┘    │
│           │                                │              │
│           │ Port 1521                      │ Port 5500    │
│           │ (SQL*Net)                      │ (EM Express) │
│           │                                │              │
│  ─────────┼────────────────────────────────┼──────────────│
│           │        Docker Engine           │              │
│  ─────────┼────────────────────────────────┼──────────────│
│           │                                │              │
│  ┌────────▼────────────────────────────────▼──────────┐   │
│  │     Conteneur : oracle-db                         │   │
│  │                                                    │   │
│  │  ┌──────────────────────────────────────────┐    │   │
│  │  │   Oracle Database 23c Free               │    │   │
│  │  │   Image: gvenzl/oracle-free:23.4-slim    │    │   │
│  │  │                                          │    │   │
│  │  │   ┌────────────┐      ┌──────────────┐  │    │   │
│  │  │   │  CDB       │      │  PDB         │  │    │   │
│  │  │   │  (FREE)    │─────▶│  (FREEPDB1)  │  │    │   │
│  │  │   └────────────┘      └──────────────┘  │    │   │
│  │  └──────────────────────────────────────────┘    │   │
│  │                                                    │   │
│  │  Volume monté: /opt/oracle/oradata                │   │
│  └────────────────────────┬───────────────────────────┘   │
│                           │                               │
│  ─────────────────────────┼───────────────────────────────│
│                           │                               │
│  ┌────────────────────────▼──────────────────────────┐   │
│  │  Volume Docker : oracle-data                      │   │
│  │  (persistance des données)                        │   │
│  └───────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## Composants détaillés

### 1. Machine hôte (votre ordinateur)

C'est votre système d'exploitation principal (Windows, macOS ou Linux).

**Rôle** :
- Exécute Docker Desktop
- Héberge le client SQL (SQL Developer)
- Expose les ports réseau pour communiquer avec le conteneur

---

### 2. Docker Engine

Moteur de conteneurisation fourni par Docker Desktop.

**Rôle** :
- Gère le cycle de vie des conteneurs (démarrage, arrêt)
- Gère les volumes de données
- Gère le réseau entre l'hôte et les conteneurs
- Isole les processus

**Commandes principales** :
```bash
docker compose up -d      # Démarrer les conteneurs
docker compose down       # Arrêter les conteneurs
docker compose ps         # Lister les conteneurs actifs
docker compose logs       # Voir les logs
```

---

### 3. Conteneur Docker : `oracle-db`

Instance isolée exécutant Oracle Database.

**Image utilisée** : `gvenzl/oracle-free:23.4-slim`
- Version Oracle : 23c Free (gratuite)
- Optimisée et maintenue par [Gerd Völker](https://github.com/gvenzl/oci-oracle-free)
- Taille : environ 2,5 Go

**Caractéristiques** :
- Nom du conteneur : `oracle-db`
- Ports exposés :
  - `1521` : Connexion SQL (SQL*Net)
  - `5500` : Oracle Enterprise Manager Express (interface web)
- Volume persistant : `/opt/oracle/oradata`

---

### 4. Oracle Database 23c Free

Base de données relationnelle Oracle.

#### Architecture multi-tenant (CDB/PDB)

Oracle 23c utilise une architecture **multi-tenant** :

| Acronyme | Nom complet | Rôle |
|----------|-------------|------|
| **CDB** | Container Database | Base racine (conteneur) |
| **PDB** | Pluggable Database | Base "branchée" (où vous travaillez) |

**Analogie** :
- **CDB** = Immeuble
- **PDB** = Appartement dans l'immeuble

**Dans notre configuration** :
- **CDB** : `FREE` (base racine)
- **PDB** : `FREEPDB1` (base de données utilisable)

> ⚠️ **Important** : Vous vous connecterez toujours à `FREEPDB1`, jamais à `FREE` directement.

---

### 5. Volume Docker : `oracle-data`

Système de stockage persistant géré par Docker.

**Rôle** :
- Stocke les fichiers de données Oracle (`.dbf`, `.log`, etc.)
- Persiste les données même si le conteneur est supprimé
- Permet de redémarrer sans perdre vos tables et données

**Emplacement physique** :
- **Windows** : `\\wsl$\docker-desktop-data\data\docker\volumes\oracle-data`
- **macOS** : `/var/lib/docker/volumes/oracle-data`
- **Linux** : `/var/lib/docker/volumes/oracle-data`

> 💡 **Conseil** : Vous n'avez jamais besoin d'accéder directement à ce dossier. Docker le gère automatiquement.

---

## Flux de connexion SQL

Voici ce qui se passe quand vous vous connectez depuis SQL Developer :

```
1. SQL Developer (localhost:1521)
          │
          ▼
2. Docker Engine (mapping de port)
          │
          ▼
3. Conteneur oracle-db (port 1521 interne)
          │
          ▼
4. Oracle Listener (écoute sur 1521)
          │
          ▼
5. Instance Oracle FREE
          │
          ▼
6. Service FREEPDB1 (votre PDB)
```

**Paramètres de connexion** :
- **Hôte** : `localhost`
- **Port** : `1521`
- **Service Name** : `FREEPDB1`
- **Utilisateur** : `SYSTEM` ou utilisateurs créés
- **Mot de passe** : défini dans `docker-compose.yml`

---

## Cycle de vie du conteneur

### Démarrage (premier lancement)

```
1. docker compose up
          │
          ▼
2. Téléchargement de l'image (si absente)
          │
          ▼
3. Création du conteneur
          │
          ▼
4. Initialisation d'Oracle (5-10 min)
   - Création de la CDB
   - Création de la PDB
   - Configuration du listener
          │
          ▼
5. Base de données PRÊTE
```

### Démarrage (lancements suivants)

```
1. docker compose up
          │
          ▼
2. Démarrage du conteneur existant
          │
          ▼
3. Oracle démarre (1-2 min)
          │
          ▼
4. Base de données PRÊTE
```

### Arrêt propre

```
1. docker compose down
          │
          ▼
2. Arrêt propre d'Oracle (shutdown)
          │
          ▼
3. Arrêt du conteneur
          │
          ▼
4. Volume conservé (données intactes)
```

---

## Ports réseau

| Port | Protocole | Usage | Obligatoire |
|------|-----------|-------|-------------|
| 1521 | TCP | Connexions SQL (SQL*Net) | ✅ Oui |
| 5500 | TCP | Oracle EM Express (web) | ❌ Non |

**Exposition des ports** :
- Format : `HOST:CONTAINER`
- Exemple : `1521:1521` signifie "port 1521 de l'hôte redirigé vers port 1521 du conteneur"

---

## Variables d'environnement

Définies dans `docker-compose.yml` :

| Variable | Valeur (exemple) | Description |
|----------|------------------|-------------|
| `ORACLE_PASSWORD` | `OraclePass123` | Mot de passe SYSTEM, SYS |
| `APP_USER` | `appuser` | Utilisateur applicatif (optionnel) |
| `APP_USER_PASSWORD` | `AppUserPass123` | Mot de passe de l'utilisateur applicatif |

> ⚠️ **Sécurité** : Ces mots de passe sont **pédagogiques**. En production, utilisez des secrets sécurisés.

---

## Isolation et sécurité

### Isolation réseau

- Le conteneur a son **propre réseau interne**
- Seuls les ports explicitement exposés (1521, 5500) sont accessibles
- Les autres processus Oracle restent isolés

### Isolation filesystem

- Le conteneur a son **propre système de fichiers**
- Seul le volume monté (`/opt/oracle/oradata`) est partagé
- Les fichiers temporaires sont isolés dans le conteneur

### Isolation processus

- Oracle s'exécute dans un **espace de processus isolé**
- Ne peut pas affecter les processus de l'hôte
- Ressources (CPU, RAM) limitables via Docker

---

## Comparaison : Installation traditionnelle vs Docker

| Critère | Installation native | Avec Docker |
|---------|---------------------|-------------|
| **Temps d'installation** | 1-2 heures | 10-30 min (téléchargement) |
| **Configuration** | Complexe (variables, services) | Automatique |
| **Portabilité** | Liée à l'OS | Identique sur tous les OS |
| **Nettoyage** | Difficile (fichiers éparpillés) | `docker compose down -v` |
| **Reproductibilité** | Faible | Totale (même config partout) |
| **Isolation** | Aucune | Complète |
| **Performances** | Natives | Légèrement réduites (< 5%) |

---

## Pourquoi cette architecture ?

### Avantages pédagogiques

1. **Reproductibilité** : Tous les étudiants ont exactement la même configuration
2. **Pas de pollution** : Oracle reste isolé dans le conteneur
3. **Réinitialisation facile** : `docker compose down -v` efface tout
4. **Partage simplifié** : Le fichier `docker-compose.yml` suffit

### Avantages techniques

1. **Pas de conflit de ports** : Oracle isolé
2. **Gestion des versions** : Facile de tester Oracle 21c, 23c, etc.
3. **Snapshots possibles** : Sauvegarde de l'état du volume
4. **Multi-environnements** : Dev, test, prod sur la même machine

---

## Vérifier l'architecture

Une fois l'environnement démarré (Lab 03), vous pourrez vérifier :

### État du conteneur
```bash
docker compose ps
```

### Logs du démarrage
```bash
docker compose logs
```

### Ports exposés
```bash
docker ps
```

### Volumes créés
```bash
docker volume ls
```

---

** Prêt à comprendre l'architecture en pratique ? Direction [Lab 00 : Introduction](labs/lab-00-introduction.md) !**
