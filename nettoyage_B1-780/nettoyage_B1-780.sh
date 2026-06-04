#!/bin/bash

#+++++++++version 1.11 (Sans awk - Compatible Android 6 Acer)+++++++++++++++++++++

# Chemin LOG corrigé
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/../gh_drive/nettoyage_B1-780"
LOG_FILE="$LOG_DIR/nettoyage.log"

# Création du dossier log s'il n'existe pas
mkdir -p "$LOG_DIR" 2>/dev/null

DRY_RUN=false

if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    echo "--- MODE SIMULATION ---"
fi

# 1. Vérification de la connexion
if ! adb devices | grep -qw "device"; then
    echo "❌ Erreur: Tablette non détectée."
    exit 1
fi

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

# --- FONCTION POUR EXTRAIRE L'ESPACE LIBRE (SANS AWK) ---
get_free_space() {
    local path=$1
    # df sans -k, on prend la dernière ligne (données)
    local output
    output=$(adb shell "df $path 2>/dev/null | tail -1")
    
    # Extraire toutes les valeurs avec unités (ex: 14.6G, 493.7M, 14.1G)
    # Le dernier match devrait être "Free" (espace libre)
    local free_value
    free_value=$(echo "$output" | grep -oE '[0-9.]+[GMKgmkm]' | tail -1)
    
    echo "$free_value"
}

# --- Récupération de l'espace ---
TARGET_PATH="/sdcard"
RAW_SPACE=$(get_free_space "$TARGET_PATH")

# Si vide, on essaie l'autre chemin
if [ -z "$RAW_SPACE" ]; then
    TARGET_PATH="/storage/emulated/0"
    RAW_SPACE=$(get_free_space "$TARGET_PATH")
fi

# Nettoyage de la chaîne (ex: "14.1G" -> conversion en Ko)
SPACE_KB=0
if [ -n "$RAW_SPACE" ]; then
    # Extraire le nombre (enlever lettres et points)
    NUM=$(echo "$RAW_SPACE" | sed 's/[a-zA-Z.]//g')
    # Extraire l'unité
    UNIT=$(echo "$RAW_SPACE" | grep -o '[a-zA-Z]*' | head -1)
    # Conversion en Ko
    case "$UNIT" in
        G|g) SPACE_KB=$((NUM * 1024 * 1024)) ;;
        M|m) SPACE_KB=$((NUM * 1024)) ;;
        K|k) SPACE_KB=$NUM ;;
        *) SPACE_KB=$NUM ;;
    esac
fi

# Validation finale
if ! [[ "$SPACE_KB" =~ ^[0-9]+$ ]]; then
    SPACE_KB=0
    echo "⚠️ Attention : Impossible de lire l'espace libre. Valeur brute: '$RAW_SPACE'"
fi

FREESPACE_BEFORE_KB=$SPACE_KB
HUMAN_BEFORE=$((FREESPACE_BEFORE_KB / 1024))

echo "Espace libre avant : ~${HUMAN_BEFORE} Mo (Chemin: $TARGET_PATH)"

# 1. Caches applicatifs
echo "[1/3] Note: Vidage cache global désactivé (nécessite Root sur Android 6)."

# 2. Fichiers temporaires
if [ "$DRY_RUN" = true ]; then
    echo "[2/3] Analyse des fichiers temporaires (SDCard)..."
    adb shell "find $TARGET_PATH/Android/data/*/cache/ $TARGET_PATH/.thumbnails/ -type f 2>/dev/null"
else
    echo "[2/3] Suppression des résidus temporaires..."
    adb shell "rm -rf $TARGET_PATH/Android/data/*/cache/*"
    adb shell "rm -rf $TARGET_PATH/Download/*.tmp"
    adb shell "rm -rf $TARGET_PATH/.thumbnails/*"
fi

# 2b. Médias Messageries
if [ "$DRY_RUN" = true ]; then
    echo "[2b/3] Analyse des dossiers médias (WhatsApp/Telegram)..."
    adb shell "find $TARGET_PATH/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/ -type f 2>/dev/null"
else
    echo "[2b/3] Nettoyage WhatsApp/Telegram..."
    adb shell "rm -rf $TARGET_PATH/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/*"
    adb shell "rm -rf $TARGET_PATH/Android/data/org.telegram.messenger/cache/*"
fi

echo "--- Opération terminée ! ---"

