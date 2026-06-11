return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = 10,
      open_mapping = [[<C-\>]],
      persist_size = true,
      direction = "float",
      shell = vim.o.shell,
      highlights = {
        FloatBorder = {
          link = "FloatBorder",
        },
      },
      float_opts = {
        border = "curved",
        width = 80,
        height = 20,
      },
    },
  },
}
