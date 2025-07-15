FROM nginx:alpine

RUN apk update && apk upgrade --no-cache openssl

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80