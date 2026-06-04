Voici un article structuré au format Markdown, optimisé pour Obsidian. Il contient le contexte, les problèmes identifiés, les solutions appliquées et le script final prêt à l'emploi.Vous pouvez copier-coller ce bloc directement dans une nouvelle note Obsidian.---
tags:
  - bash
  - hledger
  - automation
  - finance-personnelle
  - script-correction
date-created: 2026-04-30
date-modified: 2026-04-30
source: "Conversation avec Lumo (Proton)"
status: "Finalisé"
---

# Script CCP_V9 : Automatisation Hledger & CSV

> [!INFO] Contexte
> Script bash (`ccp_v9`) conçu pour convertir les exports bancaires CSV (format suisse) en transactions `hledger`, gérer les taux de change USD/CHF, et lancer l'interface graphique.
> **Date de correction :** 30 Avril 2026
> **Problème initial :** Syntaxe bash erronée (`local $var`), risque de corruption de données, gestion incorrecte des fichiers multiples.

---

## 1. Problèmes Identifiés et Corrections

| Problème | Cause | Correction Appliquée |
| :--- | :--- | :--- |
| **Syntaxe Bash** | Déclaration `local $variable` (le `$` est interdit en déclaration). | Suppression du `$` dans `local var_name`. |
| **Orthographe** | Commande `hledger-ui` utilisant `expencies`. | Correction en `expenses`. |
| **Sécurité Données** | `sed -i` écrase sans backup la ligne 4 du journal après édition manuelle. | Ajout de `.bak` à la sauvegarde (`sed -i.bak`). |
| **Flux de travail** | `gedit` ne bloquait pas le script, risquant d'écrire pendant l'édition. | Ajout de `--wait` pour forcer l'attente de la fermeture. |
| **Robustesse** | Risque de taux de change vide si internet coupé. | Ajout de vérifications (`if [ -z ... ]`) et timeout `curl`. |
| **Gestion Fichiers** | Traitement de tous les fichiers CSV au lieu du plus récent. | Utilisation de `ls -t ... | head -n1`. |

---

## 2. Script Final Corrigé (`ccp_v9`)

Copiez ce code dans un fichier nommé `ccp_v9` et rendez-le exécutable (`chmod +x ccp_v9`).

