#!/bin/bash

#++++++++++++++README++++++++++++++
#Parfait ! La méthode "bourrin" (relancer le serveur ADB en `sudo`) est souvent la plus efficace sous Linux quand on veut s'épargner la configuration manuelle des fichiers `udev`.

#Voici un fichier **README.md** structuré et clair que vous pouvez garder à côté de votre script. Il résume la procédure, les prérequis et les commandes de secours.

#---

#### `README.md` pour `nettoyage.sh`

### 🧹 Script de Nettoyage Android via ADB

#Ce script permet de purger les fichiers temporaires, les caches applicatifs et les résidus de mise à jour sur une tablette Android depuis un PC Linux, sans passer par des applications tierces douteuses.

#### 📋 Prérequis

#1. **Sur la Tablette :**
#* **Options développeurs** activées (7 clics sur "Numéro de build").
#* **Débogage USB** activé.


#2. **Sur le PC Linux :**
#* Paquet `android-tools` ou `adb` installé.
#* Câble USB de bonne qualité.



#---

#### 🚀 Utilisation (Mode Manuel)

#Si le script renvoie une erreur de permissions (`insufficient permissions`), suivez cette procédure de réinitialisation du serveur ADB en mode "root" sur le PC :

#```bash
## 1. Tuer toute instance de ADB en cours
#adb kill-server

## 2. Relancer le serveur avec les privilèges sudo (méthode "bourrin")
#sudo adb start-server

## 3. Vérifier que la tablette est bien reconnue
## Elle doit afficher "device" et non "unauthorized" ou "no permissions"
#adb devices

## 4. Lancer le nettoyage
#chmod +x nettoyage.sh
#./nettoyage.sh

#```

#---

#### 🔍 Détail des actions du script

#| Action | Commande interne | Effet |
#| --- | --- | --- |
#| **Trim Caches** | `pm trim-caches 999G` | Demande au système de vider tous les caches non essentiels. |
#| **Purge SD** | `rm -rf .../cache/*` | Supprime physiquement les fichiers temporaires dans le stockage partagé. |
#| **Thumbnails** | `rm -rf .thumbnails/*` | Supprime les miniatures d'images (se régénèrent si besoin). |
#| **Optimisation** | `pm compile` | (Optionnel) Optimise les fichiers après une mise à jour système. |

#---

#### 💡 Astuces CLI supplémentaires

#* **Voir l'espace utilisé par dossier :**
#`adb shell du -hs /sdcard/* | sort -h`
#* **Lister les applications installées (bloatwares) :**
#`adb shell pm list packages -u`
#* **Éditer le script rapidement :**
#`micro nettoyage.sh`

#---

#> **Note :** Si vous changez de port USB ou débranchez la tablette brutalement, il est parfois nécessaire de refaire un `adb kill-server` suivi de `sudo adb start-server`.

#---

#**Souhaitez-vous que je vous aide à ajouter une ligne au script pour cibler spécifiquement les fichiers de réseaux sociaux (WhatsApp, Telegram, etc.) qui sont souvent les plus gourmands ?**

#+++++++++++++++version 1.2++++++++++++++++++
#!/bin/bash
# Script de maintenance Android via ADB v1.2
# Usage: ./nettoyage.sh          -> Exécute le nettoyage
# Usage: ./nettoyage.sh --dry-run -> Simule le nettoyage

DRY_RUN=false
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    echo "--- MODE SIMULATION (Aucun fichier ne sera supprimé) ---"
fi

# Vérification de la connexion
# Vérification de la connexion (Silence total : stdout et stderr redirigés)
if ! adb devices | grep -qw "device"; then
    echo "❌ Erreur: Tablette non détectée ou non autorisée."
    echo "👉 Essayez: sudo adb kill-server && sudo adb start-server"
    exit 1
fi
echo "✅ Tablette connectée."


	#adb devices | grep -w "device" > /dev/null
	#if [ $? -ne 0 ]; then
	#    echo "Erreur: Tablette non détectée ou non autorisée."
	#    echo "Essayez: sudo adb kill-server && sudo adb start-server"
	#    exit 1
	#fi

