#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./backups/$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

echo "Backing up MySQL database..."
docker exec pterodactyl_db sh -c "mysqldump -u root -p${MYSQL_ROOT_PASSWORD} panel" > "$BACKUP_DIR/panel.sql"

echo "Copying Pterodactyl data..."
cp -r ./data "$BACKUP_DIR/data"

echo "Backup complete: $BACKUP_DIR"
