# Dockerfile example
FROM node:20-alpine

WORKDIR /Capsule

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3130  
CMD ["npm", "start"]
