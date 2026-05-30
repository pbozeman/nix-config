{ inputs, ... }:
final: prev: {
  ccusage = inputs.ccusage.packages.${final.stdenv.hostPlatform.system}.default;
}
