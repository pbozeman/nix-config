{
  description = "dev machines nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim-nix = {
      url = "github:pbozeman/lazyvim-nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , hardware
    , nix-darwin
    , home-manager
    , lazyvim-nix
    , nixos-wsl
    , ...
    } @ inputs:
    let
      secrets = import ./secrets;

      user = "pbozeman";
      fullname = "Patrick Bozeman";
      email = "pbozeman@gmail.com";

      mkPkgs = system:
        import nixpkgs {
          inherit system;
          inherit
            (import ./overlays {
              inherit inputs nixpkgs;
            }) overlays;
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
          extraSpecialArgs = { inherit inputs secrets user fullname email; };
          users."${user}" = { lib, ... }: {
            imports = modules;
          };
        };
      };

      mkNixosSystem = hostname:
        let
          hostConfig = import (./hosts + "/${hostname}") { inherit inputs; };
        in
        nixpkgs.lib.nixosSystem {
          pkgs = mkPkgs hostConfig.system;
          specialArgs = { inherit inputs nixpkgs secrets hostname user fullname; };
          modules = [
            hostConfig.config
            home-manager.nixosModules.home-manager
            (mkHome user fullname email hostConfig.homeModules)
          ] ++ (hostConfig.extraModules or [ ]);
        };

      mkDarwinSystem = hostname:
        let
          hostConfig = import (./hosts + "/${hostname}") { inherit inputs; };
        in
        nix-darwin.lib.darwinSystem {
          system = hostConfig.system;
          pkgs = mkPkgs hostConfig.system;
          specialArgs = { inherit inputs nixpkgs secrets hostname user fullname; };
          modules = [
            hostConfig.config
            home-manager.darwinModules.home-manager
            (mkHome user fullname email hostConfig.homeModules)
          ] ++ (hostConfig.extraModules or [ ]);
        };

      mkHomeConfiguration = { system ? "x86_64-linux" }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          extraSpecialArgs = { inherit inputs secrets user fullname email; };
          modules = [
            ./home-manager
          ];
        };
    in
    {
      nixosConfigurations = {
        dev = mkNixosSystem "dev";
        fw = mkNixosSystem "fw";
        fwd = mkNixosSystem "fwd";
        tp = mkNixosSystem "tp";
        wsl = mkNixosSystem "wsl";
      };

      darwinConfigurations = {
        mba = mkDarwinSystem "mba";
        mini = mkDarwinSystem "mini";
        slabtop = mkDarwinSystem "slabtop";
      };

      homeConfigurations = {
        ubuntu-dev = mkHomeConfiguration { };
        wsl-dev = mkHomeConfiguration { };
      };
    };
}
