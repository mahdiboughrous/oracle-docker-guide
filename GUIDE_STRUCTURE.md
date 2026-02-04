# 📋 Structure du guide pédagogique Oracle Database 23c

Ce document récapitule l'organisation complète du guide.

---

## 📂 Structure des fichiers

```
tp-oracle/
│
├── README.md                    # Point d'entrée principal
├── prerequisites.md             # Prérequis techniques et installation
├── architecture.md              # Schémas et explications de l'infrastructure
├── troubleshooting.md           # Résolution de problèmes
├── glossary.md                  # Définitions des termes techniques
│
├── docker/
│   └── docker-compose.yml       # Configuration Docker Compose
│
├── labs/                        # Labs progressifs
│   ├── lab-00-introduction.md   # Concepts de base (Docker, CDB/PDB)
│   ├── lab-01-docker-setup.md   # Vérification de Docker
│   ├── lab-02-oracle-compose.md # Configuration Compose
│   ├── lab-03-running-oracle.md # Démarrage d'Oracle
│   ├── lab-04-sql-client.md     # Installation SQL Developer
│   ├── lab-05-basic-sql.md      # Requêtes SQL (CRUD, JOIN)
│   └── lab-06-cleanup-reset.md  # Nettoyage et réinitialisation
│
├── sql/                         # Scripts SQL réutilisables
│   ├── 01_users.sql             # Création d'utilisateurs
│   ├── 02_schema.sql            # Création des tables
│   └── 03_sample_data.sql       # Données de test
│
└── images/                      # Images pour la documentation
    ├── architecture/
    ├── icons/
    └── labs/
```

---

## 🎯 Parcours pédagogique

### Étape 1 : Préparation (15-30 min)
1. [README.md](README.md) - Présentation du guide
2. [prerequisites.md](prerequisites.md) - Installation Docker Desktop
3. [architecture.md](architecture.md) - Comprendre l'infrastructure

### Étape 2 : Labs pratiques (3-4 heures)

| Lab | Fichier | Durée | Objectif |
|-----|---------|-------|----------|
| Lab 00 | [lab-00-introduction.md](labs/lab-00-introduction.md) | 15 min | Concepts Docker et Oracle |
| Lab 01 | [lab-01-docker-setup.md](labs/lab-01-docker-setup.md) | 10 min | Vérifier Docker |
| Lab 02 | [lab-02-oracle-compose.md](labs/lab-02-oracle-compose.md) | 15 min | Comprendre docker-compose.yml |
| Lab 03 | [lab-03-running-oracle.md](labs/lab-03-running-oracle.md) | 30 min | Démarrer Oracle (1er lancement) |
| Lab 04 | [lab-04-sql-client.md](labs/lab-04-sql-client.md) | 20 min | Se connecter avec SQL Developer |
| Lab 05 | [lab-05-basic-sql.md](labs/lab-05-basic-sql.md) | 40 min | Créer tables, requêtes SQL |
| Lab 06 | [lab-06-cleanup-reset.md](labs/lab-06-cleanup-reset.md) | 10 min | Gérer l'environnement |

### Étape 3 : Ressources complémentaires

- [troubleshooting.md](troubleshooting.md) - En cas de problème
- [glossary.md](glossary.md) - Définitions des termes

---

## 🎓 Utilisation pédagogique

### En cours magistral
- Présenter [architecture.md](architecture.md) avec un projecteur
- Expliquer les concepts Docker et Oracle (Lab 00)
- Démonstration en direct du Lab 03 (démarrage)

### En TP (3-4 heures)
- Les étudiants suivent les labs dans l'ordre (00 → 06)
- Chaque lab est autonome avec objectifs, étapes, validation
- Formateur disponible pour dépannage ([troubleshooting.md](troubleshooting.md))

### En autonomie
- Guide auto-suffisant : README → prerequisites → labs
- Scripts SQL fournis pour réinitialisation rapide
- Glossaire pour clarifier les termes techniques

---

## 📄 Export en PDF

Pour générer un PDF unique :

### Avec Pandoc (recommandé)

```bash
pandoc README.md prerequisites.md architecture.md \
       labs/lab-*.md \
       troubleshooting.md glossary.md \
       -o guide_oracle_23c.pdf \
       --toc \
       --toc-depth=2 \
       -V geometry:margin=2cm
```

### Avec Markdown to PDF (VS Code)

1. Installer l'extension "Markdown PDF"
2. Concaténer les fichiers dans un seul Markdown
3. Clic droit → "Markdown PDF: Export (pdf)"

---

## 🔄 Maintenance du guide

### Mise à jour de la version Oracle

1. Modifier [docker/docker-compose.yml](docker/docker-compose.yml) :
   ```yaml
   image: gvenzl/oracle-free:23.5-slim  # Nouvelle version
   ```

2. Mettre à jour les références dans :
   - [README.md](README.md)
   - [architecture.md](architecture.md)
   - Labs concernés

### Ajout d'un lab supplémentaire

1. Créer `labs/lab-07-nouveau-sujet.md`
2. Suivre le template des labs existants :
   - Objectifs
   - Prérequis
   - Étapes numérotées
   - Checklist de validation
   - Lien vers lab suivant

3. Mettre à jour [README.md](README.md) (tableau des labs)

### Ajout de scripts SQL

1. Créer `sql/04_nouveau_script.sql`
2. Documenter dans [lab-05-basic-sql.md](labs/lab-05-basic-sql.md)

---

## ✅ Checklist de cohérence

Avant de publier une nouvelle version :

- [ ] Tous les liens internes fonctionnent
- [ ] Les numéros de versions sont cohérents (Oracle, Docker)
- [ ] Les mots de passe sont identiques partout (docker-compose.yml, labs)
- [ ] Les chemins de fichiers sont corrects
- [ ] Les commandes sont testées sur Windows, macOS et Linux
- [ ] Le glossaire est à jour
- [ ] Le troubleshooting couvre les erreurs courantes

---

## 📊 Statistiques

- **Nombre de labs** : 7
- **Nombre de scripts SQL** : 3
- **Durée totale estimée** : 3-4 heures
- **Niveau** : Licence / Master / École d'ingénieurs
- **Prérequis** : Bases en terminal, aucune connaissance Oracle requise

---

## 🤝 Contribution

Pour améliorer le guide :

1. Fork le dépôt
2. Créez une branche : `git checkout -b amelioration-labXX`
3. Modifiez les fichiers
4. Testez les changements
5. Commit : `git commit -m "Amélioration Lab XX : ..."`
6. Push : `git push origin amelioration-labXX`
7. Ouvrez une Pull Request

---

**Guide créé avec ❤️ pour l'apprentissage d'Oracle Database avec Docker**
