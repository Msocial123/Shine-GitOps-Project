# Dockerfile example

# ---- Build stage: install dependencies -------------------------------
FROM node:20-alpine AS build

WORKDIR /Capsule

COPY package*.json ./
RUN npm install

COPY . .

# ---- Final stage: minimal runtime image -------------------------------
# Starts fresh from the base image (not the build stage) so none of the
# build stage's own tooling carries over.
FROM node:20-alpine

# Pull in the latest patched OS packages (e.g. openssl) on top of the
# base image layer.
RUN apk update && apk upgrade --no-cache

WORKDIR /Capsule

COPY --from=build /Capsule ./

# We run the app via `node server.js` directly (see CMD below), so the
# npm CLI itself is never needed at runtime. It ships its own bundled
# dependencies (tar, undici, brace-expansion, ...) which can carry CVEs
# independent of our app's dependencies - drop it entirely to keep the
# final image's attack surface (and Trivy findings) to just what we
# actually use.
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

EXPOSE 3130
CMD ["node", "server.js"]