# 3. Calcul du gain
if [ "$DRY_RUN" = false ]; then
    # Re-récupération AFTER
    RAW_SPACE=$(get_free_space "$TARGET_PATH")
    if [ -z "$RAW_SPACE" ]; then
        RAW_SPACE=$(get_free_space "/storage/emulated/0")
    fi

    SPACE_KB=0
    if [ -n "$RAW_SPACE" ]; then
        NUM=$(echo "$RAW_SPACE" | sed 's/[a-zA-Z.]//g')
        UNIT=$(echo "$RAW_SPACE" | grep -o '[a-zA-Z]*' | head -1)
        case "$UNIT" in
            G|g) SPACE_KB=$((NUM * 1024 * 1024)) ;;
            M|m) SPACE_KB=$((NUM * 1024)) ;;
            K|k) SPACE_KB=$NUM ;;
            *) SPACE_KB=$NUM ;;
        esac
    fi
    
    if ! [[ "$SPACE_KB" =~ ^[0-9]+$ ]]; then
        SPACE_KB=0
    fi

    FREESPACE_AFTER_KB=$SPACE_KB
    HUMAN_AFTER=$((FREESPACE_AFTER_KB / 1024))
    
    # Calcul du gain
    GAIN=$(( (FREESPACE_AFTER_KB - FREESPACE_BEFORE_KB) / 1024 ))
    
    if [ $GAIN -lt 0 ]; then
        GAIN=0
    fi

    DATE=$(date "+%Y-%m-%d %H:%M")
    echo "[$DATE] Libre: ${HUMAN_BEFORE}Mo -> ${HUMAN_AFTER}Mo | Gain: ${GAIN}Mo" >> "$LOG_FILE"
    
    echo "Espace libre après : ~${HUMAN_AFTER} Mo"
    if [ $GAIN -gt 0 ]; then
        echo "✅ Gain total : ${GAIN} Mo (Détails dans $LOG_FILE)"
    else
        echo "ℹ️ Aucun gain significatif détecté."
    fi
fi

# --- Débranchement ---
echo ""
read -p "Voulez-vous éjecter la tablette proprement ? (o/n) : " reponse

if [[ "$reponse" =~ ^[oOyY] ]]; then
    echo "Fin des opérations. Fermeture du pont ADB..."
    adb kill-server
    sleep 1
    if ! pgrep adb > /dev/null; then
        echo "✅ Le pont ADB est coupé. Vous pouvez débrancher la tablette Acer."
    else
        echo "⚠️ Le serveur ADB est encore actif."
    fi
else
    echo "ℹ️ Le serveur ADB reste actif."
fi

#++++++++++++++++++++++++++++++

##!/bin/bash

##+++++++++version 1.10 (Fix df sans -k pour Android 6 Acer)+++++++++++++++++++++

## Chemin LOG corrigé
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#LOG_DIR="$SCRIPT_DIR/../gh_drive/nettoyage_B1-780"
#LOG_FILE="$LOG_DIR/nettoyage.log"

## Création du dossier log s'il n'existe pas
#mkdir -p "$LOG_DIR" 2>/dev/null

#DRY_RUN=false

#if [ "$1" == "--dry-run" ]; then
#    DRY_RUN=true
#    echo "--- MODE SIMULATION ---"
#fi

## 1. Vérification de la connexion
#if ! adb devices | grep -qw "device"; then
#    echo "❌ Erreur: Tablette non détectée."
#    exit 1
#fi

#echo "--- Début de l'analyse/nettoyage ---"

## Fonction pour exécuter ou simuler
#do_action() {
#    local cmd=$1
#    local msg=$2
#    if [ "$DRY_RUN" = true ]; then
#        echo "[SIMU] Devrait exécuter: $cmd"
#    else
#        echo "$msg"
#        adb shell "$cmd"
#    fi
#}

## --- Récupération de l'espace (CORRIGÉ pour Android 6 sans -k) ---
#TARGET_PATH="/sdcard"
## df SANS -k, et on prend le 3ème champ ($3) qui est "Free"
#RAW_SPACE=$(adb shell "df $TARGET_PATH 2>/dev/null | awk 'NR==2 {print \$3}'")

## Si vide, on essaie l'autre chemin
#if [ -z "$RAW_SPACE" ]; then
#    TARGET_PATH="/storage/emulated/0"
#    RAW_SPACE=$(adb shell "df $TARGET_PATH 2>/dev/null | awk 'NR==2 {print \$3}'")
#fi

