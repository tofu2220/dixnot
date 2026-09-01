{ pkgs, unstablePkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "tofu2220";
      email = "66412548+tofu2220@users.noreply.github.com";
    };
  };

  home.packages = [
    pkgs.gh
    pkgs.helix
    pkgs.nixd
    unstablePkgs.zed-editor
  ];
}
