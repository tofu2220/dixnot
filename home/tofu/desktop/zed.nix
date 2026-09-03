{ lib, ... }:

{
  home.activation.seedZedSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    zed_settings="$HOME/.config/zed/settings.json"

    if [ ! -e "$zed_settings" ] && [ ! -L "$zed_settings" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config/zed"
      $DRY_RUN_CMD cp ${../../config/zed/settings.json} "$zed_settings"
    fi
  '';
}
