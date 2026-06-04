#!/usr/bin/env bash

# ==============================================================================
# Configuration et Programmation Défensive
# ==============================================================================
set -o errexit  
set -o nounset  
set -o pipefail 

CURL_BIN=$(command -v curl) || { echo "Erreur: curl n'est pas installé." >&2; exit 1; }
GREP_BIN=$(command -v grep) || { echo "Erreur: grep n'est pas installé." >&2; exit 1; }

# ==============================================================================
# Fonctions
# ==============================================================================

usage() {
    echo "Usage 1 (Arguments) : $0 <balise_debut> <balise_fin> <url>"
    echo "Usage 2 (Heredoc/Pipe): $0 < fichier_entree"
    exit 1
}

extraire_flux() {
    local debut="$1"
    local fin="$2"
    local url="$3"

    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "Erreur: L'URL doit commencer par http:// ou https://" >&2
        exit 1
    fi

    if ! "$CURL_BIN" -sf "$url" | "$GREP_BIN" -oP "(?<=$debut).*?(?=$fin)"; then
        echo "Information: Aucun résultat trouvé ou erreur de flux." >&2
    fi
}

# ==============================================================================
# Logique Principale
# ==============================================================================

if [[ $# -eq 3 ]]; then
    # Mode 1 : Les arguments sont passés directement sur la ligne de commande
    BALISE_DEBUT="$1"
    BALISE_FIN="$2"
    URL_FLUX="$3"
elif [[ $# -eq 0 ]]; then
    # Mode 2 : Lecture depuis l'entrée standard (Heredoc, redirection ou pipe)
    # On lit ligne par ligne pour attribuer correctement les variables complexes
    read -r BALISE_DEBUT
    read -r BALISE_FIN
    read -r URL_FLUX
else
    usage
fi

# Validation de la présence des données
if [[ -z "${BALISE_DEBUT:-}" || -z "${BALISE_FIN:-}" || -z "${URL_FLUX:-}" ]]; then
    echo "Erreur: Les 3 paramètres (début, fin, URL) sont obligatoires." >&2
    exit 1
fi

# Exécution
extraire_flux "$BALISE_DEBUT" "$BALISE_FIN" "$URL_FLUX"
