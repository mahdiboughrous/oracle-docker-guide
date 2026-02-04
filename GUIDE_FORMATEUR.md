# Guide pour le formateur

Ce document est destiné aux enseignants et formateurs utilisant ce guide pédagogique.

---

## Objectifs pédagogiques globaux

À l'issue de ce TP, les étudiants seront capables de :

1. **Comprendre** les concepts de conteneurisation avec Docker
2. **Déployer** une base de données Oracle avec Docker Compose
3. **Se connecter** à Oracle avec un client SQL
4. **Créer** et **manipuler** des tables et données
5. **Gérer** le cycle de vie d'un environnement conteneurisé

---

## Planning suggéré

### Séance 1 (2 heures) : Installation et concepts

| Durée | Activité | Support |
|-------|----------|---------|
| 15 min | Présentation de Docker et Oracle | Slides + [architecture.md](architecture.md) |
| 20 min | Installation Docker Desktop (étudiants) | [prerequisites.md](prerequisites.md) |
| 15 min | Lab 00 : Concepts de base | [lab-00-introduction.md](labs/lab-00-introduction.md) |
| 15 min | Lab 01 : Vérification Docker | [lab-01-docker-setup.md](labs/lab-01-docker-setup.md) |
| 20 min | Lab 02 : Configuration Compose | [lab-02-oracle-compose.md](labs/lab-02-oracle-compose.md) |
| 30 min | Lab 03 : Démarrage Oracle | [lab-03-running-oracle.md](labs/lab-03-running-oracle.md) |
| 5 min | Pause / Questions | - |

### Séance 2 (2 heures) : SQL et pratique

| Durée | Activité | Support |
|-------|----------|---------|
| 20 min | Lab 04 : Installation SQL Developer | [lab-04-sql-client.md](labs/lab-04-sql-client.md) |
| 50 min | Lab 05 : Requêtes SQL | [lab-05-basic-sql.md](labs/lab-05-basic-sql.md) |
| 15 min | Lab 06 : Nettoyage | [lab-06-cleanup-reset.md](labs/lab-06-cleanup-reset.md) |
| 20 min | Exercices supplémentaires | Scripts personnalisés |
| 15 min | Récapitulatif et questions | - |

---

## Préparation avant la séance

### Matériel nécessaire

- ✅ Ordinateurs avec **8 Go RAM minimum** (16 Go recommandé)
- ✅ Connexion Internet stable (WiFi ou filaire)
- ✅ Accès administrateur sur les postes (installation Docker)
- ✅ Projecteur pour démonstrations
- ✅ Accès au dépôt GitHub ou fichiers ZIP distribués

### Installation préalable (recommandé)

Pour éviter les téléchargements en séance :

1. **Installer Docker Desktop** sur tous les postes
2. **Pré-télécharger l'image Oracle** :
   ```bash
   docker pull gvenzl/oracle-free:23.4-slim
   ```
   (économise 10-30 min par poste)

3. **Tester un démarrage** sur une machine de test

---

## Conseils pédagogiques

### Gestion du groupe

- **Binômes** : Encouragez le travail à deux (entraide)
- **Rythme** : Laissez les plus rapides avancer, aidez les plus lents
- **Checkpoints** : Synchronisez le groupe à la fin de chaque lab

### Points d'attention

1. **Lab 03 (démarrage Oracle)** :
   - Temps d'attente long (5-10 min) au premier lancement
   - Profitez-en pour expliquer l'architecture (CDB/PDB)
   - Certains étudiants auront des erreurs de RAM → réduire la limite dans `docker-compose.yml`

2. **Lab 04 (SQL Developer)** :
   - macOS : Problème Gatekeeper (autorisation manuelle)
   - Windows : Parfois lent au premier démarrage

3. **Lab 05 (SQL)** :
   - Vérifiez que tous comprennent la différence PK/FK
   - Insistez sur `COMMIT` (oubli fréquent)

### Erreurs fréquentes

| Erreur | Cause probable | Solution rapide |
|--------|----------------|-----------------|
| "Docker not found" | Docker Desktop pas lancé | Lancer Docker Desktop |
| Port 1521 occupé | Oracle local installé | Changer le port dans compose |
| "ORA-12514" | Connexion à FREE au lieu de FREEPDB1 | Vérifier Service Name |
| Conteneur redémarre en boucle | Pas assez de RAM | Augmenter RAM Docker ou réduire limite |

