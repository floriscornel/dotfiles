# 🚀 Dotfiles

My personal, automated environment for macOS and Linux, managed by [chezmoi](https://chezmoi.io).

## 🛠 Stack

- **[Mise](https://mise.jdx.dev/)**: Global and project-level toolchain manager.
- **[Fish](https://fishshell.com/)**: Primary shell, set as default automatically.

## ⚡ Installation

Bootstrapping a new Mac or Linux VM takes just one command. This will install `chezmoi`, clone this repository, install `mise`, download all tools, and set up `fish`.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply floriscornel
```

## 🔄 Daily Usage

Use `chezmoi` to edit and sync your files across machines:

```bash
# Add a new file to be tracked
chezmoi add ~/.config/fish/config.fish

# Edit a tracked file
chezmoi edit ~/.config/fish/config.fish

# Apply changes locally
chezmoi apply

# Push updates to GitHub
cd $(chezmoi source-path)
git add .
git commit -m "Update config"
git push
```
