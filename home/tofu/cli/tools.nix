{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixfmt
    ripgrep
    microfetch
    htop
  ];
}
