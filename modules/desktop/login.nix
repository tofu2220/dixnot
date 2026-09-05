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

  greeting = "HEV SUIT SYSTEMS // AUTHORIZATION REQUIRED";

  theme = "border=yellow;text=yellow;time=yellow;container=black;title=yellow;greet=yellow;prompt=yellow;input=white;action=yellow;button=white";
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
        "--asterisks"
        "--sessions"
        waylandSessions
        "--greeting"
        "'${greeting}'"
        "--greet-align"
        "left"
        "--width"
        "72"
        "--window-padding"
        "2"
        "--container-padding"
        "2"
        "--theme"
        "'${theme}'"
        "--cmd"
        sway
      ];

      user = "greeter";
    };
  };
}