## Nettoyage de la chaîne (ex: "14.1G" -> conversion en Ko)
#SPACE_KB=0
#if [ -n "$RAW_SPACE" ]; then
#    if echo "$RAW_SPACE" | grep -q '[a-zA-Z]'; then
#        # Extraire le nombre (enlever lettres et points)
#        NUM=$(echo "$RAW_SPACE" | sed 's/[a-zA-Z.]//g')
#        # Extraire l'unité
#        UNIT=$(echo "$RAW_SPACE" | grep -o '[a-zA-Z]*' | head -1)
#        # Conversion en Ko
#        case "$UNIT" in
#            G|g) SPACE_KB=$((NUM * 1024 * 1024)) ;;
#            M|m) SPACE_KB=$((NUM * 1024)) ;;
#            K|k) SPACE_KB=$NUM ;;
#            *) SPACE_KB=$NUM ;;
#        esac
#    else
#        # Pas de lettre, on suppose que c'est déjà en Ko
#        SPACE_KB=$(echo "$RAW_SPACE" | tr -d '.')
#    fi
#fi

## Validation finale
#if ! [[ "$SPACE_KB" =~ ^[0-9]+$ ]]; then
#    SPACE_KB=0
#    echo "⚠️ Attention : Impossible de lire l'espace libre. Valeur brute: '$RAW_SPACE'"
#fi

#FREESPACE_BEFORE_KB=$SPACE_KB
#HUMAN_BEFORE=$((FREESPACE_BEFORE_KB / 1024))

#echo "Espace libre avant : ~${HUMAN_BEFORE} Mo (Chemin: $TARGET_PATH)"

## 1. Caches applicatifs
#echo "[1/3] Note: Vidage cache global désactivé (nécessite Root sur Android 6)."

## 2. Fichiers temporaires
#if [ "$DRY_RUN" = true ]; then
#    echo "[2/3] Analyse des fichiers temporaires (SDCard)..."
#    adb shell "find $TARGET_PATH/Android/data/*/cache/ $TARGET_PATH/.thumbnails/ -type f 2>/dev/null"
#else
#    echo "[2/3] Suppression des résidus temporaires..."
#    adb shell "rm -rf $TARGET_PATH/Android/data/*/cache/*"
#    adb shell "rm -rf $TARGET_PATH/Download/*.tmp"
#    adb shell "rm -rf $TARGET_PATH/.thumbnails/*"
#fi

## 2b. Médias Messageries
#if [ "$DRY_RUN" = true ]; then
#    echo "[2b/3] Analyse des dossiers médias (WhatsApp/Telegram)..."
#    adb shell "find $TARGET_PATH/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/ -type f 2>/dev/null"
#else
#    echo "[2b/3] Nettoyage WhatsApp/Telegram..."
#    adb shell "rm -rf $TARGET_PATH/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/*"
#    adb shell "rm -rf $TARGET_PATH/Android/data/org.telegram.messenger/cache/*"
#fi

#echo "--- Opération terminée ! ---"

## 3. Calcul du gain
#if [ "$DRY_RUN" = false ]; then
#    # Re-récupération AFTER (même logique)
#    RAW_SPACE=$(adb shell "df $TARGET_PATH 2>/dev/null | awk 'NR==2 {print \$3}'")
#    if [ -z "$RAW_SPACE" ]; then
#        RAW_SPACE=$(adb shell "df /storage/emulated/0 2>/dev/null | awk 'NR==2 {print \$3}'")
#    fi

#    SPACE_KB=0
#    if [ -n "$RAW_SPACE" ]; then
#        if echo "$RAW_SPACE" | grep -q '[a-zA-Z]'; then
#            NUM=$(echo "$RAW_SPACE" | sed 's/[a-zA-Z.]//g')
#            UNIT=$(echo "$RAW_SPACE" | grep -o '[a-zA-Z]*' | head -1)
#            case "$UNIT" in
#                G|g) SPACE_KB=$((NUM * 1024 * 1024)) ;;
#                M|m) SPACE_KB=$((NUM * 1024)) ;;
#                K|k) SPACE_KB=$NUM ;;
#                *) SPACE_KB=$NUM ;;
#            esac
#        else
#            SPACE_KB=$(echo "$RAW_SPACE" | tr -d '.')
#        fi
#    fi
#    
#    if ! [[ "$SPACE_KB" =~ ^[0-9]+$ ]]; then
#        SPACE_KB=0
#    fi

#    FREESPACE_AFTER_KB=$SPACE_KB
#    HUMAN_AFTER=$((FREESPACE_AFTER_KB / 1024))
#    
#    # Calcul du gain
#    GAIN=$(( (FREESPACE_AFTER_KB - FREESPACE_BEFORE_KB) / 1024 ))
#    
#    if [ $GAIN -lt 0 ]; then
#        GAIN=0
#    fi

