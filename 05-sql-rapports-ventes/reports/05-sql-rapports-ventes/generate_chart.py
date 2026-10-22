import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.patch.set_facecolor('#0d1117')

# Couleurs
colors = ['#2ea44f', '#58a6ff', '#f78166', '#d2a8ff', '#ffa657']

# --- Chart 1 : Top 5 pays ---
pays = ['USA', 'Canada', 'France', 'Brazil', 'Germany']
ca = [523.06, 303.96, 195.10, 190.10, 156.48]
ax1 = axes[0, 0]
ax1.set_facecolor('#161b22')
bars = ax1.barh(pays[::-1], ca[::-1], color=colors)
ax1.set_title('Top 5 Pays par CA ($)', color='white', fontsize=12, pad=10)
ax1.tick_params(colors='white')
ax1.spines['bottom'].set_color('#30363d')
ax1.spines['left'].set_color('#30363d')
ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)
for bar, val in zip(bars, ca[::-1]):
    ax1.text(bar.get_width() + 5, bar.get_y() + bar.get_height()/2,
             f'${val}', va='center', color='white', fontsize=9)

# --- Chart 2 : Top 5 genres ---
genres = ['Rock', 'Latin', 'Metal', 'Alt & Punk', 'TV Shows']
ventes = [835, 386, 264, 244, 47]
ax2 = axes[0, 1]
ax2.set_facecolor('#161b22')
ax2.bar(genres, ventes, color=colors)
ax2.set_title('Top 5 Genres Musicaux (nb ventes)', color='white', fontsize=12, pad=10)
ax2.tick_params(colors='white')
ax2.spines['bottom'].set_color('#30363d')
ax2.spines['left'].set_color('#30363d')
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)

# --- Chart 3 : Top 5 artistes ---
artistes = ['Iron Maiden', 'U2', 'Metallica', 'Led Zeppelin', 'Lost']
ca_art = [138.6, 105.93, 90.09, 86.13, 81.59]
ax3 = axes[1, 0]
ax3.set_facecolor('#161b22')
bars3 = ax3.barh(artistes[::-1], ca_art[::-1], color=colors)
ax3.set_title('Top 5 Artistes par CA ($)', color='white', fontsize=12, pad=10)
ax3.tick_params(colors='white')
ax3.spines['bottom'].set_color('#30363d')
ax3.spines['left'].set_color('#30363d')
ax3.spines['top'].set_visible(False)
ax3.spines['right'].set_visible(False)

# --- Chart 4 : KPIs ---
ax4 = axes[1, 1]
ax4.set_facecolor('#161b22')
ax4.axis('off')
kpis = [
    ('CA Total', '$2 328.60'),
    ('Factures', '412'),
    ('Clients', '59'),
    ('Pays', '24'),
    ('Titres', '3 503'),
    ('Artistes', '275'),
]
for i, (label, val) in enumerate(kpis):
    row, col = divmod(i, 2)
    ax4.text(col * 0.5 + 0.12, 0.85 - row * 0.3, val,
             color='#2ea44f', fontsize=18, fontweight='bold',
             transform=ax4.transAxes, ha='center')
    ax4.text(col * 0.5 + 0.12, 0.75 - row * 0.3, label,
             color='#8b949e', fontsize=10,
             transform=ax4.transAxes, ha='center')
ax4.set_title('KPIs Globaux', color='white', fontsize=12, pad=10)

fig.suptitle('Rapport de Ventes SQL — Base Chinook', 
             color='white', fontsize=16, fontweight='bold', y=1.01)

plt.tight_layout()
plt.savefig('images/00_dashboard_sql.png', dpi=150, bbox_inches='tight',
            facecolor='#0d1117')
print("Image sauvegardée : images/00_dashboard_sql.png")