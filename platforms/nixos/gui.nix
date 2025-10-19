# GNOME Desktop Environment configuration for NixOS GUI systems
{ config, pkgs, ... }:

{
  # === Networking ===
  networking.networkmanager.enable = true;

  # === Display & Desktop Environment ===
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude unwanted GNOME packages
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

  # === Input Configuration ===
  # Keyboard layout and behavior
  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:nocaps";
  };

  # Keyboard repeat rate
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 15;

  # Logitech mouse button remapping (remap forward button to Super key)
  environment.etc."udev/hwdb.d/90-logitech-mouse-button-remap.hwdb".text = ''
    # Remap BTN_FORWARD (scan code 90006) to KEY_LEFTMETA (Super key)
    # Logitech USB Receiver Mouse (046d:c548)
    evdev:input:b*v046DpC548*
     KEYBOARD_KEY_0115=leftmeta
     KEYBOARD_KEY_90006=leftmeta
  '';

  # Mark Logitech receiver input events as keyboard (needed for Wayland/GNOME)
  services.udev.extraRules = ''
    # Tag Logitech 046d:c548 input interfaces as keyboards so GNOME/Mutter accepts key events
    KERNEL=="event*", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="046d", ENV{ID_MODEL_ID}=="c548", \
      ENV{ID_INPUT_KEYBOARD}="1"
  '';

  # === Hardware Support ===
  # Thunderbolt daemon
  services.hardware.bolt.enable = true;

  # Fingerprint reader
  services.fprintd.enable = true;

  # === Laptop Power Management ===
  services.logind = {
    lidSwitch = "hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = ''
      HandleLidSwitch=hibernate
      HandleLidSwitchExternalPower=hibernate
      HandleLidSwitchDocked=ignore
    '';
  };

  # === Audio ===
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # === Printing ===
  services.printing.enable = true;

  # === Applications ===
  # Gaming
  programs.steam.enable = true;

  # Open ports for Spotify device discovery
  networking.firewall.allowedUDPPorts = [ 5353 ];

  # 1Password browser integration
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      brave
    '';
    mode = "0755";
  };
}
