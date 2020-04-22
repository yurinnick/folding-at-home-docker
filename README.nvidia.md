# Folding@Home Dockerfile for Nvidia GPUs

Folding@home has been supporting GPU calculations for a long time.
Right now, to the best of my knowledge, they are the
only GPU-based distributed computing project who
are running calculations against Coronavirus.

Here is a combination of [Nikolay Yurin's Folding@home Dockerfile](https://github.com/yurinnick/folding-at-home-docker)
and the [BOINC Nvidia Dockerfile](https://github.com/BOINC/boinc-client-docker),
so that you have an additional layer of sandboxing around
GPU computations of Folding@home. In case you are allowed
to use other people's computers, or your employer's,
using Docker containers might even be a requirement.

## Usage

### Build the image locally (recommended)

I encourage everyone to read the Dockerfile and to build it yourself.
It's very easy and this way you download directly your FAHClient binary
from the official web site. (If you really need pre-built images,
[someone else published one version](https://github.com/wandhydrant/folding-at-home-docker-gpu/issues/4).)

To build the image yourself:

```
cd <git-checkout>
docker build -f Dockerfile.nvidia -t my-fah-nvidia-image .
```

To update the image - even if the Dockerfile has not changed, but in case
there are new versions of the base image or of FAHClient:

```
cd <git-checkout>
docker pull nvidia/cuda:10.2-base-ubuntu18.04
docker build --no-cache -f Dockerfile.nvidia -t my-new-fah-nvidia-image .
```

### and run it:

GPU access by containers went through several stages:
first direct export of /dev/dri and other devices; then
solutions with Docker "runtimes" (nvidia-docker v1
and v2); the current variant is the Nvidia Container
Toolkit. The latter is the only one I tested this with.

As for the BOINC Nvidia container, please:

1. Install Docker (19.03 or later);

2. Install the Nvidia drivers (so that "nvidia-smi" gives you output on the host);

3. Install the [Nvidia Container Toolkit](https://github.com/NVIDIA/nvidia-docker) (see "Usage" on the linked page to test nvidia-smi in a container).

Finally you can run this container:

```
docker run -d \
  --name folding-at-home \
  --gpus all \
  -h node \
  -e USER=Anonymous \
  -e TEAM=0 \
  -e ENABLE_GPU=true \
  -e ENABLE_SMP=true \
  -e POWER=full \
  --restart unless-stopped \
  my-fah-nvidia-image \
  --allow 0/0 --web-allow 0/0
```

``-h node`` sets an anonymous hostname instead of copying yours.

The last line means that Folding@home's web access will let everybody in,
but as the port is not exported, you can use it only from the Docker host,
pointing your browser at the container:

```
echo http://$(docker inspect  --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" folding-at-home):7396
```

## Parameters (exactly the same as for the CPU image):

- USER - Folding@home username (default: Anonymous)
- TEAM - Foldinghome team number (default: 0)
- PASSKEY - [optional] Folding@home [passkey](https://apps.foldingathome.org/getpasskey)
- ENABLE_GPU - Enable GPU compute (default: true)
- ENABLE_SMP - Enable auto-configuration of SMP slots (default: true)
- POWER - by default "full"; but you might want to switch to "medium" and see how hot your hardware gets (especially laptops). The "light" level will not use the GPU at all. You can always switch this in the web interface.

Additional configuration parameters can be passed as command line arguments. To get the full list of parameters run:

```
docker run my-fah-nvidia-image --help
```
