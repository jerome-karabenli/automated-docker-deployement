FROM node:lts-alpine
WORKDIR /usr/src/app/
COPY ./api/ .
RUN yarn
ENTRYPOINT [ "yarn", "run", "start" ]
