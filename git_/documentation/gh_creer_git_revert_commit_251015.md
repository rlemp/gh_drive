#terminal 

La commande `gh` fait référence à **GitHub CLI** (Interface de Ligne de Commande de GitHub).

C'est l'outil officiel de ligne de commande qui vous permet de travailler avec GitHub directement depuis votre terminal, à côté de l'endroit où vous utilisez déjà `git` et votre code.

Elle permet d'effectuer diverses tâches liées à GitHub sans avoir à passer par l'interface web, comme :

- **Gérer les Pull Requests (PR)** : créer, lister, consulter, vérifier le statut.

- **Gérer les Issues (problèmes)** : créer, lister, afficher.

- **Gérer les dépôts (repositories)** : créer, cloner, forker.

- **Authentification** : se connecter et se déconnecter de votre compte GitHub.

- **Gérer les Releases**.

- **Travailler avec les Gists**.

- **Interagir avec GitHub Actions** (visualiser les workflows et les exécutions).

En résumé, `gh` simplifie l'interaction avec GitHub et réduit le besoin de basculer entre votre terminal et votre navigateur.

Par exemple, quelques commandes courantes :

- `gh auth login` : Se connecter à votre compte GitHub.

- `gh pr list` : Lister les Pull Requests ouvertes.

- `gh issue create` : Créer une nouvelle Issue.

- `gh repo clone <url>` : Cloner un dépôt GitHub.

- ++++++++++++++++

- Absolument. **`gh` (GitHub CLI)** ne remplace pas **`git`**. Ils servent des objectifs fondamentalement différents et sont conçus pour être utilisés ensemble.

---

## Rôles distincts

La différence essentielle réside dans leurs domaines d'application :

### 1. Git (Système de Contrôle de Version)

- **Rôle :** `git` est le **système de contrôle de version** lui-même.

- **Fonction principale :** Il est responsable du suivi de l'historique de votre code, de la gestion des versions, des commits, des branches, des fusions, et de toutes les opérations de contrôle de version, principalement en **local** sur votre machine.

- **Indépendant de la plateforme :** Il fonctionne avec n'importe quel service d'hébergement Git (GitHub, GitLab, Bitbucket, ou même un serveur privé).

- **Exemples de commandes :** `git commit`, `git branch`, `git merge`, `git status`.

### 2. gh (GitHub CLI)

- **Rôle :** `gh` est une **interface de ligne de commande (CLI)** spécifique à **GitHub**.

- **Fonction principale :** Il permet d'interagir avec les **fonctionnalités spécifiques de la plateforme GitHub** (qui ne sont pas des opérations Git pures), comme la gestion des Pull Requests, des Issues, des Releases, ou l'exécution d'Actions, directement depuis le terminal.

- **Dépend de GitHub :** Il est spécifiquement conçu pour fonctionner avec un dépôt hébergé sur GitHub.

- **Exemples de commandes :** `gh pr create`, `gh issue list`, `gh repo clone`, `gh release create`.

---

## Relation entre les deux

`gh` agit souvent comme une couche de **commodité** au-dessus de `git` pour les utilisateurs de GitHub :

1. **Opérations Git classiques :** Pour enregistrer des modifications (`git commit`), créer une nouvelle branche en local (`git branch`), ou afficher le statut local (`git status`), vous utilisez toujours les commandes **`git`**.

2. **Interaction GitHub :** Une fois que vous voulez interagir avec le dépôt distant sur GitHub (par exemple, pour créer une Pull Request à partir de votre branche locale ou lister les problèmes du projet), vous utilisez les commandes **`gh`**.
    **`git log --graph --oneline`**

Par exemple, la commande `gh pr checkout 123` est une commodité qui exécute plusieurs commandes `git` en arrière-plan (comme récupérer le code distant, créer une branche locale et y basculer) pour vous faire gagner du temps.

---

Le système de contrôle de version est **`git`**, et **`gh`** est un outil qui rend l'expérience d'utilisation de GitHub à partir de la ligne de commande plus fluide.

