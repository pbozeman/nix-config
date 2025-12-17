{ ... }:

''
  # vi mode
  fish_vi_key_bindings

  # edit command line in editor
  bind -M default v edit_command_buffer
  bind -M visual v edit_command_buffer

  # emacs-style bindings in insert mode
  bind -M insert \cp up-or-search
  bind -M insert \cn down-or-search
  bind -M insert \ca beginning-of-line
  bind -M insert \ce end-of-line
  bind -M insert \cw backward-kill-word
  bind -M insert \ck kill-line
  bind -M insert \cu backward-kill-line
  bind -M insert \cr history-search-backward
  bind -M insert \eb backward-word
  bind -M insert \ef forward-word
''
