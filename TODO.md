# TODO

- Fix mutable updates in dev machine:

  - Add support for astro in nvim treesitter as I manually installed it
    via :TSInstall astro.
    Also see: https://github.com/virchau13/tree-sitter-astro/issues/16
  - Package prettier-plugin-astro. Installed it directly with npm.

- Fix brittle code

  - the sudo pam code is pretty dangerous. Fix it.

- Linters

  - validate eslint

- tmux
  - the tokyonight plugin doesn't easily allow you to set the contents of
    the status bar. Fix it and undo the tmux_start and alias hack.
