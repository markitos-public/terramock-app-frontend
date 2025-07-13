#!/usr/bin/env bash
#.'. - comment make-delete.sh
#.'. - comment Elimina una imagen Docker local o de GCP.
#.'. - comment Solo acepta un argumento: version=n.n.n o image=gcr.io/PROJECT_ID/IMAGE_NAME:TAG (semver). No valida si la imagen existe.
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento version=n.n.n o image=gcr.io/PROJECT_ID/IMAGE_NAME:TAG" >&2
  exit 1
fi
ARG="$1"
IMAGE_NAME="terramock-app-frontend"

echo "🗑️ markitos - terramock: delete de imagen Docker"

if [[ "$ARG" =~ ^version=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "🗑️ Eliminando $IMAGE_NAME:$VERSION"
  docker rmi "$IMAGE_NAME:$VERSION" || true
  exit 0
fi

if [[ "$ARG" =~ ^image=(gcr\.io/[a-zA-Z0-9-]+/[a-zA-Z0-9._-]+:[0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  IMAGE="${BASH_REMATCH[1]}"
  echo "🗑️ Eliminando $IMAGE"
  docker rmi "$IMAGE" || true
  exit 0
fi

echo "❌ ERROR: El argumento debe ser version=n.n.n o image=gcr.io/PROJECT_ID/IMAGE_NAME:TAG (semver)" >&2
exit 2
