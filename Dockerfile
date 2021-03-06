# build stage
FROM node:14.5-alpine as build-stage

ARG PUBLIC_URL=/

COPY ./ /app
WORKDIR /app
RUN yarn install && yarn run compileLangJsons && cp /app/build/lang/* /app/src/lang && VUE_APP_PUBLIC_URL=${PUBLIC_URL} yarn run build

FROM nginx:stable-alpine
RUN mkdir /app
COPY --from=build-stage /app/dist/release /app
COPY nginx.conf /etc/nginx/nginx.conf
