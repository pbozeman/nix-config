{ inputs
, nixpkgs
, nix-darwin
, ...
}: {
  overlays = [
    (self: super: {
      libsigrok = super.libsigrok.overrideAttrs
        (oldAttrs: rec {
          pname = "libsigrok";
          version = "siglent-sds-hd-support";
          src = self.fetchFromGitHub
            {
              owner = "fredzo";
              repo = "libsigrok";
              rev = "siglent-sds-hd-support";
              sha256 = "hfg5jgzWEM/+O4Vjs6HSjx8ygeGcU4gFacPFbWGFcNc=";
            };
        });
    })
  ];
}
