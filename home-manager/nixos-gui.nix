{ pkgs
, home
, lib
, user
, ...
}: {
  home.file.".config/forge/stylesheet/forge/stylesheet.css".source = ./gnome-forge/stylesheet.css;

  home.packages = with pkgs; [
    anki

    # browsers
    brave
    chromium
    firefox

    # apps
    lmstudio
    kicad
    obs-studio
    obsidian
    slack
    spotify
    usbtop
    wireshark
    zoom-us

    # x/gnome support apps
    gnome-shell-extensions
    gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.forge
    gnomeExtensions.hide-top-bar
    xsel

    xorg.xhost

    # TODO: this is sort of a hack in that we want verible support on all but darwin
    # since there isn't an arm version of the verible build. Dropping this in the gui
    # file for the moment, as it achieves the short term goal. If this package stays
    # in the nix config, then find it a proper home.. However, it really should be
    # in the lazyvim flake.
    verible
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Nordzy";
      package = pkgs.nordzy-icon-theme;
    };
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    cursorTheme = {
      name = "Adwaita";
      # package = pkgs.adwaita-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Use `dconf watch /` to track
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-options = "none";
      primary-color = "#2E3440";
      secondary-color = "#2E3440";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      text-scaling-factor = 1.8;
      font-antialiasing = "rgba";
    };

    "org/gnome/desktop/input-sources" = {
      "xkb-options" = [ "ctrl:nocaps" ];
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 200;
      repeat-interval = lib.hm.gvariant.mkUint32 10;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [
        "org.gnome.Characters.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.Epiphany.desktop"
      ];
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      # application
      switch-application = [ "<Alt>Tab" ];
      # system
      toggle-overview = [ "<Super>Tab" ];
      # window
      begin-move = [ "<Super>w" ];
      begin-resize = [ "<Super>r" ];
      toggle-fullscreen = [ "<Super>Return" ];
      minimize = [ ];
      # workspace switching
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-left = [ "<Super>Left" ];
      switch-to-workspace-right = [ "<Super>Right" ];
      # move window to workspace
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "forge@jmmaranan.com"
      ];
      favorite-apps = [
        "Alacritty.desktop"
        "brave-browser.desktop"
        "obsidian.desktop"
        "1password.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/shell/extensions/forge" = {
      focus-border-toggle = true;
      window-gap-size-increment = lib.hm.gvariant.mkUint32 1;
    };

    "org/gnome/shell/extensions/forge/keybindings" = {
      prefs-tiling-toggle = [ ];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };
  };
}
