# Lab 06 : Nettoyer et réinitialiser l'environnement

> **Durée estimée** : 10 minutes  
> **Niveau** : Débutant

---

## 🎯 Objectifs

À la fin de ce lab, vous serez capable de :

- ✅ Arrêter proprement Oracle
- ✅ Supprimer les conteneurs Docker
- ✅ Supprimer les volumes (données)
- ✅ Nettoyer les images Docker inutilisées
- ✅ Réinitialiser complètement l'environnement
- ✅ Comprendre la différence entre arrêt et suppression

---

## 📋 Prérequis

- Docker Desktop lancé
- Terminal ouvert dans le dossier `docker/`

---

## 🛑 Étape 1 : Arrêter Oracle (sans suppression)

### Commande

```bash
docker compose down
```

**Ce qui se passe** :
```
[+] Running 2/2
 ✔ Container oracle-db            Removed
 ✔ Network docker_oracle-network  Removed
```

**Effet** :
- ✅ Le conteneur est arrêté et supprimé
- ✅ Le réseau est supprimé
- ✅ **Le volume est conservé** (données intactes)

### Vérifier l'arrêt

```bash
docker compose ps
```

**Résultat attendu** :
```
NAME   IMAGE   COMMAND   SERVICE   CREATED   STATUS   PORTS
```

(Aucun conteneur actif)

---

## 💾 Étape 2 : Vérifier les volumes persistants

Même après `docker compose down`, les données sont conservées dans le volume.

### Lister les volumes

```bash
docker volume ls
```

**Résultat attendu** :
```
DRIVER    VOLUME NAME
local     docker_oracle-data
```

✅ Le volume `docker_oracle-data` existe toujours.

### Inspecter le volume

```bash
docker volume inspect docker_oracle-data
```

**Résultat** (extrait) :
```json
[
    {
        "Name": "docker_oracle-data",
        "Driver": "local",
        "Mountpoint": "/var/lib/docker/volumes/docker_oracle-data/_data",
        "CreatedAt": "2026-02-04T10:30:00Z",
        "Scope": "local"
    }
]
```

> 💡 **Important** : Vos tables, utilisateurs et données sont dans ce volume.

---

## 🔄 Étape 3 : Redémarrer avec les données conservées

Si vous redémarrez maintenant :

```bash
docker compose up -d
```

**Résultat** :
- ✅ Démarrage rapide (1-2 minutes)
- ✅ Toutes vos données sont présentes (tables, utilisateurs, etc.)
- ✅ Pas de réinitialisation de la base

**Vérification** :
```bash
docker exec -it oracle-db sqlplus etudiant/Etudiant2024!@FREEPDB1
```

```sql
SELECT COUNT(*) FROM etudiants;
```

Si vous aviez créé des données dans le Lab 05, elles sont toujours là ! ✅

---

## 🗑️ Étape 4 : Supprimer les volumes (réinitialisation complète)

Pour repartir de zéro (base vierge), il faut supprimer le volume.

### Arrêter ET supprimer le volume

```bash
docker compose down -v
```

**Explication** :
- `down` : Arrête et supprime les conteneurs
- `-v` : Supprime aussi les volumes (**données perdues**)

**Résultat** :
```
[+] Running 3/3
 ✔ Container oracle-db            Removed
 ✔ Network docker_oracle-network  Removed
 ✔ Volume docker_oracle-data      Removed
```

### Vérifier la suppression

```bash
docker volume ls
```

**Résultat attendu** :
```
DRIVER    VOLUME NAME
```

(Aucun volume `docker_oracle-data`)

✅ Le volume a été supprimé. **Toutes les données sont perdues.**

---

## 🆕 Étape 5 : Redémarrer avec une base vierge

Après avoir supprimé le volume, un nouveau démarrage recréera tout.

### Commande

```bash
docker compose up -d
```

**Ce qui se passe** :
1. Création d'un nouveau volume `docker_oracle-data` (vide)
2. Initialisation complète d'Oracle (5-10 minutes)
3. Création de la CDB et PDB
4. Utilisateur `appuser` recréé (si défini dans `docker-compose.yml`)

### Suivre les logs

```bash
docker compose logs -f
```

Attendez le message :
```
DATABASE IS READY TO USE!
```

