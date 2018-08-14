FROM debian:wheezy

# ------------
# Prepare Gmod
# ------------

# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install lib32gcc1 wget
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates lib32tinfo5 lib32gcc1 net-tools lib32stdc++6 lib32z1 lib32z1-dev wget
RUN update-ca-certificates
RUN mkdir /steamcmd
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN mkdir /gmod-base

RUN useradd steam
RUN chown -R steam /steamcmd /gmod-base
USER steam

RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod-base +app_update 4020 validate +quit

# ----------------
# Annoying lib fix
# ----------------
USER root

RUN mkdir /gmod-libs
WORKDIR /gmod-libs
RUN wget http://launchpadlibrarian.net/195509222/libc6_2.15-0ubuntu10.10_i386.deb
RUN dpkg -x libc6_2.15-0ubuntu10.10_i386.deb .
RUN cp -a lib/i386-linux-gnu/. /gmod-base/bin/
WORKDIR /
RUN rm -rf /gmod-libs
RUN cp /steamcmd/linux32/libstdc++.so.6 /gmod-base/bin/

RUN mkdir -p /home/steam/.steam/sdk32/
RUN cp -a /steamcmd/linux32/. /home/steam/.steam/sdk32/
# RUN cp /gmod-base/bin/libsteam.so /root/.steam/sdk32

# ----------------------
# Setup Volume and Union
# ----------------------

RUN mkdir /gmod-volume
VOLUME /gmod-volume
# RUN mkdir /gmod-union
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install unionfs-fuse
RUN chown -R steam /gmod-volume /gmod-base /steamcmd /home/steam
# ---------------
# Setup Container
# ---------------

ADD start-server.sh /start-server.sh
EXPOSE 27015/udp
EXPOSE 27015/tcp
EXPOSE 27005/udp
EXPOSE 27006/tcp

ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Garry's Mod"
ENV GAMEMODE="terrortown"
ENV MAP="gm_construct"
ENV HOST_WORKSHOP_COLLECTION = ""
ENV AUTHKEY = ""
USER steam
CMD ["/bin/sh", "/start-server.sh"]
