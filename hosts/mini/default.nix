# Mac Mini configuration
{ ... }:

{
  system = "aarch64-darwin";

  homeModules = [
    ../../home-manager
    ../../home-manager/darwin.nix
  ];

  config = {
    imports = [
      ../../platforms/darwin
    ];

    networking.hostName = "mini";
  };
}
