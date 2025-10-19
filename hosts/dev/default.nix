# Proxmox VM dev server configuration
{ ... }:

{
  imports = [
    ./hardware.nix
    ../../platforms/nixos
    ../../platforms/nixos/services
  ];

  networking.hostName = "dev";
}
