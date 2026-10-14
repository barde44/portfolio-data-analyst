# Projet 03 — Nettoyage de données : Indicateurs de santé au Tchad

## Description

Nettoyage et préparation d'un jeu de données de **10 indicateurs de santé** pour le Tchad (2000–2023), extrait de l'API de la Banque Mondiale. Le projet traite les problèmes courants de qualité des données dans le contexte humanitaire : valeurs manquantes, formats incohérents, doublons, et outliers.

**Projet 3 sur 12** du portfolio Data Analyst.

## Source des données

**World Bank Open Data** — [data.worldbank.org](https://data.worldbank.org)

| Indicateur | Code | Unité |
|------------|------|-------|
| Mortalité infantile (< 5 ans) | SH.DYN.MORT | pour 1 000 naissances |
| Retard de croissance (stunting) | SH.STA.STNT.ZS | % enfants < 5 ans |
| Émaciation (wasting) | SH.STA.WAST.ZS | % enfants < 5 ans |
| Vaccination rougeole | SH.IMM.MEAS | % enfants 12-23 mois |
| Vaccination DPT | SH.IMM.IDPT | % enfants 12-23 mois |
| Espérance de vie | SP.DYN.LE00.IN | années |
| Dépenses de santé par habitant | SH.XPD.CHEX.PP.CD | USD courants |
| Médecins pour 1 000 hab. | SH.MED.PHYS.ZS | ratio |
| Lits d'hôpital pour 1 000 hab. | SH.MED.BEDS.ZS | ratio |
| Mortalité maternelle | SH.STA.MMRT | pour 100 000 naissances |

## Méthodologie

1. **Collecte** — Extraction via l'API REST de la Banque Mondiale (`api.worldbank.org/v2`)
2. **Exploration** — Analyse de la structure, des types, et de la complétude
3. **Nettoyage** — Traitement des valeurs manquantes (interpolation linéaire pour les séries temporelles, médiane pour les données ponctuelles), standardisation des types, détection des outliers (IQR)
4. **Validation** — Vérification de cohérence (mortalité ne peut pas augmenter ET espérance de vie augmenter simultanément)
5. **Export** — Dataset nettoyé en CSV, rapport de qualité

## Résultats du nettoyage

| Métrique | Avant | Après |
|----------|-------|-------|
| Lignes totales | 240 | 240 |
| Valeurs manquantes | 58 (24,2%) | 21 (8,8%) |
| Doublons | 0 | 0 |
| Valeurs imputées (interpolation) | — | 37 |
| Réduction des manquantes | — | 63,8% |

### Observations clés (données réelles 2000–2023)

- **Mortalité infantile** : baisse de 182 à 100 pour 1 000 naissances
- **Espérance de vie** : hausse de 48 à 55 ans
- **Vaccination rougeole** : très volatile (15% à 65%), reflétant l'instabilité des campagnes
- **Mortalité maternelle** : forte baisse après 2018 (1 200 → 760 pour 100 000)
- **Lits d'hôpital** : 87,5% de données manquantes — indicateur le plus lacunaire

## Structure du projet

```
03-data-cleaning-health-chad/
├── dataset/
│   ├── raw/                    # Données brutes de l'API
│   └── cleaned/                # Données nettoyées
├── notebooks/
│   └── 03_data_cleaning_chad_health.ipynb
├── images/                     # Visualisations
└── README.md
```

## Outils

- Python 3.x
- pandas, numpy, requests
- matplotlib, seaborn

## Auteur

**Steven Barde** — [github.com/barde44](https://github.com/barde44)
