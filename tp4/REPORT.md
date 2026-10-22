# Rapport TP4 : Bases d'Ansible

## 1. Architecture et mise en place
J'ai utilisé une VM Ubuntu (192.168.65.140) comme nœud de contrôle et nœud géré (localhost), pour ne pas surcharger mon disque. J'ai créé un inventaire (`inventory.txt`) et un `ansible.cfg`, puis testé la connexion avec `ansible all -m ping` (résultat : SUCCESS/pong).

## 2. Authentification par clé SSH
J'ai généré une paire de clés ed25519 avec `ssh-keygen`, puis copié la clé publique avec `ssh-copy-id` sur les hôtes. Les playbooks s'exécutent désormais sans l'option `-k`.

## 3. Premier playbook et idempotence
Le playbook `webserver_install.yml` installe Apache et copie un fichier `index.html`. Comme le port 80 était occupé par Nginx (TP1), j'ai configuré Apache sur le port **8080**. Le premier passage a changé 4 tâches, le second a affiché `changed=0`, prouvant l'idempotence.

## 4. Docker, Jenkins, Portainer
J'ai déployé Jenkins (port 8081), Portainer (9000) et un conteneur Nginx (8082) via un playbook Ansible. J'ai rencontré une erreur : le module `docker_container` ne sait pas construire d'image. J'ai dû utiliser `community.docker.docker_image` pour le build, puis `docker_container` pour le run.

## 5. Réorganisation en rôles
J'ai créé trois rôles (`jenkins_install`, `docker_portainer_install`, `container_deployment`) avec `ansible-galaxy role init`. Le playbook `site.yml` les appelle. Le second passage a affiché `changed=0` (ou presque), confirmant l'idempotence.

## 6. Difficultés
- Conflit de port 80 (Nginx vs Apache) → Apache déplacé sur 8080.
- Verrou `dpkg` bloqué par `unattended-upgrades` → arrêt temporaire du service.
- Module `docker_container` sans build → séparation en deux modules.
