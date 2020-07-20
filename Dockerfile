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

RUN addgroup -g 1001 nodejs && \
adduser -D -u 1001 -G nodejs nodejs
USER nodejs

ENV PORT=3300

EXPOSE ${PORT}

CMD [ "npm", "start" ]