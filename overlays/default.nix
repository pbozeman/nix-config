{ inputs
, nixpkgs
, ...
}: {
  overlays = [
    (import ./claude-code.nix {
      inherit inputs nixpkgs;
    })
    (import ./kicad.nix {
      inherit inputs nixpkgs;
    })
  ];
}
