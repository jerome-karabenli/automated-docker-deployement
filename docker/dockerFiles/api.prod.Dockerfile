FROM node:lts-alpine
WORKDIR /usr/src/app/
COPY ./api/ .
COPY ./ssl ./ssl
RUN yarn install --production=true
EXPOSE 3000
ENTRYPOINT [ "yarn", "run", "start" ]
