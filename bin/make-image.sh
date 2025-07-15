#!/usr/bin/env bash
# make-image.sh
# Construye una imagen Docker local o para Google Cloud.
# Solo acepta un argumento: local=n.n.n o google=n.n.n (semver). No hace push ni publica.
# El nombre de la imagen se toma automáticamente del nombre del directorio del repositorio.
# Uso:
#   ./bin/make-image.sh local=1.2.3
#   ./bin/make-image.sh google=1.2.3
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento local=n.n.n o google=n.n.n (semver)" >&2
  exit 1
fi
ARG="$1"
IMAGE_NAME="$(basename "$(pwd)")"
GCR_REPO="gcr.io/terramock/$IMAGE_NAME"

if [[ "$ARG" =~ ^local=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "🐳 markitos - terramock: build de imagen Docker"
  echo "� Construyendo imagen local: $IMAGE_NAME:$VERSION"
  docker build -t "$IMAGE_NAME:$VERSION" .
  exit 0
elif [[ "$ARG" =~ ^google=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "🐳 markitos - terramock: build de imagen Docker"
  echo "🔨 Construyendo imagen GCR: $GCR_REPO:$VERSION"
  docker build -t "$GCR_REPO:$VERSION" .
  exit 0
else
  echo "❌ ERROR: El argumento debe ser local=n.n.n o google=n.n.n (semver)" >&2
  exit 2
fi