{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "MesloLGS NF";
        size = 18;
      };
      keyboard = {
        bindings = [
          { key = "v"; mods = "Control"; action = "Paste"; }
          { key = "Enter"; mods = "Alt"; action = "ToggleFullscreen"; }
          { key = "Enter"; mods = "Command"; action = "ToggleFullscreen"; }
          { key = "Enter"; mods = "Shift"; chars = "\\u001b\\r"; }
        ];
      };
      mouse = {
        hide_when_typing = true;
      };
      window = {
        title = "term";
        dynamic_title = true;
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 8;
          y = 8;
        };
      };
      colors = {
        primary.foreground = "#D8DEE9";
        primary.background = "#000000";
        cursor.text = "#2E3440";
        cursor.cursor = "#D8DEE9";
        selection.text = "#D8DEE9";
        selection.background = "#4C566A";
        normal = {
          black = "#3B4252";
          red = "#BF616A";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          blue = "#81A1C1";
          magenta = "#B48EAD";
          cyan = "#88C0D0";
          white = "#E5E9F0";
        };
        bright = {
          black = "#4C566A";
          red = "#BF616A";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          blue = "#81A1C1";
          magenta = "#B48EAD";
          cyan = "#8FBCBB";
          white = "#ECEFF4";
        };
      };
    };
  };
}
