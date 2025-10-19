# ThinkPad L13 configuration
{ inputs, ... }:

{
  system = "x86_64-linux";

  homeModules = [
    ../../home-manager
    ../../home-manager/nixos-gui.nix
    ./nixos-gui.nix
  ];

  extraModules = [
    inputs.hardware.nixosModules.lenovo-thinkpad-l13
  ];

  config = {
    imports = [
      ./hardware.nix
      ../../platforms/nixos
      ../../platforms/nixos/gui.nix
      ../../platforms/nixos/services
    ];

    networking.hostName = "tp";
  };
}
