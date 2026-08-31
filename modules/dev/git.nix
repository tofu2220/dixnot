{ pkgs, ... }:

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

  environment.systemPackages = with pkgs; [
    gh
  ];
}
