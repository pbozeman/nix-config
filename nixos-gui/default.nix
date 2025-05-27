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
  services.fprintd.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Lid switch power settings
  services.logind.lidSwitch = "hibernate";
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

  # mouse button remapping
  #environment.etc."udev/hwdb.d/90-logitech-mouse-button-remap.hwdb".text = ''
  #  # Remap BTN_FORWARD (scan code 90006) to KEY_LEFTMETA (Super key)
  #  # Logitech USB Receiver Mouse
  #  evdev:input:b0003v046DpC548*
  #   KEYBOARD_KEY_90006=leftmeta
  #   ID_INPUT_KEYBOARD=1
  #'';

  # Create a udev rule to apply the mapping
  services.udev.extraRules = ''
    # Apply hwdb mapping for Logitech USB Receiver Mouse
    ACTION=="add", SUBSYSTEM=="input", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", RUN+="${pkgs.systemd}/bin/systemd-hwdb update", RUN+="${pkgs.coreutils}/bin/sleep 1", RUN+="${pkgs.systemd}/bin/udevadm trigger %p"
  '';

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:nocaps";
  };

  # keyboard rate
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 15;

  # steam
  programs.steam.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

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
