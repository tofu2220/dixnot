{ pkgs, unstablePkgs, ... }:

{
  home.packages = [
    unstablePkgs.brave-origin
    pkgs.firefox
    pkgs.kdePackages.kate
  ];
}
