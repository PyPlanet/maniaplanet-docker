#!/bin/sh

# We are required to get the public ip if we don't have it in our env currently.

if [ "$FORCE_IP_ADDRESS" = "" ]
then
   FORCE_IP_ADDRESS=`wget -4 -qO- http://ifconfig.co`
fi

if [ "$FORCE_IP_PORT" = "" ]
then
   FORCE_IP_PORT=${PORT-2350}
fi

echo "=> Going to run on forced IP: ${FORCE_IP_ADDRESS} and port: ${FORCE_IP_PORT}"

# Make sure we use defaults everywhere.
: ${TITLE:="TMStadium@nadeo"}
: ${TITLE_PACK_URL:="https://v4.live.maniaplanet.com/ingame/public/titles/download/TMStadium@nadeo.Title.Pack.gbx"}
: ${TITLE_PACK_FILE:=""}
: ${DEDICATED_CFG:="config.txt"}
: ${MATCH_SETTINGS:="MatchSettings/default.txt"}
: ${SERVER_NAME:="My Docker Server"}

# Copy the configuration files if not yet copied.
mkdir -p ${PROJECT_ROOT}/UserData/Config
mkdir -p ${PROJECT_ROOT}/UserData/Packs
mkdir -p ${PROJECT_ROOT}/UserData/Maps/MatchSettings
if [ ! -f ${PROJECT_ROOT}/UserData/Config/config.txt ]; then
    cp ${TEMPLATE_DIR}/config.txt ${PROJECT_ROOT}/UserData/Config/config.txt
fi

if [ ! -f ${PROJECT_ROOT}/UserData/Maps/MatchSettings/default.txt ]; then
    cp ${TEMPLATE_DIR}/matchsettings.txt ${PROJECT_ROOT}/UserData/Maps/MatchSettings/default.txt
fi

if [ ! -f ${PROJECT_ROOT}/UserData/Maps/stadium_map.Map.gbx ]; then
    cp ${TEMPLATE_DIR}/stadium_map.Map.gbx ${PROJECT_ROOT}/UserData/Maps/stadium_map.Map.gbx
fi

# Download title.
# TODO: Check if update is required first.
echo "=> Downloading newest title version"
if [ "$TITLE_PACK_FILE" = "" ]
then
    wget ${TITLE_PACK_URL} -qP ${PROJECT_ROOT}/UserData/Packs/
else
    wget ${TITLE_PACK_URL} -qO ${PROJECT_ROOT}/UserData/Packs/${TITLE_PACK_FILE}
fi

# Start dedicated.
echo "=> Starting server, login=${LOGIN}"
./ManiaPlanetServer $@ \
    /nodaemon \
    /forceip=${FORCE_IP_ADDRESS}:${FORCE_IP_PORT} \
    /title=${TITLE} \
    /dedicated_cfg=${DEDICATED_CFG} \
    /game_settings=${MATCH_SETTINGS} \
    /login=${LOGIN} \
    /password=${PASSWORD} \
    /servername=${SERVER_NAME} \
