{ pkgs
, home
, lib
, user
, ...
}: {
  home.packages = [ pkgs.dockutil ];

  home.activation.dockutil = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.dockutil}/bin/dockutil \
      --remove all \
      --add "/Applications/Brave Browser.app" \
      --add /Applications/Alacritty.app \
      --add /Applications/Spotify.app \
      --add "/System/Applications/Preview.app" \
      --add "/System/Applications/Utilities/Activity Monitor.app" \
      --add "/System/Applications/System Settings.app" \
      --add "~/Downloads" --view list --display folder \
      --add "~/src" --view list --display folder \
      --list ~${user} > /dev/null
  '';
}
