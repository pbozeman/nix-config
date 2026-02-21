{ inputs, ... }:
final: prev: {
  codex = inputs.codex.packages.${final.stdenv.hostPlatform.system}.default;
}
