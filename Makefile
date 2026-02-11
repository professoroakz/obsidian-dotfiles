.PHONY: help init clean sync backup verify test install-hooks

# Default target
.DEFAULT_GOAL := help

# Colors for output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(CYAN)obsidian-pub Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(NC) %s\n", $$1, $$2}'

init: ## Initialize the repository (first-time setup)
	@echo "$(GREEN)Initializing repository...$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(YELLOW)Created .env file from .env.example$(NC)"; \
		echo "$(YELLOW)Please update .env with your configuration$(NC)"; \
	fi
	@if [ ! -d .obsidian ]; then \
		mkdir -p .obsidian; \
		echo "$(GREEN)Created .obsidian directory$(NC)"; \
	fi
	@if [ ! -d notes ]; then \
		mkdir -p notes; \
		echo "$(GREEN)Created notes directory$(NC)"; \
	fi
	@echo "$(GREEN)✓ Repository initialized successfully!$(NC)"

clean: ## Clean temporary files and caches
	@echo "$(YELLOW)Cleaning temporary files...$(NC)"
	@find . -type f -name "*.swp" -delete
	@find . -type f -name "*.swo" -delete
	@find . -type f -name "*~" -delete
	@find . -type f -name ".DS_Store" -delete
	@find . -type f -name "*.log" -delete
	@echo "$(GREEN)✓ Cleanup complete!$(NC)"

sync: ## Sync notes with git (pull, commit, push)
	@echo "$(CYAN)Syncing notes...$(NC)"
	@./scripts/sync.sh

backup: ## Create a backup of the vault
	@echo "$(CYAN)Creating backup...$(NC)"
	@./scripts/backup.sh

verify: ## Verify repository structure and files
	@echo "$(CYAN)Verifying repository...$(NC)"
	@./scripts/verify.sh

test: ## Run tests (if any)
	@echo "$(CYAN)Running tests...$(NC)"
	@if [ -d tests ]; then \
		cd tests && ./run-tests.sh; \
	else \
		echo "$(YELLOW)No tests found$(NC)"; \
	fi

install-hooks: ## Install git hooks
	@echo "$(CYAN)Installing git hooks...$(NC)"
	@if [ -f scripts/install-hooks.sh ]; then \
		./scripts/install-hooks.sh; \
	else \
		echo "$(YELLOW)No hooks installer found$(NC)"; \
	fi

status: ## Show git status in a readable format
	@echo "$(CYAN)Repository status:$(NC)"
	@git status -sb

stats: ## Show repository statistics
	@echo "$(CYAN)Repository Statistics:$(NC)"
	@echo "$(GREEN)Total notes:$(NC) $$(find . -name '*.md' -not -path '*/\.*' | wc -l)"
	@echo "$(GREEN)Total words:$(NC) $$(find . -name '*.md' -not -path '*/\.*' -exec cat {} \; | wc -w)"
	@echo "$(GREEN)Repository size:$(NC) $$(du -sh . | cut -f1)"

update: ## Update repository and scripts
	@echo "$(CYAN)Updating repository...$(NC)"
	@git pull origin main
	@echo "$(GREEN)✓ Repository updated!$(NC)"

quick-commit: ## Quick commit all changes with timestamp
	@echo "$(CYAN)Quick commit...$(NC)"
	@git add .
	@git commit -m "Update notes - $$(date '+%Y-%m-%d %H:%M:%S')" || true
	@git push origin $$(git branch --show-current)
	@echo "$(GREEN)✓ Changes committed and pushed!$(NC)"

check: ## Check for broken links and issues
	@echo "$(CYAN)Checking for issues...$(NC)"
	@echo "$(YELLOW)Looking for broken links...$(NC)"
	@grep -r "\[\[.*\]\]" . --include="*.md" | grep -v ".git" || echo "$(GREEN)No broken links found$(NC)"

list-tags: ## List all tags in notes
	@echo "$(CYAN)Tags used in notes:$(NC)"
	@grep -roh "#[a-zA-Z0-9_-]*" . --include="*.md" | sort | uniq -c | sort -rn

.SILENT: help
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
