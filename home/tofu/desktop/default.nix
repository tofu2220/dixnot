{
  imports = [
    ./appearance.nix
    ./apps.nix
    ./input-method.nix
    ./sway.nix
    ./thunar.nix
    ./zed.nix

    # Optional declarative MIME defaults; intentionally disabled to avoid overriding user/app preferences.
    # ./mime.nix
  ];
}
