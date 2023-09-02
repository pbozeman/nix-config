{pkgs, ...}: {
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
      "Noteplan" = 1505432629;
      "Parallels" = 1085114709;
      "PdfScanner" = 410968114;
      "Xcode" = 497799835;
    };

    # TODO: move to homemanager version of kitty once it installs into the apps dir
    casks = [
      "arduino-ide"
      "kitty"
      "firefox"
      "google-chrome"
      "spotify"
      "zoom"
    ];
    taps = [];
    brews = ["pam-reattach"];
  };
}
