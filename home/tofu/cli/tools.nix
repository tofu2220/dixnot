{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixfmt
    ripgrep
    microfetch
    htop

    # May delete later when I run out of money
    unstable.codex
  ];
}
