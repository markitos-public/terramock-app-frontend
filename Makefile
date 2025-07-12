IMAGE_NAME=terramock-app-frontend
PORT?=8080
version?=

.PHONY: image run delete help default

default: help

help:
	@echo "Comandos disponibles:"
	@echo "  make image version=n.n.n   - Construye la imagen Docker localmente (semver requerido)"
	@echo "  make run version=n.n.n     - Ejecuta el contenedor local en el puerto $(PORT)"
	@echo "  make delete version=n.n.n  - Elimina la imagen Docker local"
	@echo "  make help                  - Muestra esta ayuda"

validate_version:
	@if [ -z "$(version)" ] || ! echo $(version) | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo "ERROR: Debes definir version=n.n.n (semver, 3 segmentos)"; exit 1; \
	fi

image: validate_version
	docker build -t $(IMAGE_NAME):$(version) .

run: validate_version
	docker run --rm -it -p $(PORT):80 $(IMAGE_NAME):$(version)

delete: validate_version
	docker rmi $(IMAGE_NAME):$(version) || true
