{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/base.nix
    ../../modules/system/networking.nix
    ../../modules/system/audio.nix
    ../../modules/system/printing.nix
    ../../modules/desktop/sway
    ../../modules/desktop/plasma.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  users.users.tofu = {
    isNormalUser = true;
    description = "Nguyen Thanh Phuc";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "26.05";
}
