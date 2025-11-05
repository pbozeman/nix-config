{ secrets, ... }:

{
  imports = [
    ./aliases.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less";
      LS_COLORS = "no=00:fi=00:di=01;34:ln=35;40:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:";
      LSCOLORS = "ExfxcxdxCxegedabagacad";
      SYSTEMD_COLORS = "true";
      COLORTERM = "truecolor";
      MANPAGER = "less -R --use-color -Dd+r -Du+b +Gg -M -s";
      HOMEBREW_NO_AUTO_UPDATE = 1;
      OPENAI_API_KEY = secrets.openAIKey;
    };

    # homemanager on ubuntu created "insecure"
    # compinit dirs.  Skip global setup and
    # then explicitly run compinit, ignoring "insecure"
    # directories.
    envExtra = ''
      skip_global_compinit=1
    '';

    completionInit = import ./completion.nix { };

    initContent = ''
      ${import ./init.nix { }}
      ${import ./keybindings.nix { }}
      ${import ./functions.nix { }}
    '';
  };
}
