{ inputs, nixpkgs }:

final: prev: {
  # Use kicad and related packages from nixpkgs-unstable
  kicad = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kicad;
  kicad-packages3d = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kicad-packages3d;
  kicad-symbols = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kicad-symbols;
  kicad-templates = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kicad-templates;
  kicad-footprints = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.kicad-footprints;
}
