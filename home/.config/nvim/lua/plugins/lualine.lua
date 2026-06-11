return {
  "nvim-lualine/lualine.nvim",
  opts = function()
    local icons = LazyVim.config.icons

    local opts = {
      options = {
        disabled_filetypes = {
          statusline = { "snacks_picker_list", "dashboard", "alpha", "ministarter", "snacks_dashboard" },
        },
      },
      sections = {
        lualine_x = {
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          { "lsp_status" },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          { "encoding" },
        },
      },
    }
    return opts
  end,
}
