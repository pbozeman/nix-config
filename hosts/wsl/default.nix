# WSL instance configuration
{ inputs, ... }:

{
  system = "x86_64-linux";

  homeModules = [
    ../../home-manager
  ];

  extraModules = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  config = {
    imports = [
      ../../platforms/nixos
      ../../platforms/nixos/wsl.nix
    ];

    networking.hostName = "wsl";
  };
}
