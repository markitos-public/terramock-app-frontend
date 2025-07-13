# Terramock App Frontend

## Descripción

Automatización de build, ejecución y publicación de imágenes Docker para este frontend. Todo el flujo está centralizado en scripts portables bajo `bin/`, con el nombre de la imagen derivado automáticamente del nombre del directorio del repositorio.

## Requisitos

- Docker instalado y funcionando.
- Acceso a Google Container Registry (GCR) para publicar imágenes.
- Para publicar en GCR necesitas:
  - Un proyecto de Google Cloud Platform (GCP).
  - Una cuenta de servicio con permisos de `roles/storage.admin` y `roles/artifactregistry.writer`.
  - El archivo de credenciales JSON de la cuenta de servicio.
  - Haber hecho login con:  
    `gcloud auth activate-service-account --key-file=KEY.json`  
    `gcloud auth configure-docker`

## Uso rápido

### Build de imagen local

```sh
make image image=local=1.2.3
```

### Build de imagen para GCR (sin publicar)

```sh
make image image=gcr=1.2.3
```


### Publicar imagen en GCR

Antes de publicar, debes autenticarte con tu key JSON de service account:

```sh
gcloud auth activate-service-account --key-file=key.json
gcloud auth configure-docker
make publish image=gcr=1.2.3 project_id=mi-proyecto-gcp-id
```

### Ejecutar contenedor local

```sh
make run image=local=1.2.3
```

### Eliminar imagen local

```sh
make delete image=local=1.2.3
```

### Ayuda

```sh
make help
```

## Convenciones

- El nombre de la imagen se deriva automáticamente del nombre del directorio del repositorio.
- Todos los argumentos son obligatorios y deben pasarse explícitamente.
- No hay comentarios en el código, solo documentación en cabecera.
- Toda la lógica está en scripts bajo `bin/`.

## Ejemplo completo

```sh
# 1. Autenticarse en GCP
export GOOGLE_APPLICATION_CREDENTIALS=KEY.json
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
gcloud auth configure-docker

# 2. Build y publicar
make image image=gcr=1.2.3
make publish image=gcr=1.2.3 project_id=mi-proyecto-gcp
```


## Anexos

### Instalación de gcloud CLI (solo binario en $HOME/.local/bin)

```sh
mkdir -p "$HOME/.local/bin"
cd /tmp
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-456.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-456.0.0-linux-x86_64.tar.gz
cp -r google-cloud-sdk "$HOME/.local/"
export PATH="$HOME/.local/google-cloud-sdk/bin:$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/google-cloud-sdk/bin:$HOME/.local/bin:$PATH"' >> ~/.bashrc
gcloud version
```

### Instalación de Terraform (solo binario en $HOME/.local/bin)

```sh
mkdir -p "$HOME/.local/bin"
cd /tmp
curl -O https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
unzip terraform_1.8.5_linux_amd64.zip
mv terraform "$HOME/.local/bin/"
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
terraform version
```

---

- Si no tienes permisos para publicar en GCR, solicita a tu administrador una cuenta de servicio con los roles indicados y descarga el JSON de credenciales.
- El sistema es portable y puede usarse en cualquier proyecto Docker siguiendo la misma convención de argumentos.
