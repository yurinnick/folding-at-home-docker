# Folding@Home Docker

![DockerHub Pulls](https://badgen.net/docker/pulls/yurinnick/folding-at-home?icon=docker)
![DockerHub Stars](https://badgen.net/docker/stars/yurinnick/folding-at-home?icon=star&label=stars)

Folding@home is a project focused on disease research. The problems we’re solving
require so many computer calcul­ations – and we need your help to find the cures!

## Image Flavors

Currently there are two types of image available:
- `latest`, `cpu` - lightweight image for CPU only workloads
- `latest-nvidia`, `nvidia` - image with Nvidia GPU support. More information [here](docs/gpu_support.md)

## Usage

### docker

```
docker run \
  --name folding-at-home \
  -p 7396:7396 \
  -p 36330:36330 \
  -e USER=Anonymous \
  -e TEAM=0 \
  -e ENABLE_GPU=[true|false] \
  -e ENABLE_SMP=true \
  # Required only for nvidia image
  --gpus all \
  --restart unless-stopped \
  yurinnick/folding-at-home:[latest|latest-nvidia]
```

### docker-compose

**Note:** Currenly there is no gpu option support in docker-compose: [issue](https://github.com/docker/compose/issues/6691)

```
---
version: "3"
services:
  folding-at-home:
    image: yurinnick/folding-at-home:[latest|latest-nvidia]
    container_name: folding-at-home
    environment:
      - USER=Anonymous
      - TEAM=0
      - ENABLE_GPU=[true|false]
      - ENABLE_SMP=true
    ports:
      - 7396:7396
      - 36330:36330
    restart: unless-stopped
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

- USER - Folding@home username (default: Anonymous)
- TEAM - Foldinghome team number (default: 0)
- PASSKEY - [optional] Folding@home [passkey](https://apps.foldingathome.org/getpasskey)
- ENABLE_GPU - Enable GPU compute (default: false).
- ENABLE_SMP - Enable auto-configuration of SMP slots (default: true)
- POWER - "full" by default, but you can switch to "medium" or "light" (if your laptop runs
too hot, or if your computer ventilates too much).

Additional configuration parameters can be passed as command line arguments. To get the full
list of parameters run:

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
  --gpus all \
  --restart unless-stopped \
  yurinnick/folding-at-home \
  --allow 0/0 \
  --web-allow 0/0
```

## Additional Security

### Anonimous Hostname

To disable sharing your hostname, override current container hostname by adding `-h <hostname>` argument.

### Host-only WebUI

To enable Folding@home WebUI only on a target Docker host, simple do not expose WubUI port:

```
docker run \
  --name folding-at-home \
  -e USER=Anonymous \
  -e TEAM=0 \
  -e ENABLE_GPU=false \
  -e ENABLE_SMP=true \
  --gpus all \
  --restart unless-stopped \
  yurinnick/folding-at-home \
  --allow 0/0 \
  --web-allow 0/0
```

In this case Folding@home will be only accessiable by the link from the script below:

```
host=$(docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" folding-at-home)
echo http://${host}:7396
```

