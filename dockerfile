# host machine is ubuntu 24.04 amd64
# x11 option for building and testing ecubus-pro
# to build download dockerfile then "sudo docker build -t docker-ecu ."
FROM nikolaik/python-nodejs:python3.12-nodejs22-bullseye

USER root
RUN apt update 
RUN apt install -y git x11-apps gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libnss3 lsb-release xdg-utils wget ca-certificates libgbm-dev xvfb libgtk2.0-0 xdg-utils

USER pn
WORKDIR /home/pn/app

RUN git clone https://github.com/ecubus/EcuBus-Pro.git

WORKDIR /home/pn/app/EcuBus-Pro

# testing sockercan 
# uncomment out to install npm package
# RUN npm install socketcan

RUN npm install

WORKDIR /home/pn/app/EcuBus-Pro/src/main/docan

RUN npx node-gyp rebuild

WORKDIR /home/pn/app/EcuBus-Pro/src/main/dolin

RUN npx node-gyp rebuild

WORKDIR /home/pn/app/EcuBus-Pro/node_modules/electron/dist/

USER root

RUN chown root:root chrome-sandbox
RUN chmod 4755 chrome-sandbox

USER pn
WORKDIR /home/pn/app/EcuBus-Pro

ENV DISPLAY=:0

# before running docker type "xhost +" to allow x11 connections
# sudo docker run -it --name docker-image-app -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --security-opt seccomp=unconfined docker-ecubus
CMD ["npm", "run", "dev"]