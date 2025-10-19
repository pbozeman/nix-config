# Framework Desktop configuration
{ ... }:

{
  imports = [
    ./hardware.nix
    ../../platforms/nixos
    ../../platforms/nixos/gui.nix
    ../../platforms/nixos/services
  ];

  networking.hostName = "fwd";

  # AMD GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];
}
