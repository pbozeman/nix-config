# TP14 laptop configuration
{ inputs, ... }:

{
  system = "x86_64-linux";

  homeModules = [
    ../../home-manager
    ../../home-manager/nixos-gui.nix
  ];

  extraModules = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t14s
  ];

  config = {
    imports = [
      ./hardware.nix
      ../../platforms/nixos
      ../../platforms/nixos/gui.nix
      ../../platforms/nixos/laptop.nix
      ../../platforms/nixos/services
    ];

    networking.hostName = "t14s";
  };
}
