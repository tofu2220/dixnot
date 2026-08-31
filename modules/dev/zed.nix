{ unstablePkgs, ... }:

{
  environment.systemPackages = with unstablePkgs; [
    zed-editor
  ];
}
