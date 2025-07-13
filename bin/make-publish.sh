#!/usr/bin/env bash
#.'. - comment make-publish.sh
#.'. - comment Publica una imagen Docker en Google Container Registry (GCR).
 #.'. - comment Solo acepta dos argumentos: image=gcr=n.n.n y project_id=xxxx. No hace login ni valida permisos de gcloud.
#.'. - comment El nombre de la imagen se toma automáticamente del nombre del directorio del repositorio.
#.'. - comment Esto permite reutilizar el script en cualquier proyecto siguiendo la convención de nombres.
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "❌ ERROR: Debes pasar exactamente dos argumentos: image=gcr=n.n.n project_id=xxxx" >&2
  exit 1
fi
ARG_IMAGE="$1"
ARG_PROJECT="$2"
IMAGE_NAME="$(basename "$(pwd)")"

if [[ "$ARG_IMAGE" =~ ^image=gcr=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
else
  echo "❌ ERROR: El primer argumento debe ser image=gcr=n.n.n (semver)" >&2
  exit 2
fi

if [[ "$ARG_PROJECT" =~ ^project_id=([a-zA-Z0-9-]+)$ ]]; then
  PROJECT_ID="${BASH_REMATCH[1]}"
else
  echo "❌ ERROR: El segundo argumento debe ser project_id=xxxx" >&2
  exit 3
fi

GCR_IMAGE="gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${VERSION}"

echo "☁️ markitos - terramock: publish de imagen Docker en GCR"
echo "🔖 Etiquetando imagen local como $GCR_IMAGE"
docker tag "$IMAGE_NAME:$VERSION" "$GCR_IMAGE"

echo "📤 Haciendo push a $GCR_IMAGE"
docker push "$GCR_IMAGE"

echo "✅ Imagen publicada exitosamente en $GCR_IMAGE"
