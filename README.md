# dotfiles

NixOS configuration inspired by [Omarchy](https://github.com/basecamp/omarchy) — a Hyprland-based desktop environment originally built for Arch Linux, ported to NixOS using flakes.

## Architecture

Uses the **Dendritic Pattern** with [flake-parts](https://flake.parts) + [import-tree](https://github.com/vic/import-tree): every `.nix` file under `modules/` is a self-contained flake-parts module that can define both NixOS system config and home-manager user config in one place.

```
.
├── flake.nix              # Entry point (flake-parts + import-tree)
├── modules/               # Dendritic modules (auto-discovered)
│   ├── hosts.nix          # nixosConfigurations (desktop + laptop)
│   ├── base/              # Boot, networking, audio, locale, SDDM
│   ├── desktop/           # Hyprland, waybar, mako, walker, fonts...
│   ├── hardware/          # NVIDIA, Intel, Bluetooth (mkEnableOption)
│   ├── terminal/          # Kitty
│   ├── shell/             # Bash, starship, tmux
│   ├── apps/              # Bitwarden, Chromium, Git, Neovim+LazyVim, VS Code...
│   ├── ai-tools/          # Claude Code, OpenCode, GitHub Copilot CLI
│   ├── theme/             # 18 themes with build-time + runtime switching
│   └── scripts/           # 160+ omarchy-* utilities (wrapped derivation)
├── hosts/                 # Per-machine configs + hardware-configuration.nix
│   ├── desktop/           # NVIDIA GPU
│   └── laptop/            # Intel iGPU
├── lib/                   # Theme engine (parseColorsToml, applyTemplate)
├── assets/                # Omarchy themes, templates, default configs, scripts
└── overlays/              # Custom packages for AUR-only software
```

## Hosts

| Host | GPU | Description |
|------|-----|-------------|
| `desktop` | NVIDIA | Primary workstation |
| `laptop` | Intel iGPU | Work notebook |

## Usage

```bash
# Build without switching (dry run)
sudo nixos-rebuild dry-build --flake .#desktop

# Apply configuration
sudo nixos-rebuild switch --flake .#desktop
# or
sudo nixos-rebuild switch --flake .#laptop
```

## Desktop Stack

| Component | Tool |
|-----------|------|
| Window Manager | Hyprland |
| Status Bar | Waybar |
| Launcher | Walker |
| Notifications | Mako |
| Lock Screen | Hyprlock |
| Idle Daemon | Hypridle |
| Terminal | Kitty |
| Login Manager | SDDM |
| Audio | Pipewire + Wireplumber |
| Editor | Neovim + LazyVim |
| Password Manager | Bitwarden |

## Themes

18 themes ported from Omarchy with a Nix-native template engine. Theme colors are defined in `assets/themes/<name>/colors.toml` and propagated across Hyprland, Waybar, Kitty, Btop, Mako, and more via `{{ variable }}` templates.

```bash
# Switch theme at runtime (no rebuild needed)
omarchy-theme-set catppuccin

# Set default theme in config (applied on rebuild)
# In hosts/<machine>/configuration.nix or users/joel/home.nix:
omarchy.theme.name = "tokyo-night";
```

Available: catppuccin, catppuccin-latte, ethereal, everforest, flexoki-light, gruvbox, hackerman, kanagawa, lumon, matte-black, miasma, nord, osaka-jade, ristretto, rose-pine, tokyo-night, vantablack, white

## Credits

- [Omarchy](https://github.com/basecamp/omarchy) by DHH / Basecamp — the original Arch Linux desktop environment
- [castrozan/.dotfiles](https://github.com/Castrozan/.dotfiles) — reference NixOS + Hyprland config with home-manager
- [vimjoyer/nixconf](https://github.com/vimjoyer/nixconf) — reference NixOS config using flake-parts + dendritic pattern
