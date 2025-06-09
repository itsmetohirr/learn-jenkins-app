FROM node:18-aplipe

WORKDIR /root/project

COPY learn-jenkins-app .

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]
