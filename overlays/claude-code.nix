{ inputs, ... }:
final: prev: {
  claude-code = inputs.nixpkgs-unstable.legacyPackages.${final.system}.claude-code.overrideAttrs (old: {
    meta = old.meta // { license = "unfree"; };
  });
}
