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
      "Amphetamine" = 937984704;
      "BetterSnapTool" = 417375580;
    };

    # TODO: move to homemanager version of kitty once it installs into the apps dir
    casks = ["kitty"];
    taps = [];
    brews = [];
  };
}
