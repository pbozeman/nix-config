{ ... }:

''
  # Refresh the interactive prompt every 1 second by signaling the current fish.
  # Equivalent to zsh: TMOUT=1 + TRAPALRM { zle reset-prompt }
  # This keeps git status and battery updated while idle.

  # Handler: repaint the current commandline/prompt
  function __prompt_repaint --on-signal SIGUSR1
    # Avoid repainting while pager/selection UIs are active
    commandline --paging-mode; and return
    commandline --search-mode; and return

    commandline -f repaint 2>/dev/null
  end

  # Start background ticker on first prompt (deferred to avoid blocking init)
  function __prompt_refresh_start --on-event fish_prompt
    if not set -q __prompt_refresh_pid
      sh -c "while true; do sleep 1; kill -USR1 $fish_pid 2>/dev/null || exit; done" &
      set -g __prompt_refresh_pid $last_pid
      disown $__prompt_refresh_pid 2>/dev/null
    end
    functions -e __prompt_refresh_start
  end
''
