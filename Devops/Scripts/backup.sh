#!/bin/bash

set -e

CONTAINER_NAME="hotel-postgres"
DB_NAME="hotel_db"
DB_USER="postgres"

BACKUP_DIR="./backups"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="$BACKUP_DIR/hotel_db_$TIMESTAMP.sql"

echo "Creating backup..."

docker exec "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"

echo "Backup completed."

echo "Backup saved to: $BACKUP_FILE"
