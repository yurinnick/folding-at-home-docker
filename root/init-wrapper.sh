#!/bin/bash

if [ $# -ne 0 ]; then
  echo -e "
\033[0;31m
[WARNING]

Due to migration to s6overlay passing command line options to FAHClient will be deprecated soon.
Please pass additional parameters using EXTRA_OPTIONS environment variable.

Documentation: https://github.com/yurinnick/folding-at-home-docker

If you experience some issues or need additinal support, please file a bug here: 
https://github.com/yurinnick/folding-at-home-docker/issues/new
\033[0m
  "
  export EXTRA_OPTIONS="${EXTRA_OPTIONS} $@"
  sleep 5
fi

exec /init
