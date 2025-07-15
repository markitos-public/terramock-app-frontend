FROM nginx:1.29.0-alpine3.22

RUN apk update && apk upgrade --no-cache openssl

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80