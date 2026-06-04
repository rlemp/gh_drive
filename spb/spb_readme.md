


# `spb` — Secure Paste Box

`spb` est une fonction Bash simple permettant de partager des données textuelles de manière sécurisée grâce au chiffrement GPG. Les données sont téléchargées sur `termbin.com`, et le destinataire peut en déchiffrer le contenu à l'aide de l'URL fournie et d'une phrase de passe.

## Aperçu des fonctionnalités

Cette fonction effectue les tâches suivantes :

* Lecture des données depuis l'entrée standard (pipe) ou un fichier.
* Chiffrement des données avec GPG via une phrase de passe saisie par l'utilisateur.
* Envoi des données chiffrées à `termbin.com:9999`.
* Affichage de l'URL générée et instructions pour le déchiffrement.
* Enregistrement local incluant la date, la commande, la phrase de passe (déconseillé) et une description.

> ⚠️ **Avertissement de sécurité** : La phrase de passe est enregistrée en texte clair dans le fichier journal (log). Évitez d'utiliser cette méthode dans un environnement de production. Il est recommandé de prendre des notes manuellement à la place.

## Utilisation

### 1. Chiffrer et partager un fichier
```bash
spb fichier.txt
```

### 2. Envoyer des données via un pipe ou << ou heredoc
```bash
echo "Message secret" | spb
```

```bash
printf %s "	chaine " | spb
```

```bash
spb<<<'
Message secret
'
```

```bash
sbp<<eof
	Message
	secret
eof
```
Ou encore :
```bash
cat config.json | spb
```

### 3. Invites lors de l'exécution
* Il vous sera demandé de saisir une phrase de passe (celle-ci ne s'affichera pas à l'écran).
* Une invite apparaîtra pour saisir une description du transfert (facultatif).

### 4. Exemple de sortie
```
Lien généré : http://termbin.com/abc123
Pour déchiffrer plus tard : curl http://termbin.com/abc123 | gpg -d

260326-1530   curl http://termbin.com/abc123 | gpg -d      motdepasse123      Envoi de la clé API
```

## Dépendances

Pour utiliser cette fonction, les outils suivants doivent être installés sur votre système :

* `gpg` (GnuPG)
* `nc` (netcat)
* `tr`

### Exemple d'installation sur Debian/Ubuntu :
```bash
sudo apt install gnupg netcat
```

## Emplacement du journal (Log)

Tous les enregistrements d'envoi sont ajoutés au fichier suivant :
```
~/Bureau/retours_termbin
```
> 📝 Le chemin utilise le dossier "Bureau". Ajustez le chemin selon votre environnement si nécessaire (ex: `~/Desktop/`).

## Notes sur la sécurité

* Les données étant chiffrées côté client avec GPG, `termbin.com` ne peut pas en connaître le contenu.
* La phrase de passe étant **enregistrée en clair dans le journal**, cet outil n'est pas adapté aux usages hautement confidentiels.
* La gestion de la phrase de passe relève de la responsabilité de l'utilisateur. En cas d'oubli, le déchiffrement est impossible.
* `termbin.com` est un service public et ne garantit pas une conservation permanente des données.

## Suggestions de personnalisation

* Modifier la fonction pour ne pas enregistrer la phrase de passe dans le fichier journal.
* Permettre de passer la description en tant qu'argument de la commande.
* Prendre en charge plusieurs services d'hébergement (ex: `ix.io`).
* Ajouter une fonction de copie automatique dans le presse-papiers (via `xclip`, etc.).

-
