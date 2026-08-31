# My NixOS Configuration

## Usage

After changing dotfiles, apply the Home Manager configuration:

```bash
home-manager switch --flake .#tofu
```

After changing `.nix` configuration files, rebuild NixOS with the appropriate action:

```bash
sudo nixos-rebuild switch --flake .#nixos
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
