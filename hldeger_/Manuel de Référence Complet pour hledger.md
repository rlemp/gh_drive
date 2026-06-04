# Manuel de Référence Complet pour hledger

hledger est un système de comptabilité en texte brut, conçu pour être à la fois robuste, convivial et multiplateforme. Il permet de suivre de l'argent, du temps ou toute autre commodité en utilisant les principes de la comptabilité en partie double et un format de fichier simple et modifiable. Cette approche garantit la pérennité, la portabilité et un contrôle total sur les données financières.

## 1. Introduction à hledger

### 1.1. Philosophie et Concepts Fondamentaux

Au cœur de hledger se trouve le principe de la **comptabilité en partie double**. Chaque transaction est vue comme un mouvement de commodités (argent, actions, heures, etc.) entre au moins deux comptes.

- **Débits et Crédits** : Les montants positifs représentent un afflux vers un compte (un **débit**), tandis que les montants négatifs représentent une sortie (un **crédit**). La somme de toutes les écritures au sein d'une transaction doit toujours être égale à zéro, garantissant ainsi l'équilibre des livres.
- **Comptes** : Les comptes peuvent représenter des entités du monde réel, comme un compte bancaire (`actifs:banque:courant`) ou un portefeuille (`actifs:cash`), ou des catégories abstraites pour suivre les flux financiers, comme les dépenses (`dépenses:nourriture`) ou les revenus (`revenus:salaire`).

### 1.2. Structure d'une Transaction de Base

La brique de base de la comptabilité avec hledger est la transaction. Voici un exemple simple d'achat de nourriture :

```hledger
2015-10-16 Achat de nourriture
    dépenses:nourriture    $10
    actifs:cash
```

Cette transaction enregistre un mouvement de 10 $ :

1. Un afflux de 10 $ vers le compte `dépenses:nourriture` (montant positif).
2. Une sortie correspondante du compte `actifs:cash`. Le montant est omis, hledger le calcule automatiquement à -10 $ pour équilibrer la transaction.

Une règle syntaxique essentielle est à retenir : il doit y avoir **deux espaces ou plus** entre le nom du compte et le montant.

La maîtrise de la structure du fichier journal est la première étape pour exploiter tout le potentiel de hledger. La section suivante détaille chaque composant de ce format.

## 2. Le Format de Fichier Journal

Le fichier journal est le cœur de hledger. Sa syntaxe, bien que simple, est structurée pour permettre une grande précision dans l'enregistrement des données financières. Comprendre chaque composant est essentiel pour garantir l'intégrité et l'exploitabilité de votre comptabilité.

### 2.1. Anatomie d'une Transaction

Une transaction commence par une ligne d'en-tête qui contient plusieurs champs, certains obligatoires et d'autres optionnels, dans un ordre précis.

`DATE [STATUT] [(CODE)] [DESCRIPTION]`

- **Date** (obligatoire) : La date de la transaction. Les formats `YYYY-MM-DD`, `YYYY/MM/DD`, et `YYYY.MM.DD` sont acceptés.
- **Statut** (optionnel) : Un caractère unique indiquant l'état de la transaction, utile pour le rapprochement bancaire.

| Marqueur | Statut                  | Signification Suggérée                                         |
| -------- | ----------------------- | -------------------------------------------------------------- |
| (aucun)  | `unmarked` (non marqué) | Enregistré mais pas encore rapproché ; nécessite une révision. |
| `!`      | `pending` (en attente)  | Rapproché de manière provisoire.                               |
| `*`      | `cleared` (validé)      | Complet, rapproché et considéré comme correct.                 |

- **Code** (optionnel) : Un identifiant court (ex: numéro de chèque) placé entre parenthèses.
- **Description** (optionnel) : Un texte décrivant la transaction. Le caractère pipe `|` peut être utilisé pour séparer le **bénéficiaire** (`payee`, à gauche) de la **note** (`note`, à droite). Si le `|` n'est pas utilisé, la description, le bénéficiaire et la note ont la même valeur.

