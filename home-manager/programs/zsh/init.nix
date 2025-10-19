{ ... }:

''
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
''
