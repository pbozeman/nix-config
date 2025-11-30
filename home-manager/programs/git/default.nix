{ fullname, email, ... }:

{
  programs.difftastic = {
    enable = false;
    options.background = "dark";
  };

  programs.git = {
    enable = true;
    ignores = [ "*.swp" ];
    settings = {
      user = {
        name = fullname;
        email = email;
      };
      alias = {
        co = "checkout";
      };
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
