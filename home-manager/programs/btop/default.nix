{ ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      # use the terminal's background instead of the theme's
      theme_background = false;
    };
  };
}
