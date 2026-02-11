#!/usr/bin/env bash

# install-hooks.sh - Install git hooks for automation
# Usage: ./install-hooks.sh

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}Installing git hooks...${NC}"

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/usr/bin/env bash

# Pre-commit hook - runs before each commit

# Check for large files (>5MB)
MAX_SIZE=5242880  # 5MB in bytes

large_files=$(git diff --cached --name-only | while read file; do
	if [ -f "$file" ]; then
		size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
		if [ "$size" -gt "$MAX_SIZE" ]; then
			echo "$file ($((size / 1024 / 1024))MB)"
		fi
	fi
done)

if [ -n "$large_files" ]; then
	echo "Error: Large files detected (>5MB):"
	echo "$large_files"
	echo ""
	echo "Consider using Git LFS or excluding these files."
	exit 1
fi

# Check for merge conflict markers
if git diff --cached | grep -E '^(\+|\-)<{7}|^(\+|\-)>{7}|^(\+|\-)={7}' >/dev/null; then
	echo "Error: Merge conflict markers detected"
	echo "Please resolve conflicts before committing"
	exit 1
fi

exit 0
EOF

chmod +x .git/hooks/pre-commit
echo -e "${GREEN}✓ Installed pre-commit hook${NC}"

# Post-commit hook (optional)
cat > .git/hooks/post-commit << 'EOF'
#!/usr/bin/env bash

# Post-commit hook - runs after each commit

# Nothing here yet, but ready for future automation
exit 0
EOF

chmod +x .git/hooks/post-commit
echo -e "${GREEN}✓ Installed post-commit hook${NC}"

echo -e "${GREEN}✓ Git hooks installed successfully!${NC}"
