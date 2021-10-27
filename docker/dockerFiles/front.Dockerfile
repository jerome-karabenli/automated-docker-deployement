FROM nginx:stable-alpine as builder
COPY ./front/build/ /bin/www
CMD [ "nginx", "-g", "daemon off;" ]

FROM builder as dev
LABEL stage=front_dev
COPY ./docker/nginx/nginx.dev.conf /etc/nginx/conf.d/default.conf

FROM builder as prod
COPY ./docker/nginx/nginx.prod.conf /etc/nginx/conf.d/default.conf
COPY ./ssl/* /etc/ssl/

