{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    xwayland.enable = true;
    wrapperFeatures.gtk = true;

    extraPackages = with pkgs; [
      foot
      fuzzel
    ];
  };
}
