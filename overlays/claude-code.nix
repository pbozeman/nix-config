{ inputs, ... }:
final: prev: {
  claude-code = inputs.claude-code.packages.${final.stdenv.hostPlatform.system}.default;
}