---

## 🧹 Étape 6 : Nettoyer les images Docker inutilisées

Au fil du temps, Docker accumule des images (anciennes versions, etc.).

### Lister les images

```bash
docker images
```

**Résultat possible** :
```
REPOSITORY                TAG          IMAGE ID       CREATED        SIZE
gvenzl/oracle-free        23.4-slim    abc123def456   2 weeks ago    2.5GB
gvenzl/oracle-free        latest       xyz789abc123   1 month ago    2.8GB
hello-world               latest       9c7a54a9a43c   3 months ago   13.3kB
```

### Supprimer une image spécifique

```bash
docker rmi gvenzl/oracle-free:latest
```

### Supprimer toutes les images inutilisées

```bash
docker image prune -a
```

**Attention** : Cela supprime **toutes** les images non utilisées par un conteneur actif.

**Confirmation** :
```
WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
```

---

## 🧼 Étape 7 : Nettoyage complet de Docker

Pour récupérer un maximum d'espace disque :

### Commande globale

```bash
docker system prune -a --volumes
```

**Ce qui est supprimé** :
- ❌ Tous les conteneurs arrêtés
- ❌ Tous les réseaux inutilisés
- ❌ Toutes les images non utilisées
- ❌ Tous les volumes non utilisés
- ❌ Tous les caches de build

**Confirmation** :
```
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all images without at least one container associated to them
  - all build cache
  - all volumes not used by at least one container

Are you sure you want to continue? [y/N]
```

> ⚠️ **ATTENTION** : Cette commande supprime TOUT ce qui n'est pas actif. Utilisez-la seulement si vous êtes sûr.

### Vérifier l'espace libéré

```bash
docker system df
```

**Avant nettoyage** :
```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          5         1         5.2GB     2.7GB (52%)
Containers      3         1         100MB     50MB (50%)
Local Volumes   2         1         3GB       1.5GB (50%)
```

**Après nettoyage** :
```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          1         1         2.5GB     0B (0%)
Containers      1         1         50MB      0B (0%)
Local Volumes   1         1         1.5GB     0B (0%)
```

---

## 🔍 Étape 8 : Vérifier les ressources Docker Desktop

### Interface graphique

1. Ouvrez **Docker Desktop**
2. Allez dans **Settings** (⚙️) > **Resources** > **Advanced**
3. Vérifiez :
   - **CPUs** : Nombre de cœurs alloués
   - **Memory** : RAM allouée (minimum 2 Go, recommandé 4 Go)
   - **Disk image size** : Espace disque maximum

### Statistiques d'utilisation

Dans le terminal :

```bash
docker stats oracle-db
```

**Résultat** (si le conteneur est actif) :
```
CONTAINER ID   NAME        CPU %     MEM USAGE / LIMIT     MEM %     NET I/O       BLOCK I/O
abc123def456   oracle-db   15.5%     1.8GiB / 4GiB        45%       1.2kB / 0B    50MB / 10MB
```

Appuyez sur `Ctrl + C` pour quitter.

---

## 📋 Récapitulatif des commandes

| Commande | Action | Données conservées ? |
|----------|--------|----------------------|
| `docker compose stop` | Arrête le conteneur (ne le supprime pas) | ✅ Oui |
| `docker compose down` | Arrête et supprime le conteneur | ✅ Oui (volume intact) |
| `docker compose down -v` | Arrête, supprime conteneur ET volume | ❌ Non (tout supprimé) |
| `docker volume rm <nom>` | Supprime un volume spécifique | ❌ Non |
| `docker image prune -a` | Supprime toutes les images inutilisées | N/A |
| `docker system prune -a --volumes` | Nettoyage complet de Docker | ❌ Non |

---

## 🔄 Étape 9 : Scénarios d'utilisation

### Scénario 1 : Pause de travail (garder les données)

**Situation** : Vous avez fini pour aujourd'hui, vous voulez libérer de la RAM.

**Commande** :
```bash
docker compose down
```

**Résultat** : Conteneur arrêté, données conservées.

**Reprise** :
```bash
docker compose up -d
```

---

### Scénario 2 : Réinitialisation complète (nouveau TP)

**Situation** : Vous voulez repartir de zéro pour un nouveau TP.

