# Git Submodules

This repository uses git submodules for external dependencies and resources.

## Available Submodules

### modules/obsidian-plugins
Official Obsidian community plugins repository
- **URL**: https://github.com/obsidianmd/obsidian-releases.git
- **Purpose**: Reference for available Obsidian plugins

### modules/awesome-obsidian
Curated list of Obsidian resources
- **URL**: https://github.com/kmaasrud/awesome-obsidian.git
- **Purpose**: Collection of awesome Obsidian resources and tools

## Working with Submodules

### Initialize submodules (first time)
```bash
git submodule update --init --recursive
```

### Update all submodules
```bash
git submodule update --remote --recursive
```

### Update specific submodule
```bash
git submodule update --remote modules/obsidian-plugins
```

### Clone repository with submodules
```bash
git clone --recurse-submodules https://github.com/professoroakz/obsidian-pub.git
```

### Add new submodule
```bash
git submodule add <repository-url> <path>
git commit -m "Add submodule: <name>"
```

### Remove submodule
```bash
git submodule deinit -f <path>
git rm -f <path>
rm -rf .git/modules/<path>
git commit -m "Remove submodule: <name>"
```

## Makefile Commands

```bash
make submodule-init      # Initialize all submodules
make submodule-update    # Update all submodules
make submodule-status    # Show submodule status
```

## Important Notes

- Submodules are referenced at specific commits
- Updates must be explicitly pulled and committed
- Each submodule has its own git repository
- Submodules are tracked in `.gitmodules` file
