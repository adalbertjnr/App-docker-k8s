FROM node:slim

WORKDIR /app

COPY package.json .

RUN npm install

EXPOSE 8080

COPY . .

CMD ["node", "server.js"]


