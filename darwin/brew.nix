{ pkgs, ... }: {
  imports = [
  ];

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
    };
    global.brewfile = true;

    masApps = {
      "1Password" = 1333542190;
      "Amphetamine" = 937984704;
      "BetterSnapTool" = 417375580;
      "BlueSee" = 1336679524;
      "Noteplan" = 1505432629;
      "Parallels" = 1085114709;
      "PdfScanner" = 410968114;
      "Tailscale" = 1475387142;
      "Xcode" = 497799835;
    };

    # TODO: move to homemanager version of kitty once it installs into the apps dir
    casks = [
      "arduino-ide"
      "brave-browser"
      "itsycal"
      "kicad"
      "kitty"
      "firefox"
      "google-chrome"
      "obsidian"
      "openlens"
      "spotify"
      "qlmarkdown"
      "wireshark"
      "zoom"
    ];
    taps = [
      "dimentium/autoraise"
      "MisterTea/et"
    ];
    brews = [
      {
        name = "autoraise";
        start_service = true;
      }
      "docker"
      "et"
      "pam-reattach"
    ];
  };
}
