{ ... }:

{
  xfconf.settings.thunar = {
    "last-view" = "ThunarCompactView";
    "last-icon-view-zoom-level" = "THUNAR_ZOOM_LEVEL_100_PERCENT";
  };

  xdg.configFile."xfce4/helpers.rc".text = ''
    [Default]
    TerminalEmulator=foot
  '';

  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file:///home/tofu/Desktop Desktop
    file:///home/tofu/Documents Documents
    file:///home/tofu/Downloads Downloads
    file:///home/tofu/Music Music
    file:///home/tofu/Pictures Pictures
    file:///home/tofu/Projects Projects
    file:///home/tofu/Public Public
    file:///home/tofu/Templates Templates
    file:///home/tofu/Videos Videos
  '';
}

# If you want to reset thunar to default setting, try this cmd:
# thunar -q && \
# xfconf-query --channel thunar \
#   --property / \
#   --reset \
#   --recursive