Git vs GitHub: What's the Difference? | Version Control Explained Ce court format explique la différence fondamentale entre Git (l'outil de contrôle de version) et GitHub (la plateforme d'hébergement), ce qui clarifie pourquoi la CLI gh est complémentaire et non un remplacement de git.
+++++++++++++
++++++++++++++git revert++++++++++++++++++++

Il existe deux commandes principales dans Git pour rétablir une ancienne version de commits, chacune ayant un impact différent sur votre historique : **`git revert`** et **`git reset`**.

Pour commencer, vous devez toujours identifier le _hash_ (identifiant unique) du commit auquel vous souhaitez revenir en utilisant `git log`.

---

## 1. `git revert` (Recommandé pour l'historique partagé)

La commande `git revert` est la méthode la plus sûre, car elle **n'écrase pas l'historique** et ne modifie pas les commits existants.

Elle **crée un nouveau commit** qui annule les modifications du commit spécifié.

| Commande                       | Description                                                                  | Quand l'utiliser                                                                                                          |
| ------------------------------ | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **`git revert <commit-hash>`** | Crée un nouveau commit inverse qui annule les modifications du commit ciblé. | Pour annuler un commit sur une **branche publique** déjà partagée (poussée) avec d'autres. Votre historique reste intact. |
| **`git revert HEAD`**          | Annule le dernier commit.                                                    |                                                                                                                           |

### Processus :

1. Identifiez le hash du commit que vous voulez annuler.

2. Exécutez `git revert <hash>`.

3. Git vous demandera d'éditer le message du nouveau commit d'annulation (le _revert_).

4. Le nouveau commit est ajouté, et votre code revient à l'état _avant_ le commit ciblé.

---

## 2. `git reset` (Pour l'historique local/non partagé)

La commande `git reset` **écrase l'historique** en déplaçant le pointeur de votre branche (`HEAD`) vers un commit antérieur. **⚠️ Soyez prudent**, car cela peut entraîner une perte de travail si ce n'est pas fait correctement. **Ne l'utilisez jamais** sur des commits qui ont déjà été poussés sur un dépôt partagé, sauf si vous êtes sûr de ce que vous faites (cela nécessiterait un `git push --force`).

### Options principales de `git reset` :

| Commande                                | Effet sur le code                                                                | État des modifications               | Quand l'utiliser                                                                                                                   |
| --------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| **`git reset --soft <hash>`**           | Conserve les modifications du commit annulé dans la **zone de staging** (index). | Prêtes à être _commitées_ à nouveau. | Pour corriger le message du dernier commit (suivi de `git commit --amend`).                                                        |
| **`git reset --mixed <hash>`** (Défaut) | Conserve les modifications du commit annulé dans le **répertoire de travail**.   | **Non** indexées.                    | Pour défaire un commit et réorganiser les fichiers avant de _commiter_ à nouveau.                                                  |
| **`git reset --hard <hash>`**           | **Supprime définitivement** toutes les modifications et commits _après_ le hash. | Modifications **perdues**.           | Pour revenir à un état propre sans aucune trace des changements suivants (uniquement pour un historique **local et non partagé**). |

**Exemple d'utilisation de `--hard` pour revenir deux commits en arrière :**

Bash

```
# Pour revenir à l'état d'un commit spécifique
git reset --hard <hash-du-commit-désiré>

# OU pour revenir aux deux derniers commits
git reset --hard HEAD~2
```

+++++++++
Oui, la commande `git revert <hash>` s'exécute **localement dans votre interface de ligne de commande (CLI)**.

C'est une commande Git standard qui manipule votre dépôt local.

Voici ce que vous faites lorsque vous l'exécutez :

1. **Exécution locale :** Vous tapez la commande dans votre terminal, à l'intérieur du répertoire de votre projet Git.

2. **Création du _Revert_ :** Git crée un nouveau commit dans votre historique **local** qui annule les modifications du `<hash>` spécifié.

3. **Synchronisation :** Le nouveau commit d'annulation existe alors sur votre branche locale. Pour que cette annulation soit visible par les autres et sur le dépôt distant (comme GitHub), vous devez ensuite exécuter un **`git push`**.

En résumé, `git revert <hash>` est une opération **locale** qui nécessite un **`git push`** pour être partagée.

+++++++++++++++nettoyage commit+++++++++++++++++++++++
Votre intention est de **nettoyer** votre historique Git pour éviter d'accumuler des commits intermédiaires, peu clairs ou inutiles, en les fusionnant en un seul commit propre.

Ceci est généralement effectué en utilisant le **Rebase Interactif** (`git rebase -i`) ou en utilisant le **Squash lors de la fusion**.

⚠️ **Avertissement Important :** Ces méthodes (sauf si vous utilisez le Squash lors d'un _Merge Request_ ou _Pull Request_ sur la plateforme d'hébergement) **réécrivent l'historique** des commits. **NE FAITES JAMAIS CELA** sur une branche qui a déjà été partagée (poussée) et que d'autres développeurs utilisent, car cela causerait des problèmes de désynchronisation pour vos collaborateurs. Ces opérations doivent être réservées aux **branches de travail locales** avant la fusion finale.

---

## 1. Utiliser le Rebase Interactif (`git rebase -i`)

C'est l'outil le plus puissant pour nettoyer votre historique local. Il vous permet de modifier, fusionner, réordonner ou supprimer des commits.

### Étapes :

1. **Identifier la limite :** Déterminez le commit **avant** lequel vous souhaitez commencer à nettoyer. Par exemple, si vous voulez nettoyer les **cinq derniers commits**, le point de départ est `HEAD~5`.
   
    Bash
   
   ```
   git rebase -i HEAD~5
   # OU utilisez le hash du commit *parent* du premier commit à modifier
   ```

2. **Modifier le fichier d'instructions :** Un éditeur de texte s'ouvrira, listant les commits.
   
   ```
   pick 1a4d6e9 commit: ajout de la fonction A (commit inutile)
   pick 2f5c1a0 commit: correction faute de frappe (commit inutile)
   pick 3b6e8f1 commit: ajout final de la fonction A
   
   # Commandes:
   # p, pick = utiliser le commit
   # r, reword = utiliser le commit, mais modifier le message
   # e, edit = utiliser le commit, puis s'arrêter pour le modifier (ajuster les fichiers, split, etc.)
   # s, squash = utiliser le commit, et le fusionner avec le commit précédent
   # f, fixup = similaire à squash, mais jeter le message de commit (le plus courant pour le nettoyage)
   # d, drop = supprimer le commit
   # ...
   ```

3. **Nettoyer l'historique (Squash/Fixup) :** Pour fusionner les commits intermédiaires (les "accumulations") dans le commit principal (le plus ancien de la série) :
   
   - Laissez la première ligne avec **`pick`**.
   
   - Changez les lignes des commits intermédiaires par **`fixup`** (ou `f`).

    **Exemple :**
    
    ```
    pick 1a4d6e9 commit: ajout de la fonction A  <-- Reste en 'pick'
    fixup 2f5c1a0 commit: correction faute de frappe <-- Deviendra partie de 1a4d6e9
    fixup 3b6e8f1 commit: ajout final de la fonction A <-- Deviendra partie de 1a4d6e9
    ```

4. **Enregistrer et terminer :** Enregistrez et fermez l'éditeur. Git va alors réécrire votre historique local en un seul commit propre.

5. **Pousser (si nécessaire et autorisé) :** Si vous avez réécrit un historique qui était déjà sur le dépôt distant, vous devrez faire un _push forcé_ (à utiliser **avec la plus grande prudence**):
   
    Bash
   
   ```
   git push --force-with-lease
   ```

---

## 2. Utiliser le "Squash" à la Fusion (Recommandé en équipe)

De nombreuses plateformes comme GitHub, GitLab et Bitbucket offrent une option appelée **"Squash and Merge"** (Fusionner et Écraser).

- **Principe :** Le développeur travaille en local, accumule autant de commits qu'il le souhaite (même des commits comme "fix typo", "test1", etc.).

- **Nettoyage :** Au moment de fusionner sa _Pull Request_ (ou _Merge Request_) dans la branche principale, l'option "Squash and Merge" est choisie.

- **Résultat :** Tous les commits de la branche de travail sont combinés en **un seul commit propre** dans l'historique de la branche principale. L'historique de la branche principale reste ainsi propre et concis, sans nécessiter de `git push --force`.
  ++++++++++++++

git rebase -i HEAD~5
donne une erreur
error: impossible de rebase : vous avez des modifications non indexées.
error: Veuillez les valider ou les remiser.

C'est un message d'erreur courant. Git vous avertit que vous avez des changements dans votre répertoire de travail ou dans la zone de _staging_ (index) qui n'ont pas encore été enregistrés (_commités_) ou mis de côté (_remisés_).

Git vous empêche de lancer un `rebase` dans cet état pour éviter de perdre accidentellement vos modifications pendant la réécriture de l'historique.

Vous avez deux solutions pour résoudre ce problème :

---

## Solution 1 : Valider les modifications (`git commit`)

Si vos modifications non indexées sont finales et doivent faire partie de l'historique :

1. **Ajouter les fichiers :**
   
    Bash
   
   ```
   git add .
   ```

2. **Valider les modifications :**
   
    Bash
   
   ```
   git commit -m "WIP: Enregistrement des changements avant rebase"
   ```

3. **Lancer le rebase :**
   
    Bash
   
   ```
   git rebase -i HEAD~5
   ```

Une fois le `rebase` terminé, vous pouvez ensuite choisir d'utiliser l'action **`squash`** ou **`fixup`** pour fusionner ce nouveau commit "WIP" avec un autre commit plus ancien si vous le souhaitez.

---

## Solution 2 : Remiser les modifications (`git stash`)

Si vos modifications non indexées sont en cours et ne doivent pas encore être _commités_ (c'est souvent la meilleure approche pour un _rebase_ de nettoyage) :

1. **Remiser les changements (mettre de côté) :**
   
    Bash
   
   ```
   git stash push -m "Sauvegarde avant rebase"
   ```
   
    Cette commande enregistre tous les changements non validés (suivis ou non) dans une pile de _stashes_ et nettoie votre répertoire de travail.

2. **Lancer le rebase :**
   
    Bash
   
   ```
   git rebase -i HEAD~5
   ```

3. **Restaurer les changements :** Une fois le `rebase` terminé, vous restaurez vos modifications mises de côté :
   
    Bash
   
   ```
   git stash pop
   ```
   
    Vos fichiers reviendront à l'état non indexé/non validé où ils se trouvaient avant le `rebase`.

> 💡 **Rappel :** Avant de lancer un `rebase`, exécutez toujours `git status` pour voir l'état actuel de votre dépôt.

+++++++++++++++git rebase++++++++++++++++++
ok, la commande git rebase -i HEAD-5
ouvre les 5 derniers commits dans l'editeur nano.
qu'est-ce que je fait pour editer  p.e. le ...
pick 477a531 mis a jour hledger/ et ajout script depenses_hl

Quand l'éditeur (Nano, dans votre cas) s'ouvre après `git rebase -i HEAD~5`, vous voyez une liste des commits. Pour éditer (modifier) le contenu du commit `477a531`, vous devez remplacer le mot clé **`pick`** par **`edit`** (ou l'abréviation **`e`**) devant ce commit.

Voici la démarche complète :

## 1. Modifier l'instruction dans Nano

1. **Trouvez la ligne** de votre commit dans l'éditeur :
   
   ```
   pick 477a531 mis a jour hledger/ et ajout script depenses_hl
   pick 8c2d1b4 autre commit
   pick e6f9a0d encore un commit
   ...
   ```

2. **Remplacez `pick` par `edit`** pour le commit que vous souhaitez modifier :
   
   ```
   edit 477a531 mis a jour hledger/ et ajout script depenses_hl  <-- Changé de 'pick' à 'edit'
   pick 8c2d1b4 autre commit
   pick e6f9a0d encore un commit
   ...
   ```

3. **Enregistrez et quittez Nano** pour démarrer le processus de _rebase_ :
   
   - Appuyez sur **`Ctrl + O`** (pour enregistrer).
   
   - Appuyez sur **`Entrée`** (pour confirmer le nom du fichier).
   
   - Appuyez sur **`Ctrl + X`** (pour quitter).

---

## 2. Effectuer les modifications

Git va s'arrêter sur le commit `477a531` et vous donner le contrôle.

1. **Modifiez votre code et indexez les changements :**
   
   - Faites toutes les modifications nécessaires à vos fichiers (édition, ajout, suppression, etc.).
   
   - Indexez ces changements :
     
       Bash
     
     ```
     git add .
     ```

2. **Apportez les modifications au commit (Amender) :**
   
   - Utilisez l'option `--amend` pour inclure les nouveaux changements dans le commit **sans changer le message** (si vous voulez juste modifier le contenu) :
     
       Bash
     
     ```
     git commit --amend --no-edit
     ```
     
       Si vous voulez aussi changer le message, utilisez simplement `git commit --amend`.

---

## 3. Continuer le Rebase

Une fois que vous avez amendé le commit, vous demandez à Git de continuer le processus :

Bash

```
git rebase --continue
```

Git appliquera alors les commits restants (`8c2d1b4`, `e6f9a0d`, etc.) sur votre historique modifié, et le _rebase_ sera terminé.

**Rappel :** Comme cette opération réécrit l'historique, si vous poussez la branche, vous devrez utiliser `git push --force-with-lease`.
++++++++++++++++++++++++++++++
