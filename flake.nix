{
  description = "dev machines nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    secrets = import ./secrets;

    user = "pbozeman";
    fullname = "Patrick Bozeman";
    email = "pbozeman@gmail.com";

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnsupportedSystem = false;
          allowBroken = false;
          allowUnfree = true;
          experimental-features = "nix-command flakes";
          keep-derivations = true;
          keep-outputs = true;
        };
      };

    mkHome = user: fullname: email: modules: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit inputs secrets user fullname email;};
        users."${user}" = {lib, ...}: {
          imports = modules;
        };
      };
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs "x86_64-linux";
        specialArgs = {
          inherit inputs nixpkgs secrets user fullname;
        };
        modules = [
          ./hardware/parallels.nix
          ./nixos
          home-manager.nixosModules.home-manager
          (mkHome user fullname email [
            ./home-manager
          ])
        ];
      };
    };

    homeConfigurations = {
      "parallels" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "x86_64-linux";
        extraSpecialArgs = {inherit inputs secrets user fullname email;};
        modules = [
          ./home-manager
        ];
      };
    };

    darwinConfigurations = {
      "Miless-Air" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        pkgs = mkPkgs "x86_64-darwin";
        specialArgs = {
          inherit inputs nixpkgs secrets user;
        };
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          (mkHome user fullname email [
            ./home-manager
            ./home-manager/darwin.nix
          ])
        ];
      };
    };
  };
}
