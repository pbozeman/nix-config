{ ... }:

''
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
''
