# Makefile for Obsidian Vault Management
# obsidian-pub - Obsidian iCloud 2026 Markdown Notes

.PHONY: help init clean sync backup verify test install-hooks status stats update quick-commit check list-tags push pull lint count docker-build docker-run python-install python-dev npm-install npm-dev brew-install submodule-init submodule-update submodule-status

# Default target
.DEFAULT_GOAL := help

# Colors for output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Project variables
PROJECT_NAME := obsidian-pub
DOCKER_IMAGE := $(PROJECT_NAME):latest
PYTHON_VERSION := 3.9

help: ## Show this help message
	@echo "$(CYAN)$(PROJECT_NAME) Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(NC) %s\n", $$1, $$2}'

# ===== Repository Management =====

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
	@find . -type f -name "*.swp" -delete 2>/dev/null || true
	@find . -type f -name "*.swo" -delete 2>/dev/null || true
	@find . -type f -name "*~" -delete 2>/dev/null || true
	@find . -type f -name ".DS_Store" -delete 2>/dev/null || true
	@find . -type f -name "*.log" -delete 2>/dev/null || true
	@find . -type f -name "*.tmp" -delete 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "dist" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "build" -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete!$(NC)"

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

# ===== Git Operations =====

status: ## Show git status in a readable format
	@echo "$(CYAN)Repository status:$(NC)"
	@git status -sb

sync: ## Sync notes with git (pull then push)
	@echo "$(CYAN)Syncing vault...$(NC)"
	@if git pull --rebase origin $$(git branch --show-current); then \
		git add -A && \
		git commit -m "vault: sync $$(date +%Y-%m-%d\ %H:%M)" || true && \
		git push origin $$(git branch --show-current); \
	else \
		echo "$(RED)Pull failed - please resolve conflicts manually$(NC)"; \
		exit 1; \
	fi

push: ## Stage all changes and push to remote
	@echo "$(CYAN)Pushing changes...$(NC)"
	@git add -A
	@git commit -m "vault: sync $$(date +%Y-%m-%d\ %H:%M)" || true
	@git push origin $$(git branch --show-current)

pull: ## Pull latest changes from remote
	@echo "$(CYAN)Pulling changes...$(NC)"
	@git pull --rebase

quick-commit: ## Quick commit all changes with timestamp
	@echo "$(CYAN)Quick commit...$(NC)"
	@git add .
	@git commit -m "Update notes - $$(date '+%Y-%m-%d %H:%M:%S')" || true
	@git push origin $$(git branch --show-current)
	@echo "$(GREEN)✓ Changes committed and pushed!$(NC)"

# ===== Backup & Statistics =====

backup: ## Create a backup of the vault
	@echo "$(CYAN)Creating backup...$(NC)"
	@./scripts/backup.sh

stats: ## Show repository statistics
	@echo "$(CYAN)Repository Statistics:$(NC)"
	@echo "$(GREEN)Total notes:$(NC) $$(find . -name '*.md' -not -path '*/\.*' -not -path '*/node_modules/*' | wc -l)"
	@echo "$(GREEN)Total words:$(NC) $$(find . -name '*.md' -not -path '*/\.*' -not -path '*/node_modules/*' -exec cat {} \; | wc -w)"
	@echo "$(GREEN)Repository size:$(NC) $$(du -sh . | cut -f1)"

count: stats ## Alias for stats

# ===== Linting & Checking =====

lint: ## Check for broken links (requires markdown-link-check)
	@echo "$(CYAN)Checking for broken links...$(NC)"
	@if command -v markdown-link-check >/dev/null 2>&1; then \
		find . -name "*.md" -not -path "./.obsidian/*" -not -path "*/node_modules/*" -exec markdown-link-check {} \; ; \
	else \
		echo "$(YELLOW)markdown-link-check not installed$(NC)"; \
		echo "$(YELLOW)Install with: npm install -g markdown-link-check$(NC)"; \
	fi

check: ## Check for broken links and issues
	@echo "$(CYAN)Checking for issues...$(NC)"
	@echo "$(YELLOW)Looking for broken internal links...$(NC)"
	@grep -r "\[\[.*\]\]" . --include="*.md" --exclude-dir=".git" --exclude-dir="node_modules" || echo "$(GREEN)No broken links found$(NC)"

list-tags: ## List all tags in notes
	@echo "$(CYAN)Tags used in notes:$(NC)"
	@grep -roh "#[a-zA-Z0-9_-]*" . --include="*.md" --exclude-dir=".git" --exclude-dir="node_modules" | sort | uniq -c | sort -rn

# ===== Python Package Management =====

python-install: ## Install Python package and dependencies
	@echo "$(CYAN)Installing Python package...$(NC)"
	@if command -v python3 >/dev/null 2>&1; then \
		python3 -m pip install --upgrade pip; \
		python3 -m pip install -e .; \
		echo "$(GREEN)✓ Python package installed$(NC)"; \
	else \
		echo "$(RED)Python 3 not found$(NC)"; \
		exit 1; \
	fi

