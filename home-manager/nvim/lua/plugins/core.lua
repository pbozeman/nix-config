return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { fg = "#f8c8dc", italic = true },
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = { draw = { animation = require("mini.indentscope").gen_animation.none() } },
  },
}
