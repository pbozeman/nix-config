{ inputs, nixpkgs }: final: prev:
let
  pname = "brave";
  version = "1.76.82";

  # fill in hashes as used
  allArchives = {
    aarch64-linux = {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_arm64.deb";
      hash = "";
    };
    x86_64-linux = {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
      hash = "sha256-a5c8tqayrCKPWaQmoDTGx+KH0SEcO8TfPlAX82v9MLY=";
    };
    aarch64-darwin = {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-v${version}-darwin-arm64.zip";
      hash = "";
    };
    x86_64-darwin = {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-v${version}-darwin-x64.zip";
      hash = "";
    };
  };

  archive =
    if builtins.hasAttr prev.stdenv.system allArchives then
      allArchives.${prev.stdenv.system}
    else
      throw "Unsupported platform: ${prev.stdenv.system}";

in
{
  brave = prev.brave.overrideAttrs (oldAttrs: {
    pname = pname;
    version = version;
    src = prev.fetchurl (archive // {
      inherit (archive) url;
    });
    meta = oldAttrs.meta // {
      changelog = "https://github.com/brave/brave-browser/releases/tag/v${version}";
    };
  });
}
