# Quick Reference

## Common Commands

### Initialization
```bash
make init                # First-time setup
make install-hooks       # Install git hooks
```

### Daily Workflow
```bash
make sync               # Sync with git
make quick-commit       # Quick commit with timestamp
make backup             # Create backup
make status             # Check git status
```

### Maintenance
```bash
make clean              # Remove temporary files
make verify             # Verify repository structure
make stats              # Show statistics
make update             # Update repository
```

## Script Usage

### Sync Script
```bash
./scripts/sync.sh
```
Pulls changes, commits updates, and pushes to remote.

### Backup Script
```bash
./scripts/backup.sh
```
Creates timestamped backup in `./backups/`.

### Verify Script
```bash
./scripts/verify.sh
```
Checks repository health and configuration.

## Environment Variables

```bash
# .env configuration
BACKUP_DIR=./backups
BACKUP_RETENTION_DAYS=30
AUTO_COMMIT=true
SYNC_INTERVAL=3600
```

## Git Commands

### Basic Operations
```bash
git status              # Check status
git add .               # Stage all changes
git commit -m "msg"     # Commit with message
git push                # Push to remote
git pull                # Pull from remote
```

### Useful Shortcuts
```bash
make quick-commit       # Add, commit, push with timestamp
make sync               # Full sync workflow
```

## Markdown Tips

### Obsidian Links
```markdown
[[Note Name]]           # Internal link
[[Note|Alias]]          # Link with custom text
![[Image.png]]          # Embed image
```

### Tags
```markdown
#tag                    # Simple tag
#nested/tag             # Nested tag
```

### Code Blocks
````markdown
```language
code here
```
````

## Troubleshooting

### Sync Issues
```bash
git status              # Check what's wrong
git pull --rebase       # Pull with rebase
git push --force        # Force push (careful!)
```

### Large Files
```bash
# Check for large files
find . -type f -size +5M -not -path "./.git/*"

# Use git lfs for large files
git lfs track "*.pdf"
```

### Backup Recovery
```bash
# List backups
ls -lh backups/

# Extract backup
tar -xzf backups/obsidian_backup_YYYYMMDD_HHMMSS.tar.gz -C /destination
```

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `make` | Show help |
| `make s` + Tab | Auto-complete to sync |
| `Ctrl+C` | Cancel operation |

## Best Practices

1. Run `make sync` regularly
2. Create backups before major changes
3. Use meaningful commit messages
4. Keep notes organized in folders
5. Review `make verify` output periodically

## Links

- [Obsidian Help](https://help.obsidian.md/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Git Documentation](https://git-scm.com/doc)
