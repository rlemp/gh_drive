 concernant la commande git log :

git log

donne

commit b4c21a24c81865f03483ea928810b6a98b72e2d2 (HEAD -> main)

Author: rlemp <rlemp@sunrise.ch>

Date:   Thu Dec 4 08:59:24 2025 +0100

    WIP: Enregistrement des changements avant rebase

commit d5ab43a97a7cb1560d60e5654e75ef9dc4fa5253

Author: rlemp <rlemp@sunrise.ch>

Date:   Wed Dec 3 20:51:41 2025 +0100

    Mise à jour gh_drive

commit 0b560ab6ed782c3a3b376677ee3ee21b34b1698a

Author: rlemp <rlemp@sunrise.ch>

Date:   Wed Dec 3 17:29:15 2025 +0100

    Commit initial du projet après réinitialisation

commit 7e87da38eb59738c48d7579d1940397b1ad453f7

Author: rlemp <rlemp@sunrise.ch>

Date:   Wed Dec 3 18:28:16 2025 +0100

    mise a jour

et git log --oneline --graph --decorate

donne

 b4c21a2 (HEAD -> main) WIP: Enregistrement des changements avant rebase

* d5ab43a Mise à jour gh_drive

* 0b560ab Commit initial du projet après réinitialisation

* 7e87da3 mise a jour

* 68ee46d Commit initial du projet après réinitialisation

lemp@lemp-PN41:~/gh_drive$ git log

question 1: pourquoi git log reste en suspens dans le terminal (:)

question2: pourquoi 'git log' affiche 5 commits et 'git log --oneline --graph --decorate' 4 commits

C'est une excellente question sur la façon dont git log affiche l'historique de votre projet !

Voici les réponses à vos deux questions concernant la commande git log :
❓ Pourquoi git log reste-t-il en suspens (:) ?

La commande git log ne reste pas en suspens ; elle utilise par défaut un programme de pagination (généralement less sur les systèmes Unix/Linux et macOS) pour afficher le résultat.

    Pagination : Lorsque l'historique des commits est long, Git utilise less pour que vous puissiez voir les résultats page par page. Cela empêche l'historique entier de défiler trop rapidement dans le terminal.
    
    Le signe : : Le caractère deux-points (:) que vous voyez en bas du terminal est le prompt de l'outil less. Il indique que vous êtes en mode de visualisation et que vous pouvez interagir avec le log.

⌨️ Commandes utiles dans l'afficheur (less):

    Espace ou f : Pour passer à la page suivante.
    
    Entrée ou j : Pour avancer d'une ligne.
    
    b : Pour revenir à la page précédente.
    
    q : Pour quitter le pager et revenir au prompt du terminal.

🔢 Pourquoi le nombre de commits est-il différent ?

Il y a une différence dans le nombre de commits affichés entre vos deux commandes car les logs que vous avez fournis ne sont pas exactement les mêmes, mais la cause la plus probable réside dans l'historique réel de votre dépôt et la façon dont git log trie ou filtre par défaut.
Analyse des logs fournis

    git log (Log Complet):
    
        Commit 1 : b4c21a2
    
        Commit 2 : d5ab43a
    
        Commit 3 : 0b560ab
    
        Commit 4 : 7e87da3
    
        Total : 4 commits visibles. (Notez qu'il n'y en a que 4 dans l'extrait que vous avez copié, pas 5.)
    
    git log --oneline --graph --decorate (Log Court):
    
        Commit 1 : b4c21a2
    
        Commit 2 : d5ab43a
    
        Commit 3 : 0b560ab
    
        Commit 4 : 7e87da3
    
        Commit 5 : 68ee46d
    
        Total : 5 commits visibles.

Conclusion de l'analyse : C'est le second log (--oneline...) qui affiche 5 commits, et le premier (git log) qui en affiche 4 dans votre extrait.
🧐 Explication de la différence

Le commit 68ee46d est présent dans le log court (--oneline) mais absent du log complet (git log).

Ceci est très probablement dû à un problème de copie/coller de l'historique par vous-même, où vous avez accidentellement tronqué ou manqué le dernier commit dans le premier affichage, OU cela révèle un point important sur le tri de Git :

    Tri et Affichage : Par défaut, Git trie les commits par date de commit (du plus récent au plus ancien).
    
    Commit 68ee46d : Ce commit est 68ee46d Commit initial du projet après réinitialisation. Il a le même message que 0b560ab. Dans un scénario de rebase, de cherry-pick, ou d'autres manipulations de l'historique, il est possible que deux commits aient des messages similaires et que leur ordre soit légèrement différent, ou que l'un soit l'ancêtre direct de l'autre et que le premier affichage ait été tronqué après 4 commits par le pager less.

Étant donné que le log court --graph est souvent plus complet car il montre la structure entière des branches, il est plus probable que le log court soit le plus précis et que le premier log ait été tronqué par less juste avant le 5ème commit.

En résumé, la commande git log --oneline --graph --decorate est plus susceptible de montrer un historique plus complet et sa différence avec l'autre affichage est probablement due au fait que l'affichage complet a été interrompu après 4 commits.

Souhaitez-vous que je vous donne une commande git log encore plus lisible qui combine tous les détails importants dans un format concis ?

merci pour vos explications: en fait git log affiche en mode less et f affiche le commit manquant!

Absolument ! Ravi de savoir que mes explications vous ont été utiles. 😊

C'est exactement ça :

    git log utilise par défaut le programme less pour la pagination.
    
    Le fait d'appuyer sur la touche f (ou Espace) a permis de faire défiler la page et d'afficher le cinquième commit manquant (68ee46d).

Ceci confirme que la différence de comptage n'était pas due à un filtrage ou à un tri différent, mais simplement à la troncation de l'affichage par le pager less !
💡 Rappel Rapide sur less

    Prompt : Le symbole : en bas indique que vous êtes dans less.
    
    Avancer : Touches Espace ou f (Page suivante).
    
    Ligne par ligne : Touches Entrée ou j.
    
    Quitter : Touche q.

N'hésitez pas si vous avez d'autres questions sur Git !

Voulez-vous une introduction aux options de filtrage les plus courantes de git log (par exemple, par date, par auteur, ou par fichier) ?
