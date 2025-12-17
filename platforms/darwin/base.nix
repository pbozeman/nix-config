{ pkgs
, secrets
, user
, ...
}: {
  system.stateVersion = 4;
  system.primaryUser = user;

  ids.gids.nixbld = 350;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # ideally we would enable touch sudo using:
  #   security.pam.enableSudoTouchIdAuth = true;
  # but this doesn't work in tmux.  See pam.nix for more info.  This is
  # a work around.
  security.pam.enableCustomSudoTouchIdAuth = false;

  # shells
  programs.bash.enable = true;
  programs.bash.completion.enable = true;

  programs.fish.enable = true;

  environment.shells = [ pkgs.bashInteractive pkgs.fish ];

  users.users.${user} = {
    # See https://github.com/nix-community/home-manager/issues/4026
    home = "/Users/${user}";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = secrets.authorizedKeys;
  };

  fonts.packages = [
    pkgs.meslo-lgs-nf
  ];

  documentation.enable = true;

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        KeyRepeat = 1;
        InitialKeyRepeat = 14;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        # speed up animation on open/save boxes (default:0.2)
        NSWindowResizeTime = 0.001;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        "com.apple.swipescrolldirection" = false;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        mru-spaces = false;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        FXPreferredViewStyle = "Nlsv";
        FXDefaultSearchScope = "SCcf";
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      CustomUserPreferences = {
        NSGlobalDomain = {
          # Add a context menu item for showing the Web Inspector in web views
          WebKitDeveloperExtras = true;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          _FXSortFoldersFirst = true;
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
      };

      # These security settings should already be set, but lets make sure.
      # quarantine downloads
      LaunchServices.LSQuarantine = true;

      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      # firewall settings
      #        Failed assertions:
      # - The option definition `system.defaults.alf.stealthenabled' in `/nix/store/a6ymwrvp4rcwblh7p8y8yw568nwy3cy7-source/platforms/darwin/base.nix' no longer has any effect; please remove it.
      # Use `networking.applicationFirewall.enableStealthMode' instead.
      #
      # - The option definition `system.defaults.alf.loggingenabled' in `/nix/store/a6ymwrvp4rcwblh7p8y8yw568nwy3cy7-source/platforms/darwin/base.nix' no longer has any effect; please remove it.
      # It's no longer necessary.
      #
      # - The option definition `system.defaults.alf.globalstate' in `/nix/store/a6ymwrvp4rcwblh7p8y8yw568nwy3cy7-source/platforms/darwin/base.nix' no longer has any effect; please remove it.
      # Use `networking.applicationFirewall.enable' and `networking.applicationFirewall.blockAllIncoming' instead.
      #
      # alf = {
      #   # 0 = disabled 1 = enabled 2 = blocks all connections except for essential services
      #   globalstate = 1;
      #   loggingenabled = 0;
      #   stealthenabled = 1;
      # };
    };

    activationScripts.extraActivation.enable = true;
    activationScripts.extraActivation.text = ''
      echo "Activating extra preferences..."
      # Close any open System Preferences panes, to prevent them from overriding
      # settings we’re about to change
      osascript -e 'tell application "System Preferences" to quit'

      # Control Center
      # Note: this requires a full reboot, not just logout/login
      /usr/libexec/PlistBuddy \
        -c "clear dict" \
        -c "add :Siri integer 8" \
        -c "add :Bluetooth integer 18" \
        -c "add :WiFi integer 2" \
        -c "add :ScreenMirroring integer 18" \
        -c "add :Display integer 18" \
        -c "add :FocusModes integer 2" \
        -c "add :BatteryShowPercentage bool true" \
        -c "add :StageManager integer 8" \
        -c "add :NowPlaing integer 2" \
        -c "add :Sound integer 18" \
        -c "add :KeyboardBrightness integer 8" \
        -c "add :AirDrop integer 8" \
        -c "add :UserSwitcher integer 2" \
        "/Users/${user}/Library/Preferences/ByHost/com.apple.controlcenter.$(system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }').plist"

      # Better Snap Tool
      /usr/libexec/PlistBuddy \
        -c "delete :registeredHotkeys" \
        "/Users/${user}/Library/Preferences/com.hegenberg.BetterSnapTool.plist" || true

      /usr/libexec/PlistBuddy \
        -c "delete :shiftMove" \
        "/Users/${user}/Library/Preferences/com.hegenberg.BetterSnapTool.plist" || true

      /usr/libexec/PlistBuddy \
        -c "add :shiftMove integer 1" \
        -c "add :registeredHotkeys dict" \
        -c "add :registeredHotkeys:15 dict" \
        -c "add :registeredHotkeys:16 dict" \
        -c "add :registeredHotkeys:2 dict" \
        -c "add :registeredHotkeys:4 dict" \
        -c "add :registeredHotkeys:15:keyCode integer 126" \
        -c "add :registeredHotkeys:15:modifiers integer 8392960" \
        -c "add :registeredHotkeys:16:keyCode integer 125" \
        -c "add :registeredHotkeys:16:modifiers integer 8392960" \
        -c "add :registeredHotkeys:2:keyCode integer 123" \
        -c "add :registeredHotkeys:2:modifiers integer 8392960" \
        -c "add :registeredHotkeys:4:keyCode integer 124" \
        -c "add :registeredHotkeys:4:modifiers integer 8392960" \
        "/Users/${user}/Library/Preferences/com.hegenberg.BetterSnapTool.plist"
    '';

    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    activationScripts.customize.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
