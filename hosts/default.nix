{ ... }:

{
  imports = [
    ../modules/core
    ../modules/desktop
    ../modules/services
    ../profiles/tofu.nix
  ];

  system.stateVersion = "26.05";
}
