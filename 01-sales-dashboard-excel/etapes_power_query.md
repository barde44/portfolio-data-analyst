# 🔧 Étapes Power Query - Préparation des données Superstore

> **Projet** : Tableau de bord des ventes avec Excel  
> **Dataset** : Sample - Superstore (Kaggle)  
> **Outil** : Power Query (Excel)  
> **Date** : Mai 2026

---

## 🎯 Objectif de ce document

Documenter **toutes les étapes** de préparation et de nettoyage des données effectuées avec Power Query avant de pouvoir construire le tableau de bord. Ce document sert de **journal de bord** reproductible : si tu dois refaire le projet (ou aider un collègue), tu sauras exactement quoi faire.

---

## 📁 Structure du dossier projet

```
Portfolio-Data-Analyst/
└── 01-sales-dashboard-excel/
    ├── dataset/
    │   └── Sample - Superstore.csv
    ├── dashboard/
    │   └── Superstore_Dashboard.xlsx
    ├── images/
    ├── reports/
    ├── README.md
    └── etapes_power_query.md  ← ce fichier
```

---

## 🚨 Problèmes rencontrés au début

### Problème 1 : CSV mal séparé

Lors de l'ouverture directe du fichier `Sample - Superstore.csv` dans Excel (en français), toutes les données apparaissaient **dans une seule colonne**. Excel français attend le `;` comme séparateur, alors que le fichier utilisait la `,`.

### Problème 2 : Dates au mauvais format

Le dataset utilise le format de date **américain** (`MM/DD/YYYY`), alors qu'Excel français interprétait les dates en **DD/MM/YYYY**. Résultat : certaines dates s'affichaient correctement, d'autres en erreur.

### Problème 3 : Nombres stockés comme texte

Les colonnes `Sales`, `Discount` et `Profit` étaient considérées comme du **texte** (icône `ABC`), donc la fonction `SOMME()` retournait des valeurs incorrectes (ex : 27 635 $ au lieu de 2 297 200 $).

### Problème 4 : Cellules vides parasites

L'utilisation de l'option "Convertir le texte en colonnes" (méthode dépassée) avait découpé les données de manière incorrecte sur certaines lignes contenant des virgules dans les noms de produits, créant **6 cellules vides** dans la colonne `Sales`.

---

## ✅ Solution adoptée : Power Query

Power Query est l'outil intégré à Excel qui permet d'**importer**, **transformer** et **nettoyer** les données de manière reproductible. Toutes les étapes sont enregistrées et peuvent être réappliquées automatiquement à chaque actualisation des données.

---

## 📝 Étapes Power Query détaillées

### Étape 1 — Importer le CSV proprement

1. Ouvrir un **nouveau classeur Excel vide** (ne pas double-cliquer sur le CSV)
2. Onglet **Données** → **Nouvelle requête** → **À partir d'un fichier** → **À partir d'un fichier CSV**
3. Sélectionner `Sample - Superstore.csv`
4. Dans la fenêtre d'aperçu :
   - **Origine du fichier** : `1252 : Europe occidentale (Windows)`
   - **Délimiteur** : `Virgule`
   - **Détection du type de données** : `Basé sur les 200 premières lignes`
5. Cliquer sur **Transformer les données** *(et NON sur "Charger" — on veut nettoyer avant)*

### Étape 2 — Vérifier les types de colonnes

Power Query a auto-détecté certains types, mais a laissé d'autres colonnes en texte. Voici les types **corrects** à appliquer :

| Colonne | Type attendu | Icône |
|---|---|---|
| Row ID | Nombre entier | `123` |
| Order ID | Texte | `ABC` |
| **Order Date** | **Date** | `📅` |
| **Ship Date** | **Date** | `📅` |
| Ship Mode | Texte | `ABC` |
| Customer ID | Texte | `ABC` |
| Customer Name | Texte | `ABC` |
| Segment | Texte | `ABC` |
| Country | Texte | `ABC` |
| City | Texte | `ABC` |
| State | Texte | `ABC` |
| Postal Code | Nombre entier | `123` |
| Region | Texte | `ABC` |
| Product ID | Texte | `ABC` |
| Category | Texte | `ABC` |
| Sub-Category | Texte | `ABC` |
| Product Name | Texte | `ABC` |
| **Sales** | **Nombre décimal** | `1.2` |
| Quantity | Nombre entier | `123` |
| **Discount** | **Nombre décimal** | `1.2` |
| **Profit** | **Nombre décimal** | `1.2` |

### Étape 3 — Convertir les dates avec la bonne locale ⚠️

C'est l'étape **critique** qui résout le problème des dates au format américain.

**Pour `Order Date` :**

1. **Clic droit** sur l'en-tête `Order Date`
2. **Modifier le type** → **Avec les paramètres régionaux...**
3. Dans la fenêtre :
   - **Type de données** : `Date`
   - **Paramètres régionaux** : `Anglais (États-Unis)` ⚠️
4. **OK**
5. Si demandé : **Ajouter une nouvelle étape** (pas Remplacer)

**Refaire EXACTEMENT la même chose pour `Ship Date`.**

> 💡 **Pourquoi "Anglais (États-Unis)" ?**  
> Le format américain est `MM/DD/YYYY`. Sans cette locale, Power Query interprète les dates comme `DD/MM/YYYY` (format français), ce qui provoque des erreurs sur les dates où le mois > 12 (ex: `4/15/2017`).

