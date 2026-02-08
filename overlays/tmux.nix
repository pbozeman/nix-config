{ ... }:

# this is to get the version without screen flickering in claude code
# as of Jan 25. Remove this overlay when 1c7e164 is in an official
# release
final: prev: {
  tmux = prev.tmux.overrideAttrs (oldAttrs: {
    version = "615c27c";
    src = prev.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      rev = "615c27c";
      hash = "sha256-zcll86R5uxUHhEb7VKshJibGwgJOGz2K6ru2gf+DT9g=";
    };
  });
}
