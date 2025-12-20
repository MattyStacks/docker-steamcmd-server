#!/bin/bash
while true
do
        sleep ${BACKUP_INTERVAL}m
        # Foundry saves are stored in Wine's AppData/LocalLow directory
        SAVE_DIR="${SERVER_DIR}/WINE64/drive_c/users/steam/AppData/LocalLow/Channel 3 Entertainment/FoundryDedicatedServer"
        if [ -d "${SAVE_DIR}" ]; then
                cd "${SAVE_DIR}"
                tar --warning=no-file-changed -czf ${SERVER_DIR}/Backups/$(date '+%Y-%m-%d_%H.%M.%S').tar.gz ./save/
                cd ${SERVER_DIR}/Backups
                ls -1tr ${SERVER_DIR}/Backups | sort | head -n -${BACKUPS_TO_KEEP} | xargs -d '\n' rm -f --
                chmod -R ${DATA_PERM} ${SERVER_DIR}/Backups
        else
                echo "---Save directory not found, skipping backup---"
        fi
done