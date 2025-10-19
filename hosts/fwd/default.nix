# Framework Desktop configuration
{ inputs, ... }:

{
  system = "x86_64-linux";

  homeModules = [
    ../../home-manager
    ../../home-manager/nixos-gui.nix
    ./nixos-gui.nix
  ];

  extraModules = [
    inputs.hardware.nixosModules.framework-desktop-amd-ai-max-300-series
  ];

  config = {
    imports = [
      ./hardware.nix
      ../../platforms/nixos
      ../../platforms/nixos/gui.nix
      ../../platforms/nixos/services
    ];

    networking.hostName = "fwd";

    # AMD GPU driver
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
