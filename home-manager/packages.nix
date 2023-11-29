{pkgs}:
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
  aspell
  aspellDicts.en
  autojump
  bash-completion
  bat
  btop
  coreutils
  fd
  duf
  killall
  mosh
  openssh
  pandoc
  wget
  zip

  # c/c++
  gnumake
  gcc

  # Fonts
  meslo-lgs-nf

  # Source code management, Git, GitHub tools
  git
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
  python39
  python39Packages.virtualenv

  # base vim - configured with lazyvim still
  # and linters etc
  neovim
  alejandra
  black
  clang-tools
  nodejs
  mypy
  ruff
  statix

  # Brew's version is much newer
  # platformio

  # node
  nodePackages."@astrojs/language-server"
  nodePackages.pyright # python lsp
  nodePackages.eslint_d # js/ts code formatter and linter
  nodePackages.prettier # ditto
  # nodePackages.prettier-plugin-astro # does not exist :(

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
]