### 2.2. Les Écritures (Postings)

Sous la ligne d'en-tête se trouvent les écritures, qui doivent être indentées (généralement avec 2 ou 4 espaces).

`[STATUT] COMPTE [MONTANT]`

- **Structure Hiérarchique** : Les noms de compte utilisent le deux-points (`:`) pour créer une hiérarchie, comme `actifs:banque:courant`.
- **Règle des Deux Espaces** : Il doit y avoir au moins **deux espaces** entre le nom du compte et le montant. C'est une erreur fréquente pour les débutants.
- **Montant Inféré** : Vous pouvez omettre le montant d'une seule écriture par transaction. hledger le calculera automatiquement pour que la somme totale des écritures soit nulle.

### 2.3. Syntaxe des Montants et des Coûts

Un montant dans hledger est flexible et peut inclure plusieurs éléments :

- **Signe** : `+` (par défaut) ou `-`.
- **Quantité** : Un nombre avec un séparateur décimal qui peut être un point (`.`) ou une virgule (`,`). Des séparateurs de milliers peuvent également être utilisés.
- **Commodité** : Un symbole monétaire (`$`, `EUR`) ou un nom (`AAPL`, `"Chocolate Frogs"`). Les commodités contenant des espaces ou des chiffres doivent être entourées de guillemets doubles.

