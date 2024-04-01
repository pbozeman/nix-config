{ pkgs
, home
, lib
, user
, ...
}: {
  home.packages = with pkgs; [
    # browsers
    brave
    chromium
    firefox

    # apps
    kicad
    spotify
    zoom-us

    # x/gnome support apps
    gnome.gnome-tweaks
    wl-clipboard
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
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      text-scaling-factor = 1.5;
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
    };

    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        "kitty.desktop"
        "spotify.desktop"
        "1password.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };
}
