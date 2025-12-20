FROM ich777/winehq-baseimage

LABEL org.opencontainers.image.authors="steamcmd.washstand773@aleeas.com"
LABEL org.opencontainers.image.source="https://github.com/mattystacks/docker-steamcmd-server"
LABEL org.opencontainers.image.description="A Docker image to run SteamCMD for a dedicated foundry game server."
LABEL org.opencontainers.image.version="foundry"


RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y install lib32gcc-s1 screen xvfb winbind && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_PARAMS=""
ENV VALIDATE=""
ENV BACKUP="false"
ENV BACKUP_INTERVAL=360
ENV BACKUPS_TO_KEEP=8
ENV SERVER_NAME="FoundryDockerServer"
ENV SERVER_PASSWORD=""
ENV SERVER_WORLD_NAME="FoundryWorld"
ENV SERVER_PORT=3724
ENV SERVER_QUERY_PORT=27015
ENV SERVER_MAX_PLAYERS=32
ENV SERVER_IS_PUBLIC="true"
ENV PAUSE_WHEN_EMPTY="false"
ENV AUTOSAVE_INTERVAL=300
ENV MAP_SEED=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""
ENV USER="steam"
ENV DATA_PERM=770

RUN mkdir $DATA_DIR && \
	mkdir $STEAMCMD_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
COPY /etc/ /etc/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]