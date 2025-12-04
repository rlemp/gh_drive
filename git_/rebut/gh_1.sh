


cd ~/gh_drive && git pull origin main # synchro distant vers local

cd ~/gh_drive && git clone https://github.com/rlemp/gh_drive.git # importer referentiel distant


cd ~/gh_drive && git add . && git commit -m "Mise à jour gh_drive" && git push origin main # synchro local vers distant

cd ~/gh_drive && git add new_file.md && git commit -m "Mise à jour de new_file.md" && git push origin main # synchro local vers distant


cd ~/gh_drive && git rm fichier_a_suppr && git add . && git commit -m "Supprimer le fichier 'fichier_a_suppr'"  && git push # supprimer un fichier depuis local

cd ~/gh_drive && git log  # historique commit

git log --oneline	#Affiche chaque commit sur une seule ligne (plus concis).
git log -n 5	#Limite l'affichage aux cinq derniers commits.
git log --author="Nom Auteur"	#Filtre les commits d'un auteur spécifique.
git log --grep="mot clé"	#Filtre les commits dont le message contient le mot clé spécifié.
git log --graph --oneline	#Affiche l'historique avec un graphe ASCII des branches et des fusions (très utile).

++++++++++++++++branche variantes+++++++gemini+++++++++

Absolument. Voici la séquence de commandes Git pour réaliser l'intégralité du cycle de vie de votre branche **variantes**, de sa création à sa suppression.

J'assume que votre branche principale est nommée **main** et que votre dépôt distant est nommé **origin**.

***

## 1. Créer la branche "variantes" et la pousser vers le distant

Cette étape crée la nouvelle branche localement, y ajoute un *commit* simulé (pour qu'il y ait quelque chose à pousser), puis la publie sur votre dépôt distant.

| Commande | Explication |
| :--- | :--- |
| `git switch main` | S'assurer que vous êtes sur la branche principale (**main**) pour créer la nouvelle branche à partir de celle-ci. |
| `git switch -c variantes` | **Crée** et passe immédiatement sur la nouvelle branche nommée **variantes**. |
| `touch fichier_variante.txt` | *Simule un ajout de fichier/modification.* |
| `git add .` | Ajoute le fichier à la zone de *staging*. |
| `git commit -m "Développement de nouvelles variantes"` | Crée un *commit* avec vos modifications. |
| `git push -u origin variantes` | **Pousse** la branche **variantes** vers le dépôt distant (**origin**) et établit le suivi (drapeau `-u`). |

***

## 2. Fusionner la branche et synchroniser local/distant

Maintenant que le travail est terminé sur **variantes**, nous allons le fusionner dans la branche principale, puis mettre à jour le dépôt distant.

| Commande | Explication |
| :--- | :--- |
| `git switch main` | Revenir sur la branche principale (**main**) pour recevoir les modifications. |
| `git pull origin main` | **Bonne pratique** : S'assurer que la branche locale **main** est à jour avec le distant avant la fusion. |
| `git merge variantes` | **Fusionne** les *commits* de la branche **variantes** dans la branche **main**. |
| `git push origin main` | Envoie les *commits* fusionnés (y compris ceux de **variantes**) vers le distant. |

***

## 3. Supprimer la branche "variantes"

Une fois que la fusion est complète et que le distant est synchronisé, la branche **variantes** est obsolète et peut être supprimée à la fois localement et à distance.

| Commande | Explication |
| :--- | :--- |
| `git branch -d variantes` | **Supprime** la branche **variantes** du dépôt **local**. Le drapeau `-d` garantit que la suppression n'a lieu que si elle a été correctement fusionnée. |
| `git push origin --delete variantes` | **Supprime** la branche **variantes** du dépôt **distant** (**origin**). |

Vous avez maintenant créé, poussé, fusionné, et complètement nettoyé la branche **variantes** ! 🎉