echo "Espace libre avant :"
adb shell df -h /data | grep /data

echo "--- Début de l'analyse/nettoyage ---"

# Fonction pour exécuter ou simuler
do_action() {
    local cmd=$1
    local msg=$2
    if [ "$DRY_RUN" = true ]; then
        echo "[SIMU] Devrait exécuter: $cmd"
    else
        echo "$msg"
        adb shell "$cmd"
    fi
}

# 1. Caches applicatifs
do_action "pm trim-caches 999G" "[1/3] Vidage des caches applicatifs..."

# 2. Fichiers temporaires
if [ "$DRY_RUN" = true ]; then
    echo "[2/3] Analyse des fichiers temporaires (SDCard)..."
    adb shell "find /sdcard/Android/data/*/cache/ /sdcard/.thumbnails/ -type f 2>/dev/null"
else
    echo "[2/3] Suppression des résidus temporaires..."
    adb shell "rm -rf /sdcard/Android/data/*/cache/*"
    adb shell "rm -rf /sdcard/Download/*.tmp"
    adb shell "rm -rf /sdcard/.thumbnails/*"
fi

# 2b. Médias Messageries
if [ "$DRY_RUN" = true ]; then
    echo "[2b/3] Analyse des dossiers médias (WhatsApp/Telegram)..."
    adb shell "find /sdcard/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/ -type f 2>/dev/null"
else
    echo "[2b/3] Nettoyage WhatsApp/Telegram..."
    adb shell "rm -rf /sdcard/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/*"
    adb shell "rm -rf /sdcard/Android/data/org.telegram.messenger/cache/*"
fi

echo "--- Opération terminée ! ---"

if [ "$DRY_RUN" = false ]; then
    echo "Espace libre après :"
    adb shell df -h /data | grep /data
fi




##+++++++++++version 1.1++++++++++++++++++++

## Script de maintenance Android via ADB

## Au début du script
#echo "Espace libre avant :"
#adb shell df -h /data | grep /data


#echo "--- Début du nettoyage de la tablette ---"

## 1. Purge des caches de toutes les applications (sans Root)
## On demande au système de libérer 999 Go de cache (il videra tout ce qu'il peut)
#echo "[1/3] Vidage des caches applicatifs..."
#adb shell pm trim-caches 999G

## 2. Suppression des fichiers temporaires connus dans /sdcard/
#echo "[2/3] Suppression des résidus temporaires..."
#adb shell rm -rf /sdcard/Android/data/*/cache/*
#adb shell rm -rf /sdcard/Download/*.tmp
#adb shell rm -rf /sdcard/.thumbnails/*

## 2b. Nettoyage ciblé des messageries (Médias temporaires)
#echo "[2b/3] Nettoyage des dossiers médias (WhatsApp/Telegram/Signal)..."

## WhatsApp : Supprime les "Sent" (doublons de ce que vous envoyez) et les "Private"
#adb shell rm -rf /sdcard/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/*
#adb shell rm -rf /sdcard/Android/media/com.whatsapp/WhatsApp/Media/*/Private/*

## Telegram : Supprime les fichiers mis en cache (ils restent sur le cloud de toute façon)
#adb shell rm -rf /sdcard/Android/data/org.telegram.messenger/cache/*
#adb shell rm -rf /sdcard/Telegram/Telegram\ Documents/*
#adb shell rm -rf /sdcard/Telegram/Telegram\ Video/*

## Suppression des fichiers .exo (souvent des fragments de vidéos YouTube/Streaming)
#adb shell find /sdcard/ -name "*.exo" -type f -delete

## 3. Optimisation des bases de données (si Root disponible)
## Si vous n'êtes pas Root, cette étape sera ignorée silencieusement.
#echo "[3/3] Tentative d'optimisation système..."
#adb shell "su -c 'pm compile -a -f --compile-filter speed-profile'" 2>/dev/null

#echo "--- Nettoyage terminé ! ---"

## À la fin du script
#echo "Espace libre après :"
#adb shell df -h /data | grep /data


