FROM docker.io/library/ubuntu:latest

ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_USERNAME=developer
ARG USER_GROUPNAME=developer
ARG USER_PASSWORD=developer

RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  gnupg \
  curl \
  sudo \
  zsh \
  ssh \
  unzip \
  nano \
  git \
  build-essential \
  python3 \
  python3-distutils && \
  apt autoremove && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sSLf https://raw.githubusercontent.com/tj/n/master/bin/n -o /usr/local/bin/n && \
  chmod 755 /usr/local/bin/n && \
  n lts

RUN groupadd -g ${USER_GID} ${USER_GROUPNAME} && \
  useradd -m -s /bin/bash -u ${USER_UID} -g ${USER_GID} ${USER_USERNAME} && \
  gpasswd -a ${USER_USERNAME} sudo && \
  echo "${USER_USERNAME}:${USER_PASSWORD}" | chpasswd && \
  echo "${USER_USERNAME} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

COPY entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

USER ${USER_USERNAME}

WORKDIR /home/${USER_USERNAME}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]
