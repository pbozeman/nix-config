{ inputs
, nixpkgs
, ...
}: {
  overlays = [
    (import ./claude-code.nix {
      inherit inputs nixpkgs;
    })
  ];
}
