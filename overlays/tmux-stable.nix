{
  inputs,
  nixpkgs,
  ...
}:

final: prev: {
  # Override tmux to use the stable version from nixpkgs-stable 24.11
  tmux = inputs.nixpkgs-stable.legacyPackages.${prev.system}.tmux;
}