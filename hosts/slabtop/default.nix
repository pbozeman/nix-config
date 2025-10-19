# Slabtop configuration
{ ... }:

{
  system = "x86_64-darwin";

  homeModules = [
    ../../home-manager
    ../../home-manager/darwin.nix
  ];

  config = {
    imports = [
      ../../platforms/darwin
    ];

    networking.hostName = "slabtop";
  };
}
