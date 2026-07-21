#!/usr/bin/env bash
# Construit l'image habillee. A relancer a CHAQUE montee de version amont.
set -euo pipefail
VERSION="${1:-0.51.834}"
MARQUE="${2:-MANIA}"

docker build \
  --build-arg BASE_VERSION="$VERSION" \
  --build-arg MARQUE="$MARQUE" \
  -t "mania-webui:$VERSION" \
  -t "mania-webui:latest" .

echo
echo "Construit : mania-webui:$VERSION (et :latest)"
echo "Verifier :  docker run --rm mania-webui:latest grep -o '<title>[^<]*' /apptoo/static/index.html"
