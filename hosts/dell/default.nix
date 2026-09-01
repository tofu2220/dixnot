{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/base.nix
    ../../modules/system/common.nix
    ../../modules/desktop/sway.nix
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
