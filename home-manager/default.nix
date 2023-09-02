{
  pkgs,
  user,
  fullname,
  email,
  ...
}: let
  # TODO: this is probably a sign that some parts of these should
  # start getting refactored int separate files.
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
in {
  home = {
    stateVersion = "23.05";
    username = "${user}";
    homeDirectory =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${user}"
      else "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};

    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less";
      LS_COLORS = "no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
      LSCOLORS = "ExfxcxdxCxegedabagacad";
      SYSTEMD_COLORS = "true";
      COLORTERM = "truecolor";
      MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
      HOMEBREW_NO_AUTO_UPDATE = 1;
    };

    shellAliases = {
      # TODO: this was a raw port of my aliases. These should likely not really
      # just al be dumped into the common alias set.  Consider refactoring later.

      # don't add a newline at the top of a clear
      clear = "precmd() {precmd() {echo }} && clear";

      # misc shortcuts
      e = "\${EDITOR}";
      c = "clear";

      # rebuilds
      darwin-rebuild = "~/src/nix-config/bin/darwin-rebuild";
      home-rebuild = "~/src/nix-config/bin/home-build";

      # This is a hack to quickly disable the lazyvim startup screen
      # TODO: figure out how to do this via the lazyvim config
      nvim = "nvim -";

      # ssh
      # https://sw.kovidgoyal.net/kitty/kittens/ssh/
      kssh = "kitty +kitten ssh";
      s = "kitty +kitten ssh";

      # ls
      ls = "ls --color=auto -F";
      l = "exa --icons --git-ignore --git -F --extended";
      ll = "exa --icons --git-ignore --git -F --extended -l";
      lt = "exa --icons --git-ignore --git -F --extended -T";
      llt = "exa --icons --git-ignore --git -F --extended -l -T";

      # movement
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # tmux
      tm = "tmux";
      tma = "tmux a -t";
      tmls = "tmux ls";
      tmn = "tmux new -t";

      # utils
      calc = "kalker";
      df = "duf";

      # clang format for pio code
      cf = "find {src,test} -iname *.h -o -iname *.cpp | xargs clang-format -i -style=Google";

      #scc
      scc = "scc --cocomo-project-type embedded";

      # pio
      t = "pio test -e native -f test_native";
      tn = "pio test -e native";
      tv = "pio test -e native -vvv";
      ta = "pio test -e native -e esp32";
      td = "lldb .pio/build/native/program";
      r = "pio run";
      u = "pio run -t upload";
      m = "pio device monitor";
      um = "pio run -t upload && pio device monitor";
      pd = "pio debug --interface=gdb -- -x .pioinit";
      pc = "pio check";

      # git
      g = "git";
      ga = "git add";
      gca = "git commit --amend";
      gl = "git log";
      gd = "git diff";
      gdc = "git diff --cached";
      gs = "git status";
      gco = "git checkout";
      grs = "git restore --staged";

      # Always enable colored `grep` output
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
    };

    file = {
      ".config/nvim" = {
        # disable to develop/debug nvim config
        enable = true;
        source = ./nvim;
      };
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      # homemanager on ubuntu created "insecure"
      # compinit dirs.  Skip global setup and
      # then explicitly run compinit, ignoring "insecure"
      # directories.
      envExtra = ''
        skip_global_compinit=1
      '';

      completionInit = ''
        autoload -Uz compinit
        compinit -i # ignore unsecure dirs
      '';

      initExtra = ''
        # this should not be necessary, but homeManager isn't addding this to
        # the path when running stand alone (i.e. without nixos or darwin)
        export PATH="$HOME/.nix-profile/bin:$PATH"

        # vi cmd line editing
        set -o vi
        bindkey -v

        # disable the weird zsh command edit, because I sometimes try
        # to enter it out of habbit
        bindkey -rM vicmd :

        # setup vim command line editing
        autoload -z edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd v edit-command-line

        # Setup preferred key bindings that emulate emacs.
        bindkey '^P' up-history
        bindkey '^N' down-history
        bindkey '^?' backward-delete-char
        bindkey '^h' backward-delete-char
        bindkey '^w' backward-kill-word
        bindkey '\e^h' backward-kill-word
        bindkey '\e^?' backward-kill-word
        bindkey '^r' history-incremental-search-backward
        bindkey '^a' beginning-of-line
        bindkey '^e' end-of-line
        bindkey '\eb' backward-word
        bindkey '\ef' forward-word
        bindkey '^k' kill-line
        bindkey '^u' backward-kill-line

        zstyle ':completion:*' completer _extensions _complete _approximate
        zstyle ':completion:*' menu select
        zstyle ':completion:*:manuals'    separate-sections true
        zstyle ':completion:*:manuals.*'  insert-sections   true
        zstyle ':completion:*:man:*'      menu yes select
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path ~/.zsh/cache
        zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
        zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
        zstyle ':completion:*:*:kill:*' menu yes select
        zstyle ':completion:*:kill:*'   force-list always

        zstyle -e ':completion:*:default' list-colors 'reply=("$''${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:''${(s.:.)LS_COLORS}")'

        setopt list_ambiguous
        zmodload -a autocomplete
        zmodload -a complist

        # print a newline between the last program's output,
        # but only the first time.
        precmd() {
          precmd() {
            echo
          }
        }
      '';
    };

    git = {
      enable = true;
      ignores = ["*.swp"];
      userName = fullname;
      userEmail = email;
      extraConfig = {
        init.defaultBranch = "main";
        color.ui = true;
        pull.rebase = true;
        core = {
          editor = "nvim";
          autocrlf = "input";
        };
      };
      aliases = {
        co = "checkout";
      };
      difftastic = {
        enable = false;
        background = "dark";
      };
    };

    exa.enable = true;

    tmux = {
      enable = true;
      prefix = "C-Space";
      sensibleOnTop = true;
      mouse = true;
      keyMode = "vi";
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
      plugins = with pkgs; [tmux-tokyo-night];
      extraConfig = ''
        set -s set-clipboard on
        set-option -g focus-events on
        set-option -g automatic-rename on
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

        # vim/tmux integration
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" { send-keys C-h } { if-shell -F '#{pane_at_left}'   {} { select-pane -L } }
        bind-key -n 'C-j' if-shell "$is_vim" { send-keys C-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
        bind-key -n 'C-k' if-shell "$is_vim" { send-keys C-k } { if-shell -F '#{pane_at_top}'    {} { select-pane -U } }
        bind-key -n 'C-l' if-shell "$is_vim" { send-keys C-l } { if-shell -F '#{pane_at_right}'  {} { select-pane -R } }

        bind-key -T copy-mode-vi 'C-h' if-shell -F '#{pane_at_left}'   {} { select-pane -L }
        bind-key -T copy-mode-vi 'C-j' if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
        bind-key -T copy-mode-vi 'C-l' if-shell -F '#{pane_at_right}'  {} { select-pane -R }
        bind-key -T copy-mode-vi 'C-k' if-shell -F '#{pane_at_top}'    {} { select-pane -U }

        # dim inactive panes
        # Note: these have to be coordinated with the kitty and tmux style.
        # TODO: someday use kitty escape codes to remap the entire palette
        set -g window-style 'fg=#939cac,bg=#111111'
        set -g window-active-style 'fg=#dcdfe4,bg=#000000'
        set -g pane-border-style 'fg=#666666,bg=#111111'
        set -g pane-active-border-style 'fg=#666666,bg=#111111'
      '';
    };

    kitty = {
      enable = true;
      theme = "One Half Dark";
      font = {
        name = "MesloLGS Nerd Font Mono";
        size = 12;
      };
      keybindings = {
        "super+equal" = "increase_font_size";
        "super+minus" = "decrease_font_size";
        "super+0" = "restore_font_size";
        "cmd+c" = "copy_to_clipboard";
        "cmd+v" = "paste_from_clipboard";
        "ctrl+super+h" = "neighboring_window left";
        "ctrl+super+j" = "neighboring_window down";
        "ctrl+super+k" = "neighboring_window up";
        "ctrl+super+l" = "neighboring_window right";
        "cmd+1" = "goto_tab 1";
        "cmd+2" = "goto_tab 2";
        "cmd+3" = "goto_tab 3";
        "cmd+4" = "goto_tab 4";
        "cmd+5" = "goto_tab 5";
        "cmd+6" = "goto_tab 6";
        "cmd+7" = "goto_tab 7";
        "cmd+8" = "goto_tab 8";
        "cmd+9" = "goto_tab 9";
      };
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
        macos_quit_when_last_window_closed = true;
        adjust_line_height = "105%";
        disable_ligatures = "cursor"; # disable ligatures when cursor is on them
        shell_integration = "enabled";

        # Window layout
        hide_window_decorations = "titlebar-and-corners";
        window_padding_width = "0 2";
        macos_show_window_title_in = "window";

        remember_window_size = "no";
        initial_window_width = "80c";
        initial_window_height = "25c";

        # Tab bar
        tab_bar_style = "hidden";
        #tab_bar_edge = "bottom";
        #tab_bar_style = "powerline";
        #tab_title_template = "{title}"; # "{index}: {title}";

        enabled_layouts = "Tall";
      };
      extraConfig = ''
        mouse_hide_wait 1.0
        inactive_text_alpha 0.4
        active_border_color #888888
        inactive_border_color #888888
        background #000000
        focus_follows_mouse yes
      '';
    };

    autojump = {
      enable = false;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$username$hostname$localip$shlvl$directory$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$nix_shell$conda$meson$spack$memory_usage$cmd_duration$line_break$jobs$battery$time$status$os$container$shell$character";
        battery = {
          full_symbol = "";
          charging_symbol = "⚡";
          discharging_symbol = "󰁽 ";
          unknown_symbol = "󰁽 ";
          display = [
            {
              threshold = 30;
              style = "bold red";
            }
          ];
        };

        username = {
          show_always = true;
          style_user = "fg:#8E9AAF";
          format = "[$user]($style)";
        };

        hostname = {
          ssh_only = false;
          style = "fg:#CBC0D3";
          ssh_symbol = "";
          format = "[@$hostname]($style)";
        };

        directory = {
          style = "bold fg:#DEE2FF";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        nix_shell = {
          style = "fg:#DEE2FF";
          symbol = "";
          format = "\\[[$symbol$state(\($name\))]($style)\\]";
        };

        git_branch = {
          style = "fg:#FEEAFA";
          format = "[$symbol$branch]($style)";
        };

        git_status = {
          conflicted = "[=](bold red)";
          ahead = "[󰁝](bold)";
          behind = "[󰁅](bold yellow)";
          diverged = "[󰹺](bold red)";
          untracked = "[](bold red)";
          stashed = "[](bold)";
          modified = "[󰇂](bold yellow)";
          staged = "[󰐕](bold green)";
          deleted = "[x](bold)";
          style = "bold";
          format = "( [\\[$all_status$ahead_behind\\]]($style))";
        };

        os.format = "\\[[$symbol]($style)\\]";

        cmd_duration = {
          disabled = true;
          min_time = 10000;
          format = "\\[[⏱ $duration]($style)\\]";
        };
      };
    };
  };
}
