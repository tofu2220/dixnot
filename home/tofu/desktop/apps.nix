{ pkgs, ... }:

{
  home.packages = [
    # Browser
    pkgs.unstable.brave-origin

    # Editor
    pkgs.unstable.zed-editor
    pkgs.mousepad

    # Archive
    pkgs.file-roller
  ];
}
