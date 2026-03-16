#!/bin/bash

# Exit script immediately if a command fails
set -e
# Configuration variables

# Name of the running MySQL container
MYSQL_CONTAINER="wordpress-mysql"

# Database credentials (same as in .env)
DB_NAME="wordpressdb"
DB_USER="wpuser"
DB_PASSWORD="wppassword"

# S3 bucket where backups will be stored
S3_BUCKET="s3://wordpress-backup-sochi-2026"

# Local backup directory
BACKUP_DIR="$HOME/db-backups"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Generate timestamp filename
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_FILE="backup-$TIMESTAMP.sql"

echo "Starting database backup..."

# Run mysqldump inside container
docker exec $MYSQL_CONTAINER \
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME \
> $BACKUP_DIR/$BACKUP_FILE


echo "Database backup created at $BACKUP_DIR/$BACKUP_FILE"
# Upload backup to S3
aws s3 cp $BACKUP_DIR/$BACKUP_FILE $S3_BUCKET/


# Confirmation message
echo "Backup successfully uploaded to:"
echo "$S3_BUCKET/$BACKUP_FILE"
