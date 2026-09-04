# My NixOS Configuration

### Refresh a host hardware configuration

Run this on the target NixOS machine after installation:

```bash
./scripts/genhw.sh t14
```

## Usage

This configuration separates machine-specific settings under `hosts/`, reusable
NixOS modules under `modules/`, user integration under `profiles/`, package
overlays under `overlays/`, and Home Manager configuration under `home/tofu/`.

The Home Manager configuration is split by responsibility:

- `home/tofu/cli/`: shell, Git, Helix, and command-line tooling.
- `home/tofu/desktop/`: graphical applications, appearance, input method,
  Sway integration, and Thunar.
- `home/config/`: native configuration files linked into the user profile.

Apply the configuration for the target host:

```bash
sudo nixos-rebuild switch --flake .#dell

sudo nixos-rebuild switch --flake .#t14
```

Format and validate the configuration with:

```bash
nix fmt -- --excludes 'hosts/*/hardware-configuration.nix'
nix flake check --no-build
```

Available `nixos-rebuild` actions:

- `switch`: Build, activate, and make the configuration the default for future boots.
- `boot`: Build and make the configuration the default for the next boot without activating it now.
- `test`: Build and activate the configuration temporarily; rebooting returns to the previous default.
- `build`: Build only; do not activate it.
- `dry-build`: Show what would be built or downloaded without making changes.
- `dry-activate`: Show what activation would change without activating it.
- `edit`: Open the configuration in the default editor.
- `repl`: Open the configuration in the Nix REPL.
- `build-image`: Build a configured disk image.
- `build-vm`: Build a script to run the configuration in a virtual machine.
- `build-vm-with-bootloader`: Build a virtual machine that uses the configured boot loader.
- `list-generations`: List available NixOS generations.

## Task

- [ ] Default enable numlock in sway/config.d
