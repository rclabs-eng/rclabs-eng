FROM ubuntu:20.04

ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y
RUN apt-get install sudo tzdata
RUN sudo apt-get -y install make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm
RUN sudo apt-get -y install libncurses5-dev unzip libncursesw5-dev xz-utils \
tk-dev libffi-dev liblzma-dev python-openssl git bash-completion redis-server nano libpq-dev nginx redis virtualenv certbot \
build-essential checkinstall libreadline-gplv2-dev libgdbm-dev libc6-dev

RUN useradd -m -U -s /bin/bash dcpms
RUN adduser dcpms sudo
RUN echo "root:root" | chpasswd
RUN echo "dcpms:dcpms" | chpasswd
RUN echo "dcpms ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER dcpms
RUN cd /tmp/ && wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz && tar xzf Python-2.7.18.tgz && cd Python-2.7.18 && \
./configure --prefix=/usr --enable-shared LDFLAGS="-Wl,-rpath /usr/lib" && sudo make && sudo make altinstall

RUN cd /tmp && curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && python2.7 get-pip.py
SHELL ["/bin/bash", "--login", "-c"]
RUN cd /home/dcpms/ && pip install virtualenv  && virtualenv -p python2.7 unifi_virtualenv2.7

RUN mkdir -p /home/dcpms/.ssh && mkdir -p /home/dcpms/.aws && sudo mkdir -p /usr/local/dev && touch /home/dcpms/.aws/config && touch /home/dcpms/.aws/credentials
COPY id_rsa /home/dcpms/.ssh
RUN sudo chown -R dcpms:dcpms /home/dcpms/.ssh/id_rsa
RUN sudo chmod 400 /home/dcpms/.ssh/id_rsa

RUN cd /tmp && wget "http://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz"  && tar -xvf Python-3.8.1.tgz && cd Python-3.8.1 && \
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && sudo make && sudo make altinstall && rm -rf /tmp/Python-3.8.1.tgz
SHELL ["/bin/bash", "--login", "-c"]
RUN cd /home/dcpms && pip3.8 --no-cache-dir install virtualenv --user && virtualenv -p python3.8 orchestrator_virtualenv
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
RUN sudo apt update
RUN sudo apt-get install -y postgresql-12 postgresql-client-12
RUN sudo adduser www-data dcpms

EXPOSE 8001
USER root
COPY startup.sh /startup.sh
RUN sudo chmod +x /startup.sh
ENTRYPOINT /startup.sh && bash




