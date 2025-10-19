{ config
, pkgs
, secrets
, hostname
, user
, fullname
, ...
}: {
  system.stateVersion = "23.11";

  networking.hostName = "${hostname}";
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ user ];
  };

  environment = {
    shells = [ pkgs.bashInteractive pkgs.zsh ];

    # Note: these vars are pam environment so set on login globally
    # as part of parent to shells. Starting new shells doesn't get the
    # new env. You have to logout first. Or use home-manager vars instead.
    sessionVariables = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    systemPackages = with pkgs; [
      vim
      wget
      curl
      git
      binutils
      pciutils
      coreutils
      psmisc
      usbutils
      dnsutils
      tailscale
    ];
  };

  users.mutableUsers = false;

  users.users.root = {
    hashedPassword = secrets.root.hashedPassword;
    openssh.authorizedKeys.keys = secrets.authorizedKeys;
  };

  virtualisation.docker.enable = true;

  users.users.${user} = {
    hashedPassword = secrets.${user}.hashedPassword;
    home = "/home/${user}";
    shell = pkgs.zsh;
    description = "${fullname}";
    isNormalUser = true;
    extraGroups = [
      "dialout"
      "docker"
      "wheel"
      "usbmon"
      "vboxusers"
      "wireshark"
    ];
    openssh.authorizedKeys.keys = secrets.authorizedKeys;
  };

  services.udev.enable = true;
  services.udev.packages = with pkgs; [
    platformio-core.udev
    # openocd
  ];

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      X11Forwarding = true;
      X11UseLocalhost = true;
    };
  };
}
