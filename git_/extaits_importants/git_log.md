La commande principale de Git pour lister et inspecter l'historique des commits est **`git log`**.

Cette commande offre de nombreuses options pour personnaliser la sortie en fonction de ce que vous cherchez.

## 📜 Commandes de base de `git log`

| Commande            | Résultat                                                                                                                                           |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `git log`           | Affiche l'historique complet des commits pour la branche courante, du plus récent au plus ancien.                                                  |
| `git log --oneline` | Affiche chaque commit sur une seule ligne : les 7 premiers caractères du hachage (SHA) et le message du commit. C'est idéal pour un aperçu rapide. |
| `git log --graph`   | Affiche l'historique avec un graphique ASCII pour visualiser les branches et les fusions.                                                          |
| `git log -p`        | Affiche l'historique complet **et** les différences (**patch**) introduites par chaque commit.                                                     |

## 🔍 Filtrage de l'historique

Vous pouvez affiner votre recherche en filtrant par auteur, date, fichier ou contenu.

### Par Quantité ou Contenu

- `git log -n 5` : Affiche les **5 derniers** commits.

- `git log --author="Nom de l'auteur"` : Liste les commits faits par un **auteur spécifique**.

- `git log --grep="Mot clé"` : Liste les commits dont le message contient le **mot clé**.

### Par Fichier ou Répertoire

- `git log chemin/du/fichier` : Liste les commits qui ont **modifié ce fichier**.

- `git log -- chemin/du/dossier` : Liste les commits qui ont **modifié quelque chose dans ce dossier**.

### Par Période

- `git log --since="2 weeks ago"` : Affiche les commits des **deux dernières semaines**.

- `git log --until="2025-01-01"` : Affiche les commits faits **jusqu'à cette date**.

## ✨ Formatage Avancé

Pour un affichage très lisible et souvent préféré par les utilisateurs expérimentés, combinez `graph`, `oneline`, et d'autres options de formatage :

```
git log --oneline --graph --decorate
```

- `--oneline` : Format compact (SHA court + message).

- `--graph` : Affiche la structure des branches.

- `--decorate` : Affiche les références de branches et de tags (étiquettes) à côté des commits correspondants.

Voulez-vous une autre commande pour comparer l'état des commits (par exemple, entre deux branches) ?

<style id="pf-image-display-styles" style="color: rgb(33, 37, 41); font-size: 16px; font-weight: 400; font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, Liberation Sans, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol, Noto Color Emoji; text-decoration: none; text-align: start; line-height: 24px; margin-top: 0px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; padding-left: 0px; padding-right: 0px; background-color: rgba(0, 0, 0, 0); border: 0px rgb(33, 37, 41); border-bottom: 0px rgb(33, 37, 41); border-top: 0px rgb(33, 37, 41); border-left: 0px rgb(33, 37, 41); border-right: 0px rgb(33, 37, 41); border-width: 0px; border-style: none; border-color: rgb(33, 37, 41); border-bottom-width: 0px; border-bottom-style: none; border-bottom-color: rgb(33, 37, 41); display: none; float: none; clear: none; flex: 0 1 auto"> #pf-content img.mediumImage, #pf-content figure.mediumImage { margin: 1em auto;clear: both;display: block;float: none } </style>
