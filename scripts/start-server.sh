#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login ${USERNAME} ${PASSWRD} \
    +quit
fi

echo "---Update Server---"
if [ "${USERNAME}" == "" ]; then
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi

echo "---Prepare Server---"
#if [ ! -f ${SERVER_DIR}/Engine/Binaries/Linux/libsteam_api.so ]; then
#    echo "---Librarys not found, downloading---"
#    cd ${SERVER_DIR}/Engine/Binaries/Linux
#    if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/runtimes/raw/master/arkse/lib.tar.gz ; then
#		echo "---Download complete, extracting---"
#		tar -xvf ${SERVER_DIR}/Engine/Binaries/Linux/lib.tar.gz
#		rm ${SERVER_DIR}/Engine/Binaries/Linux/lib.tar.gz
#	else
#		echo "---Something went wrong, can't download Librarys, putting server in sleep mode---"
#		sleep infinity
#	fi
#fi

#Fix for version 1.0
if [ ! -d ${SERVER_DIR}/FactoryGame/Saved/Config/LinuxServer ]; then
  mkdir -p ${SERVER_DIR}/FactoryGame/Saved/Config/LinuxServer
fi
if [ ! -f ${SERVER_DIR}/FactoryGame/Saved/Config/LinuxServer/Engine.ini ]; then
  touch ${SERVER_DIR}/FactoryGame/Saved/Config/LinuxServer/Engine.ini
fi
if ! grep -Pzoq '\[HTTPServer\.Listeners\]\nDefaultBindAddress=any' ${SERVER_DIR}/FactoryGame/Saved/Config/LinuxServer/Engine.ini ; then
 echo -e "\n[HTTPServer.Listeners]\nDefaultBindAddress=any" >> ${SERVER_DIR}/FactoryGame/Saved/Config/LinuxServer/Engine.ini
fi

if [ ! -d ${SERVER_DIR}/.steam/sdk64 ]; then
  mkdir -p ${SERVER_DIR}/.steam/sdk64
fi
if [ ! -f ${SERVER_DIR}/.steam/sdk64/steamclient.so ]; then
  cp ${STEAMCMD_DIR}/linux64/steamclient.so ${SERVER_DIR}/.steam/sdk64/steamclient.so
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}/Engine/Binaries/Linux
if [ -f ${SERVER_DIR}/Engine/Binaries/Linux/UE4Server-Linux-Shipping ]; then
  ./UE4Server-Linux-Shipping FactoryGame $GAME_PARAMS
elif [ -f ${SERVER_DIR}/Engine/Binaries/Linux/UnrealServer-Linux-Shipping ]; then
  ./UnrealServer-Linux-Shipping FactoryGame $GAME_PARAMS
elif [ -f ${SERVER_DIR}/Engine/Binaries/Linux/FactoryServer-Linux-Shipping ]; then
  ./FactoryServer-Linux-Shipping FactoryGame $GAME_PARAMS
else
  echo "--ERROR: Couldn't find a game executable, something went probably wrong with the download!---"
  sleep infinity
fi
