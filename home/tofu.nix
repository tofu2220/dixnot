{ ... }:

{
  home.username = "tofu";
  home.homeDirectory = "/home/tofu";
  home.stateVersion = "26.05";

  xdg.configFile."sway".source =
    ../dotfiles/sway;

  xdg.configFile."foot/foot.ini".source =
    ../dotfiles/foot/foot.ini;
}
