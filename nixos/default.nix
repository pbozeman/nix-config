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
    polkitPolicyOwners = [ "pbozeman" ];
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
      "docker"
      "wheel"
    ];
    openssh.authorizedKeys.keys = secrets.authorizedKeys;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # FIXME: This isn't the best place for this, but as of now, all my nixos
  # machines are backend servers, not laptops. I would not want to enable
  # this on a laptop.
  services.eternal-terminal.enable = true;

  # tailscale
  services.tailscale.enable = true;

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey ${secrets.tailscaleKey}
    '';
  };
}
