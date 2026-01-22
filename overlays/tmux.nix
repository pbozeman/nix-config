{ ... }:

# this is to get the version without screen flickering in claude code
# as of Jan 25. Remove this overlay when 1c7e164 is in an official
# release
final: prev: {
  tmux = prev.tmux.overrideAttrs (oldAttrs: {
    version = "master";
    src = prev.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      rev = "master";
      hash = "sha256-Le76k5X6YJKVjOstOreqixzeRLt6+E9qzmltMS5Vlc4=";
    };
  });
}
