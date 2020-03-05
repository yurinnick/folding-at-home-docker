#!/bin/bash
set -e

# if a command was specified, we run that command. E.g. helpful when we do
# docker run -it <container> /bin/bash
if [ "${1}" ]
then
  exec "$@"
# otherwise we attempt to run boinc.
else
  /opt/fahclient/FAHClient \
      --user="${USER}" \
      --team="${TEAM}" \
      --passkey="${PASSKEY}" \
      --gpu="${ENABLE_GPU}" \
      --smp="${ENABLE_SMP}" \
      --power=full \
      --gui-enabled=false \
      "${@}"
fi
