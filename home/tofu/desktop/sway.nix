{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # foot
    fuzzel
    pamixer
    i3status-rust
    nwg-displays
    autotiling

    # swayidle
    # swaylock
  ];

  xdg.configFile = {
    "sway/config".source = ../../config/sway/config;
    "sway/config.d".source = ../../config/sway/config.d;
    "fuzzel".source = ../../config/fuzzel;
    "foot".source = ../../config/foot;
    "i3status-rust".source = ../../config/i3status-rust;
  };
}
