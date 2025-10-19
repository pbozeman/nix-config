{ ... }:

{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      return {
        front_end = "WebGpu",
        check_for_updates = false,
        audible_bell = "Disabled",
        enable_tab_bar = false,
        font = wezterm.font_with_fallback({
          "MesloLGS NF",
          "MesloLGS Nerd Font Mono",
        }),
        font_size = 12.0,
        native_macos_fullscreen_mode = true,
        window_decorations = "RESIZE",
        enable_wayland = false,
        keys = {
          {
            key = 'Enter',
            mods = 'CMD',
            action = wezterm.action.ToggleFullScreen,
          },
          {
            key = 'v',
            mods = 'CTRL',
            action = wezterm.action.PasteFrom('Clipboard'),
          },
          {
            key = 't',
            mods = 'ALT',
            action = wezterm.action.SpawnTab('DefaultDomain'),
          },
          {
            key = '1',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(0),
          },
          {
            key = '2',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(1),
          },
          {
            key = '3',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(2),
          },
          {
            key = '4',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(3),
          },
          {
            key = '5',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(4),
          },
          {
            key = '6',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(5),
          },
          {
            key = '7',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(6),
          },
          {
            key = '8',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(7),
          },
          {
            key = '9',
            mods = 'ALT',
            action = wezterm.action.ActivateTab(8),
          },
        },
        colors = {
          foreground = "#D8DEE9",
          background = "#000000",
          cursor_bg = "#D8DEE9",
          cursor_border = "#D8DEE9",
          cursor_fg = "#2E3440",
          selection_bg = "#4C566A",
          selection_fg = "#D8DEE9",

          ansi = {"#3B4252", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#88C0D0", "#E5E9F0"},
          brights = {"#4C566A", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#8FBCBB", "#ECEFF4"},

          tab_bar = {
            background = "#2E3440",

            active_tab = {
              bg_color = "#88C0D0",
              fg_color = "#2E3440",
            },

            inactive_tab = {
              bg_color = "#4C566A",
              fg_color = "#D8DEE9",
            },
          },
        },
      }
    '';
  };
}
