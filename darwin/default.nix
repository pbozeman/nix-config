{pkgs, ...}: {
  imports = [
    ./pam.nix
    ./base.nix
    ./brew.nix
  ];
}