### Étape 4 — Convertir Sales, Discount et Profit en nombre décimal ⚠️

Les nombres dans le CSV utilisent le **point** comme séparateur décimal (`957.5775`). En français, le séparateur est la virgule. Il faut donc forcer la locale anglaise pour la conversion.

**Pour chaque colonne (Sales, Discount, Profit) :**

1. **Clic droit** sur l'en-tête de la colonne
2. **Modifier le type** → **Avec les paramètres régionaux...**
3. Dans la fenêtre :
   - **Type de données** : `Nombre décimal`
   - **Paramètres régionaux** : `Anglais (États-Unis)` ⚠️
4. **OK**
5. Si demandé : **Ajouter une nouvelle étape**

> 💡 **Format anglo-saxon vs français**  
> - Anglo-saxon : `1,234.56` (virgule = milliers, point = décimal)  
> - Français : `1 234,56` (espace = milliers, virgule = décimal)  
> Toujours utiliser la locale qui correspond au **format source** des données.

### Étape 5 — Charger les données dans Excel

1. Onglet **Accueil** dans Power Query
2. Cliquer sur la flèche sous **Fermer et charger**
3. Choisir **Fermer et charger dans...**
4. Dans la fenêtre :
   - **Tableau**
   - **Nouvelle feuille de calcul**
5. **Charger**

⏳ Power Query charge les **9 994 lignes** dans une nouvelle feuille.

### Étape 6 — Renommer le tableau et la feuille

**Renommer le tableau :**

1. Cliquer dans n'importe quelle cellule du tableau chargé
2. Onglet **Création de tableau** → zone **Nom du tableau** (à gauche)
3. Taper : **`tbl_Ventes`** → **Entrée**

**Renommer l'onglet de la feuille :**

1. **Double-clic** sur le nom de l'onglet en bas
2. Taper : **`Donnees`** → **Entrée**

### Étape 7 — Sauvegarder

`Ctrl + S` pour sauvegarder le fichier au format `.xlsx` (jamais en `.csv` pour ne pas perdre les requêtes Power Query, les tableaux croisés dynamiques et les graphiques).

---

## 🔍 Étapes appliquées (visibles dans Power Query)

À la fin du processus, le panneau "Étapes appliquées" de Power Query contient :

1. **Source** — Importation du fichier CSV
2. **En-têtes promus** — Première ligne utilisée comme en-têtes de colonnes
3. **Type modifié** — Auto-détection des types de base
4. **Type modifié avec paramètres régionaux** — Order Date en Date US
5. **Type modifié avec paramètres régionaux** — Ship Date en Date US
6. **Type modifié avec paramètres régionaux** — Sales en Nombre décimal US
7. **Type modifié avec paramètres régionaux** — Discount en Nombre décimal US
8. **Type modifié avec paramètres régionaux** — Profit en Nombre décimal US

> 💡 Ces étapes seront automatiquement ré-appliquées à chaque actualisation de la requête (`Données` → `Actualiser tout`). Si on ajoute de nouvelles lignes au CSV source, elles seront traitées exactement de la même manière.

---

## ✅ Vérifications post-import

Pour vérifier que les données sont correctement chargées, on a créé une feuille `01_Exploration` avec les indicateurs suivants :

| Indicateur | Formule | Valeur attendue |
|---|---|---|
| Nombre total de lignes | `=NBVAL(tbl_Ventes[Order ID])` | **9 994** |
| Nombre de commandes uniques | `=SOMMEPROD(1/NB.SI(tbl_Ventes[Order ID];tbl_Ventes[Order ID]))` | **5 009** |
| Première date | `=MIN(tbl_Ventes[Order Date])` | **03/01/2014** |
| Dernière date | `=MAX(tbl_Ventes[Order Date])` | **30/12/2017** |
| Ventes totales | `=SOMME(tbl_Ventes[Sales])` | **2 297 200,86 $** |
| Profit total | `=SOMME(tbl_Ventes[Profit])` | **286 397,02 $** |
| Cellules vides dans Sales | `=NB.VIDE(tbl_Ventes[Sales])` | **0** |

Si tous ces chiffres sont obtenus, les données sont **propres et fiables** pour la suite du projet.

---

## 🎓 Leçons apprises

1. **Ne jamais ouvrir un CSV directement dans Excel** — toujours passer par Power Query pour ne pas corrompre les dates et les nombres.
2. **Toujours vérifier les types de colonnes** avant de faire des calculs. Un nombre stocké en texte donne `SOMME = 0`.
3. **La locale est cruciale** pour les dates et les nombres décimaux. Toujours choisir la locale qui correspond au **format source** des données, pas à la langue de son Excel.
4. **Power Query enregistre toutes les transformations** : c'est de la documentation automatique et reproductible. C'est l'un des outils les plus puissants d'Excel pour un Data Analyst.
5. **L'exploration et le nettoyage des données représentent 70% du travail.** Sans cette étape rigoureuse, toutes les analyses suivantes seraient fausses.

---

## 📚 Ressources utiles

- [Power Query - Documentation Microsoft](https://learn.microsoft.com/fr-fr/power-query/)
- [Superstore Dataset sur Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- Pour des tutoriels en français : chaîne YouTube **LeCoinStat** par Natacha Njongwa Yepnga

---

*Document rédigé dans le cadre du projet "12 Projets pour devenir Data Analyst"*
