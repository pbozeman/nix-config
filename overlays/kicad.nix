{ inputs, nixpkgs }:

final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  # Use kicad and related packages from nixpkgs-unstable
  kicad = inputs.nixpkgs-unstable.legacyPackages.${system}.kicad;
  kicad-packages3d = inputs.nixpkgs-unstable.legacyPackages.${system}.kicad-packages3d;
  kicad-symbols = inputs.nixpkgs-unstable.legacyPackages.${system}.kicad-symbols;
  kicad-templates = inputs.nixpkgs-unstable.legacyPackages.${system}.kicad-templates;
  kicad-footprints = inputs.nixpkgs-unstable.legacyPackages.${system}.kicad-footprints;
}
