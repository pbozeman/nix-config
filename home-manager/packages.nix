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
  gcc
  killall
  openssh
  pandoc
  wget
  zip

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

  # platformio
  platformio
]
