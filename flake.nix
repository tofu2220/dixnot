{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      modules = [
        ./hosts/dell

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit unstablePkgs; };
          home-manager.users.tofu = import ./home/tofu;
        }
      ];
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system modules;

        specialArgs = {
          inherit unstablePkgs;
        };
      };

      homeConfigurations.tofu = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit unstablePkgs; };
        modules = [ ./home/tofu ];
      };
    };
}
