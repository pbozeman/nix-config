{ pkgs, lib, ... }:

let
  insertNewlineBinding = ''insert_newline = ["alt-enter"]'';
in
{
  home.activation.codexKeymap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config="$HOME/.codex/config.toml"

    mkdir -p "$(dirname "$config")"
    touch "$config"

    ${pkgs.perl}/bin/perl -0pi -e '
      my $binding = q{${insertNewlineBinding}};

      if (/\[tui\.keymap\.editor\]/m) {
        if (!s{(^\[tui\.keymap\.editor\]\n(?:(?!^\[).*\n)*?)^insert_newline\s*=.*$}{$1$binding}m) {
          s{(^\[tui\.keymap\.editor\]\n)}{$1$binding\n}m;
        }
      } else {
        $_ .= "\n" if length($_) && $_ !~ /\n\z/;
        $_ .= "\n[tui.keymap.editor]\n$binding\n";
      }
    ' "$config"
  '';
}
