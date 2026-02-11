#!/usr/bin/env bash

# sync.sh - Sync Obsidian notes with git
# Usage: ./sync.sh

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Syncing Obsidian notes...${NC}"

# Pull latest changes
echo -e "${YELLOW}Pulling latest changes...${NC}"
if git pull --rebase origin "$(git branch --show-current)"; then
	echo -e "${GREEN}✓ Pulled successfully${NC}"
else
	echo -e "${RED}✗ Pull failed - resolve conflicts manually${NC}"
	exit 1
fi

# Check for changes
if [ -z "$(git status --porcelain)" ]; then
	echo -e "${GREEN}✓ No changes to commit${NC}"
	exit 0
fi

# Add all changes
echo -e "${YELLOW}Adding changes...${NC}"
git add .

# Commit with timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "Sync notes - ${TIMESTAMP}"

# Push changes
echo -e "${YELLOW}Pushing changes...${NC}"
if git push origin "$(git branch --show-current)"; then
	echo -e "${GREEN}✓ Sync complete!${NC}"
else
	echo -e "${RED}✗ Push failed${NC}"
	exit 1
fi
