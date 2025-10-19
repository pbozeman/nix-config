# Mac Mini configuration
{ ... }:

{
  imports = [
    ../../platforms/darwin
  ];

  networking.hostName = "mini";
}
