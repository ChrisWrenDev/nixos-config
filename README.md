# NixOS Configuration

Declarative NixOS + Home Manager configuration for the **Beelink SER8**,
recreating the [Omarchy](https://omarchy.org) desktop experience using native
NixOS, Home Manager, Hyprland, and native application tools instead of Omarchy's
Arch/Quickshell wrappers.

The migration mapping (what was kept, replaced, rewritten, or dropped) is
documented in [docs/omarchy-migration.md](docs/omarchy-migration.md).

## Layout

```text
flake.nix                     inputs + nixosConfigurations
hosts/beelink-ser8/           host-specific (hardware + host wiring)
modules/system/               shared NixOS system modules (boot, base)
modules/desktop/              shared NixOS desktop modules (Hyprland backend services)
home/chriswrendev/            shared Home Manager desktop config (the user experience)
themes/                       color themes (Tokyo Night default)
wallpapers/                   wallpaper assets
docs/                         migration + architecture notes
```

## Rebuild

```bash
nix fmt
nix flake check
sudo nixos-rebuild switch --flake .#beelink-ser8
```

Home Manager is integrated as a NixOS module, so a single switch updates both.
