{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenvNoCC.isDarwin;

  ghosttyConfig = ''
    # Font
    font-family = Hack
    font-size = 12
    font-style-italic = false
    font-style-bold-italic = false
    font-synthetic-style = no-italic,no-bold-italic

    shell-integration = none
    app-notifications = no-clipboard-copy

    # Window
    title = term
    macos-titlebar-style = transparent
    gtk-tabs-location = hidden
    mouse-hide-while-typing = true
    window-padding-color = background

    # Colors (matching Alacritty config)
    foreground = D8DEE9
    background = 000000
    cursor-color = D8DEE9
    cursor-text = 2E3440
    selection-foreground = D8DEE9
    selection-background = 4C566A

    # Normal colors
    palette = 0=#3B4252
    palette = 1=#BF616A
    palette = 2=#A3BE8C
    palette = 3=#EBCB8B
    palette = 4=#81A1C1
    palette = 5=#B48EAD
    palette = 6=#88C0D0
    palette = 7=#E5E9F0
    # Bright colors
    palette = 8=#4C566A
    palette = 9=#BF616A
    palette = 10=#A3BE8C
    palette = 11=#EBCB8B
    palette = 12=#81A1C1
    palette = 13=#B48EAD
    palette = 14=#8FBCBB
    palette = 15=#ECEFF4

    # Key bindings
    keybind = ctrl+v=paste_from_clipboard
    keybind = cmd+enter=toggle_fullscreen
    keybind = shift+enter=text:\x1b\r
    keybind = alt+t=new_tab
    keybind = alt+n=new_window
    keybind = alt+one=goto_tab:1
    keybind = alt+two=goto_tab:2
    keybind = alt+three=goto_tab:3
    keybind = alt+four=goto_tab:4
    keybind = alt+five=goto_tab:5
    keybind = alt+six=goto_tab:6
    keybind = alt+seven=goto_tab:7
    keybind = alt+eight=goto_tab:8
    keybind = alt+nine=goto_tab:9
  '';
in
{
  # Use home-manager's file management to create the config on Darwin
  xdg.configFile = lib.mkIf isDarwin {
    "ghostty/config".text = ghosttyConfig;
  };

  # Use the ghostty program module on non-Darwin systems
  programs.ghostty = lib.mkIf (!isDarwin) {
    enable = true;
    settings = {
      # Font
      font-family = "Hack";
      font-size = 12;
      font-style-italic = false;
      font-style-bold-italic = false;
      font-synthetic-style = "no-italic,no-bold-italic";

      shell-integration = "none";
      app-notifications = "no-clipboard-copy";

      # Window
      title = "term";
      window-decoration = false;
      gtk-tabs-location = "hidden";
      mouse-hide-while-typing = true;

      # Colors (matching Alacritty config)
      foreground = "#D8DEE9";
      background = "#000000";
      cursor-color = "#D8DEE9";
      cursor-text = "#2E3440";
      selection-foreground = "#D8DEE9";
      selection-background = "#4C566A";

      # Normal colors
      palette = [
        "0=#3B4252" # black
        "1=#BF616A" # red
        "2=#A3BE8C" # green
        "3=#EBCB8B" # yellow
        "4=#81A1C1" # blue
        "5=#B48EAD" # magenta
        "6=#88C0D0" # cyan
        "7=#E5E9F0" # white
        # Bright colors
        "8=#4C566A" # bright black
        "9=#BF616A" # bright red
        "10=#A3BE8C" # bright green
        "11=#EBCB8B" # bright yellow
        "12=#81A1C1" # bright blue
        "13=#B48EAD" # bright magenta
        "14=#8FBCBB" # bright cyan
        "15=#ECEFF4" # bright white
      ];

      # Key bindings
      keybind = [
        "ctrl+v=paste_from_clipboard"
        "alt+enter=toggle_fullscreen"
        "super+enter=toggle_fullscreen"
        "shift+enter=text:\\x1b\\r"
        "alt+t=new_tab"
        "alt+n=new_window"
        "alt+one=goto_tab:1"
        "alt+two=goto_tab:2"
        "alt+three=goto_tab:3"
        "alt+four=goto_tab:4"
        "alt+five=goto_tab:5"
        "alt+six=goto_tab:6"
        "alt+seven=goto_tab:7"
        "alt+eight=goto_tab:8"
        "alt+nine=goto_tab:9"
      ];
    };
  };
}
