return {
  {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        local dap = require("dap")

        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
            args = { "--port", "${port}" },
          },
        }

        dap.configurations.cpp = {
          {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
          },
        }

        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
      end,
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "debugpy", "codelldb" },
    },
  },
}
