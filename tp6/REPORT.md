# Rapport TP6 : Infrastructure as Code avec Terraform

## 1. Installation et premier projet Docker
J'ai installé Terraform v1.17.0 depuis le dépôt HashiCorp. J'ai créé un premier projet dans `~/terraform/docker-nginx` avec le provider `kreuzwerker/docker` pour piloter le démon Docker local. Le `terraform plan` a montré la création de 2 ressources (image nginx + conteneur), et le `terraform apply` a bien créé le conteneur sur le port 8001.

## 2. Utilisation de variables
J'ai ajouté une variable `external_port` dans `variables.tf` pour paramétrer le port. J'ai pu recréer le conteneur sur le port 8002 avec `terraform apply -var external_port=8002`.

## 3. Docker distant via SSH
J'ai configuré le provider Docker pour pointer vers la VM `tp2-partie1` (192.168.65.142) via SSH. Après avoir copié ma clé SSH avec `ssh-copy-id`, Terraform a pu créer un conteneur `nginx_remote` sur le port 8003 de cette VM distante.

## 4. Intégration Vagrant + Ansible + Terraform
J'ai créé 2 VM Vagrant (`cv-vm1` et `cv-vm2`) avec un `Vagrantfile` multi-machines. Un playbook Ansible a installé Docker et Terraform sur les 2 VM.

J'ai préparé une image Docker de mon CV One Page et je l'ai poussée sur Docker Hub (`maryemelheni/mon-cv:latest`).

Enfin, j'ai utilisé Terraform (avec le provider Docker en mode SSH) pour déployer le conteneur CV sur la VM1 (port 8001) et la VM2 (port 8002).

## 5. Difficultés rencontrées
- **Virtualisation imbriquée** : J'ai dû activer VT-x dans VMware et modifier le fichier `.vmx` pour que VirtualBox fonctionne dans la VM Ubuntu.
- **Clés SSH Vagrant** : Vagrant génère ses propres clés SSH, il a fallu pointer Terraform vers la bonne clé privée (`.vagrant/machines/cv-vm1/virtualbox/private_key`).
- **Permissions Docker** : L'utilisateur `vagrant` n'était pas dans le groupe `docker`, il a fallu l'ajouter avec `usermod -aG docker vagrant`.
- **Réseau Windows** : Le navigateur Windows n'arrivait pas à accéder aux VM Vagrant (réseau interne VirtualBox). J'ai utilisé `w3m` (navigateur texte) depuis la VM Ubuntu pour faire les captures.
