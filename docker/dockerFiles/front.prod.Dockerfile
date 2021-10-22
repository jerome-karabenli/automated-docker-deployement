FROM nginx:stable-alpine
COPY ./front/build/ /bin/www
COPY ./docker/nginx/nginx.prod.conf /etc/nginx/conf.d/default.conf
COPY ./ssl/* /etc/ssl/
EXPOSE 80
EXPOSE 443
CMD [ "nginx", "-g", "daemon off;" ]