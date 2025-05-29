{ pkgs, user, ... }: {
  system.primaryUser = user;
  imports = [
    ./pam.nix
    ./base.nix
    ./brew.nix
  ];
}