Référez-vous à [troubleshooting.md](troubleshooting.md) pour plus de détails.

---

## Évaluation des acquis

### Quiz rapide (fin de séance)

1. Quelle est la différence entre une image et un conteneur ?
2. Qu'est-ce qu'une PDB dans Oracle ?
3. Quel port utilise Oracle SQL*Net par défaut ?
4. Quelle commande arrête Oracle en conservant les données ?
5. Quelle commande SQL valide définitivement les changements ?

**Réponses** :
1. Image = modèle, Conteneur = instance en cours d'exécution
2. PDB = Pluggable Database, base "branchée" dans une CDB
3. Port 1521
4. `docker compose down` (sans `-v`)
5. `COMMIT`

### Exercice pratique (évaluation)

**Sujet** : Créer une base de données de bibliothèque

1. Créer un utilisateur `biblio` avec mot de passe `Biblio2024!`
2. Créer 3 tables :
   - `livres` (id, titre, auteur, isbn, annee_publication)
   - `membres` (id, nom, prenom, email, date_inscription)
   - `emprunts` (id, id_livre, id_membre, date_emprunt, date_retour)
3. Insérer au moins 5 livres et 3 membres
4. Requête : Lister tous les emprunts en cours (date_retour NULL)
5. Requête : Compter le nombre d'emprunts par membre

**Fichier de correction** : Fournissez un script SQL modèle.

---

## Dépannage en séance

### Problème : Tous les étudiants téléchargent en même temps

**Impact** : Sature la bande passante, téléchargements très lents.

**Solution** :
1. Pré-télécharger l'image avant la séance
2. Ou : Utiliser un **registry local** Docker (avancé)

### Problème : Certains postes n'ont pas assez de RAM

**Solution** :
Réduire la limite dans `docker-compose.yml` :
```yaml
deploy:
  resources:
    limits:
      memory: 2G  # Au lieu de 4G
```

### Problème : Pare-feu de l'établissement bloque Docker Hub

**Solution** :
1. Demander à l'IT de whitelister `registry-1.docker.io`
2. Ou : Distribuer l'image sur clé USB et charger localement :
   ```bash
   docker load -i oracle-free-23.4-slim.tar
   ```

---

## Exercices supplémentaires

### Niveau débutant

1. Ajouter une colonne `telephone` à la table `etudiants`
2. Créer une vue `etudiants_actifs` qui filtre sur `date_inscription`
3. Compter le nombre d'inscriptions par semestre

### Niveau intermédiaire

1. Créer un trigger qui empêche la suppression d'un étudiant ayant des inscriptions
2. Créer une procédure stockée pour inscrire un étudiant à un cours
3. Utiliser un ROLLBACK pour annuler des modifications

### Niveau avancé

1. Optimiser les requêtes avec des index
2. Analyser les plans d'exécution avec EXPLAIN PLAN
3. Créer une sauvegarde avec expdp et la restaurer avec impdp

---

## Ressources complémentaires pour formateurs

### Documentation Oracle

- [Oracle Database Concepts](https://docs.oracle.com/en/database/oracle/oracle-database/23/cncpt/)
- [SQL Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/)
- [Oracle Academy](https://academy.oracle.com/) (cours gratuits pour enseignants)

### Docker

- [Docker for Educators](https://www.docker.com/community/get-involved/educators/)
- [Play with Docker](https://labs.play-with-docker.com/) (environnement en ligne)

### Supports visuels

- Schémas dans [architecture.md](architecture.md) à projeter
- Diagrammes d'architecture CDB/PDB
- Flux de démarrage Docker Compose

---

## Contribution et amélioration

Vous avez des suggestions pour améliorer ce guide ?

1. Ouvrez une issue sur GitHub
2. Proposez une Pull Request (voir [CONTRIBUTING.md](CONTRIBUTING.md))
3. Partagez vos retours d'expérience

---

## 📧 Support

Pour toute question sur l'utilisation pédagogique de ce guide :

- Ouvrir une **Discussion** sur GitHub
- Consulter [troubleshooting.md](troubleshooting.md)

---

**Bon enseignement ! 🎓**
