# Makefile for Obsidian Vault Management
# obsidian-pub - Obsidian iCloud 2026 Markdown Notes

.PHONY: help status sync push pull clean lint count backup

# Default target
help:
	@echo "Obsidian Vault Management"
	@echo "========================="
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  status    - Show git status"
	@echo "  sync      - Pull latest and push local changes"
	@echo "  push      - Stage all changes and push to remote"
	@echo "  pull      - Pull latest changes from remote"
	@echo "  clean     - Remove temporary and cache files"
	@echo "  lint      - Check for broken links (requires markdown-link-check)"
	@echo "  count     - Count notes and words"
	@echo "  backup    - Create a local backup archive"
	@echo ""

# Git operations
status:
	@git status

sync: pull push

push:
	@git add -A
	@git commit -m "vault: sync $(shell date +%Y-%m-%d\ %H:%M)" || true
	@git push

pull:
	@git pull --rebase

# Maintenance
clean:
	@echo "Cleaning temporary files..."
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*~" -delete 2>/dev/null || true
	@echo "Done."

# Linting (optional - requires: npm install -g markdown-link-check)
lint:
	@echo "Checking for broken links..."
	@find . -name "*.md" -not -path "./.obsidian/*" -exec markdown-link-check {} \; 2>/dev/null || echo "Install markdown-link-check: npm install -g markdown-link-check"

# Statistics
count:
	@echo "Vault Statistics"
	@echo "================"
	@echo "Total notes: $(shell find . -name '*.md' -not -path './.obsidian/*' | wc -l | tr -d ' ')"
	@echo "Total words: $(shell find . -name '*.md' -not -path './.obsidian/*' -exec cat {} \; | wc -w | tr -d ' ')"
	@echo "Total size:  $(shell du -sh . | cut -f1)"

# Backup
backup:
	@echo "Creating backup..."
	@tar -czf "../obsidian-pub-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz" --exclude='.git' .
	@echo "Backup created: ../obsidian-pub-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz"
