# Proxmox VM dev server configuration
{ ... }:

{
  system = "x86_64-linux";

  homeModules = [
    ../../home-manager
  ];

  config = {
    imports = [
      ./hardware.nix
      ../../platforms/nixos
      ../../platforms/nixos/services
    ];

    networking.hostName = "dev";
  };
}
