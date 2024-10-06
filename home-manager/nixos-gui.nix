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
    obsidian
    spotify
    zoom-us

    # x/gnome support apps
    gnome-shell-extensions
    gnome-tweaks
    gnomeExtensions.forge
    xsel
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
        "org.wezfurlong.wezterm.desktop"
        "brave-browser.desktop"
        "obsidian.desktop"
        "1password.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };
}
