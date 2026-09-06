{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixfmt

    clang-tools

    ripgrep
    microfetch
    htop
    jq

    # May delete later when I run out of money
    unstable.codex
  ];
}
