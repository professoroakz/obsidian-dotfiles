#!/usr/bin/env bash

# verify.sh - Verify repository structure and configuration
# Usage: ./verify.sh

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo -e "${YELLOW}Verifying repository...${NC}\n"

# Check required files
echo "Checking required files..."
REQUIRED_FILES=(".gitignore" "README.md" "LICENSE" "Makefile" ".editorconfig")
for file in "${REQUIRED_FILES[@]}"; do
	if [ -f "$file" ]; then
		echo -e "  ${GREEN}✓${NC} $file"
	else
		echo -e "  ${RED}✗${NC} $file (missing)"
		((ERRORS++))
	fi
done

# Check optional files
echo -e "\nChecking optional files..."
OPTIONAL_FILES=("CONTRIBUTING.md" "SECURITY.md" "CHANGELOG.md" ".env.example")
for file in "${OPTIONAL_FILES[@]}"; do
	if [ -f "$file" ]; then
		echo -e "  ${GREEN}✓${NC} $file"
	else
		echo -e "  ${YELLOW}⚠${NC} $file (recommended)"
		((WARNINGS++))
	fi
done

# Check directories
echo -e "\nChecking directories..."
REQUIRED_DIRS=("scripts")
for dir in "${REQUIRED_DIRS[@]}"; do
	if [ -d "$dir" ]; then
		echo -e "  ${GREEN}✓${NC} $dir/"
	else
		echo -e "  ${RED}✗${NC} $dir/ (missing)"
		((ERRORS++))
	fi
done

# Check git configuration
echo -e "\nChecking git configuration..."
if git config user.name >/dev/null 2>&1; then
	echo -e "  ${GREEN}✓${NC} Git user.name configured"
else
	echo -e "  ${YELLOW}⚠${NC} Git user.name not configured"
	((WARNINGS++))
fi

if git config user.email >/dev/null 2>&1; then
	echo -e "  ${GREEN}✓${NC} Git user.email configured"
else
	echo -e "  ${YELLOW}⚠${NC} Git user.email not configured"
	((WARNINGS++))
fi

# Check for .env file
echo -e "\nChecking environment..."
if [ -f .env ]; then
	echo -e "  ${GREEN}✓${NC} .env file exists"
else
	echo -e "  ${YELLOW}⚠${NC} .env file not found (copy from .env.example)"
	((WARNINGS++))
fi

# Check script permissions
echo -e "\nChecking script permissions..."
for script in scripts/*.sh; do
	if [ -x "$script" ]; then
		echo -e "  ${GREEN}✓${NC} $script (executable)"
	else
		echo -e "  ${YELLOW}⚠${NC} $script (not executable)"
		echo -e "     Run: chmod +x $script"
		((WARNINGS++))
	fi
done

# Summary
echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
	echo -e "${GREEN}✓ All checks passed!${NC}"
	exit 0
elif [ $ERRORS -eq 0 ]; then
	echo -e "${YELLOW}⚠ Verification complete with ${WARNINGS} warning(s)${NC}"
	exit 0
else
	echo -e "${RED}✗ Verification failed with ${ERRORS} error(s) and ${WARNINGS} warning(s)${NC}"
	exit 1
fi
