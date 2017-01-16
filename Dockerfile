FROM debian:jessie
MAINTAINER Atchariya Darote <atchariya@gmail.com>

RUN echo "postfix postfix/mailname string `hostname`" | debconf-set-selections \
    && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

RUN apt-get update && apt-get install -y python-minimal sudo telnet ansible \
  git build-essential python-setuptools python-dev libffi-dev libssl-dev wget \
  libmysqlclient-dev nodejs cron python-mysqldb \
  libxslt1.1 libxslt1-dev redis-server libssl-dev libcrypto++-dev postfix nginx \
  supervisor python-pip fontconfig libxrender1 libxext6 xfonts-75dpi xfonts-base \
  libtiff5-dev libjpeg62-turbo-dev zlib1g-dev libfreetype6-dev \
  liblcms2-dev libwebp-dev tcl8.5-dev tk8.5-dev python-tk npm

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN sudo python get-pip.py

ENV BRANCH=master \
    FRAPPE_USER=frappe \
    ERPNEXT_BRANCH=master

RUN useradd $FRAPPE_USER \
    && usermod -aG sudo frappe \
    && echo 'frappe ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers

RUN mkdir /home/$FRAPPE_USER && chown $FRAPPE_USER:$FRAPPE_USER /home/$FRAPPE_USER
USER $FRAPPE_USER
WORKDIR /home/$FRAPPE_USER

RUN git clone https://github.com/frappe/bench /tmp/.bench
RUN sudo pip install -e /tmp/.bench
RUN bench init frappe-bench && cd frappe-bench

ENV DOCKERIZE_VERSION v0.2.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm *.tar.gz

COPY ./config/ /tmp/config
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sudo chmod +x /usr/local/bin/docker-entrypoint.sh




ENV ADMIN_PASSWORD=frappe \
    DB_HOST=db \
    DB_NAME=frappe \
    DB_PASSWORD=frappe \
    DB_USER=frappe \
    MAIL_LOGIN= \
    MAIL_PASSWORD= \
    MAIL_PORT= \
    MAIL_SERVER= \
    REDIS_CACHE_URL=redis-cache \
    REDIS_QUEUE_URL=redis-queue \
    REDIS_SOCKETIO_URL=redis-socketio \
    ROOT_PASSWORD=root \
    USE_SSL=false \
    DEVELOPER_MODE=true


ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

