{ ... }:

{
  imports = [
    ./apps.nix
    ./dev.nix
    ./desktop.nix
  ];

  home.username = "tofu";
  home.homeDirectory = "/home/tofu";
  home.stateVersion = "26.05";
}
