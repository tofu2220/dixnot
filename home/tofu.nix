{ ... }:

{
  home.username = "tofu";
  home.homeDirectory = "/home/tofu";
  home.stateVersion = "26.05";

  xdg.configFile."sway/config".source =
    ./config/sway/config;

  xdg.configFile."fuzzel/fuzzel.ini".source =
    ./config/fuzzel/fuzzel.ini;
}
