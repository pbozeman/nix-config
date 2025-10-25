{ inputs
, pkgs
, lib
, user
, fullname
, email
, ...
}:

{
  imports = [
    ./programs/alacritty
    ./programs/autoraise
    ./programs/git
    ./programs/lazygit
    ./programs/navigation
    ./programs/starship
    ./programs/tmux
    ./programs/wezterm
    ./programs/zathura
    ./programs/zsh
  ];

  home = {
    # FIXME: take this out once possible.
    # See: https://github.com/nix-community/home-manager/issues/4483
    enableNixpkgsReleaseCheck = false;

    stateVersion = "23.05";
    username = "${user}";
    homeDirectory =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${user}"
      else "/home/${user}";

    # TODO: make nixcats show up in packages (with an overlay? )
    packages = with pkgs; let
      additionalPackages = [
        inputs.nixcats.packages.${system}.nvim
      ];
    in
    (import ./packages.nix { inherit pkgs; }) ++ additionalPackages;

    activation.linkBinFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      src="${./bin}"
      dest="$HOME/bin"

      mkdir -p "$dest"
      for f in "$src"/*; do
        [ -f "$f" ] || continue
        ln -sf "$f" "$dest/$(basename "$f")"
      done
    '';
  };
}
