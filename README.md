# Void Dotfiles

dotfiles are the files that starts with a `.` (dot). This files are generally responsible for software configurations. This repository contains my favorite and most used dotfiles in my `Void Linux` setup.

| **Module Type**     |                     **Module Name**                     |
| :------------------ | :-----------------------------------------------------: |
| Window Manager      |         [sway](https://github.com/swaywm/sway)          |
| Terminal            |         [foot](https://codeberg.org/dnkl/foot)          |
| Status Bar          |       [waybar](https://github.com/Alexays/Waybar)       |
| Text Editor         |        [nvim](https://github.com/neovim/neovim)         |
| Shell               |           [zsh](https://zsh.sourceforge.io/)            |
| App Launcher        |       [fuzzel](https://codeberg.org/dnkl/fuzzel)        |
| File Manager        |         [yazi](https://github.com/sxyazi/yazi)          |
| Notification Deamon |     [dunst](https://github.com/dunst-project/dunst)     |
| Screen Locker       |       [swaylock](https://github.com/swaywm/sway)        |
| System Info Tool    | [fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| Resource Monitor    |      [btop](https://github.com/aristocratos/btop)       |

## 🛠️ Installation & Management

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks. This allows a clean separation between the repository and your `$HOME` directory.

### 1. Prerequisites

Ensure you have `stow` installed on your Void Linux system:

```bash
sudo xbps-install -S stow
```

### 2. Deployment

To "install" a specific configuration (e.g., `nvim` or `fuzzel`), navigate to the `dotfiles` directory and use the following command:

```bash
cd ~/Documents/void-dotfiles
stow -t $HOME <folder_name>
```

To deploy all packages at once:

```bash
stow -t $HOME --ignore='README.md' --ignore='.git' --ignore='LICENSE' */
```

### 3. Handling Conflicts

If a file already exists in your `$HOME/.config`, Stow will abort to prevent data loss. You can "adopt" existing files into the repository using:

```bash
stow -t $HOME --adopt <folder_name>
```

> **Note:** Using `--adopt` will overwrite the file in the repository with the one from your local system. Use `git restore .` if you want to keep the repository version instead.