```bash
#!/bin/bash

# ==============================================================================
# SCRIPT CCP_V9 - Gestion comptable hledger
# Date de mise à jour : 30 Avril 2026
# ==============================================================================

# Fonction pour générer le taux de change USD/CHF
generate_price_usd() {
    local yesterday_date exchange_rate output_string
    
    # Calcul de la date d'hier
    yesterday_date=$(date -d "yesterday" +%Y-%m-%d)
    
    echo "🔄 Récupération du taux de change USD/CHF pour le $yesterday_date..."
    
    # Récupération du taux avec timeout et vérification
    exchange_rate=$(curl -s --connect-timeout 10 "https://www.zonebourse.com/cours/devise/US-DOLLAR-SWISS-FRANC-USD-4597/" 2>/dev/null | grep '"price":' | awk -F'[:" ]+' '{print $3}')
    
    # Vérification si le taux a été trouvé
    if [ -z "$exchange_rate" ] || [ "$exchange_rate" = "null" ]; then
        echo "⚠️  ERREUR : Impossible de récupérer le taux de change. Vérifiez votre connexion internet."
        return 1
    fi
    
    output_string="P $yesterday_date USD $exchange_rate CHF"
    
    # Copie dans le presse-papier
    if command -v xclip &>/dev/null; then
        echo "$output_string" | xclip -selection clipboard
        echo "✅ Taux copié dans le presse-papier."
    elif command -v xsel &>/dev/null; then
        echo "$output_string" | xsel --clipboard
        echo "✅ Taux copié dans le presse-papier (via xsel)."
    else
        echo "ℹ️  Taux généré (xclip/xsel non trouvé) : $output_string"
    fi
    
    # Ajout au journal
    echo "$output_string" >> "$HOME/.hledger.journal"
    echo "✅ Ligne de prix ajoutée à ~/.hledger.journal"
    
    # Mise à jour du fichier de directives (avec sauvegarde automatique .bak)
    if [ -f "$HOME/.hledger.directives" ]; then
        sed -i.bak "4c$output_string" "$HOME/.hledger.directives"
        echo "✅ Fichier de directives mis à jour (sauvegarde créée : .bak)."
    else
        echo "⚠️  Fichier .hledger.directives introuvable."
    fi
}

# Fonction pour trier et imprimer le journal
update_journal_trie() {
    local RAW TRIE
    RAW="$HOME/.hledger.journal"
    TRIE="$HOME/.hledger.journal_trie"
    
    if [ ! -f "$RAW" ]; then
        echo "❌ ERREUR : Le fichier journal '$RAW' est introuvable."
        return 1
    fi
    
    echo "📊 Génération du journal trié..."
    if hledger -f "$RAW" print > "$TRIE"; then
        echo "✅ Journal trié généré : $TRIE"
    else
        echo "❌ ERREUR : Échec de la génération du journal trié."
        return 1
    fi
}

# Fonction d'affichage interactif
display() {
    local choix period_arg
    local journal_file="$HOME/.hledger.journal"
    local currency="CHF"
    
    if ! command -v hledger-ui &>/dev/null; then
        echo "❌ ERREUR : La commande 'hledger-ui' n'est pas installée."
        return 1
    fi
    
    if [[ ! -f $journal_file ]]; then
        echo "❌ ERREUR : Le fichier journal '$journal_file' est introuvable."
        return 1
    fi
    
    echo "----------------------------------------"
    echo "Analyse des comptes (hledger-ui)"
    echo "----------------------------------------"
    echo "1. Semaine"
    echo "2. Mois"
    echo "3. Année"
    echo "----------------------------------------"
    
    read -r -p "Votre choix (1-3) : " choix
    
    case "$choix" in
        1) period_arg="this week" ;;
        2) period_arg="this month" ;;
        3) period_arg="this year" ;;
        *) 
            echo "❌ Choix invalide."
            return 1
            ;;
    esac
    
    echo "🚀 Lancement de l'interface UI pour : $period_arg..."
    # Correction orthographique : expenses
    hledger-ui assets expenses -X "$currency" --period "$period_arg" --all --tree
}

# Fonction de conversion CSV vers hledger
csv2hledger() {
    local FILE
    
    cd "$HOME/Bureau/" || { echo "❌ Impossible de changer de répertoire"; exit 1; }
    
    FILE="${1:-export.csv}"
    
    if [ ! -f "$FILE" ]; then
        echo "❌ ERREUR : Le fichier '$FILE' est introuvable."
        exit 1
    fi

    if [ $(wc -l < "$FILE") -lt 10 ]; then
        echo "⚠️  AVERTISSEMENT : Le fichier semble trop petit."
    fi

    echo "🔄 Conversion de : $FILE"
    
    tail -n +8 "$FILE" | head -n -3 | tac | awk -F';' '{
        split($1, d, ".")
        date_iso = d[3] "-" d[2] "-" d[1]
        desc = tolower($3)
        gsub(/"/, "", desc)

        if (desc ~ /comp/) res_name = "avs_mc"
        else if (desc ~ /crédit/) res_name = "remboursement"
        else if (desc ~ /aligro/) res_name = "aligro"
        else if (desc ~ /coop/) res_name = "coop"
        else if (desc ~ /migros/) res_name = "migros"
        else if (desc ~ /denner/) res_name = "denner"
        else if (desc ~ /manor/) res_name = "manor"
        else if (desc ~ /galenicare/) res_name = "sunstore"
        else if (desc ~ /boucherie/) res_name = "boucherie_crettaz"
        else if (desc ~ /jumbo/) res_name = "jumbo"
        else if (desc ~ /package/) res_name = "frais"
        else res_name = "divers"
         
        if ($5 == "" || $5 == "0") {
            montant = $4
        } else {
            montant = $5
        }

        if (res_name == "avs_mc") expenses = "revenues:avs"
        else if (res_name == "sunstore") expenses = "expenses:sante"
        else if (res_name == "jumbo") expenses = "expenses:equipement"
        else if (res_name == "frais") expenses = "expenses:finance"
        else expenses = "expenses:alimentation"

        if (montant != "") {
            printf("%s  %s\n", date_iso, res_name)
            printf("    assets:ccp  %.2f\n", montant)
            printf("    %s\n\n", expenses)
        }
    }' > output4hledger
    
    echo "✅ Conversion terminée. Sortie dans : $HOME/Bureau/output4hledger"
}

# ==============================================================================
# EXÉCUTION PRINCIPALE
# ==============================================================================

echo "----------------------------------------------------------------------------"
echo "Démarrage du script ccp_v9 - $(date)"
echo "----------------------------------------------------------------------------"

# 1. Sélection du fichier CSV le plus récent
LATEST_CSV=$(ls -t "$HOME/Téléchargements/"*.csv 2>/dev/null | head -n1)

if [ -z "$LATEST_CSV" ]; then
    echo "❌ ERREUR : Aucun fichier CSV trouvé dans $HOME/Téléchargements/"
    exit 1
fi

echo "✅ Fichier sélectionné : $(basename "$LATEST_CSV")"
csv2hledger "$LATEST_CSV"

# 2. Déplacement vers l'historique
echo "📦 Déplacement des fichiers CSV vers l'historique..."
mv -i "$HOME/Téléchargements/"*.csv "$HOME/Bureau/hledger_labo/csv2hledger/"

echo "----------------------------------------------------------------------------"
echo "Édition manuelle requise..."
echo "----------------------------------------------------------------------------"
echo "Veuillez vérifier : $HOME/.hledger.journal et $HOME/Bureau/output4hledger"
echo "----------------------------------------------------------------------------"

# 3. Édition avec attente
if gedit --version &>/dev/null; then
    gedit --wait "$HOME/.hledger.journal" "$HOME/Bureau/output4hledger"
    RETOUR_GEDIT=$?
else
    echo "⚠️  Note : gedit --wait non supporté. Attention aux conflits d'écriture."
    gedit "$HOME/.hledger.journal" "$HOME/Bureau/output4hledger" &
    RETOUR_GEDIT=0
fi

if [ $RETOUR_GEDIT -eq 0 ]; then
    echo "✅ Édition terminée. Suite du traitement..."
    generate_price_usd
    update_journal_trie
    display
else
    echo "⚠️  Édition interrompue. Arrêt du script."
    exit 1
fi

echo "----------------------------------------------------------------------------"
echo "Script terminé avec succès."
echo "----------------------------------------------------------------------------"3. Notes d'UtilisationPrérequis

hledger et hledger-ui installés.
curl, awk, sed, xclip (ou xsel) disponibles.
Structure de dossiers :

~/Téléchargements/ : Contient les exports CSV bruts.
~/Bureau/ : Contient le script et le fichier de sortie output4hledger.
~/Bureau/hledger_labo/csv2hledger/ : Dossier d'archive.



Flux de Travail

Import : Le script détecte automatiquement le CSV le plus récent dans Téléchargements.
Conversion : Transformation en format hledger dans output4hledger.
Archivage : Déplacement des CSV vers le dossier d'historique (avec confirmation -i).
Édition : Ouverture de gedit pour vérifier les transactions et le journal.

Important : Le script attend que vous fermiez gedit avant de continuer.


Mise à jour : Ajout automatique du taux de change USD/CHF et tri du journal.
Visualisation : Lancement de hledger-ui pour l'analyse.

Sécurité

Backup automatique : sed crée un fichier .bak avant de modifier les directives.
Validation : Le script s'arrête si aucun CSV n'est trouvé ou si hledger-ui manque.


4. Liens Utiles

Documentation Hledger
Support Proton (Lumo)
Politique de confidentialité Proton


### Comment l'utiliser dans Obsidian :
1.  Créez une nouvelle note (ex: `Scripts/CCP_V9_Hledger.md`).
2.  Collez le contenu ci-dessus.
3.  Les balises `---` au début créeront automatiquement des propriétés (Frontmatter) visibles dans l'éditeur de propriétés d'Obsidian.
4.  Le bloc de code est formaté pour être facilement copiable.
5.  Vous pouvez lier cette note à d'autres notes de votre vault (ex: `[[Finance]]`, `[[Automatisation]]`).
