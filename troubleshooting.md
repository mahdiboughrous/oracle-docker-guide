# Dépannage et résolution de problèmes

Ce document recense les erreurs courantes et leurs solutions.

---

## Catégories

- [Docker et installation](#docker-et-installation)
- [Démarrage d'Oracle](#démarrage-doracle)
- [Connexion SQL](#connexion-sql)
- [Performances](#performances)
- [Volumes et données](#volumes-et-données)
- [Autres problèmes](#autres-problèmes)

---

## Docker et installation

### "docker: command not found"

**Symptôme** :
```bash
$ docker --version
bash: docker: command not found
```

**Cause** : Docker n'est pas installé ou pas dans le PATH.

**Solutions** :

1. **Windows** :
   - Vérifiez que Docker Desktop est installé
   - Redémarrez votre terminal (PowerShell)
   - Relancez Docker Desktop

2. **macOS** :
   - Installez Docker Desktop depuis [docker.com](https://www.docker.com/products/docker-desktop)
   - Ajoutez Docker au PATH si nécessaire

3. **Linux** :
   ```bash
   # Vérifier si Docker est installé
   sudo systemctl status docker
   
   # Si absent, installer
   sudo apt update
   sudo apt install docker.io docker-compose
   
   # Ajouter votre utilisateur au groupe docker
   sudo usermod -aG docker $USER
   newgrp docker
   ```

---

### "Cannot connect to the Docker daemon"

**Symptôme** :
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock.
Is the docker daemon running?
```

**Cause** : Docker Desktop n'est pas lancé.

**Solutions** :

- **Windows/macOS** : Lancez Docker Desktop et attendez que l'icône baleine soit verte
- **Linux** :
  ```bash
  sudo systemctl start docker
  sudo systemctl enable docker  # Démarrage automatique au boot
  ```

---

### "permission denied" (Linux)

**Symptôme** :
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Cause** : L'utilisateur n'est pas dans le groupe `docker`.

**Solution** :
```bash
sudo usermod -aG docker $USER
newgrp docker
# Ou redémarrer la session
```

---

### Docker très lent sur Windows

**Symptôme** : Démarrage/arrêt extrêmement lent, machine qui rame.

**Cause** : WSL2 mal configuré ou pas assez de ressources.

**Solutions** :

1. **Augmenter les ressources** :
   - Docker Desktop > Settings > Resources
   - Augmenter RAM (min 4 Go, idéal 8 Go)
   - Augmenter CPUs (min 2)

2. **Limiter la RAM de WSL2** :
   Créez `C:\Users\VOTRE_NOM\.wslconfig` :
   ```ini
   [wsl2]
   memory=4GB
   processors=2
   ```
   Puis redémarrez WSL :
   ```powershell
   wsl --shutdown
   ```

---

## Démarrage d'Oracle

### "pull access denied" ou "unauthorized"

**Symptôme** :
```
Error response from daemon: pull access denied for gvenzl/oracle-free
```

**Cause** : Connexion Internet défaillante ou image introuvable.

**Solutions** :

1. Vérifiez votre connexion Internet
2. Vérifiez l'orthographe de l'image dans `docker-compose.yml` :
   ```yaml
   image: gvenzl/oracle-free:23.4-slim
   ```
3. Essayez de télécharger manuellement :
   ```bash
   docker pull gvenzl/oracle-free:23.4-slim
   ```

---

### ❌ Le conteneur redémarre en boucle

**Symptôme** :
```bash
$ docker ps
CONTAINER ID   STATUS
abc123def456   Restarting (1) 10 seconds ago
```

**Cause** : Pas assez de RAM ou erreur de configuration.

**Diagnostic** :
```bash
docker compose logs
```

**Solutions** :

1. **Augmenter la RAM** :
   - Docker Desktop > Settings > Resources > Memory : 4 Go minimum

2. **Vérifier les logs** :
   ```bash
   docker compose logs | grep -i error
   ```

3. **Vérifier la configuration** :
   ```bash
   docker compose config
   ```

---

### ❌ "DATABASE IS READY" n'apparaît jamais

**Symptôme** : L'initialisation prend plus de 20 minutes sans message de fin.

**Cause** : Processeur trop lent, pas assez de RAM, ou erreur silencieuse.

**Solutions** :

1. **Patience** : Sur machine lente, cela peut prendre jusqu'à 30 minutes
2. **Vérifier les logs** :
   ```bash
   docker compose logs -f
   ```
3. **Redémarrer proprement** :
   ```bash
   docker compose down -v
   docker compose up -d
   ```

---

### ❌ Port 1521 déjà utilisé

**Symptôme** :
```
Error starting userland proxy: listen tcp4 0.0.0.0:1521: bind: address already in use
```

**Cause** : Une autre application utilise le port 1521 (Oracle local, autre conteneur).

**Solutions** :

1. **Identifier le processus** :
   
   **Windows (PowerShell)** :
   ```powershell
   Get-NetTCPConnection -LocalPort 1521
   ```
   
   **Linux/macOS** :
   ```bash
   sudo lsof -i :1521
   ```

2. **Changer le port dans `docker-compose.yml`** :
   ```yaml
   ports:
     - "1522:1521"  # Utiliser 1522 au lieu de 1521
   ```
   
   Puis connectez-vous avec le port 1522.

---

## 🔌 Connexion SQL

### ❌ "ORA-12514: TNS:listener does not currently know of service"

**Symptôme** : Impossible de se connecter depuis SQL Developer.

**Cause** : Mauvais service name ou Oracle pas complètement démarré.

**Solutions** :

1. **Vérifier le service name** : Utilisez `FREEPDB1` (pas `FREE`)

2. **Vérifier que Oracle est prêt** :
   ```bash
   docker exec -it oracle-db lsnrctl status
   ```
   
   Cherchez :
   ```
   Service "FREEPDB1" has 1 instance(s).
   ```

3. **Attendre quelques minutes** : Le listener peut mettre 2-3 minutes à se synchroniser.

---

### ❌ "ORA-01017: invalid username/password"

**Symptôme** : Erreur d'authentification.

**Cause** : Mauvais utilisateur ou mot de passe.

**Solutions** :

1. **Vérifier le mot de passe dans `docker-compose.yml`** :
   ```yaml
   environment:
     ORACLE_PASSWORD: OraclePass123
   ```

2. **Utiliser le bon utilisateur** :
   - `SYSTEM` / `OraclePass123`
   - `SYS` / `OraclePass123` (avec rôle SYSDBA)
   - `appuser` / `AppUserPass123`

3. **Réinitialiser le mot de passe** (si modifié) :
   ```bash
   docker exec -it oracle-db sqlplus sys/OraclePass123@FREEPDB1 as sysdba
   ```
   ```sql
   ALTER USER system IDENTIFIED BY NouveauMotDePasse;
   ```

---

### ❌ "IO Error: The Network Adapter could not establish the connection"

**Symptôme** : Erreur réseau dans SQL Developer.

**Cause** : Conteneur arrêté, port bloqué, ou mauvais hostname.

**Solutions** :

1. **Vérifier que le conteneur est actif** :
   ```bash
   docker compose ps
   ```
   Statut attendu : `Up X minutes (healthy)`

2. **Tester la connectivité réseau** :
   
   **Windows (PowerShell)** :
   ```powershell
   Test-NetConnection -ComputerName localhost -Port 1521
   ```
   
   **Linux/macOS** :
   ```bash
   nc -zv localhost 1521
   ```

3. **Vérifier le pare-feu** : Autorisez le port 1521

4. **Utiliser `127.0.0.1` au lieu de `localhost`** (parfois résout des problèmes DNS)

---

### ❌ "ORA-12541: TNS:no listener"

**Symptôme** : Le listener Oracle ne répond pas.

**Cause** : Oracle pas complètement démarré.

**Solutions** :

1. **Vérifier les logs** :
   ```bash
   docker compose logs | grep -i listener
   ```

2. **Vérifier le statut du listener** :
   ```bash
   docker exec -it oracle-db lsnrctl status
   ```

3. **Redémarrer le conteneur** :
   ```bash
   docker compose restart
   ```

---

## ⚡ Performances

### ❌ Oracle consomme toute la RAM

**Symptôme** : La machine devient très lente.

**Cause** : Oracle prend autant de RAM que disponible (comportement normal).

**Solutions** :

1. **Limiter la RAM dans `docker-compose.yml`** :
   ```yaml
   deploy:
     resources:
       limits:
         memory: 2G  # Maximum 2 Go
   ```

2. **Augmenter la RAM de la machine** si possible

3. **Fermer les applications inutiles**

---

### ❌ Requêtes SQL très lentes

**Symptôme** : `SELECT` prend plusieurs secondes.

**Cause** : Pas d'index, trop de données, ou conteneur surchargé.

**Solutions** :

1. **Créer des index** :
   ```sql
   CREATE INDEX idx_nom ON etudiants(nom);
   ```

2. **Analyser les plans d'exécution** :
   ```sql
   EXPLAIN PLAN FOR
   SELECT * FROM etudiants WHERE nom = 'Dupont';
   
   SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
   ```

3. **Augmenter les ressources CPU** :
   - Docker Desktop > Settings > Resources > CPUs

---

## 💾 Volumes et données

### ❌ "Error response from daemon: volume is in use"

**Symptôme** : Impossible de supprimer le volume.

**Cause** : Un conteneur utilise encore le volume.

**Solutions** :

1. **Arrêter tous les conteneurs** :
   ```bash
   docker compose down
   ```

2. **Forcer la suppression** :
   ```bash
   docker volume rm docker_oracle-data -f
   ```

3. **Nettoyer tous les volumes inutilisés** :
   ```bash
   docker volume prune
   ```

---

### ❌ Mes données ont disparu !

**Symptôme** : Tables créées précédemment introuvables.

**Cause** : Volume supprimé avec `docker compose down -v`.

**Solutions** :

1. **Vérifier si le volume existe** :
   ```bash
   docker volume ls
   ```

2. **Si absent** : Les données sont perdues (pas de sauvegarde automatique).

3. **Prévention** :
   - Ne jamais utiliser `-v` sauf si vous voulez réinitialiser
   - Exporter vos données régulièrement :
     ```bash
     docker exec -it oracle-db expdp system/OraclePass123@FREEPDB1 DIRECTORY=DATA_PUMP_DIR DUMPFILE=backup.dmp FULL=Y
     ```

---

## 🐛 Autres problèmes

### ❌ SQL Developer ne démarre pas

**Symptôme** : Fenêtre ne s'ouvre pas ou crash immédiat.

**Cause** : Java manquant ou incompatible.

**Solutions** :

1. **Télécharger la version avec JDK inclus** depuis oracle.com

2. **Installer Java 11+** :
   - [Adoptium](https://adoptium.net/)
   - Vérifier : `java -version`

3. **macOS** : Autoriser l'application (Gatekeeper) :
   - Clic droit > Ouvrir

---

### ❌ "ORA-01950: no privileges on tablespace"

**Symptôme** : Impossible de créer des tables.

**Cause** : L'utilisateur n'a pas de quota sur le tablespace.

**Solution** :

Connectez-vous avec `SYSTEM` et exécutez :
```sql
ALTER USER etudiant QUOTA UNLIMITED ON USERS;
```

---

### ❌ Docker occupe 50+ Go d'espace disque

**Symptôme** : Disque plein.

**Cause** : Accumulation d'images, conteneurs et volumes.

**Solutions** :

1. **Voir l'utilisation** :
   ```bash
   docker system df
   ```

2. **Nettoyer** :
   ```bash
   docker system prune -a --volumes
   ```

3. **Supprimer manuellement** :
   ```bash
   docker volume prune
   docker image prune -a
   ```

---

## 📞 Obtenir de l'aide

Si votre problème n'est pas listé ici :

1. **Vérifier les logs** :
   ```bash
   docker compose logs -f
   ```

2. **Rechercher l'erreur** sur :
   - [Stack Overflow](https://stackoverflow.com/)
   - [Oracle Forums](https://forums.oracle.com/)
   - [GitHub Issues de l'image](https://github.com/gvenzl/oci-oracle-free/issues)

3. **Fournir ces informations** :
   - Version de Docker : `docker --version`
   - Système d'exploitation
   - Contenu de `docker-compose.yml`
   - Logs complets : `docker compose logs > logs.txt`

---

## ✅ Checklist de dépannage générique

Avant de chercher de l'aide :

- [ ] Docker Desktop est lancé
- [ ] `docker --version` fonctionne
- [ ] `docker compose ps` montre le conteneur actif
- [ ] Les logs ne montrent pas d'erreur flagrante
- [ ] Le port 1521 n'est pas utilisé par une autre application
- [ ] Le service name est bien `FREEPDB1`
- [ ] Le mot de passe correspond à `docker-compose.yml`

---

**👉 Retour au [README.md](README.md)**
