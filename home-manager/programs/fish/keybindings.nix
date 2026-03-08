{ ... }:

''
  # vi mode
  fish_vi_key_bindings

  # edit command line in editor
  bind -M default v edit_command_buffer
  bind -M visual v edit_command_buffer

  # session-local history navigation in insert mode
  bind -M insert \cp __session_history_up
  bind -M insert \cn __session_history_down
  bind -M insert up __session_history_up
  bind -M insert down __session_history_down

  # session-local history navigation in normal (default) mode
  bind -M default k __session_history_up
  bind -M default j __session_history_down
  bind -M default up __session_history_up
  bind -M default down __session_history_down
  bind -M insert \ca beginning-of-line
  bind -M insert \ce end-of-line
  bind -M insert \cw backward-kill-word
  bind -M insert \ck kill-line
  bind -M insert \cu backward-kill-line
  bind -M insert \eb backward-word
  bind -M insert \ef forward-word
''
