#!/usr/bin/env bash
#.'. - comment make-image.sh
#.'. - comment Construye una imagen Docker local o para GCP.
 #.'. - comment Solo acepta un argumento: local=n.n.n o gcr=n.n.n. No hace push ni publica.
#.'. - comment El nombre de la imagen se toma automáticamente del nombre del directorio del repositorio.
#.'. - comment Esto permite reutilizar el script en cualquier proyecto siguiendo la convención de nombres.
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento local=n.n.n o gcr=n.n.n" >&2
  exit 1
fi
INPUT_ARG="$1"
IMAGE_NAME="$(basename "$(pwd)")"
GCR_REPO="gcr.io/terramock/$IMAGE_NAME"

echo "🐳 markitos - terramock: build de imagen Docker"


if [[ "$INPUT_ARG" =~ ^local=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "🔨 Construyendo imagen local: $IMAGE_NAME:$VERSION"
  docker build -t "$IMAGE_NAME:$VERSION" .
  exit 0
fi

if [[ "$INPUT_ARG" =~ ^gcr=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "🔨 Construyendo imagen GCR: $GCR_REPO:$VERSION"
  docker build -t "$GCR_REPO:$VERSION" .
  exit 0
fi

echo "❌ ERROR: El argumento debe ser local=n.n.n o gcr=n.n.n (semver)" >&2
exit 2