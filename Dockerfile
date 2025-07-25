FROM node:18-alpine

WORKDIR /root/project

COPY . .

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]
