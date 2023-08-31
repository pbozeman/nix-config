{
  config,
  pkgs,
  secrets,
  user,
  fullname,
  ...
}: {
  system.stateVersion = "23.05";

  networking.hostName = "nixos";
  time.timeZone = "America/Los_Angeles";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  environment = {
    shells = [pkgs.bashInteractive pkgs.zsh];

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
    ];
  };

  users.mutableUsers = false;

  users.users.root = {
    hashedPassword = secrets.root.hashedPassword;
  };

  users.users.${user} = {
    hashedPassword = secrets.${user}.hashedPassword;
    home = "/home/${user}";
    shell = pkgs.zsh;
    description = "${fullname}";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  services.openssh.enable = true;
}
