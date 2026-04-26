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
        br = "!git for-each-ref refs/heads --sort=committerdate --format='%(if)%(HEAD)%(then)*%(else) %(end)|%(refname:short)|%(committerdate:format:%Y-%m-%d %H:%M:%S)' | column -t -s '|'";
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
