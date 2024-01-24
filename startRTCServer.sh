#!/bin/bash

docker build  . -t rtc_server

IP="$1"
if [ -z "$1" ]
    then
        echo "No argument given, If an IP is required, please provide it as an argument. Using [localhost] for this run."
        IP="localhost"
fi

docker run -it \
  --rm \
  --name="rtc_server" \
  --privileged \
  --net=host \
  --volume="${PWD}/":"/external:rw" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  rtc_server bash -c "firebase server --only hosting"

