# =============================================================================
#  mania-webui — habillage MANIA de Hermes Web UI
# =============================================================================
#  Image derivee de l'officielle : on n'ajoute que l'habillage visible.
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
