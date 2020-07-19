FROM node:current-alpine3.12 AS buildhelper

WORKDIR /app

RUN apk update --no-cache && apk add git

COPY app/package.json ./
COPY app/package-lock.json ./

RUN npm install

COPY app/ .

FROM node:current-alpine3.12

WORKDIR /app
ARG sha
ARG version
RUN echo $sha
RUN echo $version
ENV SHA=$sha
ENV VERSION=$version
COPY --from=buildhelper /app /app

ENV PORT=3300

EXPOSE ${PORT}

CMD [ "npm", "start" ]