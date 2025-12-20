# GitHub Copilot Instructions for docker-steamcmd-server

## Project Overview

This repository contains Docker configurations for running dedicated game servers using SteamCMD. Each game server is maintained in its own branch and automatically built/published to GitHub Container Registry (GHCR).

## Project Structure

- **master branch**: Base configuration and shared workflow
- **Game branches** (e.g., `foundry`, `satisfactory`, etc.): Game-specific configurations
- Each game branch contains customized:
  - `Dockerfile` - With game-specific environment variables
  - `scripts/start-server.sh` - Game server startup and configuration logic
  - `scripts/start-backup.sh` - Backup system for game saves
  - `README.md` - Game-specific documentation

## Key Concepts

### Branch-Based Architecture
- Each game has its own dedicated branch (e.g., `foundry`, `satisfactory`)
- Branch name becomes the Docker image tag
- Example: `foundry` branch → `ghcr.io/mattystacks/steamcmd:foundry`
- Master branch contains the generic GitHub Actions workflow

### Automated Build System
- **Workflow**: `.github/workflows/build-game-image.yml` (on master)
- Triggers on push to any branch except master/main
- Automatically tags images using branch name
- Uses GitHub Container Registry (GHCR) for hosting

### Server Configuration Pattern
1. **SteamCMD** downloads Windows game server files
2. **Wine** runs Windows executables on Linux
3. **Game-specific config files** are generated from environment variables
4. **Backup system** runs as background daemon (optional)

## File Purposes

### Dockerfile
- Sets up Wine environment for Windows game servers
- Defines environment variables for server configuration
- Each game branch has customized ENV variables
- Base structure is consistent across games

### scripts/start-server.sh
- Downloads/updates game via SteamCMD
- Sets up Wine environment (`WINE64` prefix)
- **Generates game-specific config files** (e.g., `app.cfg` for Foundry)
- Starts the game server executable
- **Important**: Config file paths are game-specific

### scripts/start-backup.sh
- Runs as background daemon when `BACKUP=true`
- Creates timestamped backups of save files
- Cleans up old backups based on retention policy
- **Must be customized per game** for correct save file paths

### README.md
- Documents all environment variables
- Provides Docker run examples
- Game-specific ports and configuration details
- Should be updated when adding new ENV variables

## Important Conventions

### Environment Variables in Dockerfile
- All configurable options should be ENV variables
- Use sensible defaults
- Document in README.md
- Example naming: `SERVER_NAME`, `SERVER_PORT`, `MAP_SEED`

### Configuration File Generation
- **Always check if config exists first** before overwriting
- Allow users to manually edit configs without container overwriting them
- Use pattern:
  ```bash
  if [ ! -f "${CONFIG_FILE}" ]; then
    # Generate config
  fi
  ```

### Paths and Variables
- Use `${SERVER_DIR}` for all server-relative paths, not hardcoded paths
- Wine prefix: `${SERVER_DIR}/WINE64`
- Game install location varies by Steam app structure
- Backup location: `${SERVER_DIR}/Backups`

### Port Configuration
- Document default ports in README
- Make ports configurable via ENV variables
- Include both UDP and TCP as needed

## Adding a New Game Server

1. Create new branch from master: `git checkout -b gamename`
2. Update `Dockerfile` with game-specific ENV variables
3. Update `scripts/start-server.sh`:
   - Set correct Steam App ID
   - Configure game-specific paths
   - Generate appropriate config files
   - Update server executable name
4. Update `scripts/start-backup.sh` with correct save file paths
5. Update `README.md` with game-specific documentation
6. Push branch - GitHub Actions will automatically build and publish

## Common Pitfalls to Avoid

- **Don't hardcode paths** - Always use `${SERVER_DIR}` variable
- **Don't overwrite user configs** - Check if files exist first
- **Document all ENV variables** - Update README when adding new ones
- **Test Wine paths** - Game save locations in Wine are in AppData/LocalLow
- **Match upstream structure** - Follow patterns from original ich777 repo
- **Lowercase image names** - Docker registry requires lowercase

## Workflow Behavior

- Workflow is stored in **master branch only**
- Triggers on pushes to any branch except master/main
- All game branches inherit this workflow automatically
- Image tags use the branch name exactly as-is

## Testing Approach

When making changes to a game branch:
1. Create a feature branch from game branch (e.g., `foundry-dev`)
2. Test changes in feature branch (won't trigger builds)
3. Merge to main game branch when ready
4. Main game branch push triggers automatic build/publish

## Key URLs and Resources

- Original upstream: `https://github.com/ich777/docker-steamcmd-server`
- Container Registry: `ghcr.io/mattystacks/steamcmd:GAMENAME`
- Built for Unraid compatibility
