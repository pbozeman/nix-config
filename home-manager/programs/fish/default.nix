{ secrets, pkgs, ... }:

{
  imports = [
    ./aliases.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;

    shellInit = ''
      set -gx LANG en_US.UTF-8
      set -gx LC_ALL en_US.UTF-8

      # the nix-profile/bin should not be necessary, but homeManager isn't
      # adding this to the path when running stand alone
      # (i.e. without nixos or darwin)
      #
      # verible couldn't be found on darwin without adding homebrew explicitly.
      # It has to be installed from there because the nix package doesn't support
      # apple silicon yet.
      fish_add_path -g $HOME/bin $HOME/.nix-profile/bin /opt/homebrew/bin

      set -gx SOPS_AGE_KEY_FILE ~/.config/sops/age/keys.txt
    '';

    interactiveShellInit = ''
      ${import ./keybindings.nix { }}
      ${import ./functions.nix { }}

      # disable greeting
      set -g fish_greeting
    '';

    shellAbbrs = {
      # editor
      e = "$EDITOR";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
    LS_COLORS = "no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
    LSCOLORS = "ExfxcxdxCxegedabagacad";
    SYSTEMD_COLORS = "true";
    COLORTERM = "truecolor";
    MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
    HOMEBREW_NO_AUTO_UPDATE = "1";
    OPENAI_API_KEY = secrets.openAIKey;
  };
}
