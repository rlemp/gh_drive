##!/bin/bash

#++++++++++++++++++++++++++gemini+++++++++++++++++++

## Script de maintenance préventive pour Ubuntu 24.04 (Asus PN41)
## Auteur : Gemini Thought Partner
## Date : Décembre 2025

#echo "--- Début de la maintenance système ---"

## 1. Nettoyage des paquets APT (Anciens installateurs et dépendances inutiles)
#echo "[1/4] Nettoyage des paquets APT..."
#sudo apt-get autoremove -y
#sudo apt-get clean

## 2. Nettoyage des journaux (Logs) pour éviter la saturation de /var
#echo "[2/4] Limitation de la taille des journaux à 500Mo..."
#sudo journalctl --vacuum-size=500M

## 3. Nettoyage des anciens paquets Snap (Versions désactivées)
#echo "[3/4] Nettoyage des anciennes versions Snap..."
#set -eu
#snap list --all | awk '/désactivé|disabled/{print $1, $3}' |
#    while read snapname revision; do
#        sudo snap remove "$snapname" --revision="$revision"
#    done

## 4. Vérification de l'espace disque final
#echo "[4/4] État final de l'espace disque :"
#df -h / | grep -E "Filesystem|/"

#echo "--- Maintenance terminée avec succès ! ---"

#++++++++++++++++++++++phind-revision++++++++++++++++++++++++++++++++

#!/bin/bash
set -euo pipefail

echo "--- Début de la maintenance système ---"

# 1. Nettoyage des paquets APT (Anciens installateurs et dépendances inutiles)
echo "[1/4] Nettoyage des paquets APT..."
#sudo apt-get autoremove -y
#sudo apt-get clean

	# 1. Mise à jour de la liste et nettoyage profond
	sudo apt-get update          # Optionnel : permet d'identifier les paquets obsolètes
	sudo apt-get autoremove -y   # Supprime les dépendances inutilisées
	sudo apt-get autoclean       # Supprime les archives obsolètes
	sudo apt-get clean           # Vide totalement le cache restant


# 2. Nettoyage des journaux (Logs) pour éviter la saturation de /var
echo "[2/4] Limitation de la taille des journaux à 500Mo..."
sudo journalctl --vacuum-size=500M

# 3. Nettoyage des anciennes révisions Snap (uniquement les révisions désactivées)
echo "[3/4] Nettoyage des anciennes révisions Snap..."
snap list --all |
    awk '/disabled|désactivé/ {print $1, $3}' |
    while IFS=' ' read -r snapname revision; do
        if [[ "$revision" =~ ^[0-9]+$ ]]; then
            sudo snap remove "$snapname" --revision="$revision"
        fi
    done

# 4. Vérification de l'espace disque final
echo "[4/4] État final de l'espace disque :"
df -h /
echo "Seuils : alerte si < 15% libres ou < 5% inodes libres."

echo "--- Maintenance terminée avec succès ! ---"





