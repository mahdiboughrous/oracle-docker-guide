# Compte Rendu - TP Oracle avec Docker

## Objectif du compte rendu

Ce compte rendu a pour objectif de vérifier que vous avez :

- réellement exécuté le TP
- compris le fonctionnement d'Oracle avec Docker
- été capable d'analyser ce qui s'est passé sur votre machine

### Attention

Un compte rendu basé uniquement sur le guide, sur des réponses génériques ou générées par IA sans exécution réelle sera facilement détectable et ne sera pas validé.

## Utilisation des outils d'IA

Vous êtes autorisé à utiliser des outils d'IA pour :

- reformuler vos phrases
- améliorer la clarté
- corriger l'orthographe

**Mais :**

- L'IA ne peut pas exécuter le TP à votre place.
- Vous êtes évalué sur ce que vous avez fait et observé.

## Format attendu

- **Document PDF**
- **4 à 6 pages maximum**
- Texte clair, concis, structuré
- **Captures d'écran obligatoires**
- Chaque capture doit être commentée

---

## Structure obligatoire du compte rendu

### 1. Environnement de travail

Indiquez précisément :

- Système d'exploitation (Windows / macOS / Linux)
- Version de Docker Desktop
- Quantité de RAM allouée à Docker

**Capture attendue :**

- Paramètres Docker (mémoire)

**Question à traiter :**

- Pourquoi Oracle nécessite-t-il une quantité de mémoire minimale ?

---

### 2. Lancement d'Oracle avec Docker Compose

**Captures attendues :**

- Commande `docker compose up`
- Extrait des logs montrant que la base est prête

**Questions obligatoires :**

- Quel message exact dans les logs indique que la base Oracle est opérationnelle ?
- Combien de temps a duré le premier démarrage sur votre machine ?
- Pourquoi ce premier démarrage est-il plus long que les suivants ?

---

### 3. Persistance des données (volume Docker)

**Captures attendues :**

- Volume Docker créé
- Redémarrage du conteneur
- Données toujours présentes après redémarrage

**Questions obligatoires :**

- Quel est le rôle du volume Docker dans ce TP ?
- Que se passerait-il si vous exécutiez `docker compose down -v` ?
- Pourquoi la persistance est-elle critique pour une base de données ?

---

### 4. Connexion à Oracle avec SQL Developer

**Captures attendues :**

- Configuration de la connexion SQL Developer
- Exécution de la requête `SELECT 1 FROM dual`

**Questions obligatoires :**

- Quel service name avez-vous utilisé ?
- Quelle est la différence entre SID et Service Name ?
- Quelle erreur avez-vous rencontrée (ou auriez pu rencontrer) lors de la connexion ?

---

### 5. Manipulation SQL minimale

**Captures attendues :**

- Création d'un utilisateur ou d'une table
- Résultat d'un SELECT

**Questions obligatoires :**

- Où sont stockées physiquement les données que vous avez créées ?
- Ces données survivront-elles à un redémarrage du conteneur ? Pourquoi ?

---

### 6. Problèmes rencontrés (obligatoire)

Même si tout a fonctionné, indiquez :

- au moins une difficulté
- ou une erreur mineure
- ou un point qui vous a posé question

**Questions :**

- Quel était le problème ?
- Comment l'avez-vous résolu ?
- Qu'avez-vous appris à ce moment-là ?

**Attention :** Un TP "sans aucun problème" est extrêmement rare.

---

### 7. Conclusion personnelle

En 5 à 8 lignes maximum :

- Ce que vous avez réellement compris
- Ce que vous seriez capable de refaire seul
- Ce qui reste flou

**Cette partie doit être personnelle.**

---

## Ce qui entraînera une pénalisation

- Texte copié intégralement du guide
- Réponses génériques non liées à votre exécution
- Captures d'écran non commentées
- Incohérences entre captures et explications
- Réponses "parfaites" mais déconnectées de la réalité du TP

---

## Critères d'évaluation (résumé)

| Critère | Évalué |
|---------|--------|
| Exécution réelle du TP | Oui |
| Compréhension des volumes | Oui |
| Connexion Oracle fonctionnelle | Oui |
| Cohérence captures ↔ explications | Oui |
| Capacité à expliquer | Oui |

---

## Règle finale à retenir

**Vous pouvez vous faire aider pour écrire, mais vous ne pouvez pas inventer ce que vous n'avez pas fait.**
