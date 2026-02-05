# Lab 01 : Vérifier votre installation Docker

## Objectifs

À la fin de ce lab, vous aurez :

- Vérifié que Docker Desktop est installé et fonctionne
- Testé la commande `docker`
- Testé la commande `docker compose`
- Compris la différence entre `docker` et `docker compose`

---

## Prérequis

- Docker Desktop installé (voir [prerequisites.md](../prerequisites.md))
- Docker Desktop en cours d'exécution

---

## Étape 1 : Vérifier que Docker Desktop est lancé

### Windows

1. Cherchez **Docker Desktop** dans le menu Démarrer
2. Lancez l'application
3. Attendez que l'icône Docker dans la barre des tâches affiche "Docker Desktop is running"

**Indicateur visuel** :

- ✅ Icône baleine verte = Docker fonctionne
- ❌ Icône baleine rouge/grise = Docker en cours de démarrage ou arrêté

### macOS

1. Ouvrez **Applications**
2. Lancez **Docker**
3. Attendez que l'icône baleine dans la barre de menus affiche "Docker Desktop is running"

### Linux

Docker démarre automatiquement comme service système. Vérifiez son état :

```bash
sudo systemctl status docker
```

**Résultat attendu** :

```
● docker.service - Docker Application Container Engine
   Loaded: loaded
   Active: active (running)
```

---

## Étape 2 : Tester la commande `docker`

Ouvrez un terminal :

- **Windows** : PowerShell (clic droit sur Démarrer > Windows PowerShell)
- **macOS** : Terminal (Applications > Utilitaires > Terminal)
- **Linux** : Terminal (Ctrl+Alt+T)

### Test 1 : Vérifier la version de Docker

```bash
docker --version
```

**Résultat attendu** :

```
Docker version 28.4.0, build d8eb465
```

> 💡 **Note** : Le numéro de version peut varier (24.x, 25.x, etc.). L'important est que la commande fonctionne.

### Test 2 : Afficher les informations système

```bash
docker info
```

**Résultat attendu** (extrait) :

```
Client:
 Version:    28.4.0
 Context:    desktop-linux
 Debug Mode: false
 Plugins:
  ...

Server:
 Containers: 6
  Running: 4
  Paused: 0
  Stopped: 2
 Images: 9
 Server Version: 28.4.0
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Discovered Devices:
  cdi: docker.com/gpu=webgpu
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 nvidia runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 05044ec0a9a75232cad458027ca83437aae3f4da
 runc version: v1.2.5-0-g59923ef
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.6.87.2-microsoft-standard-WSL2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 16
 Total Memory: 15.23GiB
 Name: docker-desktop
 ID: 2f3ca315-5e70-40d1-91de-127f1ebf134a
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: http.docker.internal:3128
 HTTPS Proxy: http.docker.internal:3128
 No Proxy: hubproxy.docker.internal
 Labels:
  com.docker.desktop.address=npipe://\\.\pipe\docker_cli
 Experimental: false
 Insecure Registries:
  hubproxy.docker.internal:5555
  ::1/128
  127.0.0.0/8
 Live Restore Enabled: false
```

✅ Si cette commande fonctionne, Docker est correctement installé.

> **À noter pour la suite**
> Dans Docker Desktop, vérifiez les paramètres de ressources allouées (Settings > Resources).
> Oracle nécessite une configuration mémoire spécifique pour fonctionner correctement.
> Observez la quantité de RAM actuellement allouée à Docker sur votre système.

---

## Étape 3 : Tester Docker Compose

### Test 1 : Vérifier la version de Compose

```bash
docker compose version
```

**Résultat attendu** :

```
Docker Compose version v2.39.4-desktop.1
```

> ⚠️ **Important** : Notez bien `docker compose` (avec un **espace**), pas `docker-compose` (ancien format).

### Test 2 : Afficher l'aide de Compose

```bash
docker compose --help
```

**Résultat attendu** :

```
Usage:  docker compose [OPTIONS] COMMAND

Define and run multi-container applications with Docker.

Options:
      --ansi string                ...
      --compatibility              ...
[...]

Commands:
  build       Build or rebuild services
  create      Creates containers for a service
  down        Stop and remove containers, networks
  up          Create and start containers
[...]
```

✅ Si vous voyez cette aide, Docker Compose est fonctionnel.

---

## Étape 4 : Test rapide avec un conteneur simple

Testons Docker avec un conteneur de test officiel.

### Commande

```bash
docker run hello-world
```

