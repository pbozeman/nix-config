{ config, ... }:

{
  home.file.".bazelrc".text = ''
    common --disk_cache=${config.home.homeDirectory}/.cache/bazel-disk
    common --experimental_disk_cache_gc_max_size=10G
  '';
}
