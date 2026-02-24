# Setup

1. Installer les outils :
   - Git
   - Terraform ou OpenTofu
   - Ansible
2. Forker ou télécharger ce projet. (https://github.com/Civilisation-IT/DEVOPS-REIMS)
3. Générer une clé API Scaleway et récupérer l'`id` et le `secret` (optionnel pendant le CESI).
4. Générer une nouvelle clé SSH et conserver la clé publique :
   - `ssh-keygen -t rsa`
5. Exporter les variables d'environnement nécessaires :
   - `export AWS_ACCESS_KEY_ID=<VOTRE_ACCESS_KEY_ID>`
   - `export AWS_SECRET_ACCESS_KEY=<VOTRE_SECRET_ACCESS_KEY>`

# Terraform

0. Se placer dans le dossier Terraform :
   - `cd tp1/terraform`
1. Initialiser le projet :
   - `tofu init`
2. Les questions Terraform seront posées pendant `tofu plan` et `tofu apply` :
   - Prénom
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - Clé SSH générée (ne l'ajouter qu'une seule fois, laisser vide ensuite)
3. Générer le plan :
   - `tofu plan`
4. Déployer :
   - `tofu apply`

# Ansible

Section à compléter plus tard.
