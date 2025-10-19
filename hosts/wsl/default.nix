# WSL instance configuration
{ ... }:

{
  imports = [
    ../../platforms/nixos
    ../../platforms/nixos/wsl.nix
  ];

  networking.hostName = "wsl";
}
