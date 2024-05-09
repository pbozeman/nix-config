# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # enable gpu
  services.xserver.videoDrivers = [ "amdgpu" ];

  # enable thunderbolt daemon
  services.hardware.bolt.enable = true;

  # enable fingerprint reader
  #services.fprintd.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # keep the laptop on when the lid is closed if on ac
  services.logind.lidSwitchExternalPower = "ignore";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ]);

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:nocaps";
  };

  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 15;

  # steam
  programs.steam.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # system.stateVersion = "23.11"; # Did you read the comment?

  # Open ports for spotify device discovery
  networking.firewall.allowedUDPPorts = [ 5353 ];

  virtualisation.virtualbox.host.enable = true;

  environment = {
    etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          brave
        '';
        mode = "0755";
      };
    };
  };
}
