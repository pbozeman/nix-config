return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "MunifTanjim/prettier.nvim" },
    opts = {
      servers = { astro = {} },
    }
  },
}
