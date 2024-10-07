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
  services.fprintd.enable = false;

  # Enable networking
  networking.networkmanager.enable = true;

  # Lid switch power settings
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.lidSwitchExternalPower = "lock";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    atomix
    cheese
    epiphany
    geary
    gedit
    gnome-characters
    gnome-contacts
    gnome-initial-setup
    gnome-music
    gnome-photos
    gnome-tour
    hitori
    iagno
    tali
    yelp
  ]);

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:nocaps";
  };

  environment.systemPackages = with pkgs; [
    input-remapper
  ];

  # mouse button remapping
  #
  # TODO: pull in the config file to this flake. The only
  # preset used is button FORWARD to SUPER_L
  services.input-remapper.enable = true;

  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 15;

  # steam
  programs.steam.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # virtualisation.virtualbox.host.enable = true;

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
