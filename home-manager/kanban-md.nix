{ lib, stdenvNoCC, fetchurl }:

let
  version = "0.33.0";
  # system -> { goreleaser platform suffix, sha256 (hex, from the release checksums.txt) }
  assets = {
    "x86_64-linux"   = { plat = "linux_amd64";  sha256 = "9d98e774dec3ba5f26009bfee8e64f7857eb2c785c98d55b201ae68f1400ea5d"; };
    "aarch64-linux"  = { plat = "linux_arm64";  sha256 = "d817393aa74d8a3e6c0ade728faebb07d5b7d3c5e8298923f78251c0aa63f9eb"; };
    "x86_64-darwin"  = { plat = "darwin_amd64"; sha256 = "fd0080aaf84b06673666f21d423aef74192a1b573d435a56c22105b9d945d3ea"; };
    "aarch64-darwin" = { plat = "darwin_arm64"; sha256 = "8ac700f112c396c2ac9a8ec946a427bd972a3da640649d744f8fa2d77bb4a039"; };
  };
  a = assets.${stdenvNoCC.hostPlatform.system}
      or (throw "kanban-md: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "kanban-md";
  inherit version;
  src = fetchurl {
    url = "https://github.com/antopolskiy/kanban-md/releases/download/v${version}/kanban-md_${version}_${a.plat}.tar.gz";
    sha256 = a.sha256;
  };
  sourceRoot = ".";              # goreleaser archive is flat (LICENSE, README.md, kanban-md)
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 kanban-md $out/bin/kanban-md
    ln -s kanban-md $out/bin/kbmd
    runHook postInstall
  '';
  meta = {
    description = "File-based Kanban board CLI/TUI for multi-agent workflows";
    homepage = "https://github.com/antopolskiy/kanban-md";
    mainProgram = "kanban-md";
    platforms = builtins.attrNames assets;
  };
}
