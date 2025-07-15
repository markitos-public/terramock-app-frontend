#!/usr/bin/env bash
 # make-delete-tag.sh
# Borra un tag git semver (n.n.n) local y remoto tras confirmación interactiva.
# Hace checkout a la rama principal antes de borrar el tag.
# Solo acepta un argumento: n.n.n (semver puro, sin prefijo).
# Uso:
#   ./bin/make-delete-tag.sh 1.2.3
set -euo pipefail

echo "🏷️ markitos - terramock: borrar tag git local y remoto"
if [ $# -ne 1 ]; then
  echo "❌ ERROR: Debes pasar exactamente un argumento n.n.n (semver)" >&2
  exit 1
fi
TAG="$1"
if [[ "$TAG" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "🚩 markitos - terramock: borrar tag git $TAG local y remoto"
  read -rp "¿Seguro que quieres borrar el tag '$TAG' en local y remoto? [y/N]: " CONFIRM
  if [[ ! "$CONFIRM" =~ ^[yY](es)?$ ]]; then
    echo "❌ Cancelado por el usuario."
    exit 3
  fi
  # Detectar rama principal (main o master)
  MAIN_BRANCH="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo main)"
  echo "🔀 Haciendo checkout a la rama principal: $MAIN_BRANCH"
  git checkout "$MAIN_BRANCH"
  echo "🗑️ Borrando tag local: $TAG"
  git tag -d "$TAG" || true
  echo "🗑️ Borrando tag remoto: $TAG"
  git push origin ":refs/tags/$TAG"
  echo "✅ Tag $TAG borrado en local y remoto."
  exit 0
else
  echo "❌ ERROR: El argumento debe ser n.n.n (semver puro)" >&2
  exit 2
fi
