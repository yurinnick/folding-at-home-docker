# Nvidia GPU Support

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

## Execution

GPU access by containers went through several stages:
first direct export of /dev/dri and other devices; then
solutions with Docker "runtimes" (nvidia-docker v1
and v2); the current variant is the Nvidia Container
Toolkit. The latter is the only one I tested this with.

As for the BOINC Nvidia container, please:

1. Install Docker (19.03 or later);

2. Install the Nvidia drivers (so that "nvidia-smi" gives you output on the host);

3. Install the [Nvidia Container Toolkit](https://github.com/NVIDIA/nvidia-docker) (see "Usage" on the linked page to test nvidia-smi in a container).
