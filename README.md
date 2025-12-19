# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Foundry Dedicated Server and run it.

**Foundry** is a first-person factory building game where you construct and automate factories on alien planets.

**ATTENTION:** First startup can take very long since it downloads the game server files!

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The Steam App ID for Foundry Dedicated Server | 2915550 |
| GAME_PARAMS | Values to start the server if needed. | empty |
| UPDATE_PUBLIC_IP | If set to 'true' the container will check on each container start if the Public IP is still valid. | false |
| BACKUP | Set this value to 'true' to enable the automated backup function from the container, you find the Backups in '.../foundry/Backups/'. Set to 'false' to disable the backup function. | true |
| BACKUP_INTERVAL | The backup interval in minutes (ATTENTION: The first backup will be triggered after the set interval in this variable after the start/restart of the container) | 360 |
| BACKUPS_TO_KEEP | Number of backups to keep (by default set to 8 to keep the last backups of the last 48 hours) | 8 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |


## Run example
```
docker run --name Foundry -d \
	-p 15777:15777/udp \
	-p 15777:15777/tcp \
	-p 7777:7777/udp \
	--env 'GAME_ID=2915550' \
	--env 'UPDATE_PUBLIC_IP=false' \
	--env 'BACKUP=true' \
	--env 'BACKUP_INTERVAL=360' \
	--env 'BACKUPS_TO_KEEP=8' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/foundry:/serverdata/serverfiles \
	ghcr.io/YOUR_USERNAME/docker-steamcmd-server:foundry
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!
