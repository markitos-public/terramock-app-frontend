# terramock-app-frontend

## Flujo de trabajo alineado

### Variables obligatorias
- `version` debe tener el formato:
  - `local=n.n.n` o `google=n.n.n` para `make image` y `make run`
  - `version=n.n.n` para `make delete` y `make publish`
- `project_id` debe ser el ID de tu proyecto en GCP (por ejemplo, `terramock`)

### Comandos principales

- **Construir imagen:**
  ```sh
  make image version=local=1.2.3         # 🏗️  Local
  make image version=google=1.2.3        # 🏗️  Google Artifact Registry
  ```

- **Ejecutar imagen:**
  ```sh
  make run version=local=1.2.3           # 🏃 Local
  make run version=google=1.2.3          # 🏃 Desde GCR
  ```

- **Publicar en Artifact Registry:**
  ```sh
  make publish version=version=1.2.3 project_id=terramock   # 🚚 Publicar
  ```

- **Eliminar imágenes:**
  ```sh
  make delete version=version=1.2.3      # 🧹 Eliminar local, GCR y Artifact Registry
  ```

- **Ayuda:**
  ```sh
  make help                              # 📖 Ayuda completa
  ```

---

#### 🎯 EJEMPLOS RÁPIDOS

```sh
make image version=local=1.2.3
make image version=google=1.2.3
make run version=local=1.2.3
make run version=google=1.2.3
make publish version=version=1.2.3 project_id=terramock
make delete version=version=1.2.3
make help
```

### Notas y convenciones
- Todos los comandos requieren que la variable `version` esté en el formato correcto según el target.
- El Makefile valida el formato antes de ejecutar los scripts.
- Los scripts solo aceptan un argumento y validan su formato.
- El código es limpio, directo y alineado con buenas prácticas (KISS, YAGNI, SOLID).
- El nombre de la imagen se toma automáticamente del nombre del directorio del repositorio.
- No se realiza login ni validación de permisos de gcloud en los scripts.

---
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

---

## 📦 CI/CD: Publicar imagen Docker en Artifact Registry (GCP) con GitHub Actions

### Pipeline automático

Cada vez que creas un tag semver **estricto** (ejemplo: `1.2.3`) y lo pusheas a GitHub, se construye y publica la imagen Docker en Artifact Registry usando ese tag como versión.

#### Requisitos previos

- Haber creado un repositorio Artifact Registry en GCP llamado `terramock-docker-registry` en la región `us-east1`.
- Añadir estos secretos en la configuración del repositorio de GitHub:
  - `GCP_PROJECT_ID`: ID de tu proyecto GCP (ejemplo: `terramock`)
  - `GCP_SA_KEY`: Contenido del JSON de una cuenta de servicio con permisos de `Artifact Registry Writer` y `Storage Admin`

#### ¿Qué hace el pipeline?

1. Solo se ejecuta cuando creas un tag semver (`vX.Y.Z`).
2. Hace checkout del código.
3. Configura el SDK de Google Cloud y autentica Docker.
4. Construye la imagen Docker usando el Dockerfile del proyecto.
5. Publica la imagen en Artifact Registry en la ruta:
   ```
   us-east1-docker.pkg.dev/$GCP_PROJECT_ID/terramock-docker-registry/terramock-app-frontend:$TAG
   ```

#### Ejemplo de despliegue manual

Para desplegar la imagen publicada en Cloud Run:

```sh
gcloud run deploy terramock-app-frontend \
  --image us-east1-docker.pkg.dev/$GCP_PROJECT_ID/terramock-docker-registry/terramock-app-frontend:v1.2.3 \
  --region us-east1 \
  --platform managed \
  --allow-unauthenticated
```

> Reemplaza `$GCP_PROJECT_ID` y `v1.2.3` por los valores correspondientes.
