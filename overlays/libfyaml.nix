{ ... }:

final: prev: {
  libfyaml = prev.libfyaml.overrideAttrs (
    old:
    prev.lib.optionalAttrs final.stdenv.hostPlatform.isDarwin {
      postFixup = (old.postFixup or "") + ''
        if [ -f "$dev/lib/pkgconfig/libfyaml.pc" ]; then
          substituteInPlace "$dev/lib/pkgconfig/libfyaml.pc" \
            --replace " none required" ""
        fi
      '';
    }
  );
}
