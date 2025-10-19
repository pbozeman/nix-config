{ ... }:

''
  autoload -Uz compinit
  compinit -i # ignore unsecure dirs

  # gtkwave completion
  function _gtkwave() {
    _arguments -S -s \
      '*:VCD files:_files -g "*(-/)" -g "*.vcd(-.)"'
  }

  compdef _gtkwave gtkwave

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
''
