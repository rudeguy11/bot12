FROM node:24-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production
ENV MC_VERSION=26.1

COPY package.json ./
RUN npm install --omit=dev

COPY . .

CMD ["npm", "start"]
