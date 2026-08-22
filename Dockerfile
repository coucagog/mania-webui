# =============================================================================
#  mania-webui — habillage MANIA de Hermes Web UI
# =============================================================================
#  Image derivee de l'officielle : habillage visible + un correctif fonctionnel
#  documente ci-dessous (derive de version hermes-agent vs webui 0.51.834).
#  Licence amont : MIT (Hermes Web UI Contributors) — /app/LICENSE est conserve,
#  ce qui satisfait la seule obligation de la licence.
#
#  Construction :  ./build.sh [version_amont] [marque]
# =============================================================================
ARG BASE_VERSION=0.51.834
FROM ghcr.io/nesquena/hermes-webui:${BASE_VERSION}

ARG MARQUE=MANIA

# Favicons, logos (references en relatif depuis /app/static/style.css)
COPY assets/ /apptoo/static/

COPY rebrand.sh /tmp/rebrand.sh
RUN sh /tmp/rebrand.sh "${MARQUE}" && rm -f /tmp/rebrand.sh

# --- Correctif 2026-08-22 : derive de version hermes-agent -------------------
# Le pyproject.toml de hermes-agent refuse desormais l'installation NON-editable
# ("Building wheels or sdists for hermes-agent is not supported ... use an
# editable install"), or le script d'init de la webui 0.51.834 fait un
# `uv pip install "$_stage_src[all]"` non-editable -> premier boot en echec en
# boucle (conteneur qui meurt ~30 s, redisparti par la policy). Correctif :
# install EDITABLE (`uv pip install -e`, voie recommandee par le message
# d'erreur amont) + conservation de l'arborescence stagee
# (/tmp/hermes-agent-build) que l'editable reference au runtime.
RUN sed -i 's|uv pip install "$_stage_src\[all\]"|uv pip install -e "$_stage_src[all]"|' /hermeswebui_init.bash \
 && sed -i '/uv pip install -e "$_stage_src\[all\]"/,+2s|rm -rf "$_stage_src"|# rm -rf conserve (correctif 2026-08-22) : l install editable pointe vers cette arborescence|' /hermeswebui_init.bash \
 && grep -c 'uv pip install -e "$_stage_src\[all\]"' /hermeswebui_init.bash
