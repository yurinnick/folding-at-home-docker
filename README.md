# Folding@Home Docker

Folding@home is a project focused on disease research. The problems we’re solving require so many computer calcul­ations – and we need your help to find the cures!

## Note
Currently I only support CPU workloads. For GPU support, please use [wandhydrant
/
folding-at-home-docker-gpu](https://github.com/wandhydrant/folding-at-home-docker-gpu) fork.

## Usage

### docker

```
docker run \
  --name folding-at-home \
  -p 7396:7396 \
  -p 36330:36330 \
  -e USER=Anonymous \
  -e TEAM=0 \
  -e ENABLE_GPU=false \
  -e ENABLE_SMP=true \
  --restart unless-stopped \
  yurinnick/folding-at-home
```

### docker-compose

```
---
version: "3"
services:
  folding-at-home:
    image: yurinnick/folding-at-home
    container_name: folding-at-home
    environment:
      - USER=Anonymous
      - TEAM=0
      - ENABLE_GPU=false
      - ENABLE_SMP=true
    ports:
      - 7396:7396
      - 36330:36330
    restart: unless-stopped
```

### Kubernetes

```
TDB
```

## Parameters

- USER - Folding@home username (default: Anonymous)
- TEAM - Foldinghome team number (default: 0)
- PASSKEY - [optional] Folding@home [passkey](https://apps.foldingathome.org/getpasskey)
- ENABLE_GPU - Enable GPU compute (default: false)
- ENABLE_SMP - Enable auto-configuration of SMP slots (default: true)

Additional configuration parameters can be passed as command line arguments. To get the full list of parameters run:

```
docker run yurinnick/folding-at-home:latest --help
```

## Web Interface

Web interface is locked to `localhost` by default, to enable remote access run:

```
docker run \
  --name folding-at-home \
  -p 7396:7396 \
  -p 36330:36330 \
  -e USER=Anonymous \
  -e TEAM=0 \
  -e ENABLE_GPU=false \
  -e ENABLE_SMP=true \
  --restart unless-stopped \
  yurinnick/folding-at-home \
  --allow 0/0 \
  --web-allow 0/0
```
