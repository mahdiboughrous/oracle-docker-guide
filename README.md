# Guide pratique : Oracle Database 23c avec Docker Compose

> Guide pédagogique complet pour apprendre à déployer et utiliser Oracle Database 23c Free avec Docker

---

## À propos de ce guide

Ce guide pratique (hands-on) vous accompagne pas à pas dans la mise en place d'une base de données Oracle Database 23c Free à l'aide de Docker Compose, puis dans son utilisation avec un client SQL.

**Public cible** : Étudiants en licence, master ou école d'ingénieurs ayant des bases en systèmes d'information.

**Durée estimée** : 3 à 4 heures de travaux pratiques.

---

## Ce que vous allez apprendre

À l'issue de ce guide, vous serez capable de :

- Configurer un environnement Oracle Database avec Docker Compose
- Démarrer et arrêter une instance Oracle de manière reproductible
- Vous connecter à Oracle avec un client SQL (SQL Developer)
- Exécuter des requêtes SQL de base
- Créer des utilisateurs, des schémas et des tables
- Gérer la persistance des données avec Docker
- Diagnostiquer les erreurs courantes

---

## Prérequis

Avant de commencer, assurez-vous d'avoir :

- **Docker Desktop** installé et fonctionnel
- Un **terminal** (PowerShell, Bash, ou Terminal)
- Au moins **8 Go de RAM disponible** sur votre machine
- Une **connexion Internet** pour télécharger les images Docker
- Un **éditeur de texte** (VS Code, Notepad++, etc.)

👉 **Consultez le fichier [prerequisites.md](prerequisites.md) pour les instructions détaillées d'installation.**

---

## Comment utiliser ce dépôt

### Option 1 : Télécharger en ZIP (recommandé pour débutants)

1. Cliquez sur le bouton vert **Code** en haut de cette page
2. Sélectionnez **Download ZIP**
3. Décompressez l'archive dans un dossier de travail
4. Ouvrez un terminal dans ce dossier

### Option 2 : Cloner avec Git

```bash
git clone https://github.com/VOTRE_USERNAME/oracle-docker-guide.git
cd oracle-docker-guide
```

---

## Structure du guide

Le guide est organisé en **labs progressifs** :

| Lab | Titre | Objectif |
|-----|-------|----------|
| [Lab 00](labs/lab-00-introduction.md) | Introduction | Comprendre l'architecture globale |
| [Lab 01](labs/lab-01-docker-setup.md) | Vérifier Docker | S'assurer que Docker fonctionne |
| [Lab 02](labs/lab-02-oracle-compose.md) | Configurer Compose | Comprendre le fichier docker-compose.yml |
| [Lab 03](labs/lab-03-running-oracle.md) | Démarrer Oracle | Lancer votre première instance |
| [Lab 04](labs/lab-04-sql-client.md) | Installer SQL Developer | Se connecter avec un client SQL |
| [Lab 05](labs/lab-05-basic-sql.md) | Requêtes SQL de base | Créer des tables et insérer des données |
| [Lab 06](labs/lab-06-cleanup-reset.md) | Nettoyer / Réinitialiser | Gérer les conteneurs et volumes |

---

## Démarrage rapide

**Pour commencer immédiatement :**

1. Lisez [prerequisites.md](prerequisites.md) pour installer Docker
2. Consultez [architecture.md](architecture.md) pour comprendre l'architecture
3. Commencez par [Lab 00 : Introduction](labs/lab-00-introduction.md)
4. Suivez les labs dans l'ordre numérique

---

## Ressources complémentaires

- **[Architecture](architecture.md)** : Schéma explicatif de l'infrastructure
- **[Troubleshooting](troubleshooting.md)** : Solutions aux problèmes courants
- **[Glossaire](glossary.md)** : Définitions des termes techniques

---

## Technologies utilisées

- **Oracle Database Free 23c** : Base de données relationnelle
- **Docker** : Conteneurisation
- **Docker Compose** : Orchestration de conteneurs
- **Oracle SQL Developer** : Client SQL graphique

---

## Philosophie pédagogique

Ce guide privilégie :

- **L'apprentissage par la pratique** : chaque concept est appliqué immédiatement
- **La reproductibilité** : toutes les commandes sont copiables et testées
- **L'autonomie** : les erreurs courantes sont documentées
- **La progressivité** : chaque lab s'appuie sur le précédent

---

## Notes importantes

- Les **mots de passe** utilisés dans ce guide sont **à usage pédagogique uniquement**
- En environnement de production, utilisez des mots de passe sécurisés
- Les volumes Docker persistent les données : consultez le Lab 06 pour les supprimer

---

## Licence

Ce guide est fourni à des fins pédagogiques.

---

## Contribution

Vous avez trouvé une erreur ou souhaitez améliorer le guide ?  
N'hésitez pas à ouvrir une issue ou proposer une pull request.

---

**👉 Prêt à commencer ? Direction [prerequisites.md](prerequisites.md) !**
