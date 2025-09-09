{ inputs
, pkgs
, lib
, user
, fullname
, email
, ...
}:
let
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
in
{
  home = {
    # FIXME: take this out once possible.
    # See: https://github.com/nix-community/home-manager/issues/4483
    enableNixpkgsReleaseCheck = false;

    stateVersion = "23.05";
    username = "${user}";
    homeDirectory =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${user}"
      else "/home/${user}";

    # TODO: make lazyvim-nix show up in packages (with an overlay? )
    packages = with pkgs; let
      additionalPackages = [
        inputs.lazyvim-nix.packages.${system}.nvim
      ];
    in
    (import ./packages.nix { inherit pkgs; }) ++ additionalPackages;

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
      clear = "precmd() {precmd() {echo }} && clear && tmux clear-history";

      # misc shortcuts
      e = "\${EDITOR}";
      c = "clear";
      cm = "clear && make";

      # rebuilds
      darwin-rebuild = "~/src/nix-config/bin/darwin-rebuild";
      home-rebuild = "~/src/nix-config/bin/home-build";

      # This is a hack to quickly disable the lazyvim startup screen
      # TODO: figure out how to do this via the lazyvim config
      nvim = "nvim -";

      # ls
      ls = "ls --color=auto -F";
      l = "ls -lh";
      ll = "ls -lh";
      la = "ls -alh";

      # movement
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # tmux
      tm = "tmux";
      tma = "tmux new-session -A -s";
      tmls = "tmux ls";
      tmd = "tmux new-session -A -s dev";

      # utils
      calc = "kalker";
      df = "duf";

      # clang format
      cf = "git -C \"$(git rev-parse --show-toplevel)\" status --porcelain | awk '{print $2}' | grep -E '\\.(h|cpp)$' | sed \"s|^|$(git rev-parse --show-toplevel)/|\" | xargs -r clang-format -i";

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
      gc = "git commit";
      gca = "git commit --amend";
      gcm = "git commit -m";
      gco = "git checkout";
      gd = "git diff";
      gdc = "git diff --cached";
      gf = "git absorb";
      gfr = "git absorb --and-rebase";
      gl = "git log";
      gs = "git status";
      gr = "git rebase -i --autosquash";
      grs = "git restore --staged";

      lazygit = "lazygit -ucd ~/.config/lazygit";

      # Always enable colored `grep` output
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";

      # terraform
      tff = "tf fmt";
      tfp = "tf plan";
      tfa = "tf apply";
      tfd = "tf plan";

      # k8s
      k = "kubecolor";
      hfa = "hf apply";
      hfd = "hf diff";
      hfaa = "hf apply -f helmfile.d/30-home-automation.yaml";

      # remote copy
      rpbcopy = "ssh $(echo $SSH_CLIENT | cut -f1 -d ' ') 'pbcopy'";
      tpbcopy = "tmux show-buffer | rpbcopy";
      rpb = "rpbcopy";
      tpb = "tpbcopy";

      # run and log
      rl = "run_and_log";
      lr = "less_run_log";

      dnc = "rg -U '#.*DNC.*(\n# .*)*'";
      fixme = "rg -U '#.*FIXME.*(\n# .*)*'";
      todo = "rg -U '#.*TODO.*(\n# .*)*'";
      wut = "rg -U '(#.*TODO|#.*FIXME|#.*DNC).*((\n# ).*)*'";

      # search and replace
      srv = "sr_f v";
      srsv = "sr_f sv";

      gtkwave = "command gtkwave --dark";
    };

    file = {
      ".config/Autoraise/config" = {
        enable = true;
        source = ./Autoraise/config;
      };

      ".config/lazygit/config.yml" = {
        enable = true;
        source = ./lazygit/config.yml;
      };
    };

    activation.linkBinFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      src="${./bin}"
      dest="$HOME/bin"

      mkdir -p "$dest"
      for f in "$src"/*; do
        [ -f "$f" ] || continue
        ln -sf "$f" "$dest/$(basename "$f")"
      done
    '';
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
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

        # gtkwave completion
        function _gtkwave() {
          _arguments -S -s \
            '*:VCD files:_files -g "*(-/)" -g "*.vcd(-.)"'
        }

        compdef _gtkwave gtkwave
      '';

      initContent = ''
        eval "$(direnv hook zsh)"

        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        # the nix-profile/bin should not be necessary, but homeManager isn't
        # addding this to the path when running stand alone
        # (i.e. without nixos or darwin)
        #
        # verible couldn't be found on darwin without adding homebrew explicitly.
        # It has to be installed from there because the nix package doesn't support
        # apple silicon yet.
        export PATH="$HOME/bin:$HOME/.nix-profile/bin:/opt/homebrew/bin:$PATH"

        export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

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
        zstyle ':completion:*:make:*:targets' call-command true
        zstyle ':completion:*:*:make:*' tag-order 'targets'
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

        # refresh the prompt every 1 second
        #   https://www.zsh.org/mla/users/2007/msg00944.html
        # and
        #   https://stackoverflow.com/questions/26526175/zsh-menu-completion-causes-problems-after-zle-reset-prompt
        TMOUT=1
        TRAPALRM() {
          if [[ "$WIDGET" != "expand-or-complete" ]] && \
             [[ ! "$_lastcomp[insert]" =~ "^automenu$|^menu:" ]]; then
            zle reset-prompt
          fi
        }

        run_and_log() {
          local full_command="$*"
          local timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
          local command_name=$(echo "$full_command" | awk '{print $1}' | xargs basename)
          local log_file="/tmp/run-log-$command_name-$timestamp.log"

          echo "Log file: $log_file"

          eval "$full_command" 2>&1 | \
            awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' | \
            tee "$log_file"

          echo "Log file: $log_file"
        }

        less_run_log() {
          local log_file_prefix="/tmp/run-log-"
          local log_file

          if [[ -n "$1" ]]; then
            # If a command is provided, find the most recent log for that command.
            local command_name=$(echo "$1" | xargs basename)
            log_file=$(ls -Art $log_file_prefix$command_name-* 2> /dev/null | tail -n 1)
          else
            # If no command is provided, find the overall most recent log.
            log_file=$(ls -Art $log_file_prefix* 2> /dev/null | tail -n 1)
          fi

          if [[ -n "$log_file" ]]; then
            less -F -N "$log_file"
          else
            echo "No matching run-log files found."
          fi
        }

        # TODO: refactor hf and tf into som common updo function.
        # I tried once, but dealing with aray arguments in bash was too much of a
        # a pita.
        hf() {
          local current_dir=$(pwd)
          while true; do
            if [ -f "helmfile.yaml" ] || [ -d "helmfile.d" ]; then
              helmfile "$@"
              break
            else
              if [ "$(pwd)" = "/" ]; then
                echo "No helmfile.yaml or helmfile.d found in any parent directories."
                break
              else
                cd ..
              fi
            fi
          done
          cd "$current_dir"
        }

        tf() {
          local current_dir=$(pwd)
          while true; do
            if [ -d .terraform ]; then
              scripts/terraform-sops.sh "$@"
              break
            else
              if [ "$(pwd)" = "/" ]; then
                echo "No .terraform found in any parent directories."
                break
              else
                cd ..
              fi
            fi
          done
          cd "$current_dir"
        }

        sr_f() {
          find . -type f -name "*.$1" -exec sed -i "s/$2/$3/g" {} \;
        }

        wip() {
          local message="wip"
          if [ $# -gt 0 ]; then
            message="$message: $*"
          fi
          git add -A && git commit --no-verify -m "$message"
        }
      '';
    };

    git = {
      enable = true;
      ignores = [ "*.swp" ];
      userName = fullname;
      userEmail = email;
      aliases = {
        co = "checkout";
      };
      difftastic = {
        enable = false;
        background = "dark";
      };
      extraConfig = {
        color.ui = true;
        core = {
          editor = "nvim";
          autocrlf = "input";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autoStash = true;
      };
    };

    tmux = {
      enable = true;
      prefix = "C-Space";
      sensibleOnTop = false;
      mouse = true;
      keyMode = "vi";
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
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
        set -g status-right "#[fg=#394b70,bg=#292e42]#[none]#[fg=#ffffff,bg=#394b70] %a %b %d %H:%M %Y #[none]"
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
          symbol = "❄️";
          format = " $symbol($style)";
          #format = "\\[[$symbol$state(\($name\))]($style)\\]";
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

    alacritty = {
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
          ];
        };
        mouse = {
          hide_when_typing = true;
        };
        window = {
          title = "term";
          dynamic_title = true;
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

    zathura = {
      enable = true;
      options = {
        # zoom and scroll step size
        zoom-step = 20;
        scroll-step = 80;

        # copy selection to system clipboard
        selection-clipboard = "clipboard";

        # enable incremental search
        incremental-search = true;
      };
      mappings = {
        "<C-i>" = "zoom in";
        "<C-o>" = "zoom out";
      };
    };

    wezterm = {
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
  };
}
