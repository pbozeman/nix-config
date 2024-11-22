{
  description = "dev machines nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim-nix = {
      url = "github:pbozeman/lazyvim-nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      # https://github.com/NixOS/nixpkgs/issues/348832
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
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
              inherit inputs nixpkgs nix-darwin;
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
    in
    {
      nixosConfigurations = {
        nixos-parallels =
          let
            hostname = "nixos-parallels";
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux";
            specialArgs = {
              inherit inputs nixpkgs secrets hostname user fullname;
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

        fw =
          let
            hostname = "fw";
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux";
            specialArgs = {
              inherit inputs nixpkgs secrets hostname user fullname;
            };
            modules = [
              hardware.nixosModules.framework-16-7040-amd
              ./hardware/fw.nix
              ./nixos
              ./nixos/services.nix
              ./nixos-gui
              home-manager.nixosModules.home-manager
              (mkHome user fullname email [
                ./home-manager
                ./home-manager/nixos-gui.nix
              ])
            ];
          };

        tp =
          let
            hostname = "tp";
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux";
            specialArgs = {
              inherit inputs nixpkgs secrets hostname user fullname;
            };
            modules = [
              hardware.nixosModules.lenovo-thinkpad-l13
              ./hardware/tp.nix
              ./nixos
              ./nixos/services.nix
              ./nixos-gui
              home-manager.nixosModules.home-manager
              (mkHome user fullname email [
                ./home-manager
                ./home-manager/nixos-gui.nix
              ])
            ];
          };

        dev =
          let
            hostname = "dev";
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux";
            specialArgs = {
              inherit inputs nixpkgs secrets hostname user fullname;
            };
            modules = [
              ./hardware/proxmox.nix
              ./nixos
              ./nixos/services.nix
              home-manager.nixosModules.home-manager
              (mkHome user fullname email [
                ./home-manager
              ])
            ];
          };

        wsl =
          let
            hostname = "wsl";
          in
          nixpkgs.lib.nixosSystem {
            pkgs = mkPkgs "x86_64-linux";
            specialArgs = {
              inherit inputs nixpkgs secrets hostname user fullname;
            };
            modules = [
              nixos-wsl.nixosModules.wsl
              ./wsl.nix
              ./nixos
              home-manager.nixosModules.home-manager
              (mkHome user fullname email [
                ./home-manager
              ])
            ];
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
        "miles-mba" = nix-darwin.lib.darwinSystem {
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

        "mba" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = mkPkgs "aarch64-darwin";
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

        "mini" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = mkPkgs "aarch64-darwin";
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
