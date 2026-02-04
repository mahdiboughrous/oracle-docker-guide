# Lab 04 : Installer et configurer SQL Developer

> **Durée estimée** : 20 minutes  
> **Niveau** : Débutant

---

## 🎯 Objectifs

À la fin de ce lab, vous aurez :

- ✅ Installé Oracle SQL Developer
- ✅ Créé une connexion à votre base Oracle
- ✅ Testé la connexion avec succès
- ✅ Exploré l'interface de SQL Developer
- ✅ Exécuté votre première requête SQL

---

## 📋 Prérequis

- Oracle démarré et fonctionnel (Lab 03)
- Conteneur `oracle-db` en état "healthy"

---

## 📥 Étape 1 : Télécharger SQL Developer

### 1.1 Accéder à la page de téléchargement

Rendez-vous sur :
[https://www.oracle.com/tools/downloads/sqldev-downloads.html](https://www.oracle.com/tools/downloads/sqldev-downloads.html)

### 1.2 Choisir la version pour votre OS

**Windows** :
- Téléchargez : **Windows 64-bit with JDK 11 included**
- Format : `.zip` (environ 400 Mo)

**macOS** :
- Téléchargez : **macOS** (version avec JDK)
- Format : `.dmg` ou `.app.zip`

**Linux** :
- Téléchargez: **Linux RPM** ou **Other Platforms** (avec JDK)
- Format : `.rpm` ou `.zip`

> 💡 **Conseil** : Privilégiez la version **avec JDK inclus** pour éviter les problèmes de compatibilité Java.

### 1.3 Accepter la licence

- Cochez "I reviewed and accept the Oracle License Agreement"
- Cliquez sur **Download**

> ℹ️ **Note** : Aucun compte Oracle n'est requis pour SQL Developer standalone.

---

## 🛠️ Étape 2 : Installer SQL Developer

### Windows

1. **Décompresser l'archive**
   - Faites un clic droit sur le fichier `.zip` téléchargé
   - Sélectionnez "Extraire tout..."
   - Choisissez un emplacement (ex : `C:\Tools\SQLDeveloper`)

2. **Lancer SQL Developer**
   - Ouvrez le dossier décompressé
   - Double-cliquez sur `sqldeveloper.exe`

3. **Premier lancement**
   - Une fenêtre "Import Preferences" peut apparaître
   - Cliquez sur **No** (première installation)

### macOS

1. **Ouvrir le fichier `.dmg`**
   - Double-cliquez sur le fichier téléchargé
   - Glissez l'icône **SQLDeveloper.app** dans **Applications**

2. **Lancer SQL Developer**
   - Allez dans Applications
   - Double-cliquez sur **SQLDeveloper**

3. **Autorisation Gatekeeper**
   - macOS peut bloquer l'application (première fois)
   - Faites un **clic droit** > **Ouvrir**
   - Confirmez "Ouvrir"

### Linux

**Méthode 1 : Archive ZIP**

```bash
# Décompresser
unzip sqldeveloper-*-no-jre.zip -d ~/

# Lancer
cd ~/sqldeveloper
./sqldeveloper.sh
```

**Méthode 2 : RPM (Fedora/RedHat/CentOS)**

```bash
sudo rpm -Uvh sqldeveloper-*.rpm
sqldeveloper
```

---

## 🔌 Étape 3 : Créer une connexion à Oracle

### 3.1 Ouvrir la fenêtre de connexion

1. Lancez SQL Developer
2. Dans le panneau de gauche, repérez **"Connections"**
3. Cliquez sur le bouton **"+"** (ou clic droit > New Connection)

Ou :
- Menu **File** > **New** > **Database Connection**

### 3.2 Remplir les paramètres de connexion

Une fenêtre "New / Select Database Connection" s'ouvre.

**Remplissez les champs suivants** :

| Champ | Valeur | Explication |
|-------|--------|-------------|
| **Connection Name** | `Oracle23c-FREEPDB1` | Nom affiché dans SQL Developer (arbitraire) |
| **Username** | `SYSTEM` | Utilisateur administrateur |
| **Password** | `OraclePass123` | Mot de passe défini dans docker-compose.yml |
| **Save Password** | ✅ Coché | Évite de retaper le mot de passe |
| **Hostname** | `localhost` | Votre machine (l'hôte Docker) |
| **Port** | `1521` | Port SQL*Net standard |
| **Service name** | `FREEPDB1` | ⚠️ **Important** : PDB, pas CDB |

**Capture d'écran de référence** :

```
┌────────────────────────────────────────────┐
│  New / Select Database Connection          │
├────────────────────────────────────────────┤
│ Name:        Oracle23c-FREEPDB1            │
│                                            │
│ Username:    SYSTEM                        │
│ Password:    ●●●●●●●●●●●●                  │
│ ☑ Save Password                            │
│                                            │
│ Connection Type:  Basic  ☑                 │
│                                            │
│ Hostname:    localhost                     │
│ Port:        1521                          │
│ Service name: FREEPDB1                     │
│                                            │
│ [Test]  [Save]  [Connect]  [Cancel]       │
└────────────────────────────────────────────┘
```

> ⚠️ **Erreur courante** : Ne cochez **PAS** "SID" mais bien **"Service name"** !

---

## ✅ Étape 4 : Tester la connexion

### 4.1 Cliquer sur "Test"

En bas à gauche de la fenêtre, cliquez sur le bouton **Test**.

### 4.2 Résultat attendu

En bas de la fenêtre, vous devriez voir :

```
Status: Success
```

✅ **Succès !** La connexion fonctionne.

### 4.3 Si échec

**Message d'erreur** :
```
Status: Failure - Test failed: IO Error: The Network Adapter could not establish the connection
```

**Causes possibles** :
1. ❌ Oracle n'est pas démarré
2. ❌ Le conteneur n'est pas "healthy"
3. ❌ Mauvais hostname, port ou service name
4. ❌ Pare-feu bloque le port 1521

**Solutions** :
1. Vérifiez que le conteneur est actif : `docker compose ps`
2. Vérifiez les logs : `docker compose logs`
3. Testez le port : `Test-NetConnection localhost -Port 1521` (Windows)
4. Vérifiez que le service name est bien `FREEPDB1`

---

## 🔗 Étape 5 : Sauvegarder et se connecter

### 5.1 Sauvegarder la connexion

Cliquez sur le bouton **Save** en bas de la fenêtre.

La connexion apparaît maintenant dans le panneau de gauche sous **Connections**.

### 5.2 Se connecter

**Option 1** : Depuis la fenêtre de configuration
- Cliquez sur **Connect**

**Option 2** : Depuis le panneau Connections
- Double-cliquez sur `Oracle23c-FREEPDB1`

**Option 3** : Clic droit
- Clic droit sur la connexion > **Connect**

### 5.3 Résultat

La connexion s'affiche avec une icône verte ✅ et développe l'arborescence :

```
Connections
 └─ Oracle23c-FREEPDB1 (SYSTEM) ✅
     ├─ Tables
     ├─ Views
     ├─ Indexes
     ├─ Procedures
     └─ ...
```

---

## 🖥️ Étape 6 : Explorer l'interface SQL Developer

### Panneau de gauche : Connections

- **Arborescence hiérarchique** des objets de base de données
- Développez **Tables** pour voir les tables existantes (vide pour l'instant)

### Panneau central : Worksheet (feuille de travail)

- **Zone de saisie SQL** : Écrivez vos requêtes ici
- **Barre d'outils** : Boutons pour exécuter les requêtes

### Panneau du bas : Results (résultats)

- **Script Output** : Résultats textuels
- **Query Result** : Résultats tabulaires

---

## 🧪 Étape 7 : Exécuter votre première requête

### 7.1 Ouvrir un Worksheet

Si le worksheet n'est pas ouvert :
- Clic droit sur votre connexion > **Open SQL Worksheet**

### 7.2 Taper une requête simple

Dans le worksheet, tapez :

```sql
SELECT 'Hello Oracle 23c!' AS message FROM dual;
```

**Explication** :
- `SELECT` : Interroge la base
- `FROM dual` : Table virtuelle Oracle (1 ligne, 1 colonne)
- `AS message` : Alias de colonne

### 7.3 Exécuter la requête

**Méthode 1** : Icône "Execute Statement"
- Cliquez sur l'icône ▶️ verte (ou `Ctrl + Enter`)

**Méthode 2** : Menu
- Menu **Run** > **Execute Statement**

### 7.4 Résultat attendu

Dans le panneau **Query Result** en bas :

```
MESSAGE
------------------
Hello Oracle 23c!
```

✅ **Félicitations !** Votre première requête Oracle !

---

## 📊 Étape 8 : Requêtes d'exploration

Essayez ces requêtes pour explorer votre environnement :

### Vérifier la version d'Oracle

```sql
SELECT banner FROM v$version;
```

**Résultat** :
```
BANNER
-----------------------------------------------------------------------
Oracle Database 23c Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
```

### Lister les PDBs

```sql
SELECT name, open_mode FROM v$pdbs;
```

**Résultat** :
```
NAME         OPEN_MODE
------------ ----------
PDB$SEED     READ ONLY
FREEPDB1     READ WRITE
```

### Voir l'utilisateur connecté

```sql
SELECT USER FROM dual;
```

**Résultat** :
```
USER
------
SYSTEM
```

### Lister les tablespaces

```sql
SELECT tablespace_name, status FROM dba_tablespaces;
```

**Résultat** :
```
TABLESPACE_NAME    STATUS
------------------ ------
SYSTEM             ONLINE
SYSAUX             ONLINE
UNDOTBS1           ONLINE
TEMP               ONLINE
USERS              ONLINE
```

---

## 🔑 Étape 9 : (Optionnel) Créer une connexion avec l'utilisateur applicatif

Rappelez-vous : dans `docker-compose.yml`, nous avons créé un utilisateur `appuser`.

### 9.1 Créer une nouvelle connexion

1. Cliquez sur **"+"** (New Connection)
2. Remplissez :

| Champ | Valeur |
|-------|--------|
| Connection Name | `Oracle23c-AppUser` |
| Username | `appuser` |
| Password | `AppUserPass123` |
| Hostname | `localhost` |
| Port | `1521` |
| Service name | `FREEPDB1` |

3. Cliquez sur **Test** → **Success**
4. Cliquez sur **Save** puis **Connect**

### 9.2 Tester avec appuser

Dans le worksheet de `appuser`, tapez :

```sql
SELECT USER FROM dual;
```

**Résultat** :
```
USER
--------
APPUSER
```

✅ Vous êtes bien connecté en tant qu'utilisateur applicatif.

---

## 📋 Récapitulatif des paramètres de connexion

| Paramètre | Valeur | Ne pas confondre |
|-----------|--------|------------------|
| Hostname | `localhost` | Pas `127.0.0.1` (fonctionne aussi) |
| Port | `1521` | Port par défaut Oracle |
| Service name | `FREEPDB1` | ⚠️ Pas `FREE` (CDB) |
| Username | `SYSTEM` ou `appuser` | Selon vos besoins |
| Password | `OraclePass123` ou `AppUserPass123` | Défini dans docker-compose.yml |

---

## ❓ Dépannage

### Problème : "ORA-12514: TNS:listener does not currently know of service requested in connect descriptor"

**Cause** : Mauvais service name.

**Solution** :
- Vérifiez que vous utilisez bien `FREEPDB1` (pas `FREE`)
- Vérifiez avec : `docker exec -it oracle-db lsnrctl status`

### Problème : "ORA-01017: invalid username/password; logon denied"

**Cause** : Mauvais mot de passe.

**Solution** :
- Vérifiez le mot de passe dans `docker-compose.yml`
- Par défaut : `OraclePass123`

### Problème : "IO Error: Got minus one from a read call"

**Cause** : Connexion interrompue.

**Solution** :
- Vérifiez que le conteneur est actif : `docker compose ps`
- Vérifiez que le statut est "(healthy)"

### Problème : SQL Developer ne démarre pas (Windows)

**Cause** : Java introuvable ou incompatible.

**Solution** :
- Téléchargez la version **avec JDK inclus**
- Ou installez Java 11+ : [Adoptium](https://adoptium.net/)

---

## ✅ Checklist de validation

Avant de passer au lab suivant, vérifiez :

- [ ] SQL Developer est installé et lancé
- [ ] La connexion à `FREEPDB1` avec `SYSTEM` fonctionne
- [ ] Le test de connexion affiche "Success"
- [ ] Vous avez exécuté une requête SQL avec succès
- [ ] Vous savez ouvrir un SQL Worksheet
- [ ] (Optionnel) La connexion avec `appuser` fonctionne

---

## 🎓 Ce que vous avez appris

- ✅ Installer et configurer SQL Developer
- ✅ Créer une connexion à Oracle Database
- ✅ Distinguer CDB (FREE) et PDB (FREEPDB1)
- ✅ Exécuter des requêtes SQL dans un worksheet
- ✅ Explorer les objets de base de données (tables, vues, etc.)
- ✅ Diagnostiquer les erreurs de connexion courantes

---

## 🔜 Prochaine étape

Vous êtes connecté ! Place à la pratique SQL.

**👉 [Lab 05 : Requêtes SQL de base](lab-05-basic-sql.md)**

---

## 📚 Pour aller plus loin

- [Oracle SQL Developer Documentation](https://docs.oracle.com/en/database/oracle/sql-developer/)
- [Oracle SQL Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/)
- [PL/SQL Getting Started](https://docs.oracle.com/en/database/oracle/oracle-database/23/lnpls/)
