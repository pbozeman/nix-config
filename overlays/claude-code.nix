{ inputs, nixpkgs, ... }:

final: prev: {
  claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
    version = "0.2.41";
    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-HxPdULdggaFeNkRnrqIU2Y7HC6F8UdqRLTl8QiLV8wg=";
    };
  });
}
