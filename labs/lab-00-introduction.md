# Lab 00 : Introduction et concepts de base

> **Durée estimée** : 15 minutes  
> **Niveau** : Débutant

---

## 🎯 Objectifs

À la fin de ce lab, vous serez capable de :

- ✅ Comprendre ce qu'est Docker et pourquoi on l'utilise
- ✅ Distinguer une image d'un conteneur
- ✅ Comprendre le rôle de Docker Compose
- ✅ Comprendre l'architecture multi-tenant d'Oracle (CDB/PDB)

---

## 📚 1. Qu'est-ce que Docker ?

### Définition simple

**Docker** est une plateforme qui permet d'empaqueter une application et toutes ses dépendances dans un **conteneur**.

### Analogie : Docker = Conteneur maritime

Imaginez Docker comme un conteneur maritime :

```
┌─────────────────────────────────────┐
│  Conteneur Docker                   │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  Oracle Database 23c          │ │
│  ├───────────────────────────────┤ │
│  │  Java Runtime                 │ │
│  ├───────────────────────────────┤ │
│  │  Bibliothèques système        │ │
│  ├───────────────────────────────┤ │
│  │  Configuration Oracle         │ │
│  └───────────────────────────────┘ │
│                                     │
│  Tout est isolé et portable !      │
└─────────────────────────────────────┘
```

**Avantages** :
- 📦 **Portabilité** : Fonctionne partout (Windows, macOS, Linux)
- 🔒 **Isolation** : N'affecte pas le reste de votre système
- ⚡ **Rapidité** : Démarrage en quelques secondes
- 🔄 **Reproductibilité** : Même environnement pour tous

---

## 🖼️ 2. Image vs Conteneur

### Image Docker

Une **image** est un modèle en lecture seule (comme un ISO ou un template).

**Analogie** : Une image = un plan de maison

**Exemple** :
```
Image: gvenzl/oracle-free:23.4-slim
- Oracle Database 23c Free
- Configuration par défaut
- Prête à être instanciée
```

### Conteneur Docker

Un **conteneur** est une instance en cours d'exécution d'une image.

**Analogie** : Un conteneur = une maison construite à partir du plan

**Exemple** :
```
Conteneur: oracle-db
- Créé depuis l'image gvenzl/oracle-free:23.4-slim
- Processus Oracle actif
- Données modifiables
```

### Relation Image ↔ Conteneur

```
Image (plan)                  Conteneur (instance)
    │
    │  docker run
    ├────────────────────────▶  Conteneur 1 (oracle-db)
    │
    │  docker run
    └────────────────────────▶  Conteneur 2 (oracle-db-test)
```

> 💡 **Note** : Une seule image peut générer plusieurs conteneurs.

---

## 🎼 3. Qu'est-ce que Docker Compose ?

### Définition

**Docker Compose** est un outil pour définir et exécuter des applications Docker multi-conteneurs à l'aide d'un fichier YAML.

### Pourquoi utiliser Compose ?

Sans Docker Compose, vous devriez taper :

```bash
docker run -d \
  --name oracle-db \
  -p 1521:1521 \
  -p 5500:5500 \
  -e ORACLE_PASSWORD=OraclePass123 \
  -e APP_USER=appuser \
  -e APP_USER_PASSWORD=AppUserPass123 \
  -v oracle-data:/opt/oracle/oradata \
  --restart unless-stopped \
  gvenzl/oracle-free:23.4-slim
```

**Avec Docker Compose**, tout est dans `docker-compose.yml` :

```yaml
services:
  oracle-db:
    image: gvenzl/oracle-free:23.4-slim
    ports:
      - "1521:1521"
    environment:
      ORACLE_PASSWORD: OraclePass123
    volumes:
      - oracle-data:/opt/oracle/oradata
```

Et vous démarrez simplement avec :
```bash
docker compose up -d
```

**Avantages** :
- ✅ Configuration lisible et versionnable
- ✅ Reproductible (même config partout)
- ✅ Facile à partager avec d'autres étudiants
- ✅ Gestion de plusieurs conteneurs (si besoin)

---

## 🗄️ 4. Architecture Oracle : CDB et PDB

Oracle 23c utilise une architecture **multi-tenant** (multi-locataire).

### Concepts clés

| Terme | Nom complet | Description |
|-------|-------------|-------------|
| **CDB** | Container Database | Base de données racine (conteneur) |
| **PDB** | Pluggable Database | Base de données "branchée" (où vous travaillez) |

### Analogie : Immeuble et appartements

