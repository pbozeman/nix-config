{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      # zoom and scroll step size
      zoom-step = 20;
      scroll-step = 80;

      # copy selection to system clipboard
      selection-clipboard = "clipboard";

      # enable incremental search
      incremental-search = true;
    };
    mappings = {
      "<C-i>" = "zoom in";
      "<C-o>" = "zoom out";
    };
  };
}
