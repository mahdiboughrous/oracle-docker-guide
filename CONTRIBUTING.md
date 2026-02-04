# 🤝 Guide de contribution

Merci de votre intérêt pour améliorer ce guide pédagogique !

---

## 🎯 Types de contributions acceptées

- ✅ Correction de fautes (orthographe, grammaire)
- ✅ Amélioration des explications
- ✅ Ajout de captures d'écran
- ✅ Nouveaux labs ou exercices
- ✅ Mise à jour des versions (Oracle, Docker)
- ✅ Ajout de cas d'erreurs dans troubleshooting.md
- ✅ Traductions (si pertinent)

---

## 📝 Règles de style

### Markdown

- Utiliser des titres hiérarchisés (`#`, `##`, `###`)
- Ajouter des emojis pour améliorer la lisibilité (🎯, ✅, ❌, etc.)
- Inclure des blocs de code avec le langage spécifié :
  ````markdown
  ```sql
  SELECT * FROM etudiants;
  ```
  ````

### Ton et langage

- **Français professionnel** mais accessible
- **Tutoiement** (`vous`) pour rester cohérent avec le reste du guide
- Expliquer les termes techniques lors de leur première utilisation
- Éviter le jargon inutile

### Structure des labs

Chaque lab doit contenir :

1. **En-tête** : Durée estimée et niveau
2. **Objectifs** : Liste claire avec ✅
3. **Prérequis** : Ce qui doit être fait avant
4. **Étapes numérotées** : Instructions claires et reproductibles
5. **Dépannage** (si applicable)
6. **Checklist de validation**
7. **Ce que vous avez appris**
8. **Lien vers le lab suivant**

---

## 🔄 Processus de contribution

### 1. Fork et clone

```bash
# Fork sur GitHub, puis :
git clone https://github.com/VOTRE_USERNAME/oracle-docker-guide.git
cd oracle-docker-guide
```

### 2. Créer une branche

```bash
git checkout -b amelioration-description
```

**Nommage des branches** :
- `fix/typo-lab03` : Correction de faute
- `feature/lab07-plsql` : Nouveau lab
- `docs/update-version` : Mise à jour doc
- `troubleshooting/wsl2-error` : Ajout d'erreur

### 3. Faire vos modifications

- Éditez les fichiers concernés
- Testez vos changements (commandes, scripts SQL)
- Vérifiez les liens internes

### 4. Tester vos changements

**Pour les modifications de labs** :
- Suivez vous-même le lab modifié de bout en bout
- Vérifiez sur Windows **ET** Linux/macOS si possible

**Pour les scripts SQL** :
- Exécutez-les dans un environnement propre :
  ```bash
  docker compose down -v
  docker compose up -d
  # Attendre que Oracle soit prêt
  docker exec -i oracle-db sqlplus etudiant/Etudiant2024!@FREEPDB1 @/chemin/script.sql
  ```

### 5. Commit avec message clair

```bash
git add .
git commit -m "Fix: Correction faute de frappe dans lab-03"
```

**Format des messages de commit** :
- `Fix: ...` : Correction de bug ou faute
- `Feat: ...` : Nouvelle fonctionnalité (lab, script)
- `Docs: ...` : Amélioration documentation
- `Chore: ...` : Maintenance (version, dépendances)

### 6. Push et Pull Request

```bash
git push origin amelioration-description
```

Puis ouvrez une Pull Request sur GitHub avec :
- **Titre clair** : "Amélioration du Lab 03 : ajout de captures d'écran"
- **Description** : Ce qui a été changé et pourquoi
- **Tests effectués** : OS testé, versions utilisées

---

## 🧪 Checklist avant Pull Request

- [ ] Les modifications sont testées localement
- [ ] Aucune erreur de syntaxe Markdown
- [ ] Les liens internes fonctionnent
- [ ] Le style est cohérent avec le reste du guide
- [ ] Les commandes copiables sont validées
- [ ] Pas de mots de passe en clair (sauf pédagogiques)
- [ ] Le glossaire est mis à jour si nouveaux termes

---

## 🚫 Ce qui n'est PAS accepté

- ❌ Modifications de fond sans discussion préalable
- ❌ Changement de philosophie pédagogique (tutoiement → vouvoiement)
- ❌ Ajout de dépendances externes non justifiées
- ❌ Code non testé
- ❌ Contenu non lié à Oracle Database ou Docker

---

## 📄 Licence

En contribuant, vous acceptez que vos modifications soient publiées sous la même licence que le projet original.

---

## 💬 Questions ?

- Ouvrez une **Issue** sur GitHub pour discuter avant de contribuer
- Décrivez clairement le problème ou l'amélioration envisagée

---

**Merci de contribuer à l'amélioration de ce guide pédagogique ! 🙏**
