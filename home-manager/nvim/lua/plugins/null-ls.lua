return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      -- need to import first
      --
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      local formatting = null_ls.builtins.formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      local diagnostics = null_ls.builtins.diagnostics
      local codeactions = null_ls.builtins.code_actions
      null_ls.setup({
        sources = {
          formatting.alejandra,
          formatting.clang_format,
          formatting.eslint,
          formatting.lua_format,
        },
        diagnostics.statix,
        diagnostics.mypy,
        diagnostics.ruff,
        formatting.black,
      })
    end,
  },
}
