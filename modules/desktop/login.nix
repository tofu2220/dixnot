{
  config,
  lib,
  pkgs,
  ...
}:

let
  tuigreet = lib.getExe pkgs.tuigreet;
  sway = lib.getExe config.programs.sway.package;
  waylandSessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session = {
      command = builtins.concatStringsSep " " [
        tuigreet
        "--time"
        "--remember"
        "--remember-user-session"
        "--sessions"
        waylandSessions
        "--cmd"
        sway
      ];

      user = "greeter";
    };
  };
}
