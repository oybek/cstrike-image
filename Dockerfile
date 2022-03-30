FROM ubuntu:latest

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install lib32gcc1
RUN apt-get -y install --reinstall ca-certificates
RUN apt-get -y install curl
RUN curl google.com

RUN mkdir /root/SteamCMD
RUN cd /root/SteamCMD

COPY linux32 /root/SteamCMD/linux32/
COPY steamcmd.sh /root/SteamCMD/

RUN /root/SteamCMD/steamcmd.sh +force_install_dir /root/hlds +login anonymous +app_update 90 validate +quit || :
RUN /root/SteamCMD/steamcmd.sh +force_install_dir /root/hlds +login anonymous +app_update 70 validate +quit || :
RUN /root/SteamCMD/steamcmd.sh +force_install_dir /root/hlds +login anonymous +app_update 10 validate +quit || :
RUN /root/SteamCMD/steamcmd.sh +force_install_dir /root/hlds +login anonymous +app_update 90 validate +quit

RUN ln -s /root/SteamCMD/linux32 /root/.steam/sdk32
RUN touch /root/hlds/cstrike/listip.cfg
RUN touch /root/hlds/cstrike/banned.cfg

WORKDIR /root/hlds
CMD ./hlds_run -game cstrike +ip 0.0.0.0 +maxplayers 12 +map de_dust2
