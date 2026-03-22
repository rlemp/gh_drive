Parfait ! La méthode "bourrin" (relancer le serveur ADB en `sudo`) est souvent la plus efficace sous Linux quand on veut s'épargner la configuration manuelle des fichiers `udev`.

Voici un fichier **README.md** structuré et clair que vous pouvez garder à côté de votre script. Il résume la procédure, les prérequis et les commandes de secours.

---

### `README.md` pour `nettoyage.sh`

## 🧹 Script de Nettoyage Android via ADB

Ce script permet de purger les fichiers temporaires, les caches applicatifs et les résidus de mise à jour sur une tablette Android depuis un PC Linux, sans passer par des applications tierces douteuses.

### 📋 Prérequis

1. **Sur la Tablette :**
* **Options développeurs** activées (7 clics sur "Numéro de build").
* **Débogage USB** activé.


2. **Sur le PC Linux :**
* Paquet `android-tools` ou `adb` installé.
* Câble USB de bonne qualité.



---

### 🚀 Utilisation (Mode Manuel)

Si le script renvoie une erreur de permissions (`insufficient permissions`), suivez cette procédure de réinitialisation du serveur ADB en mode "root" sur le PC :

```bash
# 1. Tuer toute instance de ADB en cours
adb kill-server

# 2. Relancer le serveur avec les privilèges sudo (méthode "bourrin")
sudo adb start-server

# 3. Vérifier que la tablette est bien reconnue
# Elle doit afficher "device" et non "unauthorized" ou "no permissions"
adb devices

# 4. Lancer le nettoyage
chmod +x nettoyage_TCL.sh
./nettoyage_TCL.sh

```

---

### 🔍 Détail des actions du script

| Action | Commande interne | Effet |
| --- | --- | --- |
| **Trim Caches** | `pm trim-caches 999G` | Demande au système de vider tous les caches non essentiels. |
| **Purge SD** | `rm -rf .../cache/*` | Supprime physiquement les fichiers temporaires dans le stockage partagé. |
| **Thumbnails** | `rm -rf .thumbnails/*` | Supprime les miniatures d'images (se régénèrent si besoin). |
| **Optimisation** | `pm compile` | (Optionnel) Optimise les fichiers après une mise à jour système. |

---

### 💡 Astuces CLI supplémentaires

* **Voir l'espace utilisé par dossier :**
`adb shell du -hs /sdcard/* | sort -h`
* **Lister les applications installées (bloatwares) :**
`adb shell pm list packages -u`
* **Éditer le script rapidement :**
`micro nettoyage_TCL.sh`

---

> **Note :** Si vous changez de port USB ou débranchez la tablette brutalement, il est parfois nécessaire de refaire un `adb kill-server` suivi de `sudo adb start-server`.

---

**Souhaitez-vous que je vous aide à ajouter une ligne au script pour cibler spécifiquement les fichiers de réseaux sociaux (WhatsApp, Telegram, etc.) qui sont souvent les plus gourmands ?**