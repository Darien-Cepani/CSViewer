FROM node:18-alpine

WORKDIR /app

COPY ["package.json","package-lock.json", "./"]
RUN npm install
# RUN npm run build
# RUN npm prune --production # Remove dev dependencies
COPY . .

EXPOSE 3000
# ENV HOST=0.0.0.0