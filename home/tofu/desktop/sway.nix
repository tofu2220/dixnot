{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    pamixer
    i3status-rust
    nwg-displays
    autotiling

    # Screenshot
    satty
    slurp
    wl-clipboard

    # Notification
    mako
    libnotify
  ];

  xdg.configFile = {
    "sway/config".source = ../../config/sway/config;
    "sway/config.d".source = ../../config/sway/config.d;
    "satty".source = ../../config/satty;
    "mako".source = ../../config/mako;
    "fuzzel".source = ../../config/fuzzel;
    "foot".source = ../../config/foot;
    "i3status-rust".source = ../../config/i3status-rust;
  };
}
