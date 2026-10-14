"""Télécharge les indicateurs de santé du Tchad depuis l'API Banque Mondiale."""

import requests
import pandas as pd
from pathlib import Path
import time

RAW_DIR = Path(__file__).parent / 'dataset' / 'raw'
RAW_DIR.mkdir(parents=True, exist_ok=True)

COUNTRY = 'TCD'
YEAR_START = 2000
YEAR_END = 2023

INDICATORS = {
    'SH.DYN.MORT': 'mortalite_infantile_pour_1000',
    'SH.STA.STNT.ZS': 'retard_croissance_pct',
    'SH.STA.WAST.ZS': 'emaciation_pct',
    'SH.IMM.MEAS': 'vaccination_rougeole_pct',
    'SH.IMM.IDPT': 'vaccination_dpt_pct',
    'SP.DYN.LE00.IN': 'esperance_vie_annees',
    'SH.XPD.CHEX.PP.CD': 'depenses_sante_usd_hab',
    'SH.MED.PHYS.ZS': 'medecins_pour_1000',
    'SH.MED.BEDS.ZS': 'lits_hopital_pour_1000',
    'SH.STA.MMRT': 'mortalite_maternelle_pour_100k',
}


def fetch_indicator(country, indicator_code, start_year, end_year):
    url = (
        f'https://api.worldbank.org/v2/country/{country}'
        f'/indicator/{indicator_code}'
        f'?date={start_year}:{end_year}&format=json&per_page=500'
    )
    response = requests.get(url, timeout=60)
    response.raise_for_status()
    data = response.json()

    if len(data) < 2 or data[1] is None:
        return pd.DataFrame()

    records = []
    for entry in data[1]:
        records.append({
            'pays': entry['country']['value'],
            'code_pays': entry['countryiso3code'],
            'annee': entry['date'],
            'code_indicateur': entry['indicator']['id'],
            'indicateur': entry['indicator']['value'],
            'valeur': entry['value'],
        })
    return pd.DataFrame(records)


if __name__ == '__main__':
    frames = []
    for code, name in INDICATORS.items():
        try:
            df = fetch_indicator(COUNTRY, code, YEAR_START, YEAR_END)
            if not df.empty:
                df['nom_indicateur'] = name
                frames.append(df)
                non_null = df['valeur'].notna().sum()
                print(f'  OK  {name}: {len(df)} lignes, {non_null} valeurs')
            else:
                print(f'  --  {name}: aucune donnee')
        except Exception as e:
            print(f'  ERR {name}: {e}')
        time.sleep(0.5)

    df_all = pd.concat(frames, ignore_index=True)
    out_path = RAW_DIR / 'chad_health_indicators_raw.csv'
    df_all.to_csv(out_path, index=False)
    print(f'\nTotal: {len(df_all)} lignes -> {out_path}')
