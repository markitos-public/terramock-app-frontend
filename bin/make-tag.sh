#!/usr/bin/env bash
# make-tag.sh
 # Crea y pushea un tag git semver (n.n.n) tras confirmación interactiva.
# Solo acepta un argumento: n.n.n (semver puro, sin prefijo).
# Uso:
#   ./bin/make-tag.sh 1.2.3
set -euo pipefail

echo "🏷️ markitos - terramock: crear y pushear tag git"
if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento n.n.n (semver)" >&2
  exit 1
fi
TAG="$1"
if [[ "$TAG" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "🚩 markitos - terramock: crear y pushear tag git $TAG"
  read -rp "¿Seguro que quieres crear y pushear el tag '$TAG'? [y/N]: " CONFIRM
  if [[ ! "$CONFIRM" =~ ^[yY](es)?$ ]]; then
    echo "❌ Cancelado por el usuario."
    exit 3
  fi
  git tag "$TAG"
  git push origin "$TAG"
  echo "✅ Tag $TAG creado y pusheado."
  exit 0
else
  echo "❌ ERROR: El argumento debe ser n.n.n (semver puro)" >&2
  exit 2
fi
