{ pkgs }:
let
  # https://nixos.wiki/wiki/Helm_and_Helmfile
  my-kubernetes-helm = with pkgs; wrapHelm kubernetes-helm {
    plugins = with pkgs.kubernetes-helmPlugins; [
      helm-secrets
      helm-diff
    ];
  };

  my-helmfile = with pkgs; helmfile-wrapped.override {
    inherit (my-kubernetes-helm.passthru) pluginsDir;
  };
in

with pkgs; [
  # General packages for development and system management
  ascii
  aspell
  aspellDicts.en
  autojump
  bash-completion
  bat
  btop
  coreutils
  direnv
  fswatch
  nix-direnv
  fd
  duf
  killall
  openssh
  pandoc
  wget
  zip

  # c/c++
  gnumake
  gcc

  # agents
  claude-code

  # Sigrok
  # pulseview
  # sigrok-cli

  # Fonts
  meslo-lgs-nf

  # Source code management, Git, GitHub tools
  git
  git-absorb
  git-crypt
  git-filter-repo
  gh

  # git tuis
  lazygit
  tig

  # Text and terminal utilities
  htop
  ipcalc
  jq
  kalker
  ripgrep
  tree
  tmux
  unzip

  # Python packages
  python3
  python3Packages.virtualenv

  # iac
  terraform

  # secrets management
  sops

  # k8s
  k9s
  kubectl
  kubecolor
  my-kubernetes-helm
  my-helmfile
  velero

  # go
  go

  # rust
  cargo
  rustc

  # FIXME: this should be coming from lazyvim-nix
  markdownlint-cli
]