#    DATE=$(date "+%Y-%m-%d %H:%M")
#    echo "[$DATE] Libre: ${HUMAN_BEFORE}Mo -> ${HUMAN_AFTER}Mo | Gain: ${GAIN}Mo" >> "$LOG_FILE"
#    
#    echo "Espace libre après : ~${HUMAN_AFTER} Mo"
#    if [ $GAIN -gt 0 ]; then
#        echo "✅ Gain total : ${GAIN} Mo (Détails dans $LOG_FILE)"
#    else
#        echo "ℹ️ Aucun gain significatif détecté."
#    fi
#fi

## --- Débranchement ---
#echo ""
#read -p "Voulez-vous éjecter la tablette proprement ? (o/n) : " reponse

#if [[ "$reponse" =~ ^[oOyY] ]]; then
#    echo "Fin des opérations. Fermeture du pont ADB..."
#    adb kill-server
#    sleep 1
#    if ! pgrep adb > /dev/null; then
#        echo "✅ Le pont ADB est coupé. Vous pouvez débrancher la tablette Acer."
#    else
#        echo "⚠️ Le serveur ADB est encore actif."
#    fi
#else
#    echo "ℹ️ Le serveur ADB reste actif."
#fi

#+++++++++++++

##!/bin/bash

##+++++++++version 1.9 (Fix Log Path & Space Detection)+++++++++++++++++++++

## Correction du chemin LOG : Utilisation de $HOME pour éviter le problème de ~
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#LOG_DIR="$SCRIPT_DIR/../gh_drive/nettoyage_B1-780"
#LOG_FILE="$LOG_DIR/nettoyage.log"

## Création du dossier log s'il n'existe pas
#mkdir -p "$LOG_DIR" 2>/dev/null

#DRY_RUN=false

#if [ "$1" == "--dry-run" ]; then
#    DRY_RUN=true
#    echo "--- MODE SIMULATION ---"
#fi

## 1. Vérification de la connexion
#if ! adb devices | grep -qw "device"; then
#    echo "❌ Erreur: Tablette non détectée."
#    exit 1
#fi

#echo "--- Début de l'analyse/nettoyage ---"

## Fonction pour exécuter ou simuler
#do_action() {
#    local cmd=$1
#    local msg=$2
#    if [ "$DRY_RUN" = true ]; then
#        echo "[SIMU] Devrait exécuter: $cmd"
#    else
#        echo "$msg"
#        adb shell "$cmd"
#    fi
#}

## --- Récupération de l'espace (Debug inclus) ---
## On essaie d'abord /sdcard, sinon /storage/emulated/0
#TARGET_PATH="/sdcard"
#RAW_SPACE=$(adb shell "df -k $TARGET_PATH 2>/dev/null | awk 'NR==2 {print \$4}'")

## Si vide, on essaie l'autre chemin
#if [ -z "$RAW_SPACE" ]; then
#    TARGET_PATH="/storage/emulated/0"
#    RAW_SPACE=$(adb shell "df -k $TARGET_PATH 2>/dev/null | awk 'NR==2 {print \$4}'")
#fi

## Debug : Afficher ce qu'on a reçu (pour vérification si ça plante encore)
## echo "DEBUG RAW_SPACE: '$RAW_SPACE'"

## Nettoyage de la chaîne
#SPACE_KB=0
#if [ -n "$RAW_SPACE" ]; then
#    if echo "$RAW_SPACE" | grep -q '[a-zA-Z]'; then
#        NUM=$(echo "$RAW_SPACE" | sed 's/[a-zA-Z.]//g')
#        UNIT=$(echo "$RAW_SPACE" | grep -o '[a-zA-Z]*' | head -1)
#        case "$UNIT" in
#            G|g) SPACE_KB=$((NUM * 1024 * 1024)) ;;
#            M|m) SPACE_KB=$((NUM * 1024)) ;;
#            K|k) SPACE_KB=$NUM ;;
#            *) SPACE_KB=$NUM ;;
#        esac
#    else
#        SPACE_KB=$(echo "$RAW_SPACE" | tr -d '.')
#    fi
#fi

## Validation finale
#if ! [[ "$SPACE_KB" =~ ^[0-9]+$ ]]; then
#    SPACE_KB=0
#    echo "⚠️ Attention : Impossible de lire l'espace libre. Valeur brute: '$RAW_SPACE'"
#fi

#FREESPACE_BEFORE_KB=$SPACE_KB
#HUMAN_BEFORE=$((FREESPACE_BEFORE_KB / 1024))

#echo "Espace libre avant : ~${HUMAN_BEFORE} Mo (Chemin utilisé: $TARGET_PATH)"

