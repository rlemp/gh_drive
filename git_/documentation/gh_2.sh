#!/bin/bash

# créer une nouvelle branche
git switch main
git switch -c variantes
touch fichier_variante.txt # ajout de fichier

# synchro local vers distant
git add .
git commit -m "Développement de nouvelles variantes" # Crée un commit
git push -u origin variantes  # établit le suivi (drapeau -u);
	# -u est crucial lors du premier push d'une nouvelle branch;
	# apres: git push.

# Fusionner la branche et synchroniser local/distant
git switch main
git pull origin main # S'assurer que la branche locale main est à jour
git merge variantes # Fusionne les commits de la branche variantes
git push origin main # Envoie les commits fusionnés (y compris ceux de variantes)


# Supprimer la branche
git branch -d variantes
git push origin --delete variantes # Supprime la branche du dépôt distant


# Modifier le dernier commit (HEAD)
git commit --amend

# modifier pas le dernier commit (rebasage)
git rebase -i
git rebase -i HEAD~N





++++++++++++++++++
https://github.com/rlemp/gh_drive.git

echo "# gh_drive" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/rlemp/gh_drive.git
git push -u origin main

git remote add origin https://github.com/rlemp/gh_drive.git
git branch -M main
git push -u origin main
+++++++++++++++++++++++++++
