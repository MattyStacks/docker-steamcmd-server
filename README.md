# SteamCMD in Docker optimized for Unraid

This Docker will download and install SteamCMD. It will also install Foundry Dedicated Server and run it.

**Foundry** is a first-person factory building game where you construct and automate factories on alien planets.

**ATTENTION:** First startup can take very long since it downloads the game server files!

**Default Port:** 3724 (game) and 27015 (query port for Steam server browser if public)

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params

| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The Steam App ID for Foundry Dedicated Server | 2915550 |
| GAME_PARAMS | Additional command line parameters for the server | empty |
| SERVER_NAME | The name of the server listed in the Steam server browser | Foundry Docker Server |
| SERVER_PASSWORD | Password required to join the server (leave empty for no password) | empty |
| SERVER_WORLD_NAME | The world name/save folder name | FoundryWorld |
| SERVER_PORT | The network port used by the game | 3724 |
| SERVER_QUERY_PORT | The network port used by Steam server browser (only if public) | 27015 |
| SERVER_MAX_PLAYERS | Maximum number of players allowed on the server | 32 |
| SERVER_IS_PUBLIC | Whether the server is listed on the Steam server browser (true/false) | true |
| PAUSE_WHEN_EMPTY | Pause the server when nobody is connected (true/false) | false |
| AUTOSAVE_INTERVAL | Autosave frequency in seconds | 300 |
| MAP_SEED | Map seed used to generate the world (leave empty for random) | empty |
| BACKUP | Enable automated backup function (true/false) | false |
| BACKUP_INTERVAL | Backup interval in minutes | 360 |
| BACKUPS_TO_KEEP | Number of backups to keep | 8 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data (true/false) | false |
| USERNAME | Steam username (leave blank for anonymous login) | blank |
| PASSWRD | Steam password (leave blank for anonymous login) | blank |

## Run example

```bash
docker run --name Foundry -d \
  -p 3724:3724/udp \
  -p 27015:27015/udp \
  --env 'GAME_ID=2915550' \
  --env 'SERVER_NAME=My Foundry Server' \
  --env 'SERVER_WORLD_NAME=MyFactory' \
  --env 'SERVER_PASSWORD=' \
  --env 'SERVER_PORT=3724' \
  --env 'SERVER_QUERY_PORT=27015' \
  --env 'SERVER_MAX_PLAYERS=32' \
  --env 'SERVER_IS_PUBLIC=true' \
  --env 'PAUSE_WHEN_EMPTY=false' \
  --env 'AUTOSAVE_INTERVAL=300' \
  --env 'BACKUP=true' \
  --env 'BACKUP_INTERVAL=360' \
  --env 'BACKUPS_TO_KEEP=8' \
  --env 'UID=99' \
  --env 'GID=100' \
  --volume /path/to/steamcmd:/serverdata/steamcmd \
  --volume /path/to/foundry:/serverdata/serverfiles \
  ghcr.io/mattystacks/steamcmd:foundry
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

## Available Images

Docker images are automatically built and published to both registries for different game servers:

### GitHub Container Registry (GHCR)
```
ghcr.io/mattystacks/steamcmd:<game-name>
```

### Docker Hub
```
docker.io/mattystacks/steamcmd:<game-name>
```

**Available game tags:**
- `foundry` - Foundry Dedicated Server
- `valheim` - Valheim Dedicated Server
- *(Additional game servers may be available - check the repository branches)*

**Example pulls:**
```bash
# From GitHub Container Registry
docker pull ghcr.io/mattystacks/steamcmd:foundry

# From Docker Hub
docker pull mattystacks/steamcmd:foundry
```

## CI/CD Automation

This repository uses GitHub Actions to automatically build and publish Docker images:

- **Automatic Builds**: Images are built automatically when changes are pushed to game-specific branches
- **Multi-Registry Publishing**: Images are simultaneously published to both GitHub Container Registry (ghcr.io) and Docker Hub
- **Branch-Based Tagging**: Each branch name corresponds to a game server type (e.g., `foundry` branch creates `steamcmd:foundry` image)
- **Manual Triggers**: Workflows can be manually triggered from the GitHub Actions UI

For more details, see [`.github/workflows/build-game-image.yml`](.github/workflows/build-game-image.yml)

## Backup System

When `BACKUP=true`, the container will automatically backup your Foundry save files:
- Backups are stored in `/serverdata/serverfiles/Backups/`
- Creates timestamped archives (YYYY-MM-DD_HH.MM.SS.tar.gz)
- Runs every `BACKUP_INTERVAL` minutes (default: 360 = 6 hours)
- Keeps the most recent `BACKUPS_TO_KEEP` backups (default: 8)
- Automatically cleans up old backups

## Troubleshooting

- If you have trouble connecting to your server, you may need to open port 3724 (default) in your firewall and forward that port on your router to your machine.
- Make sure your server version matches your game version.
- Server save files are stored in: `%APPDATA%/../LocalLow/Channel 3 Entertainment/FoundryDedicatedServer/save` (inside the Wine prefix)
