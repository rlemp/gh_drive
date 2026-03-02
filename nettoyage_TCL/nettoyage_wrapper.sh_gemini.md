Pour automatiser cela sous Linux, nous allons utiliser **udev**. C'est le gestionnaire de périphériques qui peut déclencher une action (votre script) dès qu'il détecte l'ID spécifique de votre tablette sur le bus USB.

Voici la marche à suivre pour transformer votre maintenance en processus "Plug & Play".

---

### 1. Identifier votre tablette

D'abord, il nous faut l'identifiant unique (ID) de votre appareil. Branchez la tablette et tapez :

```bash
lsusb

```

Cherchez la ligne correspondant à votre tablette. Elle ressemblera à ceci :
`Bus 001 Device 008: ID 18d1:4e12 Google Inc. Nexus/Pixel...`

* **idVendor** : `18d1` (les 4 premiers chiffres/lettres)
* **idProduct** : `4e12` (les 4 derniers chiffres/lettres)

### 2. Créer la règle udev

Ouvrez un nouveau fichier de règle avec **micro** (en remplaçant `18d1` et `4e12` par vos codes) :

```bash
sudo micro /etc/udev/rules.d/99-android-clean.rules

```

Copiez-y cette ligne :

```text
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e12", RUN+="/usr/local/bin/nettoyage_wrapper.sh"

```

### 3. Créer le "Wrapper" (L'astuce de l'environnement)

`udev` exécute les commandes avec un environnement très restreint et en mode root. Pour que votre script fonctionne bien, il est préférable de passer par un petit script intermédiaire (wrapper) qui s'assure que le serveur ADB est lancé.

Créez le fichier `/usr/local/bin/nettoyage_wrapper.sh` :

```bash
sudo micro /usr/local/bin/nettoyage_wrapper.sh

```

Collez ce contenu (ajustez le chemin vers votre script v1.3) :

```bash
#!/bin/bash
# On force le chemin vers ADB et on lance le script en root pour éviter les soucis de permissions
export HOME=/root
export PATH=$PATH:/usr/bin:/usr/local/bin

/usr/bin/adb kill-server
/usr/bin/adb start-server
# Remplacez /home/votre_user/ par le vrai chemin vers votre script
			#/home/votre_user/nettoyage_v1.3.sh >> /home/votre_user/nettoyage.log 2>&1
/home/scripts/nettoyage.sh >> /home/.gh_drive/nettoyage_TCL/nettoyage.log 2>&1

```

Rendez le wrapper exécutable :

```bash
sudo chmod +x /usr/local/bin/nettoyage_wrapper.sh

```

---

### 4. Recharger la configuration

Pour que Linux prenne en compte cette nouvelle automatisation :

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger

```

### Comment ça va se passer maintenant ?

Désormais, à chaque fois que vous brancherez votre tablette :

1. Le système reconnaît l'ID USB.
2. Il lance discrètement le script en arrière-plan.
3. Vous n'avez rien à faire.
4. Vous pouvez vérifier plus tard dans votre fichier `nettoyage.log` si le gain d'espace a été effectué.

**Attention :** Assurez-vous que l'écran de la tablette est déverrouillé lors du premier branchement pour que l'autorisation ADB soit valide, sinon le script échouera par manque de permissions.

**Souhaitez-vous que je vous aide à ajouter une notification visuelle sur votre bureau Linux pour savoir quand le nettoyage automatique est terminé ?**