python-dev: ## Install Python development dependencies
	@echo "$(CYAN)Installing Python dev dependencies...$(NC)"
	@python3 -m pip install -e ".[dev]"
	@echo "$(GREEN)✓ Dev dependencies installed$(NC)"

python-build: ## Build Python distribution packages
	@echo "$(CYAN)Building Python package...$(NC)"
	@python3 -m pip install --upgrade build
	@python3 -m build
	@echo "$(GREEN)✓ Package built in dist/$(NC)"

python-publish: ## Publish Python package to PyPI
	@echo "$(CYAN)Publishing to PyPI...$(NC)"
	@python3 -m pip install --upgrade twine
	@python3 -m twine upload dist/*

# ===== NPM Package Management =====

npm-install: ## Install NPM dependencies
	@echo "$(CYAN)Installing NPM dependencies...$(NC)"
	@if command -v npm >/dev/null 2>&1; then \
		npm install; \
		echo "$(GREEN)✓ NPM dependencies installed$(NC)"; \
	else \
		echo "$(RED)NPM not found$(NC)"; \
		exit 1; \
	fi

npm-dev: ## Install NPM development dependencies
	@echo "$(CYAN)Installing NPM dev dependencies...$(NC)"
	@npm install --save-dev
	@echo "$(GREEN)✓ Dev dependencies installed$(NC)"

npm-build: ## Build NPM package
	@echo "$(CYAN)Building NPM package...$(NC)"
	@npm run build
	@echo "$(GREEN)✓ NPM package built$(NC)"

npm-publish: ## Publish NPM package
	@echo "$(CYAN)Publishing to NPM...$(NC)"
	@npm publish

npm-test: ## Run NPM tests
	@npm test

# ===== Docker Management =====

docker-build: ## Build Docker image
	@echo "$(CYAN)Building Docker image...$(NC)"
	@docker build -t $(DOCKER_IMAGE) .
	@echo "$(GREEN)✓ Docker image built: $(DOCKER_IMAGE)$(NC)"

docker-run: ## Run Docker container
	@echo "$(CYAN)Running Docker container...$(NC)"
	@docker run -it --rm -v $$(pwd):/workspace $(DOCKER_IMAGE)

docker-shell: ## Open shell in Docker container
	@echo "$(CYAN)Opening Docker shell...$(NC)"
	@docker run -it --rm -v $$(pwd):/workspace $(DOCKER_IMAGE) /bin/bash

docker-clean: ## Remove Docker images
	@echo "$(CYAN)Cleaning Docker images...$(NC)"
	@docker rmi $(DOCKER_IMAGE) 2>/dev/null || true
	@echo "$(GREEN)✓ Docker images cleaned$(NC)"

# ===== Homebrew CLI =====

brew-install: ## Install via Homebrew (for development)
	@echo "$(CYAN)Installing via Homebrew...$(NC)"
	@brew install --build-from-source Formula/obsidian-pub.rb || echo "$(YELLOW)Run from homebrew tap$(NC)"

brew-test: ## Test Homebrew formula
	@brew install --build-from-source --verbose --debug Formula/obsidian-pub.rb

# ===== Update & Maintenance =====

update: ## Update repository and scripts
	@echo "$(CYAN)Updating repository...$(NC)"
	@git pull origin main
	@echo "$(GREEN)✓ Repository updated!$(NC)"

update-deps: ## Update all dependencies
	@echo "$(CYAN)Updating dependencies...$(NC)"
	@if [ -f requirements.txt ]; then python3 -m pip install --upgrade -r requirements.txt; fi
	@if [ -f package.json ]; then npm update; fi
	@echo "$(GREEN)✓ Dependencies updated!$(NC)"

# ===== All-in-One Commands =====

all: init install-hooks python-install npm-install ## Complete setup (init + hooks + Python + NPM)

dev-setup: all ## Alias for all

# ===== Git Submodules =====

submodule-init: ## Initialize git submodules
	@echo "$(CYAN)Initializing git submodules...$(NC)"
	@git submodule update --init --recursive
	@echo "$(GREEN)✓ Submodules initialized$(NC)"

submodule-update: ## Update all git submodules
	@echo "$(CYAN)Updating git submodules...$(NC)"
	@git submodule update --remote --recursive
	@echo "$(GREEN)✓ Submodules updated$(NC)"

submodule-status: ## Show git submodule status
	@echo "$(CYAN)Submodule status:$(NC)"
	@git submodule status

submodule-foreach: ## Execute command in each submodule (use CMD=...)
	@echo "$(CYAN)Executing in submodules: $(CMD)$(NC)"
	@git submodule foreach '$(CMD)'

.SILENT: help
