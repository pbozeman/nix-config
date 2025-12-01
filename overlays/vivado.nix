{ inputs, ... }:
final: prev:
let
  vivado = inputs.nix-vivado.packages.${final.stdenv.hostPlatform.system}.vivado;

  vivado-launcher = final.writeShellScriptBin "vivado-wrapped" ''
    cd /tmp && exec ${vivado}/bin/vivado "$@"
  '';

  vivado-desktop = final.makeDesktopItem {
    name = "vivado";
    desktopName = "Vivado";
    exec = "${vivado-launcher}/bin/vivado-wrapped";
    icon = ../media/vivado.png;
    comment = "Xilinx Vivado Design Suite";
    categories = [ "Development" "Electronics" ];
    terminal = false;
  };
in
{
  vivado-wrapped = final.symlinkJoin {
    name = "vivado-wrapped";
    paths = [
      vivado-launcher
      vivado-desktop
    ];
  };
}
