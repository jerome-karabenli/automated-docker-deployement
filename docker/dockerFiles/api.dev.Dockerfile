FROM node:lts-alpine
WORKDIR /usr/src/app/
COPY ./api/ .
COPY ./ssl .
RUN yarn
ENTRYPOINT [ "yarn", "run", "dev" ]
