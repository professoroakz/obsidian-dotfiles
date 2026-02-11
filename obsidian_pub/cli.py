#!/usr/bin/env python3
"""
CLI for obsidian-pub - Obsidian Vault Management Tool
"""

import argparse
import subprocess
import sys
from pathlib import Path


def run_command(cmd, cwd=None):
    """Run a shell command and return the result."""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr}", file=sys.stderr)
        sys.exit(1)


def sync_vault(args):
    """Sync vault with git."""
    vault_path = Path(args.vault).resolve()
    if not vault_path.exists():
        print(f"Error: Vault not found at {vault_path}", file=sys.stderr)
        sys.exit(1)
    
    print("Syncing vault...")
    run_command("git pull --rebase", cwd=vault_path)
    run_command("git add -A", cwd=vault_path)
    
    try:
        message = args.message or "auto"
        run_command(f'git commit -m "vault sync {message}"', cwd=vault_path)
    except subprocess.CalledProcessError:
        print("No changes to commit")
    
    run_command("git push", cwd=vault_path)
    print("✓ Vault synced successfully!")


def backup_vault(args):
    """Create a backup of the vault."""
    vault_path = Path(args.vault).resolve()
    backup_script = vault_path / "scripts" / "backup.sh"
    
    if backup_script.exists():
        run_command(str(backup_script), cwd=vault_path)
    else:
        print("Error: Backup script not found", file=sys.stderr)
        sys.exit(1)


def stats_vault(args):
    """Show vault statistics."""
    vault_path = Path(args.vault).resolve()
    
    # Count markdown files
    md_files = list(vault_path.rglob("*.md"))
    md_files = [f for f in md_files if not any(
        part.startswith('.') for part in f.parts
    )]
    
    # Count words
    total_words = 0
    for file in md_files:
        try:
            with open(file, 'r', encoding='utf-8') as f:
                content = f.read()
                total_words += len(content.split())
        except (IOError, UnicodeDecodeError) as e:
            print(f"Warning: Could not read {file}: {e}", file=sys.stderr)
    
    print(f"Vault Statistics:")
    print(f"  Total notes: {len(md_files)}")
    print(f"  Total words: {total_words}")
    print(f"  Location: {vault_path}")


def init_vault(args):
    """Initialize a new vault."""
    vault_path = Path(args.vault).resolve()
    vault_path.mkdir(parents=True, exist_ok=True)
    
    # Create basic structure
    (vault_path / "notes").mkdir(exist_ok=True)
    (vault_path / "templates").mkdir(exist_ok=True)
    (vault_path / "attachments").mkdir(exist_ok=True)
    (vault_path / ".obsidian").mkdir(exist_ok=True)
    
    print(f"✓ Vault initialized at {vault_path}")


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Obsidian Vault Management CLI",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  obsidian-pub sync                    # Sync current vault
  obsidian-pub sync --vault ~/notes    # Sync specific vault
  obsidian-pub backup                  # Create backup
  obsidian-pub stats                   # Show statistics
  obsidian-pub init --vault ~/notes    # Initialize new vault
        """
    )
    
    parser.add_argument(
        '--version',
        action='version',
        version='%(prog)s 0.1.0'
    )
    
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # Sync command
    sync_parser = subparsers.add_parser('sync', help='Sync vault with git')
    sync_parser.add_argument(
        '--vault',
        default='.',
        help='Path to vault (default: current directory)'
    )
    sync_parser.add_argument(
        '--message',
        '-m',
        help='Commit message'
    )
    sync_parser.set_defaults(func=sync_vault)
    
    # Backup command
    backup_parser = subparsers.add_parser('backup', help='Create vault backup')
    backup_parser.add_argument(
        '--vault',
        default='.',
        help='Path to vault (default: current directory)'
    )
    backup_parser.set_defaults(func=backup_vault)
    
    # Stats command
    stats_parser = subparsers.add_parser('stats', help='Show vault statistics')
    stats_parser.add_argument(
        '--vault',
        default='.',
        help='Path to vault (default: current directory)'
    )
    stats_parser.set_defaults(func=stats_vault)
    
    # Init command
    init_parser = subparsers.add_parser('init', help='Initialize new vault')
    init_parser.add_argument(
        '--vault',
        required=True,
        help='Path to new vault'
    )
    init_parser.set_defaults(func=init_vault)
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        sys.exit(1)
    
    args.func(args)


if __name__ == '__main__':
    main()
