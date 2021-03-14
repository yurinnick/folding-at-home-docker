FROM debian:stable-slim

ARG VERSION="v7.6.21"
ARG OVERLAY_VERSION="v2.2.0.3"
ARG OVERLAY_ARCH="amd64"

LABEL maintainer="yurinnick" \
      repository="https://github.com/yurinnick/folding-at-home-docker" \
      description="Unofficial Folding@Home image for CPU compute" \
      version="${VERSION}"

ENV DEBIAN_FRONTEND=noninteractive
RUN useradd --system folding && \
    mkdir -p /opt/fahclient/work && \
    # download and untar
    apt-get update -y && \
    apt-get install -y wget bzip2 tzdata && \
    # Install s6init
    wget https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer -O /tmp/s6-overlay-installer && \
    chmod +x /tmp/s6-overlay-installer && \
    /tmp/s6-overlay-installer / && \
    rm /tmp/s6-overlay-installer && \
    # Install FAHClient
    wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/${VERSION%.*}/fahclient_${VERSION#v}-64bit-release.tar.bz2 -O /tmp/fahclient.tar.bz2 && \
    tar -xjf /tmp/fahclient.tar.bz2 -C /opt/fahclient --strip-components=1 && \
    # Fix permissions
    chown -R folding:folding /opt/fahclient && \
    # Cleanup
    rm -rf /tmp/fahclient.tar.bz2 && \
    apt-get purge -y wget bzip2 && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

COPY root/ /
RUN chmod +x /init-wrapper.sh

ENV USER "Anonymous"
ENV TEAM "0"
ENV ENABLE_GPU "false"
ENV ENABLE_SMP "true"
ENV POWER "full"
ENV ALLOWED_HOSTS "127.0.0.1/32"
ENV EXTRA_OPTIONS ""

WORKDIR /opt/fahclient

EXPOSE 7396
EXPOSE 36330

ENTRYPOINT ["/init-wrapper.sh"]
