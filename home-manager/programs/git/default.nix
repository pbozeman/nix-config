{ fullname, email, ... }:

{
  programs.git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = fullname;
    userEmail = email;
    aliases = {
      co = "checkout";
    };
    difftastic = {
      enable = false;
      background = "dark";
    };
    extraConfig = {
      color.ui = true;
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };
}
