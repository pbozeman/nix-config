{ inputs, nixpkgs }:

final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  tmux = inputs.nixpkgs-unstable.legacyPackages.${system}.tmux;
}
