{ ... }:

''
  # Session-local history for up-arrow navigation
  # Global history (ctrl-r/fzf) is unaffected

  set -g __session_history
  set -g __session_history_idx 0
  set -g __session_history_saved ""
  set -g __session_history_prefix ""

  function __session_history_record --on-event fish_preexec
    set -l cmd $argv[1]
    # skip consecutive duplicates
    if test (count $__session_history) -eq 0; or test "$__session_history[-1]" != "$cmd"
      set -a __session_history $cmd
    end
    # reset navigation state
    set -g __session_history_idx 0
  end

  function __session_history_up
    set -l count (count $__session_history)
    if test $count -eq 0
      return
    end

    # on first press, capture prefix and save current commandline
    if test $__session_history_idx -eq 0
      set -g __session_history_prefix (commandline)
      set -g __session_history_saved (commandline)
    end

    # search backwards for prefix match
    set -l i $__session_history_idx
    while true
      set i (math $i + 1)
      if test $i -gt $count
        return
      end
      set -l entry $__session_history[(math $count - $i + 1)]
      if test -z "$__session_history_prefix"; or string match -q -- "$__session_history_prefix*" "$entry"
        set -g __session_history_idx $i
        commandline -r -- $entry
        commandline -f end-of-line
        return
      end
    end
  end

  function __session_history_down
    # not navigating, nothing to do
    if test $__session_history_idx -eq 0
      return
    end

    set -l count (count $__session_history)

    # search forwards for prefix match
    set -l i $__session_history_idx
    while true
      set i (math $i - 1)
      if test $i -le 0
        # past the end, restore saved commandline
        set -g __session_history_idx 0
        commandline -r -- $__session_history_saved
        commandline -f end-of-line
        return
      end
      set -l entry $__session_history[(math $count - $i + 1)]
      if test -z "$__session_history_prefix"; or string match -q -- "$__session_history_prefix*" "$entry"
        set -g __session_history_idx $i
        commandline -r -- $entry
        commandline -f end-of-line
        return
      end
    end
  end
''
