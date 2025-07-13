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
