#!/usr/bin/env bash
# make-publish.sh
# Publica una imagen Docker en Artifact Registry.
# Solo acepta dos argumentos: version=n.n.n (semver) y project_id=xxxx. No hace login ni valida permisos de gcloud.
# El nombre de la imagen se toma automáticamente del nombre del directorio del repositorio.
# Uso:
#   ./bin/make-publish.sh version=1.2.3 project_id=xxxx
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "❌ ERROR: Debes pasar exactamente dos argumentos: version=n.n.n project_id=xxxx" >&2
  exit 1
fi
ARG_VERSION="$1"
ARG_PROJECT="$2"
IMAGE_NAME="$(basename "$(pwd)")"

if [[ "$ARG_VERSION" =~ ^version=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
else
  echo "❌ ERROR: El primer argumento debe ser version=n.n.n (semver)" >&2
  exit 2
fi

if [[ "$ARG_PROJECT" =~ ^project_id=([a-zA-Z0-9-]+)$ ]]; then
  PROJECT_ID="${BASH_REMATCH[1]}"
elif [[ "$ARG_PROJECT" =~ ^([a-zA-Z0-9-]+)$ ]]; then
  PROJECT_ID="${BASH_REMATCH[1]}"
else
  echo "❌ ERROR: El segundo argumento debe ser project_id=xxxx o xxxx" >&2
  exit 3
fi

GCR_IMAGE="gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VERSION}"
LOCAL_IMAGE="${IMAGE_NAME}:${VERSION}"
ARTIFACT_REGISTRY_URL="us-central1-docker.pkg.dev/${PROJECT_ID}/terramock-docker-registry/${IMAGE_NAME}:${VERSION}"

if docker image inspect "$GCR_IMAGE" > /dev/null 2>&1; then
  ORIGIN_IMAGE="$GCR_IMAGE"
elif docker image inspect "$LOCAL_IMAGE" > /dev/null 2>&1; then
  ORIGIN_IMAGE="$LOCAL_IMAGE"
else
  echo "❌ ERROR: No se encontró la imagen local ni con tag GCR para version $VERSION" >&2
  exit 4
fi

echo "☁️ markitos - terramock: publish de imagen Docker en Artifact Registry"
echo "🔖 Etiquetando imagen local como $ARTIFACT_REGISTRY_URL (origen: $ORIGIN_IMAGE)"
docker tag "$ORIGIN_IMAGE" "$ARTIFACT_REGISTRY_URL"

docker push "$ARTIFACT_REGISTRY_URL"

echo "✅ Imagen publicada exitosamente en $ARTIFACT_REGISTRY_URL"