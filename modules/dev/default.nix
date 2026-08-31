{ pkgs, unstablePkgs, ... }:

{
  programs.git = {
    enable = true;

    config = {
      user = {
        name = "tofu2220";
        email = "66412548+tofu2220@users.noreply.github.com";
      };
    };
  };

  environment.systemPackages = [
    pkgs.gh
    pkgs.helix
    pkgs.nixd
    unstablePkgs.zed-editor
  ];
}
