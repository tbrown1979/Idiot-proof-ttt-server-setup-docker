#!/usr/bin/env bash
if [ -z "$1" ]; then
    echo "Use: sh run.sh <IMAGEID> [<apikey> <collectionid>]"
fi

read -p "Enter a RCON Password (for Admin stuff): " rcon
read -p "Enter a Hostname (displayed in the server list): " hostname
read -p "Enter max payers: " maxplayers
read -p "Enter the initial map choice (nothing: 'gm_construct'): " map

if [ -z "$map" ]; then
    map="gm_construct"
fi

docker volume create garrysmod

if [ -z "$2" ] && [ -z "$3" ]; then

    docker run -i -t \
    -p 27015:27015 -p 27015:27015/udp -p 27005:27005 -p 27005:27005/udp \
    -v garrysmod:/gmod-base/garrysmod \
    -e "ARGS=+rcon_password $rcon" \
    -e "G_HOSTNAME=$hostname" \
    -e "MAXPLAYERS=$maxplayers" \
    --name gmod-ttt $1
else
    if [ -n "$2" ] && [ -z "$3" ]; then
        echo "Use: sh run.sh <IMAGEID> [<apikey> <collectionid>]"
    fi
    if [ -z "$2" ] && [ -n "$3" ]; then
        echo "Use: sh run.sh <IMAGEID> [<apikey> <collectionid>]"
    fi
    if [ -n "$2" ] && [ -n "$3" ]; then
        docker run -d -t \
        -p 27015:27015 -p 27015:27015/udp -p 27005:27005 -p 27005:27005/udp \
        -v garrysmod:/gmod-base/garrysmod \
        --name gmod-ttt \
        -e "AUTHKEY=$2" \
        -e "G_HOSTNAME=$hostname" \
        -e "MAXPLAYERS=$maxplayers" \
        -e "HOST_WORKSHOP_COLLECTION=$3" \
        -e "ARGS=+rcon_password $rcon" $1

    fi
fi


