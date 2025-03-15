{ inputs
, nixpkgs
, ...
}: {
  overlays = [
    (import ./claude-code.nix {
      inherit inputs nixpkgs;
    })
    (import ./tmux-stable.nix {
      inherit inputs nixpkgs;
    })
  ];
}
