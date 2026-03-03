#!/bin/bash

#+++++++++version 1.4+++++++++++++++++++++

# Script de maintenance Android v1.3
# Inclus : Dry-run, Détection auto et Journalisation (Logs)

LOG_FILE="gh_drive/nettoyage_TCL/nettoyage.log"
#LOG_FILE="nettoyage.log"
DRY_RUN=false

if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    echo "--- MODE SIMULATION ---"
fi

# 1. Vérification de la connexion (on redirige tout pour le silence)
if ! adb devices | grep -qw "device"; then
    echo "❌ Erreur: Tablette non détectée."
    exit 1
fi

# 2. Capture de l'espace avant (en Ko pour le calcul, puis en lisible)
# On récupère uniquement le chiffre de l'espace disponible
FREESPACE_BEFORE=$(adb shell df /data | awk 'NR==2 {print $4}')
HUMAN_BEFORE=$(adb shell df -h /data | awk 'NR==2 {print $4}')


#..........................................................

# [Vos fonctions do_action et commandes rm -rf ici...]
# (Utilisez la version 1.2 du script pour le corps du texte)

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

#...............................................................

echo "--- Opération terminée ! ---"

# 3. Calcul du gain et écriture du Log
if [ "$DRY_RUN" = false ]; then
    FREESPACE_AFTER=$(adb shell df /data | awk 'NR==2 {print $4}')
    HUMAN_AFTER=$(adb shell df -h /data | awk 'NR==2 {print $4}')
    
    # Calcul du gain en Mo (Bash ne gère que les entiers, suffisant ici)
    GAIN=$(( (FREESPACE_AFTER - FREESPACE_BEFORE) / 1024 ))
    DATE=$(date "+%Y-%m-%d %H:%M")

    # Écriture dans le fichier log
    echo "[$DATE] Libre: $HUMAN_BEFORE -> $HUMAN_AFTER | Gain: ${GAIN}Mo" >> "$LOG_FILE"
    
    echo "Espace libre après : $HUMAN_AFTER"
    echo "✅ Gain total : ${GAIN} Mo (Détails dans $LOG_FILE)"
fi

# --- Séquence de débranchement sécurisé ---
echo ""
read -p "Voulez-vous éjecter la tablette proprement ? (o/n) : " reponse

# Utilisation d'une expression régulière pour capturer les variantes de "oui"
if [[ "$reponse" =~ ^[oOyY] ]]; then
    echo "Fin des opérations. Fermeture du pont ADB..."
    adb kill-server

    # Petite pause pour laisser le temps au processus de s'arrêter
    sleep 1

    if ! pgrep adb > /dev/null; then
        echo "✅ Le pont ADB est coupé. Vous pouvez débrancher la tablette TCL."
    else
        echo "⚠️ Le serveur ADB est encore actif (PID: $(pgrep adb))."
    fi
else
    echo "ℹ️ Le serveur ADB reste actif pour d'autres opérations."
fi
