{ inputs, ... }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  # Pull codex from the unstable channel
  codex = inputs.nixpkgs-unstable.legacyPackages.${system}.codex;
}
