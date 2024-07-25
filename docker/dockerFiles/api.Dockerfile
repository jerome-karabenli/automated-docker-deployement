FROM node:20.15.1-alpine3.20 as builder
WORKDIR /usr/src/app/
COPY ./api/ .
ENTRYPOINT [ "yarn", "run", "start" ]

FROM builder as dev
LABEL stage=api_dev
RUN yarn

FROM builder as prod
LABEL stage=api_prod
COPY ./ssl ./ssl
RUN yarn install --production=true
