return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = {
            auto_hide = { "input" },
            layout = {
              width = 25,
            },
          },
          hidden = true,
          ignored = true,
        },
      },
    },
    image = {
      doc = {
        max_width = 40,
        max_height = 30,
        inline = false,
      },
      math = {
        enabled = false,
      },
    },
  },
}
