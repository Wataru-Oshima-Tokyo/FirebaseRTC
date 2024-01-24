FROM ubuntu:jammy AS base
RUN dpkg --print-architecture > /tmp/architecture

SHELL [ "/bin/bash", "-c" ]



# Second stage: install packages
FROM ubuntu:jammy
COPY --from=base /tmp/architecture /tmp/
RUN if [ "$(cat /tmp/architecture)" = "amd64" ]; then \
      echo "Installing for amd64" && \
      apt-get update && \
      apt -y install apt-transport-https ca-certificates curl software-properties-common && \
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
      add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable" && \
      apt-get -y install docker-ce python3-pip sqlite3; \
    elif [ "$(cat /tmp/architecture)" = "arm64" ]; then \
      echo "Installing for arm64" && \
      apt-get update && \
      apt -y install apt-transport-https ca-certificates curl software-properties-common && \
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
      add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu jammy stable" && \
      apt-get -y install docker-ce python3-pip sqlite3; \
    else \
      echo "Unsupported architecture"; \
      exit 1; \
    fi

RUN apt update && \
    apt instal -y npm && \
    npm -g install firebase-tools && \
    firebase --version && \
    firebase login && \
    firebase use -add #set the project id here