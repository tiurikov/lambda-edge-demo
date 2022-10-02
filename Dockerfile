FROM node:18-alpine
COPY ./app /app/
WORKDIR /app
CMD ["node", "main.js"]