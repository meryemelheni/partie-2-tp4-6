# Rapport TP5 : Environnements de lab reproductibles avec Vagrant

## 1. Architecture et préparation
J'ai utilisé ma VM Ubuntu (192.168.65.140) comme VM de lab. J'ai dû activer la virtualisation imbriquée (VT-x) dans VMware et modifier le fichier `.vmx` pour que VirtualBox puisse fonctionner à l'intérieur (le résultat de `grep -Ec '(vmx|svm)' /proc/cpuinfo` renvoie 4).

J'ai installé VirtualBox 7.2.6, Vagrant 2.4.9 et Ansible sur cette VM.

## 2. Démo Vagrant
J'ai créé un dossier `vagrant_demo` avec un `Vagrantfile` qui :
- Utilise la box `bento/ubuntu-24.04`.
- Provisionne un serveur Apache via un script shell.
- Synchronise le dossier `web/` avec `/var/www/html`.
- Redirige le port 80 de l'invitée vers le port 8085 de la VM de lab (le port 8080 étant déjà utilisé par mes conteneurs Docker).

La page `http://192.168.65.140:8085` affiche bien "Bonjour depuis Vagrant".

## 3. Lab final (2 VM avec Ansible)
J'ai créé un `Vagrantfile` multi-machines avec deux VM (`vm1` et `vm2`), chacune avec :
- Une IP sur un réseau `private_network` (192.168.56.11 et 192.168.56.12).
- Une redirection de ports vers des ports hôtes différents (8090, 8091, 9090, 9091, 8092, 8093) pour éviter les conflits avec mes conteneurs Docker du TP4.
- Un provisionnement Ansible qui réutilise les rôles du TP4 (`docker_portainer_install`, `jenkins_install`, `container_deployment`).

Les deux VM ont été provisionnées avec succès. Les conteneurs Jenkins, Portainer et webapp tournent sur les deux.

## 4. Difficultés rencontrées
- **Virtualisation imbriquée** : J'ai dû désactiver Hyper-V sur Windows, modifier le `.vmx` de VMware, et utiliser l'outil DG_Readiness de Microsoft pour libérer le VT-x.
- **Conflits de ports** : Le port 8080 était déjà utilisé par mes conteneurs Docker. J'ai dû décaler tous les ports de redirection.
- **Manque de RAM** : Les deux VM Vagrant (2 Go chacune) saturent la RAM de ma VM Ubuntu (8 Go). J'ai dû les démarrer et les provisionner l'une après l'autre.
- **Bug de redirection VirtualBox** : Les ports 8090, 9090, 8092 ne redirigent pas correctement vers les VM, donc j'ai dû vérifier les services en utilisant `curl` depuis l'intérieur des VM (sur les IPs internes des conteneurs).
