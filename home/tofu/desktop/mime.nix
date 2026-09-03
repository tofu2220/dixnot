{ ... }:

let
  apps = {
    browser = "brave-origin.desktop";
    textEditor = "org.xfce.mousepad.desktop";
    fileManager = "thunar.desktop";
  };
in
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = apps.browser;
      "x-scheme-handler/http" = apps.browser;
      "x-scheme-handler/https" = apps.browser;
      "text/plain" = apps.textEditor;
      "inode/directory" = apps.fileManager;
    };
  };
}
