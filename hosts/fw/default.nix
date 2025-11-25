# Framework 16 laptop configuration
{ inputs, ... }:

{
  system = "x86_64-linux";

  homeModules = [
    ../../home-manager
    ../../home-manager/nixos-gui.nix
  ];

  extraModules = [
    inputs.hardware.nixosModules.framework-16-7040-amd
  ];

  config = {
    imports = [
      ./hardware.nix
      ../../platforms/nixos
      ../../platforms/nixos/gui.nix
      ../../platforms/nixos/services
    ];

    networking.hostName = "fw";

    # NVidia GPU driver
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;

    # USB monitoring group (for Wireshark, etc.)
    users.groups.usbmon = { };
  };
}
