# Dotfiles Makefile
# Convenient commands for managing your dotfiles

.PHONY: help install uninstall update backup check clean test

# Default target
.DEFAULT_GOAL := help

# Colors
BLUE := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
NC := \033[0m

help: ## Show this help message
	@echo "$(GREEN)Dotfiles Management$(NC)"
	@echo "===================="
	@echo ""
	@echo "$(BLUE)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

install: ## Install dotfiles (packages + configs)
	@echo "$(BLUE)Installing dotfiles...$(NC)"
	@./install.sh

uninstall: ## Remove dotfiles and restore backups
	@echo "$(RED)Uninstalling dotfiles...$(NC)"
	@./uninstall.sh

update: ## Update dotfiles from git and reload configs
	@echo "$(BLUE)Updating dotfiles...$(NC)"
	@./update.sh

backup: ## Backup current dotfiles to git
	@echo "$(BLUE)Backing up dotfiles...$(NC)"
	@./scripts/dotfiles-backup backup

backup-setup: ## Setup automatic backups (hourly/daily/weekly)
	@read -p "Backup interval (hourly/daily/weekly): " interval; \
	./scripts/dotfiles-backup setup $$interval

backup-remove: ## Remove automatic backup cron job
	@echo "$(YELLOW)Removing automatic backups...$(NC)"
	@./scripts/dotfiles-backup remove

check: ## Check configuration health
	@echo "$(BLUE)Checking configuration...$(NC)"
	@./check-config.sh

status: ## Show git status of dotfiles
	@echo "$(BLUE)Git status:$(NC)"
	@git status --short

lint: ## Check for syntax errors in configs
	@echo "$(BLUE)Checking configs for syntax errors...$(NC)"
	@if command -v hyprctl >/dev/null 2>&1; then \
		hyprctl reload 2>&1 | grep -i "error" || echo "$(GREEN)No errors found in Hyprland config$(NC)"; \
	fi
	@if command -v fish >/dev/null 2>&1; then \
		fish -n ~/.config/fish/config.fish 2>&1 || echo "$(GREEN)Fish config OK$(NC)"; \
	fi

clean: ## Clean cache and temporary files
	@echo "$(YELLOW)Cleaning cache files...$(NC)"
	@rm -rf ~/.cache/wallust/*
	@rm -rf /tmp/hypr*
	@echo "$(GREEN)Cache cleaned$(NC)"

theme-toggle: ## Toggle between light and dark themes
	@./scripts/theme-switcher toggle

theme-light: ## Set light theme
	@./scripts/theme-switcher light

theme-dark: ## Set dark theme
	@./scripts/theme-switcher dark

wallpaper: ## Change wallpaper
	@~/.local/bin/swww-wallpaper.sh

clipboard: ## Show clipboard history
	@./scripts/clipboard-manager show

wifi: ## Show WiFi menu
	@./scripts/rofi-wifi

bluetooth: ## Show Bluetooth menu
	@./scripts/rofi-bluetooth

power: ## Show power menu
	@./scripts/rofi-power

monitors: ## Show monitor layout menu
	@./scripts/monitor-layout menu

keybindings: ## Generate keybindings reference
	@./scripts/generate-keybindings.sh
	@echo "$(GREEN)Keybindings saved to ~/.config/hypr/KEYBINDINGS.md$(NC)"

secrets-init: ## Initialize secrets management
	@echo "$(BLUE)Setting up secrets management...$(NC)"
	@cp templates/secrets.env.template ~/.config/secrets.env
	@cat templates/secrets.gitignore >> .gitignore
	@echo "$(GREEN)Secrets template created at ~/.config/secrets.env$(NC)"
	@echo "$(YELLOW)Remember to add your secrets and NEVER commit them!$(NC)"

edit-fish: ## Edit fish config
	@${EDITOR:-nano} ~/.config/fish/config.fish

edit-hypr: ## Edit hyprland config
	@${EDITOR:-nano} ~/.config/hypr/hyprland.conf

edit-waybar: ## Edit waybar config
	@${EDITOR:-nano} ~/.config/waybar/config

test: ## Run tests (if any)
	@echo "$(BLUE)Running tests...$(NC)"
	@if [ -d "tests" ]; then \
		for test in tests/*.sh; do \
			if [ -f "$$test" ]; then \
				echo "Running $$test..."; \
				bash "$$test"; \
			fi; \
		done; \
	else \
		echo "$(YELLOW)No tests found$(NC)"; \
	fi

# Development
dev-install: ## Install development dependencies
	@echo "$(BLUE)Installing development dependencies...$(NC)"
	@command -v sqlite3 >/dev/null 2>&1 || echo "$(YELLOW)Warning: sqlite3 not installed (needed for clipboard manager)$(NC)"
	@command -v jq >/dev/null 2>&1 || echo "$(YELLOW)Warning: jq not installed (needed for monitor layout)$(NC)"
	@echo "$(GREEN)Development check complete$(NC)"

# Git helpers
commit: ## Quick commit with message
	@read -p "Commit message: " msg; \
	git add -A && git commit -m "$$msg"

push: ## Push to remote
	@git push origin $(shell git branch --show-current)

pull: ## Pull from remote
	@git pull origin $(shell git branch --show-current)

# Maintenance
deps: ## Show system dependencies status
	@echo "$(BLUE)Checking dependencies...$(NC)"
	@for dep in hyprland waybar rofi fish swww kitty wallust cliphist wl-clipboard brightnessctl playerctl grim slurp; do \
		if command -v $$dep >/dev/null 2>&1; then \
			echo "  $(GREEN)✓$(NC) $$dep"; \
		else \
			echo "  $(RED)✗$(NC) $$dep"; \
		fi; \
	done
