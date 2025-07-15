echo "🗑️ markitos - terramock: delete de imagen Docker"
#!/usr/bin/env bash
# make-delete.sh
# Elimina una imagen Docker local, de GCR y Artifact Registry.
# Solo acepta un argumento: version=n.n.n (semver). No valida si la imagen existe.
# Uso:
#   ./bin/make-delete.sh version=1.2.3
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento version=n.n.n (semver)" >&2
  exit 1
fi
ARG="$1"
IMAGE_NAME="terramock-app-frontend"

if [[ "$ARG" =~ ^version=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  LOCAL_IMAGE="$IMAGE_NAME:$VERSION"
  GCR_IMAGE="gcr.io/terramock/$IMAGE_NAME:$VERSION"
  ARTIFACT_IMAGE="us-central1-docker.pkg.dev/terramock/terramock-docker-registry/$IMAGE_NAME:$VERSION"
  echo "🗑️ markitos - terramock: delete de imagen Docker"
  for IMG in "$LOCAL_IMAGE" "$GCR_IMAGE" "$ARTIFACT_IMAGE"; do
    echo "🗑️ Eliminando $IMG"
    docker rmi "$IMG" || true
  done
  exit 0
else
  echo "❌ ERROR: El argumento debe ser version=n.n.n (semver)" >&2
  exit 2
fi
