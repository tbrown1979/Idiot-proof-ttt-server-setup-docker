#!/usr/bin/env bash
# Use: sh run.sh <IMAGEID>

docker run --privileged=true -d -P -v /root/gmod-server:/gmod-volume \
--name gmod-test \
-e "AUTHKEY=#AUTHKEY HERE#" \
-e "HOST_WORKSHOP_COLLECTION=#SOME COLLECTION HERE#" \
-e "ARGS=+rcon_password test" $1
