FROM debian:stable-slim

LABEL maintainer="yurinnick" \
      repository="https://github.com/yurinnick/folding-at-home-docker" \
      description="Unofficial Folding@Home image for CPU compute" \
      version="7.6"

ARG version="v7.6"

RUN useradd --system folding && \
    mkdir -p /opt/fahclient/work && \
    # download and untar
    apt-get update -y && \
    apt-get install -y wget bzip2 && \
    wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/${version}/latest.tar.bz2 -O /tmp/fahclient.tar.bz2 && \
    tar -xjf /tmp/fahclient.tar.bz2 -C /opt/fahclient --strip-components=1 && \
    # fix permissions
    chown -R folding:folding /opt/fahclient && \
    # cleanup
    rm -rf /tmp/fahclient.tar.bz2 && \
    apt-get purge -y wget bzip2 && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

COPY --chown=folding:folding entrypoint.sh /opt/fahclient

RUN chmod +x /opt/fahclient/entrypoint.sh

ENV USER "Anonymous"
ENV TEAM "0"
ENV ENABLE_GPU "false"
ENV ENABLE_SMP "true"
ENV POWER "full"

USER folding
WORKDIR /opt/fahclient

EXPOSE 7396
EXPOSE 36330

ENTRYPOINT ["/opt/fahclient/entrypoint.sh"]
