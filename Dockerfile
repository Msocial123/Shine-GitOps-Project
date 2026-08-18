# Dockerfile example
FROM node:20-alpine

# Pull in the latest patched OS packages (e.g. openssl) on top of the
# base image layer.
RUN apk update && apk upgrade --no-cache

# The npm CLI bundled into the base image carries its own internal
# dependencies (tar, brace-expansion, sigstore, ...) which can be behind
# on CVE fixes even on a fresh base image. Update npm itself so those
# bundled deps are current too.
RUN npm install -g npm@11

WORKDIR /Capsule

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3130  
CMD ["npm", "start"]
