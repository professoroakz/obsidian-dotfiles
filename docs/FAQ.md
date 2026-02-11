# Frequently Asked Questions

## General

### What is this repository for?

This repository stores Obsidian markdown notes with git version control, automated syncing, and backup capabilities.

### Why use git for notes?

Git provides:
- Version history for all changes
- Backup and recovery
- Synchronization across devices
- Collaboration capabilities
- Automation through scripts and hooks

### Can I use this with Obsidian?

Yes! This repository is designed to work seamlessly with Obsidian. Just open the repository folder as your Obsidian vault.

## Setup

### How do I get started?

```bash
git clone https://github.com/professoroakz/obsidian-pub.git
cd obsidian-pub
make init
```

### What does `make init` do?

It creates:
- `.env` file from template
- `.obsidian` directory
- `notes` directory
- Required folder structure

### Do I need to install anything?

You need:
- Git (for version control)
- Make (for automation)
- Bash (for scripts)
- Optional: Obsidian app

## Usage

### How do I sync my notes?

```bash
make sync
```

This pulls changes, commits your updates, and pushes to GitHub.

### How often should I sync?

As often as you make changes. You can also use the automated GitHub Actions workflow for daily syncing.

### What if I have merge conflicts?

```bash
# Check status
git status

# Resolve conflicts manually
# Edit conflicted files
git add .
git commit -m "Resolved conflicts"
git push
```

### How do I create backups?

```bash
make backup
```

Backups are stored in `./backups/` as compressed archives.

### How do I restore from backup?

```bash
# List backups
ls -lh backups/

# Extract to a temporary location first
mkdir /tmp/restore
tar -xzf backups/obsidian_backup_YYYYMMDD_HHMMSS.tar.gz -C /tmp/restore

# Review and copy files as needed
```

## Customization

### How do I change backup settings?

Edit `.env`:

```bash
BACKUP_DIR=./backups
BACKUP_RETENTION_DAYS=30
```

### Can I disable auto-sync?

Yes, remove or disable the GitHub Actions workflow:

```bash
# Disable workflow
rm .github/workflows/auto-sync.yml
```

### How do I change the sync schedule?

Edit `.github/workflows/auto-sync.yml` and modify the cron expression:

```yaml
schedule:
  - cron: '0 2 * * *'  # Daily at 2 AM
```

## Troubleshooting

### Scripts won't run

Make them executable:

```bash
chmod +x scripts/*.sh
```

### Large file errors

Files over 5MB trigger warnings. Options:
1. Use Git LFS for large files
2. Exclude from git in `.gitignore`
3. Store externally and link

### Permission denied errors

Check file permissions:

```bash
ls -la scripts/
chmod +x scripts/*.sh
```

### GitHub Actions not running

Check:
1. Workflows are enabled in repository settings
2. Actions have appropriate permissions
3. Workflow files are in `.github/workflows/`

### Git authentication issues

Use SSH or configure Git credentials:

```bash
# Using SSH
git remote set-url origin git@github.com:professoroakz/obsidian-pub.git

# Using personal access token
git remote set-url origin https://TOKEN@github.com/professoroakz/obsidian-pub.git
```

## Advanced

### Can I use this with multiple devices?

Yes! Clone the repository on each device and sync regularly:

```bash
# Device 1
make sync

# Device 2
make sync
```

### How do I migrate existing notes?

```bash
# Copy your notes
cp -r /path/to/existing/notes/* notes/

# Commit and push
make quick-commit
```

### Can I keep some notes private?

Yes, use `.gitignore`:

```bash
# Add to .gitignore
notes/private/
notes/secret.md
```

### How do I contribute?

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

### Can I use different editors?

Yes! This is a standard markdown repository. Use any editor:
- VSCode
- Vim/Neovim
- Sublime Text
- Any markdown editor

The `.editorconfig` file ensures consistent formatting.

## Best Practices

### Organize notes in folders?

Yes, recommended structure:

```text
notes/
├── daily/
├── projects/
├── reference/
└── templates/
```

### Use tags?

Absolutely! Tags help with organization:

```markdown
#project #important #todo
```

### Commit message conventions?

Follow conventional commits:

```bash
git commit -m "feat: add new project note"
git commit -m "fix: correct typo in readme"
git commit -m "docs: update setup instructions"
```

Or use `make quick-commit` for timestamped commits.

## Support

### Where can I get help?

1. Check this FAQ
2. Review [CONTRIBUTING.md](../CONTRIBUTING.md)
3. Open an issue on GitHub
4. Check the [Obsidian documentation](https://help.obsidian.md/)

### How do I report bugs?

Use the bug report template:

1. Go to Issues
2. Select "Bug Report"
3. Fill in the template
4. Submit

### How do I request features?

Use the feature request template:

1. Go to Issues
2. Select "Feature Request"
3. Describe your idea
4. Submit
