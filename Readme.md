# Terminal Configuration Setup

Just some configurations copied from somewhere and edited some parts + vibecoded README file.

## 🚀 Features

- **Fish Shell** - A smart and user-friendly command line shell
- **Kitty Terminal** - A fast, feature-rich, GPU-based terminal emulator
- **Fastfetch/Neofetch** - Beautiful system information display
- **Doas** - A lightweight alternative to sudo
- **JetBrains Mono** - A beautiful and highly readable monospaced font
- **UV** - An extremely fast Python package installer and resolver
- **TheFuck** - Magnificent app that corrects your previous console commands

## 📦 What's Included

### Configurations
- **Fish Shell** (`fish/`)
  - Enhanced prompt with Git status indicators
  - Command execution time tracking
  - Programming language/framework detection with icons
  - Dracula-inspired color scheme
  - TheFuck integration for command correction

- **Kitty Terminal** (`kitty/`)
  - JetBrains Mono font configuration
  - Dracula color theme
  - Custom keyboard shortcuts
  - Performance optimizations
  - Modern UI settings

- **Fastfetch** (`fastfetch/`)
  - Arch Linux logo with custom colors
  - Organized system information display
  - Color-coded sections for different hardware/software info

- **Neofetch** (`neofetch/`)
  - Alternative system information display
  - Custom color scheme and layout
  - Progress bars for system metrics

- **Doas** (`doas.conf`)
  - Simple configuration allowing wheel group members to use doas

### Installation Script
- **Automated Setup** (`install.sh`)
  - Detects your Linux distribution (Debian, Arch, Fedora)
  - Installs all required packages
  - Configures system settings
  - Copies configuration files to appropriate locations
  - Sets up doas permissions
  - Changes default shell to Fish

## 🛠️ Installation

### Prerequisites
- Linux system (Debian-based, Arch-based, or Fedora-based)
- Root/sudo access for package installation

### Quick Install
```bash
git clone https://github.com/prabinpanta0/termConf.git
cd termConf
chmod +x install.sh
./install.sh
```

### What the installer does:
1. Updates your system packages
2. Installs core packages (fish, kitty, fonts, doas, fastfetch/neofetch)
3. Installs UV Python package manager
4. Installs TheFuck for command correction
5. Copies all configuration files
6. Configures doas permissions
7. Adds user to wheel group
8. Sets Fish as default shell

## 🎨 Screenshots

*Add screenshots of your terminal setup here*

## 📋 Requirements

- **OS**: Linux (Debian, Ubuntu, Arch Linux, Fedora, etc.)
- **RAM**: Minimal requirements
- **Storage**: ~50MB for packages and configs

## 🔧 Manual Configuration

If you prefer manual setup:

1. Install packages manually:
   ```bash
   # Debian/Ubuntu
   sudo apt install fish kitty fonts-jetbrains-mono doas neofetch

   # Arch Linux
   sudo pacman -S fish kitty ttf-jetbrains-mono doas fastfetch

   # Fedora
   sudo dnf install fish kitty jetbrains-mono-fonts doas neofetch
   ```

2. Install UV:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

3. Install TheFuck:
   ```bash
   pip3 install --user thefuck
   ```

4. Copy configurations:
   ```bash
   mkdir -p ~/.config/fish ~/.config/kitty ~/.config/neofetch ~/.config/fastfetch
   cp -r fish/* ~/.config/fish/
   cp -r kitty/* ~/.config/kitty/
   cp -r neofetch/* ~/.config/neofetch/
   cp -r fastfetch/* ~/.config/fastfetch/
   ```

5. Configure doas:
   ```bash
   sudo cp doas.conf /etc/doas.conf
   sudo chown root:root /etc/doas.conf
   sudo chmod 0600 /etc/doas.conf
   ```

6. Set Fish as default shell:
   ```bash
   echo $(which fish) | sudo tee -a /etc/shells
   chsh -s $(which fish)
   ```

## 🎯 Usage

After installation:

1. **Log out and log back in** for all changes to take effect
2. Open Kitty terminal
3. Run `fastfetch` or `neofetch` to see system information
4. Use Fish shell features:
   - Git status in prompt
   - Language detection icons
   - Command correction with `fuck` (after a failed command)

### Fish Shell Features

- **Enhanced Prompt**: Shows user, host, directory, Git status, and language
- **Git Integration**: Branch name, status indicators (✓/✗/↑/↓/↕), stash count
- **Language Detection**: Icons for Node.js, Python, Go, Rust, Java, Ruby, PHP, C/C++/C#, TypeScript/JavaScript, Docker
- **Command Timing**: Shows execution time for commands >5 seconds
- **TheFuck Integration**: Type `fuck` after a failed command to get suggestions

### Kitty Shortcuts

- `Ctrl+Shift+K`: Clear terminal
- `Alt+C`: Copy to clipboard
- `Alt+V`: Paste from clipboard
- `Ctrl+Left/Right`: Switch windows
- `Ctrl+P`: Previous window
- `Ctrl+Shift+D`: Detach window to new tab

## 🐛 Troubleshooting

### Common Issues

1. **Permission denied with doas**
   - Ensure you're in the wheel group: `groups | grep wheel`
   - Log out and back in after running the installer

2. **Fish not set as default shell**
   - Run: `chsh -s $(which fish)`
   - Log out and back in

3. **Fonts not displaying correctly**
   - Install JetBrains Mono font manually
   - Restart your terminal

4. **TheFuck not working**
   - Add to your Fish config: `thefuck --alias | source`

### Manual Fixes

If the installer fails partway through, you can complete setup manually using the steps in the "Manual Configuration" section.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.


## 🙏 Acknowledgments

- [Fish Shell](https://fishshell.com/)
- [Kitty Terminal](https://sw.kovidgoyal.net/kitty/)
- [Fastfetch](https://github.com/LinusDierheimer/fastfetch)
- [Neofetch](https://github.com/dylanaraps/neofetch)
- [TheFuck](https://github.com/nvbn/thefuck)
- [UV](https://github.com/astral-sh/uv)
- [JetBrains Mono Font](https://www.jetbrains.com/lp/mono/)

---

*__DO WHATEVER YOU LIKE I DON'T CARE.__ but do insert an image to this repo...*

<parameter name="filePath">~/termConf/Readme.md </parameter>
