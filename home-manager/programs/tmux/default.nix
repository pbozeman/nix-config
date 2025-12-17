{ pkgs, ... }:

let
  tmux-tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-tokyo-night";
    rtpFilePath = "tmux-tokyo-night.tmux";
    version = "unstable-2023-09-01";
    src = pkgs.fetchFromGitHub {
      owner = "fabioluciano";
      repo = "tmux-tokyo-night";
      rev = "cc3013cca97fcaacdba4ab8c3c4be72131c57490";
      sha256 = "sha256-YtW74ju+myyMfyCdH6Oj5fPXhK0PsIuVUnFAMzJ7fjM=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    sensibleOnTop = false;
    mouse = true;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    plugins = [ tmux-tokyo-night ];
    extraConfig = ''
      # work arounds from:
      #  https://github.com/LazyVim/LazyVim/discussions/163
      #  https://github.com/LazyVim/LazyVim/discussions/658
      set -sg escape-time 0
      set-option -g focus-events on

      # https://github.com/mobile-shell/mosh/pull/1054
      set -s set-clipboard on
      set -ag terminal-overrides ",xterm-256color:Ms=\\E]52;c;%p2%s\\7"

      # Disable italics (render as normal text instead of reverse video)
      set -as terminal-overrides ',*:sitm=:ritm=:smso=:rmso='

      set -g focus-events on
      set -g automatic-rename on
      set -g renumber-windows on
      set -g base-index 1
      setw -g pane-base-index 1

      # use better mnemonics for horizontal/vertical splits
      bind - split-window -v -c "#{pane_current_path}"
      bind _ split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      # navigate panes with vi like movement (raw, dumb version)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # renames
      bind , command-prompt "rename-window '%%'"
      bind $ command-prompt "rename-session '%%'"

      # window management
      bind K kill-pane
      bind W kill-window
      bind L swap-window -t -1 \; select-window -t -1
      bind R swap-window -t +1 \; select-window -t +1

      # vim/tmux integration
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
      bind -n 'C-h' if-shell "$is_vim" { send-keys C-h } { if-shell -F '#{pane_at_left}'   {} { select-pane -L } }
      bind -n 'C-j' if-shell "$is_vim" { send-keys C-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
      bind -n 'C-k' if-shell "$is_vim" { send-keys C-k } { if-shell -F '#{pane_at_top}'    {} { select-pane -U } }
      bind -n 'C-l' if-shell "$is_vim" { send-keys C-l } { if-shell -F '#{pane_at_right}'  {} { select-pane -R } }

      bind -T copy-mode-vi 'C-h' if-shell -F '#{pane_at_left}'   {} { select-pane -L }
      bind -T copy-mode-vi 'C-j' if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
      bind -T copy-mode-vi 'C-l' if-shell -F '#{pane_at_right}'  {} { select-pane -R }
      bind -T copy-mode-vi 'C-k' if-shell -F '#{pane_at_top}'    {} { select-pane -U }

      # dim inactive panes
      # Note: these have to be coordinated with the terminal and tmux style.
      set -g window-style 'fg=#939cac,bg=#111111'
      set -g window-active-style 'fg=#dcdfe4,bg=#000000'
      set -g pane-border-style 'fg=#666666,bg=#111111'
      set -g pane-active-border-style 'fg=#666666,bg=#111111'

      # override status bar to remove seconds from clock
      #
      # TODO: figure out how to use @theme_plugin_datetime_format instead
      #
      # https://github.com/fabioluciano/tmux-tokyo-night says that
      # set -g @theme_plugin_datetime_format should work, but it didn't on the
      # first try.
      set -g status-right "#[fg=#394b70,bg=#292e42]#[none]#[fg=#ffffff,bg=#394b70] %a %b %d %H:%M %Y #[none]"
    '';
  };
}
