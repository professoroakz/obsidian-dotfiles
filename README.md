# obsidian-pub 📝

Obsidian iCloud 2026 Markdown Notes @pub

[![CI](https://github.com/professoroakz/obsidian-pub/workflows/CI/badge.svg)](https://github.com/professoroakz/obsidian-pub/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A public repository for my Obsidian markdown notes, synchronized with iCloud and managed with git automation.

## 🚀 Quick Start

### First-Time Setup

```bash
# Clone the repository
git clone https://github.com/professoroakz/obsidian-pub.git
cd obsidian-pub

# Initialize the environment
make init

# Install git hooks (optional but recommended)
make install-hooks
```

### Daily Usage

```bash
# Sync notes (pull, commit, push)
make sync

# Quick commit with timestamp
make quick-commit

# Create a backup
make backup

# Check repository status
make status

# View all available commands
make help
```

## 📋 Features

- ✅ **Automated Environment Setup** - One-command initialization with Makefile
- ✅ **Git Automation** - Scripts for syncing, backing up, and managing notes
- ✅ **Pre-commit Hooks** - Prevent large files and merge conflicts
- ✅ **GitHub Actions** - CI/CD for verification and auto-sync
- ✅ **EditorConfig** - Consistent formatting across editors
- ✅ **Documentation** - Contributing guidelines, security policy, changelog
- ✅ **Issue Templates** - Structured bug reports and feature requests

## 🛠️ Available Commands

Run `make help` to see all available commands:

| Command | Description |
|---------|-------------|
| `make init` | Initialize repository (first-time setup) |
| `make sync` | Sync notes with git (pull, commit, push) |
| `make backup` | Create a backup of the vault |
| `make clean` | Clean temporary files and caches |
| `make verify` | Verify repository structure |
| `make status` | Show git status |
| `make stats` | Show repository statistics |
| `make quick-commit` | Quick commit with timestamp |
| `make install-hooks` | Install git hooks |
| `make help` | Show all available commands |

## 📁 Repository Structure

```text
obsidian-pub/
├── .github/              # GitHub configuration
│   ├── ISSUE_TEMPLATE/   # Issue templates
│   ├── workflows/        # GitHub Actions
│   └── pull_request_template.md
├── scripts/              # Automation scripts
│   ├── sync.sh           # Git sync automation
│   ├── backup.sh         # Backup creation
│   ├── verify.sh         # Repository verification
│   └── install-hooks.sh  # Git hooks installer
├── notes/                # Your markdown notes (create this)
├── .editorconfig         # Editor configuration
├── .env.example          # Environment variables template
├── .gitignore            # Git ignore rules
├── CHANGELOG.md          # Version history
├── CONTRIBUTING.md       # Contribution guidelines
├── LICENSE               # MIT License
├── Makefile              # Task automation
├── README.md             # This file
└── SECURITY.md           # Security policy
```

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize:

```bash
cp .env.example .env
```

Edit `.env` to configure:
- Backup settings
- Sync intervals
- Git configuration
- Publishing options

### Git Configuration

The scripts will use your global git configuration. To set it:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 📝 Usage Examples

### Sync Notes Manually

```bash
make sync
# or
./scripts/sync.sh
```

### Create a Backup

```bash
make backup
# or
./scripts/backup.sh
```

Backups are stored in `./backups/` by default.

### Check Repository Health

```bash
make verify
```

This checks:
- Required files exist
- Git configuration
- Script permissions
- Environment setup

### View Statistics

```bash
make stats
```

Shows:
- Total number of notes
- Total word count
- Repository size

## 🤖 Automation

### GitHub Actions

This repository includes GitHub Actions workflows:

1. **CI Workflow** (`.github/workflows/ci.yml`)
   - Runs on every push and pull request
   - Verifies repository structure
   - Checks script syntax
   - Lints markdown files

2. **Auto Sync Workflow** (`.github/workflows/auto-sync.yml`)
   - Runs daily at 2 AM UTC
   - Can be triggered manually
   - Automatically commits and pushes changes

### Git Hooks

Install pre-commit hooks with:

```bash
make install-hooks
```

Hooks will:
- Prevent commits with files >5MB
- Check for merge conflict markers
- Ensure clean commits

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 🔒 Security

For security concerns, please see [SECURITY.md](SECURITY.md).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Inspired by:
- [.floppies](https://github.com/professoroakz/.floppies) - Development environment setup
- [Obsidian](https://obsidian.md/) - The knowledge base tool
- Community best practices for git-based note management

## 📚 Documentation

- [CHANGELOG.md](CHANGELOG.md) - Version history and changes
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [SECURITY.md](SECURITY.md) - Security policy
- `.env.example` - Configuration template

## 💡 Tips

- Use `make quick-commit` for rapid note updates
- Run `make backup` before major changes
- Check `make stats` to track your note-taking progress
- Use `make verify` to ensure everything is configured correctly

---

Made with ❤️ for organized note-taking and knowledge management.
