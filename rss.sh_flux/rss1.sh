#!/usr/bin/env bash

# ==============================================================================
# Configuration et Programmation Défensive
# ==============================================================================
set -o errexit  # Quitter immédiatement si une commande échoue
set -o nounset  # Traiter les variables non définies comme des erreurs
set -o pipefail # Renvoyer le statut de la dernière commande du pipeline qui a échoué

# Localisation des binaires nécessaires
CURL_BIN=$(command -v curl) || { echo "Erreur: curl n'est pas installé." >&2; exit 1; }
GREP_BIN=$(command -v grep) || { echo "Erreur: grep n'est pas installé." >&2; exit 1; }

# ==============================================================================
# Fonctions
# ==============================================================================

# Affiche l'aide en cas de mauvais arguments
usage() {
    echo "Usage alternatif: $0 <balise_debut> <balise_fin> <url>"
    echo "Ou lancez simplement '$0' pour le mode interactif."
    exit 1
}

# Extraction et affichage du flux
extraire_flux() {
    local debut="$1"
    local fin="$2"
    local url="$3"

    # Validation rapide du protocole de l'URL
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "Erreur: L'URL doit commencer par http:// ou https://" >&2
        exit 1
    fi

    # Exécution sécurisée avec gestion des erreurs de flux
    # Note : On utilise -f sur curl pour qu'il échoue proprement en cas d'erreur HTTP (ex: 404)
    if ! "$CURL_BIN" -sf "$url" | "$GREP_BIN" -oP "(?<=$debut).*?(?=$fin)"; then
        echo "Information: Aucun résultat trouvé ou erreur lors de la récupération du flux." >&2
    fi
}

# ==============================================================================
# Logique Principale
# ==============================================================================

if [[ $# -eq 3 ]]; then
    # Mode 1 : Arguments passés en ligne de commande
    BALISE_DEBUT="$1"
    BALISE_FIN="$2"
    URL_FLUX="$3"
elif [[ $# -eq 0 ]]; then
    # Mode 2 : Mode interactif avec lecture robuste
    # Utilisation de l'option -r pour éviter que les antislashs soient interprétés
    read -r -p "Entrez la balise de début (ex: <description><\!\[CDATA\[) : " BALISE_DEBUT
    read -r -p "Entrez la balise de fin (ex: \]\]></description>) : " BALISE_FIN
    read -r -p "Entrez l'URL du flux RSS : " URL_FLUX
else
    # Nombre d'arguments incorrect
    usage
fi

# Vérification que les variables ne sont pas vides
if [[ -z "$BALISE_DEBUT" || -z "$BALISE_FIN" || -z "$URL_FLUX" ]]; then
    echo "Erreur: Tous les champs (début, fin, URL) doivent être renseignés." >&2
    exit 1
fi

# Appel de la fonction d'extraction
extraire_flux "$BALISE_DEBUT" "$BALISE_FIN" "$URL_FLUX"
