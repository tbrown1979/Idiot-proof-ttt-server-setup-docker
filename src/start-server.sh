#!/bin/bash

while true; do
/gmod-base/srcds_run -game garrysmod -norestart -port ${PORT} \
 +maxplayers ${MAXPLAYERS} \
 +hostname "${G_HOSTNAME}" \
 +gamemode ${GAMEMODE}\
 +host_workshop_collection ${HOST_WORKSHOP_COLLECTION} \
 -authkey ${AUTHKEY} \
 "${ARGS}" \
 +map ${MAP}
done

