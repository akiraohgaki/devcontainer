FROM docker.io/library/ubuntu:latest

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt update \
  && apt install -y --no-install-recommends \
  apt-transport-https gnupg ca-certificates \
  curl unzip build-essential git nano \
  sudo \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sSLf https://raw.githubusercontent.com/tj/n/master/bin/n -o /usr/local/bin/n \
  && chmod 755 /usr/local/bin/n \
  && n lts

RUN groupadd -g $USER_GID $USERNAME \
  && useradd -m -s /bin/bash -u $USER_UID -g $USER_GID $USERNAME \
  && gpasswd -a $USERNAME sudo \
  && echo "$USERNAME:$USERNAME" | chpasswd \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME

WORKDIR /home/$USERNAME
