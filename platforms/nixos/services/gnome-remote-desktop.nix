{ ... }: {
  services.gnome.gnome-remote-desktop.enable = true;

  # RDP uses port 3389
  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 3389 ];
}
