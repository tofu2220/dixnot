{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktop/sway
    ../../modules/services/auto-cpufreq.nix
    ../../profiles/tofu.nix
  ];

  networking.hostName = "nixos-dell";

  system.stateVersion = "26.05";
}