Pour les transactions de conversion (ex: achat d'actions, change de devises), une notation de coût peut être ajoutée.

| Notation          | Signification                              | Exemple                                                          |
| ----------------- | ------------------------------------------ | ---------------------------------------------------------------- |
| `@ PRIX_UNITAIRE` | Coût par unité de la commodité achetée.    | `2.0 AAAA @ $1.50` (2 unités d'AAAA achetées à 1.50 $ chacune)   |
| `@@ PRIX_TOTAL`   | Coût total pour l'ensemble de la quantité. | `3.0 AAAA @@ $4` (3 unités d'AAAA achetées pour un total de 4 $) |

### 2.4. Assertions et Affectations de Solde

Les assertions de solde sont un mécanisme de vérification puissant pour garantir l'intégrité des données, particulièrement utile lors du rapprochement bancaire.

- **Assertion de solde** : S'écrit `= SOLDE_ATTENDU` après une écriture. hledger vérifiera que le solde cumulé du compte correspond au `SOLDE_ATTENDU` à la date de la transaction. Si ce n'est pas le cas, une erreur est signalée.

Le tableau suivant différencie les assertions des affectations, qui partagent une syntaxe similaire mais ont des objectifs très différents.

| Caractéristique           | Assertion de Solde                                                                                     | Affectation de Solde                                                                                                |
| ------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| **Montant de l'écriture** | Doit être spécifié (généralement `0` ou `0.00`).                                                       | Est **omis** (laissé vide).                                                                                         |
| **Rôle**                  | **Vérifie** que le solde du compte correspond à la valeur attendue. Signale une erreur en cas d'échec. | **Calcule automatiquement** le montant de l'écriture pour forcer le solde du compte à atteindre la valeur attendue. |
| **Impact sur l'audit**    | Rend le journal plus explicite et robuste. Protège contre les modifications accidentelles.             | Rend le journal moins explicite et peut masquer des erreurs. Moins recommandé pour une comptabilité rigoureuse.     |

- **Syntaxes avancées** :
  - `== SOLDE_ATTENDU` : Vérifie le solde de toutes les commodités du compte.
  - `=* SOLDE_ATTENDU` : Inclut les soldes des sous-comptes dans la vérification.
  - `==* SOLDE_ATTENDU` : Combine les deux vérifications ci-dessus.

### 2.5. Balises (Tags) et Commentaires

Les balises permettent d'ajouter des dimensions de catégorisation supplémentaires à vos données.

- **Syntaxe** : Une balise s'écrit `nom:valeur` dans un commentaire. Elle peut être attachée à une transaction, une écriture, ou une directive `account`.
- **Héritage** : Une écriture hérite des balises de sa transaction parente et de son compte.
- **Balises spéciales** : hledger utilise certaines balises pour des fonctions spécifiques :
  - `type:` : Définit le type d'un compte (ex: `type:A` pour Actif).
  - `date:` / `date2:` : Modifie la date (primaire ou secondaire) d'une écriture individuelle.
  - `assert:`, `retain:`, `start:` : Marquent les transactions générées par `hledger close`. `retain:` est spécifiquement utilisé pour le transfert des bénéfices non distribués.
  - `t:` : Apparaît sur les écritures générées à partir du format `timedot`.
  - `generated-transaction`, `modified-transaction`, `generated-posting`, `cost-posting`, `conversion-posting` : Marquent les transactions ou écritures générées ou modifiées automatiquement.
- **Commentaires** :
  - Les commentaires de ligne commencent par `#` ou `;`.
  - Les blocs de commentaires sont délimités par les directives `comment` et `end comment`.

Au-delà des transactions, le comportement de hledger est contrôlé par un ensemble de déclarations puissantes appelées directives, qui seront explorées dans la section suivante.

## 3. Les Directives du Journal

Les directives sont des instructions qui modifient la manière dont hledger traite les données, améliorent la vérification des erreurs et personnalisent les rapports. Bien qu'optionnelles, elles sont fondamentales pour un usage professionnel et structuré de hledger.

### 3.1. Directives de Déclaration

Ces directives permettent de définir les entités de base de votre comptabilité.

- `**account**` : Cette directive multifonctionnelle est cruciale.
  - **Documentation** : Elle sert à documenter votre plan comptable.
  - **Ordre d'affichage** : L'ordre des directives `account` dans le fichier détermine l'ordre d'affichage des comptes dans les rapports.
  - **Vérification d'erreurs** : En mode strict (`--strict`), hledger signalera une erreur si une transaction utilise un compte non déclaré.
  - **Typage des comptes** : Elle permet d'assigner un type comptable via une balise (`type:A` pour Actif, `L` pour Passif, `E` pour Capitaux Propres, `R` pour Revenus, `X` pour Dépenses, `C` pour Liquidités/Cash, `V` pour Conversion).
- `**commodity**` : Déclare les devises et autres commodités.
  - **Style d'affichage** : Définit le formatage des montants (nombre de décimales, position du symbole, séparateurs).
  - **Vérification d'erreurs** : En mode strict, elle permet de s'assurer que seules les commodités déclarées sont utilisées.
- `**P**` : Déclare les prix de marché à une date donnée (`P DATE COMMODITE1 PRIX_COMMODITE2`). Ces directives sont essentielles pour les rapports de valorisation qui convertissent les actifs à leur valeur de marché.
- `**payee**` **et** `**tag**` : Permettent de déclarer une liste de bénéficiaires et de noms de balises valides, respectivement. La commande `hledger check` peut alors être utilisée pour détecter les noms non déclarés.

### 3.2. Directives de Structuration et de Génération

Ces directives organisent vos fichiers et automatisent la génération de transactions.

- `**include**` : Permet d'inclure le contenu d'un autre fichier journal. C'est une méthode efficace pour organiser les données en plusieurs fichiers (par exemple, un fichier par année ou par compte).
- `**alias**` : Réécrit les noms de compte avant la génération des rapports. Utile pour utiliser des raccourcis dans le journal ou pour refactoriser un plan comptable sans modifier toutes les transactions existantes.
  - **Alias simple** : `alias ANCIEN_NOM = NOUVEAU_NOM`
  - **Alias par expression régulière** : `alias /REGEX/ = REMPLACEMENT`
- `**~**` **(Transactions Périodiques)** : Définit une règle pour générer des transactions récurrentes.
  - Utilisée avec l'option `--forecast` pour générer des transactions futures.
  - Utilisée avec l'option `--budget` pour définir des objectifs budgétaires.
  - **Règle syntaxique** : Il doit y avoir **deux espaces ou plus** entre l'expression de période et la description de la transaction.
- `**=**` **(Écritures Automatiques)** : Ajoute des écritures supplémentaires à des transactions existantes qui correspondent à une requête.
  - S'active avec l'option `--auto`. Utile pour calculer automatiquement des taxes ou des commissions sur certaines transactions.

Ces directives et la syntaxe du journal sont exploitées via l'interface en ligne de commande, qui sera explorée dans la section suivante.

## 4. L'Interface en Ligne de Commande (CLI)

L'interface en ligne de commande (CLI) est le principal moyen d'interagir avec hledger. Sa puissance réside dans la combinaison de commandes, d'options et d'un langage de requête flexible pour produire des rapports financiers précis et personnalisés.

### 4.1. Syntaxe de Base et Options Communes

La syntaxe générale d'une commande hledger est la suivante :

`hledger COMMANDE [OPTIONS] [ARGUMENTS]`

Le tableau ci-dessous liste les options les plus fondamentales.

| Option       | Alias | Description                                                                                       |
| ------------ | ----- | ------------------------------------------------------------------------------------------------- |
| `--file`     | `-f`  | Spécifie le fichier journal à utiliser. Peut être utilisé plusieurs fois.                         |
| `--period`   | `-p`  | Définit une période de rapport en utilisant des expressions flexibles (ex: `this month`, `2023`). |
| `--begin`    | `-b`  | Définit la date de début du rapport.                                                              |
| `--end`      | `-e`  | Définit la date de fin du rapport (exclusive).                                                    |
| `--unmarked` | `-U`  | Filtre pour n'inclure que les transactions non marquées (voir section 2.1).                       |
| `--pending`  | `-P`  | Filtre pour n'inclure que les transactions en attente (marquées avec `!`, voir section 2.1).      |
| `--cleared`  | `-C`  | Filtre pour n'inclure que les transactions validées (marquées avec `*`, voir section 2.1).        |
| `--depth`    |       | Limite la profondeur de l'arborescence des comptes affichés dans les rapports.                    |
| `--strict`   | `-s`  | Active le mode de vérification strict (ex: comptes non déclarés).                                 |

### 4.2. Spécification des Périodes de Rapport

L'option `-p` est particulièrement puissante car elle utilise des "dates intelligentes" et des expressions de période.

- Une expression de période comme `from 2025-10-01 to 2025-10-10` peut être simplifiée en remplaçant `to` par `..` ou `-`.
- Les mots-clés `from` et `to` ainsi que les espaces sont souvent optionnels, permettant des syntaxes très concises comme `-p 2025-10-01..2025-10-10`.

Pour les rapports périodiques, des options d'intervalle standard sont disponibles :

- `-D` : Quotidien
- `-W` : Hebdomadaire
- `-M` : Mensuel
- `-Q` : Trimestriel
- `-Y` : Annuel

### 4.3. Gestion de la Sortie

hledger peut générer des rapports dans de multiples formats, bien au-delà du simple texte.

- **Formats disponibles** : `txt`, `html`, `csv`, `tsv`, `json`, `fods` (OpenDocument Spreadsheet), `beancount`, `sql`.
- **Sélection du format** :
  - Avec l'option `-o FICHIER.ext`, le format est déduit de l'extension du fichier de sortie (ex: `-o rapport.csv`).
  - Avec l'option `-O FORMAT`, le format est spécifié explicitement (ex: `-O csv`).

Le format `FODS` est souvent préférable au `CSV` pour l'importation dans des tableurs, car il gère mieux les séparateurs décimaux, l'encodage des caractères et d'autres métadonnées.

Le filtrage des données va bien au-delà des options de base grâce au puissant langage de requête de hledger.

## 5. Le Langage de Requête (Queries)

Le système de requêtes de hledger est le mécanisme qui permet de filtrer et de sélectionner des sous-ensembles de données avec une très grande précision. Sa maîtrise est stratégique pour réaliser des analyses financières ciblées et complexes.

### 5.1. Types de Requêtes

Par défaut, tout argument fourni à une commande de rapport est interprété comme une requête sur le nom de compte (`acct:`). Pour cibler d'autres champs, un préfixe est utilisé.

| Requête                | Cible                                                                                                                |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `acct:REGEX`           | Nom du compte (le `acct:` est optionnel).                                                                            |
| `desc:REGEX`           | Description complète de la transaction.                                                                              |
| `date:PERIODEXPR`      | Date de la transaction (ex: `date:2023-01..2023-02`).                                                                |
| `status:`              | Transactions non marquées (`unmarked`).                                                                              |
| `status:!`             | Transactions en attente (`pending`).                                                                                 |
| `status:*`             | Transactions validées (`cleared`).                                                                                   |
| `cur:REGEX`            | Devise/commodité. Effectue une correspondance **complète**. Pour une correspondance partielle, utiliser `.*REGEX.*`. |
| `amt:'<                | >N'`                                                                                                                 |
| `tag:REGEX[=VALREGEX]` | Nom et/ou valeur d'une balise.                                                                                       |
| `type:TYPECODES`       | Type de compte (`A`, `L`, `E`, `R`, `X`, `C`, `V`).                                                                  |

### 5.2. Combinaison de Requêtes

- **Logique par défaut** : Lorsque plusieurs arguments de requête sont fournis, la logique dépend de la commande.
  - Pour la plupart des commandes, les requêtes sont combinées avec une logique **ET** entre les types et **OU** au sein d'un même type (ex: `desc:amazon desc:amzn acct:dépenses` trouve les transactions de `dépenses` dont la description contient "amazon" **OU** "amzn"). Plus précisément, une entité correspond si elle satisfait *l'une* des requêtes de description ET *l'une* des requêtes de compte ET *toutes* les autres requêtes.
  - Pour `print`, la logique est légèrement différente : elle sélectionne les transactions qui correspondent à *l'une* des requêtes de description ET qui possèdent au moins une écriture correspondant à *l'une* des requêtes de compte positives.
- **Négation** : Le préfixe `not:` inverse une requête. Par exemple, `not:status:*` sélectionne toutes les transactions qui ne sont pas validées.
- **Requêtes booléennes** : Pour des combinaisons plus complexes, la syntaxe `expr:'...'` permet d'utiliser les opérateurs `AND`, `OR`, et `NOT`. Par exemple : `expr:'date:2023 AND (desc:amazon OR desc:amzn)'`.

Ce langage de requête peut être appliqué à la vaste gamme de commandes de hledger, qui seront maintenant cataloguées.

## 6. Catalogue des Commandes

Cette section sert de guide de référence rapide pour les commandes hledger, regroupées par fonction pour faciliter leur découverte et leur utilisation.

### 6.1. Commandes d'Entrée de Données

- `**add**` : Lance une session interactive en ligne de commande pour ajouter de nouvelles transactions au journal. Il n'existe pas de commande interactive équivalente pour modifier ou supprimer des transactions ; ces opérations se font en éditant directement le fichier journal avec un éditeur de texte.
- `**import**` : Importe de nouvelles transactions à partir d'autres fichiers (notamment CSV). Sa principale fonctionnalité est d'éviter l'importation de doublons en se souvenant des dernières transactions importées pour chaque fichier source.

### 6.2. Commandes de Rapport Fondamentales

- `**print**` : Affiche les transactions complètes correspondant à une requête, dans le format natif du journal hledger. La sortie est un journal valide qui peut être réutilisé.
- `**register**` **(reg)** : Affiche les écritures individuelles (postings) en ordre chronologique, avec un solde cumulé. Idéal pour un examen détaillé des flux d'un compte.
- `**aregister**` **(areg)** : Affiche les transactions complètes pour un compte spécifique, avec chaque transaction sur une seule ligne et un solde cumulé. Cette vue, similaire à un relevé bancaire, contraste avec `register` qui détaille chaque écriture individuellement.
- `**balance**` **(bal)** : Une commande de rapport polyvalente qui affiche les soldes des comptes. Par défaut, elle montre les **changements de solde** sur la période, ce qui est utile pour les revenus/dépenses. Avec l'option `-H` (`--historical`), elle affiche les **soldes de fin de période historiques**, ce qui est plus adapté aux actifs/passifs.

### 6.3. Rapports Financiers Standards

Ces commandes sont des variantes pratiques de `balance` avec des options prédéfinies. Elles tirent leur intelligence des types de comptes (`A`, `L`, `E`, `R`, `X`, `C`) définis via la directive `account` (décrite en section 3.1) pour générer des états financiers conventionnels.

- `**balancesheet**` **(bs)** : Affiche un bilan des comptes d'**Actifs** (`Assets`) et de **Passifs** (`Liabilities`).
- `**balancesheetequity**` **(bse)** : Affiche un bilan complet incluant les **Actifs**, les **Passifs** et les **Capitaux Propres** (`Equity`).
- `**incomestatement**` **(is)** : Affiche un compte de résultat avec les comptes de **Revenus** (`Revenue`) et de **Dépenses** (`Expense`).
- `**cashflow**` **(cf)** : Affiche un tableau des flux de trésorerie pour les comptes de type **Liquidités** (`Cash`).

### 6.4. Commandes de Maintenance et de Génération

- `**check**` : Vérifie l'intégrité du journal en contrôlant les assertions de solde, les comptes non déclarés (en mode strict), les dates non ordonnées, et d'autres erreurs potentielles.
- `**close**` : Génère des transactions de clôture. En mode `--retain`, elle génère une transaction qui transfère les soldes des comptes de revenus et de dépenses vers les capitaux propres.
- `**rewrite**` : Réécrit les transactions en ajoutant de nouvelles écritures. Actuellement, sa fonctionnalité est similaire à celle de `print --auto`.

La puissance de ces commandes est décuplée par les concepts de reporting avancés qui permettent de transformer la manière dont les données sont calculées et affichées.

## 7. Concepts de Reporting Avancés

Cette section explore les mécanismes avancés qui permettent de passer d'un simple affichage de données à une véritable analyse financière, en valorisant les actifs, en projetant les finances futures et en suivant les budgets.

### 7.1. Reporting au Coût vs. à la Valeur de Marché

hledger peut afficher les soldes en se basant soit sur leur coût d'origine, soit sur leur valeur de marché actuelle.

- **Reporting au Coût (**`**-B**` **/** `**--cost**`**)** : Cette option convertit les montants des commodités à leur coût d'acquisition ou de vente, tel qu'il a été enregistré dans la transaction via la notation `@` (coût unitaire) ou `@@` (coût total). C'est utile pour calculer le coût de base des investissements.
- **Reporting à la Valeur de Marché (**`**-V**`**,** `**-X**`**,** `**--value**`**)** : Ces options convertissent les montants à leur valeur de marché.
  - Elles utilisent les prix déclarés via la directive `P` (décrite en section 3.1).
  - Avec l'option `--infer-market-prices`, hledger peut aussi déduire les prix de marché à partir des coûts enregistrés dans les transactions.
  - La commande `--value=now,USD` est particulièrement utile : `now` indique d'utiliser les prix les plus récents disponibles, et `,USD` force la conversion de toutes les commodités vers la devise cible (ici, l'USD).

### 7.2. Prévisions (Forecasting)

L'option `--forecast` permet de projeter les soldes futurs en générant des transactions temporaires basées sur les règles périodiques (`~`) définies dans le journal.

- **Génération** : Les transactions prévisionnelles sont générées pour une période spécifique.
- **Règle de fin de période** : La période de prévision se termine à la date la plus précoce parmi les suivantes :
  1. La date de fin spécifiée dans la règle périodique elle-même (ex: `~ ... to 2026/01/01`).
  2. La date de fin fournie via `--forecast=PERIODE`.
  3. La date de fin du rapport fournie via `-e DATE`.
  4. La valeur par défaut de **180 jours** à partir d'aujourd'hui.
- **Méthode robuste** : Pour garantir une date de fin précise et éviter les surprises, il est recommandé de toujours spécifier la limite dans la commande elle-même, en utilisant `-e DATE` ou `--forecast=PERIODE`.

### 7.3. Budgétisation (Budgeting)

La commande `balance` combinée à l'option `--budget` transforme les règles périodiques (`~`) en objectifs budgétaires.

- **Fonctionnement** : Le rapport généré compare les montants réels dépensés ou gagnés dans chaque catégorie aux objectifs définis dans les règles `~`.
- **Analyse** : Cela permet de voir rapidement où le budget est respecté, dépassé ou sous-utilisé, avec des pourcentages de réalisation affichés pour chaque poste.

Un des usages les plus puissants de hledger est l'automatisation de l'entrée de données, notamment via l'importation de fichiers CSV, qui possède son propre système de règles.

## 8. Importation de Données CSV

L'importation de fichiers CSV est une fonctionnalité clé pour automatiser la saisie de transactions à partir de relevés bancaires ou d'autres sources de données structurées. Le processus est entièrement contrôlé par un fichier de règles (`.rules`) qui sert de moteur de transformation.

### 8.1. Le Fichier de Règles (`.csv.rules`)

Pour chaque fichier de données (ex: `releve.csv`), hledger recherche un fichier de règles correspondant (ex: `releve.csv.rules`) pour savoir comment interpréter et convertir les données.

Voici les directives de base d'un fichier de règles :

- `**skip N**` : Ignore les `N` premières lignes du fichier CSV, généralement pour sauter les en-têtes ou les lignes de métadonnées.
- `**fields ...**` : Nomme les colonnes du fichier CSV dans l'ordre. Les colonnes non pertinentes peuvent être laissées vides ou nommées `_`.
- `**date-format ...**` : Spécifie le format des dates dans le CSV si celui-ci n'est pas standard (ex: `%-d/%-m/%Y`).
- `**decimal-mark ,**` : Déclare la virgule comme séparateur décimal, essentiel pour les relevés européens.

### 8.2. Assignation des Champs et Catégorisation

La conversion s'effectue en assignant les colonnes du CSV aux champs d'une transaction hledger.

- **Syntaxe** : `CHAMP_HLEDGER %CHAMP_CSV`.
- **Champs essentiels** : Pour générer une transaction, il faut au minimum définir `date`, `amount`, `account1` et `account2`. La `description` est également fortement recommandée.
- **Rôles typiques** : Généralement, `account1` est défini de manière statique pour représenter le compte bancaire d'où provient le relevé, tandis que `account2` est assigné dynamiquement pour catégoriser la dépense ou le revenu.
- **Catégorisation** : La méthode standard pour assigner `account2` est d'utiliser une série de blocs `if`. Chaque bloc teste le contenu de la description ou d'un autre champ CSV et, s'il y a correspondance, assigne le compte de destination approprié.
- **Priorité des règles** : Seule la dernière assignation lue pour un champ donné est conservée. Cela permet de définir une catégorie par défaut, puis de l'affiner avec des règles plus spécifiques.

### 8.3. Logique Conditionnelle Avancée

- `**if**` **et** `**if table**` : Les blocs `if` permettent de définir des conditions pour appliquer des règles. La syntaxe `if table` est une manière plus compacte d'écrire une longue série de remplacements simples.
- **Logique AND** : Pour qu'une règle ne s'applique que si plusieurs conditions sont remplies, on peut utiliser :
  - L'opérateur `&&` pour combiner plusieurs conditions sur une même ligne (ex: `%description amazon && %amount ^-`).
  - Le préfixe `&` sur une ligne de condition successive à l'intérieur d'un bloc `if`.

hledger gère également d'autres formats de données spécialisés, notamment pour le suivi du temps.

## 9. Autres Formats de Données

hledger étend son utilité au-delà de la pure finance en supportant des formats de fichiers dédiés au suivi du temps. Cela permet de quantifier, d'analyser et de rapporter le temps passé on diverses activités, en le traitant comme n'importe quelle autre commodité.

### 9.1. Suivi du Temps avec `timeclock`

Le format `timeclock` est conçu pour un enregistrement précis du temps.

- **Format** : Le fichier est une série d'entrées horodatées commençant par `i` (pour *clock-in* ou début) ou `o` (pour *clock-out* ou fin).
- **Génération de transaction** : Une paire d'entrées `i` et `o` pour un même compte/projet génère une transaction hledger. Le montant de la transaction est la durée calculée entre le *clock-in* et le *clock-out*, exprimée en heures (`h`).

`i 2015/03/30 09:00:00 projet:alpha` `o 2015/03/30 10:00:00`

### 9.2. Suivi du Temps avec `timedot`

Le format `timedot` est une méthode plus simple et souvent plus approximative pour enregistrer le temps.

- **Format** : Un fichier `timedot` commence par une date, suivie de lignes indentées représentant les "écritures" de temps pour cette journée.
- **Syntaxe** : Sur chaque ligne d'écriture, des points (`.`) peuvent être utilisés pour représenter des fractions de temps (chaque `.` vaut 0,25 heure), ou un nombre peut directement indiquer une durée en heures.

```timedot
2023-05-01
    projet:alpha    .... ....  ; 2 heures
    projet:beta     ..         ; 0.5 heure
    admin           1.5        ; 1.5 heures
```

Ce manuel a couvert l'ensemble des fonctionnalités. Une annexe récapitulative est fournie pour une consultation rapide.

## 10. Annexe : Aide-mémoire

Cette section condense les syntaxes les plus courantes pour une référence rapide lors de l'utilisation quotidienne de hledger.

### 10.1. Aide-mémoire de la Syntaxe du Journal

```hledger
# Ceci est un commentaire de ligne

; Déclaration d'un compte avec son type
account actifs:banque:courant  ; type:C

; Déclaration d'une devise avec son style d'affichage
commodity $1,000.00

; Déclaration d'un prix de marché
P 2024-03-01 AAPL $179

; Règle de transaction périodique (notez les deux espaces après la période)
~ monthly  Salaire
    revenus:salaire    $-5000
    actifs:banque:courant

; Structure d'une transaction complète
2024-01-15 * (123) Magasin X | Achat de matériel
    dépenses:fournitures      $75.50
    actifs:banque:courant     $-75.50 = $4924.50 ; Assertion de solde
```

### 10.2. Aide-mémoire des Règles CSV

```csv-rules
# Ignorer la première ligne du fichier CSV
skip 1

# Déclarer le séparateur décimal
decimal-mark ,

# Nommer les colonnes du CSV
fields date,description,_,amount

# Spécifier le format de date
date-format %d/%m/%Y

# Assignations de base pour une transaction à deux écritures
account1 actifs:banque
amount %amount
description %description

# Catégorisation conditionnelle de la contrepartie (account2)
if Carrefour
    account2 dépenses:alimentation

if Amazon
    account2 dépenses:achats-en-ligne
```