## 1. Caches applicatifs
#echo "[1/3] Note: Vidage cache global désactivé (nécessite Root sur Android 6)."

## 2. Fichiers temporaires
#if [ "$DRY_RUN" = true ]; then
#    echo "[2/3] Analyse des fichiers temporaires (SDCard)..."
#    adb shell "find $TARGET_PATH/Android/data/*/cache/ $TARGET_PATH/.thumbnails/ -type f 2>/dev/null"
#else
#    echo "[2/3] Suppression des résidus temporaires..."
#    adb shell "rm -rf $TARGET_PATH/Android/data/*/cache/*"
#    adb shell "rm -rf $TARGET_PATH/Download/*.tmp"
#    adb shell "rm -rf $TARGET_PATH/.thumbnails/*"
#fi

## 2b. Médias Messageries
#if [ "$DRY_RUN" = true ]; then
#    echo "[2b/3] Analyse des dossiers médias (WhatsApp/Telegram)..."
#    adb shell "find $TARGET_PATH/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/ -type f 2>/dev/null"
#else
#    echo "[2b/3] Nettoyage WhatsApp/Telegram..."
#    adb shell "rm -rf $TARGET_PATH/Android/media/com.whatsapp/WhatsApp/Media/*/Sent/*"
#    adb shell "rm -rf $TARGET_PATH/Android/data/org.telegram.messenger/cache/*"
#fi

#echo "--- Opération terminée ! ---"

## 3. Calcul du gain
#if [ "$DRY_RUN" = false ]; then
#    # Re-récupération AFTER
#    RAW_SPACE=$(adb shell "df -k $TARGET_PATH 2>/dev/null | awk 'NR==2 {print \$4}'")
#    if [ -z "$RAW_SPACE" ]; then
#        RAW_SPACE=$(adb shell "df -k /storage/emulated/0 2>/dev/null | awk 'NR==2 {print \$4}'")
#    fi

#    SPACE_KB=0
#    if [ -n "$RAW_SPACE" ]; then
#        if echo "$RAW_SPACE" | grep -q '[a-zA-Z]'; then
#            NUM=$(echo "$RAW_SPACE" | sed 's/[a-zA-Z.]//g')
#            UNIT=$(echo "$RAW_SPACE" | grep -o '[a-zA-Z]*' | head -1)
#            case "$UNIT" in
#                G|g) SPACE_KB=$((NUM * 1024 * 1024)) ;;
#                M|m) SPACE_KB=$((NUM * 1024)) ;;
#                K|k) SPACE_KB=$NUM ;;
#                *) SPACE_KB=$NUM ;;
#            esac
#        else
#            SPACE_KB=$(echo "$RAW_SPACE" | tr -d '.')
#        fi
#    fi
#    
#    if ! [[ "$SPACE_KB" =~ ^[0-9]+$ ]]; then
#        SPACE_KB=0
#    fi

#    FREESPACE_AFTER_KB=$SPACE_KB
#    HUMAN_AFTER=$((FREESPACE_AFTER_KB / 1024))
#    
#    # Calcul du gain
#    GAIN=$(( (FREESPACE_AFTER_KB - FREESPACE_BEFORE_KB) / 1024 ))
#    
#    if [ $GAIN -lt 0 ]; then
#        GAIN=0
#    fi

#    DATE=$(date "+%Y-%m-%d %H:%M")
#    
#    # Écriture dans le log (avec le chemin corrigé)
#    echo "[$DATE] Libre: ${HUMAN_BEFORE}Mo -> ${HUMAN_AFTER}Mo | Gain: ${GAIN}Mo" >> "$LOG_FILE"
#    
#    echo "Espace libre après : ~${HUMAN_AFTER} Mo"
#    if [ $GAIN -gt 0 ]; then
#        echo "✅ Gain total : ${GAIN} Mo (Détails dans $LOG_FILE)"
#    else
#        echo "ℹ️ Aucun gain significatif détecté."
#    fi
#fi

## --- Débranchement ---
#echo ""
#read -p "Voulez-vous éjecter la tablette proprement ? (o/n) : " reponse

#if [[ "$reponse" =~ ^[oOyY] ]]; then
#    echo "Fin des opérations. Fermeture du pont ADB..."
#    adb kill-server
#    sleep 1
#    if ! pgrep adb > /dev/null; then
#        echo "✅ Le pont ADB est coupé. Vous pouvez débrancher la tablette Acer."
#    else
#        echo "⚠️ Le serveur ADB est encore actif."
#    fi
#else
#    echo "ℹ️ Le serveur ADB reste actif."
#fi
