{ ... }:

{
  home.username = "tofu";
  home.homeDirectory = "/home/tofu";
  home.stateVersion = "26.05";

  xdg.configFile = {
    "sway".source = ./config/sway;
    "fuzzel".source = ./config/fuzzel;
    "foot".source = ./config/foot;
  };
}
