# ThinkPad L13 configuration
{ ... }:

{
  imports = [
    ./hardware.nix
    ../../platforms/nixos
    ../../platforms/nixos/gui.nix
    ../../platforms/nixos/services
  ];

  networking.hostName = "tp";
}
