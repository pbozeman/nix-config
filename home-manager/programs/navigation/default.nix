{ ... }:

{
  programs.autojump = {
    enable = false;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
