{ inputs, ... }:
final: prev: {
  vivado-wrapped = inputs.nix-vivado.packages.${final.stdenv.hostPlatform.system}.vivado;
}