```
┌─────────────────────────────────────────┐
│  CDB: FREE (Container Database)         │  ← Immeuble
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  PDB: FREEPDB1                  │   │  ← Appartement 1
│  │  (C'est ici que vous travaillez)│   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  PDB: FREEPDB2 (si créé)        │   │  ← Appartement 2 (optionnel)
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

### Pourquoi cette architecture ?

**Avantages** :
- 🏢 **Mutualisation** : Une CDB peut héberger plusieurs PDB
- 🔒 **Isolation** : Chaque PDB est indépendante
- 📦 **Portabilité** : On peut "débrancher" une PDB et la brancher ailleurs
- 💰 **Économies** : Une seule instance Oracle pour plusieurs bases

### Dans notre configuration

- **CDB** : `FREE` (base racine, gérée automatiquement)
- **PDB** : `FREEPDB1` (votre espace de travail)

> ⚠️ **Important** : Vous vous connecterez toujours à `FREEPDB1`, jamais à `FREE`.

---

## 🔌 5. Connexion à Oracle : les paramètres

Lorsque vous vous connecterez avec SQL Developer (Lab 04), vous utiliserez :

| Paramètre | Valeur | Explication |
|-----------|--------|-------------|
| **Hostname** | `localhost` | Votre machine (l'hôte) |
| **Port** | `1521` | Port standard Oracle SQL*Net |
| **Service Name** | `FREEPDB1` | Nom de votre PDB (pas la CDB) |
| **Username** | `SYSTEM` | Utilisateur administrateur |
| **Password** | `OraclePass123` | Défini dans `docker-compose.yml` |

### Pourquoi `FREEPDB1` et pas `FREE` ?

```
❌ Connexion à FREE (CDB)
   → Accès administratif uniquement
   → Pas pour créer vos tables

✅ Connexion à FREEPDB1 (PDB)
   → Votre espace de travail
   → Vous pouvez créer tables, utilisateurs, etc.
```

---

## 🔍 6. Volumes Docker : persistance des données

### Problème sans volume

```
1. Vous créez une table dans le conteneur
2. Vous arrêtez le conteneur
3. Vous supprimez le conteneur (docker rm)
4. ❌ Votre table a disparu !
```

### Solution : les volumes

Un **volume Docker** est un espace de stockage persistant géré par Docker.

```
┌──────────────────────────────────────┐
│  Conteneur oracle-db                 │
│                                      │
│  /opt/oracle/oradata  ────────────┐  │
│                                   │  │
└───────────────────────────────────┼──┘
                                    │
                                    ▼
                        ┌─────────────────────┐
                        │ Volume: oracle-data │
                        │                     │
                        │ - users01.dbf       │
                        │ - system01.dbf      │
                        │ - redo logs         │
                        └─────────────────────┘
                          (persiste même si
                           conteneur supprimé)
```

**Avantages** :
- ✅ Données conservées même si le conteneur est supprimé
- ✅ Sauvegarde/restauration facile
- ✅ Performance optimale

---

## 🚀 7. Récapitulatif : le flux complet

Voici ce qui se passera dans les prochains labs :

```
Lab 01 : Vérifier Docker
   │
   ▼
Lab 02 : Comprendre docker-compose.yml
   │
   ▼
Lab 03 : Démarrer Oracle avec "docker compose up"
   │
   ├─▶ Téléchargement de l'image (1ère fois)
   ├─▶ Création du conteneur
   ├─▶ Initialisation d'Oracle (5-10 min)
   └─▶ Base de données prête
   │
   ▼
Lab 04 : Se connecter avec SQL Developer
   │
   └─▶ localhost:1521, service FREEPDB1
   │
   ▼
Lab 05 : Exécuter des requêtes SQL
   │
   └─▶ CREATE TABLE, INSERT, SELECT
   │
   ▼
Lab 06 : Nettoyer / Réinitialiser
   │
   └─▶ docker compose down -v
```

---

## 📝 8. Questions de compréhension

Avant de passer au lab suivant, assurez-vous de pouvoir répondre à :

1. **Quelle est la différence entre une image et un conteneur ?**
   <details>
   <summary>Voir la réponse</summary>
   Une image est un modèle (plan), un conteneur est une instance en cours d'exécution (maison construite).
   </details>

2. **Pourquoi utilise-t-on Docker Compose ?**
   <details>
   <summary>Voir la réponse</summary>
   Pour simplifier la configuration et rendre l'environnement reproductible avec un fichier YAML.
   </details>

3. **Qu'est-ce qu'une PDB ?**
   <details>
   <summary>Voir la réponse</summary>
   Une Pluggable Database, c'est une base de données "branchée" dans une CDB, où l'on travaille.
   </details>

4. **Quel service name utiliser pour se connecter ?**
   <details>
   <summary>Voir la réponse</summary>
   FREEPDB1 (pas FREE).
   </details>

5. **À quoi sert un volume Docker ?**
   <details>
   <summary>Voir la réponse</summary>
   À persister les données même si le conteneur est supprimé.
   </details>

---

## ✅ Checklist avant de continuer

- [ ] Je comprends ce qu'est Docker
- [ ] Je sais distinguer image et conteneur
- [ ] Je comprends le rôle de Docker Compose
- [ ] Je sais ce qu'est une CDB et une PDB
- [ ] Je sais qu'on se connecte à FREEPDB1

---

## 🔜 Prochaine étape

**👉 [Lab 01 : Vérifier votre installation Docker](lab-01-docker-setup.md)**

---

## 📚 Ressources complémentaires

- [Documentation Docker](https://docs.docker.com/)
- [Documentation Oracle Multi-tenant](https://docs.oracle.com/en/database/oracle/oracle-database/23/multi-tenant-administrators-guide.html)
- [Image gvenzl/oracle-free](https://github.com/gvenzl/oci-oracle-free)
