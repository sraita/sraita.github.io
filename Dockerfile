FROM daocloud.io/node:slim
RUN apt-get update && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/* \
    && npm install hexo-cli -g

RUN mkdir -p /root/.ssh
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

RUN echo '2016052013' > /dev/null \
    && git clone -b hexo --recursive https://github.com/sraita/sraita.github.io.git /usr/src/app

WORKDIR /usr/src/app
RUN npm install

COPY config.json /usr/src/app/
RUN git clone -b master https://github.com/sraita/sraita.github.io.git .deploy_git

ADD .gitconfig /root/.gitconfig

ENV NODE_ENV production
EXPOSE 3000

CMD ["node", "server"]