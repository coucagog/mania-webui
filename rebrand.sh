#!/bin/sh
# =============================================================================
#  Remplacements CHIRURGICAUX de l'habillage visible.
# =============================================================================
#  🔴 NE JAMAIS faire un `sed s/Hermes/MANIA/g` global : cela casserait
#     l'application. Sont VITAUX et ne doivent pas etre touches :
#       - X-Hermes-CSRF-Token   (en-tete attendu par le serveur)
#       - window.__HERMES_CONFIG__
#       - les cles localStorage (hermes-theme, hermes-skin, ...)
#       - openHermesDashboard()
# =============================================================================
set -eu
M="${1:-MANIA}"
S=/apptoo/static

# --- Titre de l'onglet et de la barre d'application -------------------------
sed -i "s|<title>Hermes</title>|<title>${M}</title>|" "$S/index.html"
sed -i "s|name=\"apple-mobile-web-app-title\" content=\"Hermes\"|name=\"apple-mobile-web-app-title\" content=\"${M}\"|" "$S/index.html"
sed -i "s|id=\"appTitlebarTitle\">Hermes<|id=\"appTitlebarTitle\">${M}<|" "$S/index.html"

# --- Infobulles et bandeaux visibles ----------------------------------------
sed -i "s|Hermes Dashboard|Tableau de bord|g" "$S/index.html"
sed -i "s|Hermes agent is not responding|Agent injoignable|" "$S/index.html"
sed -i "s|when Hermes is reachable again|quand l'agent sera de nouveau joignable|" "$S/index.html"

# --- Manifeste PWA -----------------------------------------------------------
sed -i "s|\"name\": \"Hermes\"|\"name\": \"${M}\"|" "$S/manifest.json"
sed -i "s|\"short_name\": \"Hermes\"|\"short_name\": \"${M}\"|" "$S/manifest.json"
sed -i "s|\"description\": \"Hermes AI Agent Web UI\"|\"description\": \"${M} — agent IA\"|" "$S/manifest.json"

# --- Logo de l'ecran d'accueil ----------------------------------------------
# On MASQUE leur SVG en ligne plutot que de le decouper : plus sur, et resiste
# mieux a un changement de structure lors d'une montee de version.
cat >> "$S/style.css" <<'CSS'

/* ── Habillage MANIA ──────────────────────────────────────────────────────── */
.empty-logo svg { display: none !important; }
.empty-logo {
  width: 200px;
  height: 52px;
  margin: 0 auto;
  background: url("logo.svg") no-repeat center / contain;
}
html.dark .empty-logo { background-image: url("logo-dark.svg"); }
CSS

# --- Degrade du carre de la page de connexion --------------------------------
# (le NOM et l'INITIALE viennent du reglage `bot_name`, pas de l'image)
sed -i "s|linear-gradient(145deg,#e8a030,#e94560)|linear-gradient(145deg,#F08C6A,#D4785A)|" /apptoo/api/routes.py

echo "Habillage ${M} applique."
