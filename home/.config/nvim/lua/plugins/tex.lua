return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "latex" },
        callback = function()
          vim.bo.omnifunc = "vimtex#complete#omnifunc"
        end,
      })
    end,
    init = function()
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_view_method = "zathura"
    end,
  },
  {
    "saghen/blink.compat",
    lazy = true,
    version = "*",
  },

  {
    "micangl/cmp-vimtex",
    ft = { "tex", "bib" },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          tex = { "vimtex", "lsp", "path", "snippets", "buffer" },
        },
        providers = {
          vimtex = {
            name = "vimtex",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
