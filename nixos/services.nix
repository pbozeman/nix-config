{ config
, pkgs
, secrets
, hostname
, user
, fullname
, ...
}: {
  # FIXME: This isn't the best place for this, but as of now, all my nixos
  # machines are backend servers, not laptops. I would not want to enable
  # this on a laptop.
  services.eternal-terminal.enable = true;

  # https://wiki.nixos.org/wiki/Fwupd
  services.fwupd.enable = true;

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
