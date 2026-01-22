{ inputs
, nixpkgs
, ...
}: {
  overlays = [
    (import ./claude-code.nix {
      inherit inputs nixpkgs;
    })
    (import ./codex.nix {
      inherit inputs nixpkgs;
    })
    (import ./kicad.nix {
      inherit inputs nixpkgs;
    })
    (import ./tmux.nix { })
    (import ./vivado.nix {
      inherit inputs nixpkgs;
    })
  ];
}
