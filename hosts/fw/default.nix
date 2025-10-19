# Framework 16 laptop configuration
{ ... }:

{
  imports = [
    ./hardware.nix
    ../../platforms/nixos
    ../../platforms/nixos/gui.nix
    ../../platforms/nixos/services
  ];

  networking.hostName = "fw";

  # AMD GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # USB monitoring group (for Wireshark, etc.)
  users.groups.usbmon = { };
}