### Ce qui se passe en arrière-plan

```
1. Docker cherche l'image "hello-world" localement
2. Image absente → téléchargement depuis Docker Hub
3. Création d'un conteneur depuis cette image
4. Exécution du conteneur
5. Affichage du message
6. Arrêt automatique du conteneur
```

### Résultat attendu

```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
[...]
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

[...]
```

✅ **Succès !** Docker fonctionne correctement.

---

## Étape 5 : Vérifier les images et conteneurs

### Lister les images téléchargées

```bash
docker images
```

**Résultat attendu** :

```
REPOSITORY      TAG       IMAGE ID       CREATED        SIZE
hello-world     latest    9c7a54a9a43c   3 months ago   13.3kB
```

### Lister tous les conteneurs (y compris arrêtés)

```bash
docker ps -a
```

**Résultat attendu** :

```
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
abc123def456   hello-world   "/hello"   2 minutes ago    Exited (0) 2 minutes ago              quirky_name
```

> 💡 **Note** : Le conteneur `hello-world` s'arrête automatiquement après avoir affiché son message.

---

## Étape 6 : Nettoyer le conteneur de test

Pour éviter d'accumuler des conteneurs inutilisés :

```bash
docker rm $(docker ps -aq)
```

**Explication** :

- `docker ps -aq` : liste tous les IDs de conteneurs (arrêtés ou non)
- `docker rm` : supprime les conteneurs

**Alternative Windows PowerShell** :

```powershell
docker ps -aq | ForEach-Object { docker rm $_ }
```

Vous pouvez aussi supprimer l'image `hello-world` (optionnel) :

```bash
docker rmi hello-world
```

---

##  Récapitulatif des commandes essentielles

| Commande                   | Description                                    |
| -------------------------- | ---------------------------------------------- |
| `docker --version`       | Affiche la version de Docker                   |
| `docker info`            | Informations détaillées sur Docker           |
| `docker compose version` | Affiche la version de Compose                  |
| `docker images`          | Liste les images téléchargées               |
| `docker ps`              | Liste les conteneurs actifs                    |
| `docker ps -a`           | Liste tous les conteneurs (actifs + arrêtés) |
| `docker run <image>`     | Crée et démarre un conteneur                 |
| `docker rm <id>`         | Supprime un conteneur                          |
| `docker rmi <image>`     | Supprime une image                             |

---

##  Dépannage

### Problème : "docker: command not found"

**Cause** : Docker n'est pas installé ou pas dans le PATH.

**Solution** :

1. Vérifiez que Docker Desktop est bien installé
2. Redémarrez votre terminal
3. Sur Linux : vérifiez que le service Docker est actif (`sudo systemctl start docker`)

### Problème : "Cannot connect to the Docker daemon"

**Cause** : Docker Desktop n'est pas lancé.

**Solution** :

1. Lancez Docker Desktop
2. Attendez que l'icône baleine soit verte
3. Réessayez la commande

### Problème : "permission denied" (Linux)

**Cause** : Votre utilisateur n'est pas dans le groupe `docker`.

**Solution** :

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Puis relancez votre terminal.

### Problème : Docker très lent (Windows/macOS)

**Cause** : Pas assez de ressources allouées à Docker.

**Solution** :

1. Ouvrez Docker Desktop > Settings > Resources
2. Augmentez la RAM (minimum 4 Go, recommandé 8 Go)
3. Augmentez les CPUs (minimum 2)
4. Cliquez sur "Apply & Restart"

---

## ✅ Checklist de validation

Avant de passer au lab suivant, vérifiez :

- [ ] `docker --version` fonctionne
- [ ] `docker compose version` fonctionne
- [ ] `docker run hello-world` a réussi
- [ ] Vous avez compris la différence entre `docker` et `docker compose`
- [ ] Docker Desktop affiche "running" dans la barre des tâches

---

##  Ce que vous avez appris

- ✅ Docker et Docker Compose sont deux outils distincts
- ✅ `docker` gère les conteneurs et images individuellement
- ✅ `docker compose` gère des ensembles de conteneurs via un fichier YAML
- ✅ Les commandes de base pour vérifier, lister et nettoyer

---

##  Prochaine étape

Votre environnement Docker est prêt !

** [Lab 02 : Configurer Docker Compose pour Oracle](lab-02-oracle-compose.md)**

---

##  Pour aller plus loin

- [Documentation Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)
- [Docker Desktop Overview](https://docs.docker.com/desktop/)
