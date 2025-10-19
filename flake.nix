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
        , hardwareModules
        , services ? true
        , gui ? true
        , homeModules ? [ ]
        }:
        let
          guiHomeModules = nixpkgs.lib.optional gui ./home-manager/nixos-gui.nix;
        in
        nixpkgs.lib.nixosSystem {
          pkgs = mkPkgs system;
          specialArgs = { inherit inputs nixpkgs secrets hostname user fullname; };
          modules = hardwareModules
            ++ [ ./nixos ]
            ++ nixpkgs.lib.optional services ./nixos/services.nix
            ++ nixpkgs.lib.optional gui ./nixos-gui
            ++ [
            home-manager.nixosModules.home-manager
            (mkHome user fullname email ([ ./home-manager ] ++ guiHomeModules ++ homeModules))
          ];
        };

      mkDarwinSystem = { system }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          pkgs = mkPkgs system;
          specialArgs = { inherit inputs nixpkgs secrets user; };
          modules = [
            ./darwin
            home-manager.darwinModules.home-manager
            (mkHome user fullname email [
              ./home-manager
              ./home-manager/darwin.nix
            ])
          ];
        };
    in
    {
      nixosConfigurations = {
        fw = mkNixosSystem {
          hostname = "fw";
          hardwareModules = [
            hardware.nixosModules.framework-16-7040-amd
            ./hardware/fw.nix
          ];
        };

        fwd = mkNixosSystem {
          hostname = "fwd";
          hardwareModules = [
            hardware.nixosModules.framework-desktop-amd-ai-max-300-series
            ./hardware/fwd.nix
          ];
        };

        tp = mkNixosSystem {
          hostname = "tp";
          hardwareModules = [
            hardware.nixosModules.lenovo-thinkpad-l13
            ./hardware/tp.nix
          ];
        };

        dev = mkNixosSystem {
          hostname = "dev";
          hardwareModules = [ ./hardware/proxmox.nix ];
          gui = false;
        };

        wsl = mkNixosSystem {
          hostname = "wsl";
          hardwareModules = [
            nixos-wsl.nixosModules.wsl
            ./wsl.nix
          ];
          services = false;
          gui = false;
        };
      };

      homeConfigurations = {
        "ubuntu-dev" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = { inherit inputs secrets user fullname email; };
          modules = [
            ./home-manager
          ];
        };

        "wsl-dev" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = { inherit inputs secrets user fullname email; };
          modules = [
            ./home-manager
          ];
        };
      };

      darwinConfigurations = {
        "mba" = mkDarwinSystem { system = "aarch64-darwin"; };
        "mini" = mkDarwinSystem { system = "aarch64-darwin"; };
        "slabtop" = mkDarwinSystem { system = "x86_64-darwin"; };
      };
    };
}
