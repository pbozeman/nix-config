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
  git-filter-repo
  killall
  openssh
  pandoc
  wget
  zip

  # Encryption and security tools
  #_1password

  # Media-related packages
  meslo-lgs-nf

  # Source code management, Git, GitHub tools
  gh

  # Text and terminal utilities
  htop
  ipcalc
  jq
  kalker
  ripgrep
  tree
  tmux
  #unrar
  unzip

  # Python packages
  python39
  python39Packages.virtualenv

  # base vim - configured with lazyvim still
  neovim
  clang-tools
  nodejs
  alejandra
  statix
  mypy
  ruff
  black

  platformio
]
