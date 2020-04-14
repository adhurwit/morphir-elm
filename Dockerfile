FROM ubuntu:latest

RUN apt update
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
RUN gunzip elm.gz
RUN chmod +x elm
RUN mv elm /usr/local/bin/

RUN npm install -g morphir-elm

WORKDIR /usr/src/app
COPY . ./

RUN npm run make-cli
RUN morphir-dapr -p examples/ -o examples/Main.elm
WORKDIR /usr/src/app/examples
RUN elm make Main.elm --output=Main.js
RUN npm install

EXPOSE 3000
CMD [ "node", "DaprAppShell.js" ]

