{ pkgs, ... }:

{
  home.packages = with pkgs; [
    foot
    fuzzel
  ];

  xdg.configFile = {
    "sway".source = ../config/sway;
    "fuzzel".source = ../config/fuzzel;
    "foot".source = ../config/foot;
  };
}
