# Dockerized Maniaplanet Dedicated

## Requirements

A machine with Docker engine.

## Usage

### Directly from CLI

We advice you to use the docker-compose method. CLI is not documented.

### In docker-compose file

Env file:

```
LOGIN=dedicated_login
PASSWORD=dedicated_password
TITLE=TMStadium@nadeo
TITLE_PACK_URL=https://v4.live.maniaplanet.com/ingame/public/titles/download/TMStadium@nadeo.Title.Pack.gbx
TITLE_PACK_FILE=TMStadium@nadeo.Title.Pack.gbx
MATCH_SETTINGS=MatchSettings/default.txt
```


Docker-compose entry:

```
  dedicated:
    image: pyplanet/maniaplanet-dedicated
    restart: always
    env_file: ./dedicated_vars.env
    volumes:
      - ./UserData:/dedicated/UserData
      - ./Logs:/dedicated/Logs
    expose:
      - "2350"
      - "2350/udp"
      - "3450"
      - "3450/udp"
      - "5000"
    ports:
      - 5000:5000
      - 2350:2350
      - "2350/udp"
      - "3450"
      - "3450/udp"
```
