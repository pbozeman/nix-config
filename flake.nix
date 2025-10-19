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

      mkNixosSystem =
        { hostname
        , system ? "x86_64-linux"
        , extraModules ? [ ]
        , gui ? false
        }:
        let
          guiHomeModules = nixpkgs.lib.optional gui ./home-manager/nixos-gui.nix;
        in
        nixpkgs.lib.nixosSystem {
          pkgs = mkPkgs system;
          specialArgs = { inherit inputs nixpkgs secrets hostname user fullname; };
          modules = [
            (./hosts + "/${hostname}")
            home-manager.nixosModules.home-manager
            (mkHome user fullname email ([ ./home-manager ] ++ guiHomeModules))
          ] ++ extraModules;
        };

      mkDarwinSystem =
        { hostname
        , system
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          pkgs = mkPkgs system;
          specialArgs = { inherit inputs nixpkgs secrets user; };
          modules = [
            (./hosts + "/${hostname}")
            home-manager.darwinModules.home-manager
            (mkHome user fullname email [
              ./home-manager
              ./home-manager/darwin.nix
            ])
          ];
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
      darwinConfigurations = {
        "mba" = mkDarwinSystem {
          hostname = "mba";
          system = "aarch64-darwin";
        };
        "mini" = mkDarwinSystem {
          hostname = "mini";
          system = "aarch64-darwin";
        };
        "slabtop" = mkDarwinSystem {
          hostname = "slabtop";
          system = "x86_64-darwin";
        };
      };

      homeConfigurations = {
        "ubuntu-dev" = mkHomeConfiguration { };
        "wsl-dev" = mkHomeConfiguration { };
      };

      nixosConfigurations = {
        fw = mkNixosSystem {
          hostname = "fw";
          gui = true;
          extraModules = [
            hardware.nixosModules.framework-16-7040-amd
          ];
        };

        fwd = mkNixosSystem {
          hostname = "fwd";
          gui = true;
          extraModules = [
            hardware.nixosModules.framework-desktop-amd-ai-max-300-series
          ];
        };

        tp = mkNixosSystem {
          hostname = "tp";
          gui = true;
          extraModules = [
            hardware.nixosModules.lenovo-thinkpad-l13
          ];
        };

        dev = mkNixosSystem {
          hostname = "dev";
        };

        wsl = mkNixosSystem {
          hostname = "wsl";
          extraModules = [
            nixos-wsl.nixosModules.wsl
          ];
        };
      };
    };
}
