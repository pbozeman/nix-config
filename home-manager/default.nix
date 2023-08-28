{
  pkgs,
  user,
  fullname,
  email,
  ...
}: {
  home = {
    stateVersion = "23.05";
    homeDirectory = "/Users/${user}";
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

      # misc shortcuts
      e = "\${EDITOR}";
      c = "clear";
      rebuild = "~/src/nix-config/bin/darwin-rebuild";

      # ls
      ls = "ls --color=auto -F";
      l = "exa --icons --git-ignore --git -F --extended";
      ll = "exa --icons --git-ignore --git -F --extended -l";
      lt = "exa --icons --git-ignore --git -F --extended -T";
      llt = "exa --icons --git-ignore --git -F --extended -l -T";

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
        enable = true; # for debugging nvim
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

      initExtra = ''
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
        core = {
          editor = "nvim";
          autocrlf = "input";
        };
      };
      aliases = {
        co = "checkout";
      };
      difftastic = {
        enable = true;
        background = "dark";
      };
    };

    exa.enable = true;

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
        # cmd-[ and cmd-] switch tmux windows
        # \x02 is ctrl-b so sequence below is ctrl-b, h
        #"cmd+[" = "send_text all \\x02h";
        #"cmd+]" = "send_text all \\x02l";
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
        #window_padding_width = "5";
        macos_show_window_title_in = "window";

        # Tab bar
        tab_bar_style = "hidden";
        #tab_bar_edge = "bottom";
        #tab_bar_style = "powerline";
        #tab_title_template = "{title}"; # "{index}: {title}";

        enabled_layouts = "Tall";
      };
      extraConfig = ''
        inactive_text_alpha 0.4
        active_border_color #888888
        inactive_border_color #888888
        background #000000
        focus_follows_mouse yes
      '';
    };

    autojump = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$username$hostname$localip$shlvl$directory$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$nix_shell$conda$meson$spack$memory_usage$cmd_duration$line_break$jobs$battery$time$status$os$container$shell$character";
        battery = {
          full_symbol = "🔋";
          charging_symbol = "🔌";
          discharging_symbol = "⚡";
          display = [
            {
              threshold = 30;
              style = "bold red";
            }
          ];
        };

        cmd_duration = {
          min_time = 10000;
          format = " took [$duration]($style)";
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
          style = "";
        };
      };
    };
  };
}
