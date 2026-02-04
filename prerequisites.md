# 📋 Prérequis techniques

Ce document détaille les prérequis nécessaires pour suivre ce guide pratique.

---

## 🖥️ Configuration matérielle minimale

| Ressource | Minimum | Recommandé |
|-----------|---------|------------|
| **RAM** | 8 Go | 16 Go |
| **Espace disque** | 15 Go disponibles | 30 Go |
| **Processeur** | Dual-core | Quad-core |
| **Système** | Windows 10/11, macOS 11+, Linux | - |

> ⚠️ **Attention** : Oracle Database nécessite beaucoup de ressources. Fermez les applications inutiles pendant les labs.

---

## 🐳 Docker Desktop

Docker Desktop est **obligatoire** pour ce guide.

### Installation selon votre système

#### Windows 10/11

1. Téléchargez Docker Desktop depuis [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Lancez l'installateur `Docker Desktop Installer.exe`
3. Suivez l'assistant d'installation
4. **Redémarrez votre ordinateur** après l'installation
5. Lancez Docker Desktop depuis le menu Démarrer
6. Attendez que Docker affiche "Docker Desktop is running"

**Configuration WSL2 (Windows)** :
- Docker Desktop utilise WSL2 (Windows Subsystem for Linux)
- Si demandé, installez la mise à jour WSL2 depuis le lien fourni
- Acceptez les paramètres par défaut

#### macOS

1. Téléchargez Docker Desktop depuis [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Ouvrez le fichier `.dmg` téléchargé
3. Glissez l'icône Docker dans Applications
4. Lancez Docker depuis Applications
5. Autorisez Docker à accéder au système (mot de passe requis)

**Architecture Apple Silicon (M1/M2/M3)** :
- Téléchargez la version "Apple Chip"
- La compatibilité x86 est gérée automatiquement

#### Linux (Ubuntu/Debian)

```bash
# Mise à jour du système
sudo apt update
sudo apt upgrade -y

# Installation des dépendances
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajout de la clé GPG Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajout du dépôt Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation de Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Ajouter votre utilisateur au groupe docker (évite sudo)
sudo usermod -aG docker $USER

# Redémarrer la session (ou redémarrer l'ordinateur)
newgrp docker
```

---

## ✅ Vérifier l'installation de Docker

Ouvrez un terminal et exécutez :

```bash
docker --version
```

**Résultat attendu** :
```
Docker version 24.0.x, build xxxxxxx
```

Vérifiez également Docker Compose :

```bash
docker compose version
```

**Résultat attendu** :
```
Docker Compose version v2.x.x
```

> 📌 **Note** : Nous utilisons `docker compose` (avec un espace), pas `docker-compose` (ancien format).

---

## 🛠️ Client SQL : Oracle SQL Developer

Oracle SQL Developer est le client graphique recommandé pour se connecter à Oracle Database.

### Téléchargement

1. Rendez-vous sur [oracle.com/tools/downloads/sqldev-downloads.html](https://www.oracle.com/tools/downloads/sqldev-downloads.html)
2. Téléchargez la version correspondant à votre OS
3. **Aucun compte Oracle n'est requis** pour la version standalone

### Installation

#### Windows
1. Téléchargez le fichier `.zip` (version "Windows 64-bit with JDK included")
2. Décompressez l'archive
3. Lancez `sqldeveloper.exe` depuis le dossier décompressé

#### macOS
1. Téléchargez le fichier `.dmg`
2. Ouvrez le `.dmg` et glissez SQLDeveloper dans Applications
3. Au premier lancement, faites un clic droit → Ouvrir (contournement de Gatekeeper)

#### Linux
1. Téléchargez l'archive `.zip` (avec JDK inclus)
2. Décompressez dans votre dossier personnel
```bash
unzip sqldeveloper-*-no-jre.zip -d ~/
cd ~/sqldeveloper
./sqldeveloper.sh
```

### Alternative : DBeaver (optionnel)

Si vous préférez un client multi-bases de données :
- Téléchargez [DBeaver Community](https://dbeaver.io/download/)
- Compatible avec Oracle (driver JDBC inclus)

---

## 🌐 Connexion Internet

Une connexion Internet est nécessaire pour :

- Télécharger l'image Docker Oracle (environ **2,5 Go**)
- Télécharger les dépendances lors du premier démarrage

> 💡 **Conseil** : Utilisez une connexion filaire ou WiFi stable. Le téléchargement initial peut prendre 10-30 minutes selon votre débit.

---

## 📝 Éditeur de texte

Vous aurez besoin d'un éditeur pour consulter/modifier les fichiers SQL et YAML.

**Recommandé** :
- [Visual Studio Code](https://code.visualstudio.com/) (gratuit, multiplateforme)
- Notepad++ (Windows)
- Sublime Text

**Extensions VS Code utiles (optionnel)** :
- Docker (Microsoft)
- YAML (Red Hat)
- SQL Formatter

---

## 🧪 Connaissances de base requises

### Terminal / Ligne de commande

Vous devez savoir :
- Ouvrir un terminal (PowerShell, Bash, Terminal)
- Naviguer entre dossiers avec `cd`
- Lister les fichiers avec `ls` (Unix/macOS) ou `dir` (Windows)

### SQL (niveau débutant)

Des bases en SQL sont utiles mais pas obligatoires :
- `SELECT`, `INSERT`, `CREATE TABLE`
- Le guide explique chaque requête

### Docker (notion de base)

Pas besoin d'être expert, mais il est utile de connaître :
- Qu'est-ce qu'un conteneur (expliqué dans Lab 00)
- Qu'est-ce qu'une image Docker (expliqué dans Lab 00)

---

## 🔍 Tester votre environnement (optionnel)

Avant de commencer les labs, testez Docker avec cette commande simple :

```bash
docker run hello-world
```

**Résultat attendu** :
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
[...]
```

Si cette commande fonctionne, vous êtes prêt à continuer.

---

## ❌ Que faire si quelque chose ne fonctionne pas ?

- **Docker ne démarre pas** : vérifiez les paramètres de virtualisation dans le BIOS
- **Erreur WSL2 (Windows)** : installez la mise à jour WSL2 kernel depuis [aka.ms/wsl2kernel](https://aka.ms/wsl2kernel)
- **Pas assez de RAM** : fermez les applications gourmandes (navigateurs, IDE)
- **Problème de connexion** : vérifiez votre pare-feu et proxy

👉 Consultez [troubleshooting.md](troubleshooting.md) pour plus de détails.

---

## ✅ Checklist finale

Avant de passer au Lab 00, vérifiez :

- [ ] Docker Desktop est installé et lancé
- [ ] `docker --version` fonctionne
- [ ] `docker compose version` fonctionne
- [ ] Au moins 8 Go de RAM disponible
- [ ] Au moins 15 Go d'espace disque
- [ ] SQL Developer téléchargé (installation dans Lab 04)
- [ ] Connexion Internet stable

---

**👉 Tout est prêt ? Direction [architecture.md](architecture.md) pour comprendre l'architecture !**
