FROM node:lts-alpine
WORKDIR /usr/src/app/
COPY ./api/ .
ENV NODE_ENV=production
COPY ./ssl .
RUN yarn install --production=true
EXPOSE 3000
ENTRYPOINT [ "yarn", "run", "start" ]
