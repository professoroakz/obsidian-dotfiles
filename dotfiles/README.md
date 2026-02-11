# Dotfiles Directory

This directory contains configuration files and shell enhancements for the obsidian-pub environment.

## Files

### Shell Configuration
- `.bashrc.local` - Bash shell configuration
- `.zshrc.local` - Zsh shell configuration

### Git Configuration
- `.gitconfig.local` - Git aliases and vault-specific settings
- `.gitattributes` - Git attributes for file handling

### Environment
- `.env.example.extended` - Extended environment variables template

## Usage

### Bash
Add to your `~/.bashrc`:

```bash
if [ -f /path/to/obsidian-pub/.bashrc.local ]; then
    source /path/to/obsidian-pub/.bashrc.local
fi
```

### Zsh
Add to your `~/.zshrc`:

```bash
if [ -f /path/to/obsidian-pub/.zshrc.local ]; then
    source /path/to/obsidian-pub/.zshrc.local
fi
```

### Git
Include in your `~/.gitconfig`:

```ini
[include]
    path = /path/to/obsidian-pub/.gitconfig.local
```

## Available Aliases

- `ovault` - Navigate to vault root
- `osync` - Sync vault with git
- `obackup` - Create vault backup
- `ostats` - Show vault statistics
- `oinit` - Initialize vault

## Available Functions

- `vault-search <query>` - Search for text in markdown files
- `vault-tags` - List all tags used in notes
- `vault-count` - Show vault statistics
