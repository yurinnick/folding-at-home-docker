# Folding@Home Docker

![DockerHub Pulls](https://badgen.net/docker/pulls/yurinnick/folding-at-home?icon=docker)
![DockerHub Stars](https://badgen.net/docker/stars/yurinnick/folding-at-home?icon=star&label=stars)
[![Gitter](https://badges.gitter.im/folding-at-home-docker/community.svg)](https://gitter.im/folding-at-home-docker/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Folding@home is a project focused on disease research. The problems we’re solving
require so many computer calcul­ations – and we need your help to find the cures!

If you have a question regarding the setup or found a bug feel free ping in the [Gitter chat](https://gitter.im/folding-at-home-docker/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) or open an issue on Github.

## Image Flavors

Currently there are two types of image available:
- `latest`, `cpu` - lightweight image for CPU only workloads
- `latest-nvidia`, `nvidia` - image with Nvidia GPU support. More information [here](https://github.com/yurinnick/folding-at-home-docker#gpu-support)

## Usage

### docker cli

**CPU Instance**

```
docker run \
  --name folding-at-home \
  -p 7396:7396 \
  -p 36330:36330 \
  -e USER=Anonymous \
  -e TEAM=0 \
  -e ENABLE_SMP=true \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  # Required for persistent data \
  -v /path/to/fahdata:/opt/fahclient/work \
  --restart unless-stopped \
  yurinnick/folding-at-home:latest
```

**GPU Instance**
```
docker run \
  --name folding-at-home \
  -p 7396:7396 \
  -p 36330:36330 \
  -e USER=Anonymous \
  -e TEAM=0 \
  -e ENABLE_SMP=true \
  -e ENABLE_GPU=true \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  # Required for persistent data \
  -v /path/to/fahdata:/opt/fahclient/work \
  --gpus all \
  --restart unless-stopped \
  yurinnick/folding-at-home:latest-nvidia
```

### docker-compose

**Note: Requires docker-compose version 1.28+**

**CPU Instance**

```
docker-compose up -d folding-at-home-cpu
```

**GPU Instance**

```
docker-compose up -d folding-at-home-gpu
```

## Building Locally

While providing pre-build images, we encourage everyone to read the
Dockerfile and to build it yourself.

Based on your prefered flavor use the command below:

```
# CPU-only image
docker build -f Dockerfile -t folding-at-home:cpu .

# Nvidia CUDA image
docker build -f Dockerfile.nvidia -t folding-at-home:nvidia .
```

## Parameters

- USER - Folding@home username (default: `Anonymous`)
- TEAM - Foldinghome team number (default: `0`)
- PASSKEY - [optional] Folding@home [passkey](https://apps.foldingathome.org/getpasskey)
- ENABLE_GPU - Enable GPU compute (default: `false`)
- ENABLE_SMP - Enable auto-configuration of SMP slots (default: `true`)
- POWER - "full" by default, but you can switch to "medium" or "light" (if your laptop runs
too hot, or if your computer ventilates too much)
- PUID - User ID for data volume. See details: [persistent-storage](https://github.com/yurinnick/folding-at-home-docker#persistent-storage) (default: `1000`)
- PGID - Group ID for data volume. See details: [persistent-storage](https://github.com/yurinnick/folding-at-home-docker#persistent-storage) (default: `1000`)
- ALLOWED_HOSTS - Allowed remote access to specified subnet (default: `127.0.0.1/32`)
- EXTRA_OPTIONS - Additional FAHClient command-line options (default: "")

## Persistent Storage

By default Docker doesn't store any data outside of a continer, so upon stop/restart/recreate all temporary FAH
data will be lost. To persistently store working data mount `/opt/fahclient/work` onto some directory on the disk.

While mounting local volume there may be permissions issues between the host and the container. 
Specify current users PUID/PGID as parameters to ensure that data volume owned by the same user inside the container.

```
docker run \
...
-v /path/to/fahdata:/opt/fahclient/work
-e PUID=$(id -u)
-e PGID=$(id -g)
...
```

# GPU Support

This image currenly supports only Nvidia GPUs.

To enable Nvidia support in Docker follow the instructions on [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker) installation guide for Docker. 
