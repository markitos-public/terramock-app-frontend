#!/usr/bin/env bash
# make-run.sh
# Ejecuta un contenedor Docker local o de Google Cloud.
# Solo acepta un argumento: local=n.n.n o google=n.n.n (semver).
# Uso:
#   ./bin/make-run.sh local=1.2.3
#   ./bin/make-run.sh google=1.2.3
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento local=n.n.n o google=n.n.n (semver)" >&2
  exit 1
fi
ARG="$1"
IMAGE_NAME="$(basename \"$(pwd)\")"
GCR_REPO="gcr.io/terramock/$IMAGE_NAME"

if [[ "$ARG" =~ ^local=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "🐳 markitos - terramock: run de imagen Docker local"
  docker run --rm -it "$IMAGE_NAME:$VERSION"
  exit 0
elif [[ "$ARG" =~ ^google=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "🐳 markitos - terramock: run de imagen Docker GCR"
  docker run --rm -it "$GCR_REPO:$VERSION"
  exit 0
else
  echo "❌ ERROR: El argumento debe ser local=n.n.n o google=n.n.n (semver)" >&2
  exit 2
fi
#!/usr/bin/env bash
#.'. - comment make-run.sh
#.'. - comment Ejecuta el contenedor local en el puerto indicado.
#.'. - comment Solo acepta un argumento: version=n.n.n. No valida si la imagen existe ni si el puerto está libre.
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento version=n.n.n" >&2
  exit 1
fi
ARG="$1"
IMAGE_NAME="terramock-app-frontend"
PORT="${PORT:-8080}"

echo "🚀 markitos - terramock: run de contenedor Docker"

if [[ "$ARG" =~ ^version=([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
  echo "▶️ Ejecutando $IMAGE_NAME:$VERSION en puerto $PORT"
  docker run --rm -it -p "$PORT":80 "$IMAGE_NAME:$VERSION"
  exit 0
fi


echo "❌ ERROR: El argumento debe ser version=n.n.n" >&2
exit 2
