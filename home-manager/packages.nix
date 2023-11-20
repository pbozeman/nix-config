{pkgs}:
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

  # k8s
  helmfile
  k9s
  kubectl
  kubecolor
  # https://discourse.nixos.org/t/helm-plugin-install/20705
  (pkgs.wrapHelm pkgs.kubernetes-helm { plugins = [ pkgs.kubernetes-helmPlugins.helm-diff ]; })
]
