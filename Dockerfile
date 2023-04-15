# syntax=docker/dockerfile:1.4
# pobieranie obrazu
#FROM moby/buildkit:frontend
#FROM docker.io/buildkit/buildkit:v0.9.0 AS frontend
FROM docker.io/buildkit/buildkit:latest
# problemy z obrazem

# zmienna z repo
ENV GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# kopiowanie klucza do kontenera
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa

COPY known_hosts /root/.ssh/known_hosts

# klonowanie repo / folder z kodem aplikacji
RUN --mount=type=ssh git clone git@github.com:mchoros/lab6.git /lab6 && \
    cd /lab6 && \
    git checkout main

# katalog z kodem aplikacji
WORKDIR /lab6

# Docker build
RUN --mount=type=ssh \
    DOCKER_BUILDKIT=1 \
    docker build -t lab6 .

# Buildkit
CMD ["/usr/bin/buildctl-daemonless.sh", "build", "--frontend", "dockerfile.v0", "--local", "context=.", "--local", "dockerfile=.", "--output", "type=image,name=lab6,push=true"]


