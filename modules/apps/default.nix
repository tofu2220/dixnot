{ unstablePkgs, ... }:

{
  environment.systemPackages = with unstablePkgs; [
    brave-origin
  ];
}