**Commande** :
```bash
docker compose down -v
docker compose up -d
```

**Résultat** : Base vierge, comme au premier lancement.

---

### Scénario 3 : Changer de version Oracle

**Situation** : Vous voulez tester Oracle 21c au lieu de 23c.

**Étapes** :
1. Arrêter et supprimer :
   ```bash
   docker compose down -v
   ```

2. Modifier `docker-compose.yml` :
   ```yaml
   image: gvenzl/oracle-free:21.3-slim  # Au lieu de 23.4-slim
   ```

3. Redémarrer :
   ```bash
   docker compose up -d
   ```

---

### Scénario 4 : Libérer de l'espace disque

**Situation** : Docker occupe trop d'espace.

**Commande** :
```bash
docker system prune -a --volumes
```

**Résultat** : Suppression de tout ce qui n'est pas actif.

---

## ❓ Dépannage

### Problème : "Error response from daemon: volume is in use"

**Cause** : Le conteneur utilise encore le volume.

**Solution** :
```bash
docker compose down
docker volume rm docker_oracle-data
```

### Problème : "Cannot remove volume, volume is being used"

**Cause** : Un conteneur zombie utilise le volume.

**Solution** :
```bash
# Lister tous les conteneurs (actifs + arrêtés)
docker ps -a

# Supprimer tous les conteneurs arrêtés
docker container prune

# Réessayer
docker volume rm docker_oracle-data
```

### Problème : Docker Desktop occupe 50+ Go

**Cause** : Accumulation d'images et volumes.

**Solution** :
```bash
# Voir l'utilisation
docker system df

# Nettoyer
docker system prune -a --volumes
```

---

## ✅ Checklist de validation

Après ce lab, vous savez :

- [ ] Arrêter Oracle avec `docker compose down`
- [ ] Supprimer les volumes avec `docker compose down -v`
- [ ] Redémarrer avec ou sans conservation des données
- [ ] Lister et inspecter les volumes Docker
- [ ] Nettoyer les images inutilisées
- [ ] Faire un nettoyage complet avec `docker system prune`
- [ ] Comprendre la différence entre arrêt et suppression

---

## 🎓 Ce que vous avez appris

- ✅ Gestion du cycle de vie des conteneurs Docker
- ✅ Persistance des données avec les volumes
- ✅ Différence entre `stop`, `down` et `down -v`
- ✅ Nettoyage et optimisation de l'espace disque Docker
- ✅ Réinitialisation complète de l'environnement
- ✅ Inspection des ressources Docker

---

## 🎉 Félicitations !

Vous avez terminé tous les labs du guide !

### Ce que vous maîtrisez maintenant :

1. ✅ Installer et configurer Docker
2. ✅ Déployer Oracle Database 23c avec Docker Compose
3. ✅ Se connecter avec un client SQL (SQL Developer)
4. ✅ Créer des tables, insérer et interroger des données
5. ✅ Gérer le cycle de vie de l'environnement
6. ✅ Nettoyer et réinitialiser proprement

---

## 🔜 Pour aller plus loin

### Prochaines étapes suggérées :

1. **PL/SQL** : Apprendre à écrire des procédures stockées
2. **Transactions avancées** : Gestion de la concurrence (ACID)
3. **Index et optimisation** : Améliorer les performances
4. **Sauvegarde/Restauration** : Exporter et importer des données
5. **Oracle en production** : Haute disponibilité, clustering

### Ressources recommandées :

- [Oracle Live SQL](https://livesql.oracle.com/) : Environnement en ligne gratuit
- [Oracle Academy](https://academy.oracle.com/) : Cours gratuits pour étudiants
- [AskTOM](https://asktom.oracle.com/) : Forum de questions Oracle
- [Oracle Blogs](https://blogs.oracle.com/database/) : Actualités et tutoriels

---

## 📚 Documentation

- [README.md](../README.md) : Présentation du guide
- [architecture.md](../architecture.md) : Schéma de l'infrastructure
- [troubleshooting.md](../troubleshooting.md) : Solutions aux problèmes courants
- [glossary.md](../glossary.md) : Glossaire des termes techniques

---

**👏 Bravo d'avoir suivi ce guide jusqu'au bout !**
