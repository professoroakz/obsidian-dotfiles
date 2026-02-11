#!/usr/bin/env bash

# backup.sh - Create backup of Obsidian vault
# Usage: ./backup.sh

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Load config
if [ -f .env ]; then
	source .env
fi

BACKUP_DIR="${BACKUP_DIR:-./backups}"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="obsidian_backup_${TIMESTAMP}.tar.gz"

echo -e "${YELLOW}Creating backup...${NC}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create backup (exclude .git, backups, and other temp files)
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" \
	--exclude='.git' \
	--exclude='backups' \
	--exclude='node_modules' \
	--exclude='.obsidian/workspace*' \
	--exclude='.obsidian/cache' \
	--exclude='*.swp' \
	--exclude='*.swo' \
	--exclude='.DS_Store' \
	.

echo -e "${GREEN}✓ Backup created: ${BACKUP_DIR}/${BACKUP_NAME}${NC}"

# Optional: Clean old backups (keep last 30 days by default)
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"
if [ -n "$RETENTION_DAYS" ]; then
	echo -e "${YELLOW}Cleaning backups older than ${RETENTION_DAYS} days...${NC}"
	find "$BACKUP_DIR" -name "obsidian_backup_*.tar.gz" -mtime +"$RETENTION_DAYS" -delete
	echo -e "${GREEN}✓ Old backups cleaned${NC}"
fi

# Show backup size
BACKUP_SIZE=$(du -h "${BACKUP_DIR}/${BACKUP_NAME}" | cut -f1)
echo -e "${GREEN}Backup size: ${BACKUP_SIZE}${NC}"
