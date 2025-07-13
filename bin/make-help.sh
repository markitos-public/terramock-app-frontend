#!/usr/bin/env bash
#.'. - comment make-help.sh
 #.'. - comment Muestra la ayuda de uso de los comandos make. Cada comando acepta solo los argumentos indicados, sin valores por defecto.
#.'. - comment El nombre de la imagen se toma automáticamente del nombre del directorio del repositorio.
#.'. - comment Esto permite reutilizar los scripts en cualquier proyecto siguiendo la convención de nombres.
set -euo pipefail

echo "📝 markitos - terramock: ayuda de comandos disponibles"
echo "  make image image=local=n.n.n                - Construye la imagen Docker local (semver requerido)"
echo "  make image image=gcr=n.n.n                  - Construye la imagen Docker para GCR (semver requerido)"
echo "  make run version=n.n.n                      - Ejecuta el contenedor local en el puerto \\${PORT}"
echo "  make delete version=n.n.n                   - Elimina la imagen Docker local"
echo "  make publish image=gcr=n.n.n project_id=xx  - Publica la imagen en GCR (usa make-publish.sh)"
echo "  make help                                   - Muestra esta ayuda"
echo "      Ejemplo: make image image=gcr=1.2.3"
echo "      Ejemplo: make image image=local=1.2.3"
