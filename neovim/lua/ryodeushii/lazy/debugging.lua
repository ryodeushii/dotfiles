return {
  {
    "mfussenegger/nvim-dap",
    -- lazy = true,
    -- event = { "BufReadPre", "BufNewFile" },
    keys = { "F1", "F2", "F3", "F4", "F9", "F10", "<leader>b", "<leader>gb", "<leader>?", "<leader>du" },
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        ft = { "go" },
      },
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "willamboman/mason.nvim",
    },
    config = function()
      local dap = require('dap')
      local ui = require('dapui')

      require('dapui').setup()
      require("dap-go").setup()

      --[[ NOTE: this is setup for vscode-js-debug to be used
      {
        "microsoft/vscode-js-debug",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
      },
      NOTE [2]: this should be run by node with this path and port passed:args = { vim.fn.stdpath("data") .. "/lazy/vscode-js-debug" .. "/out/src/vsDebugServer.js", "${port}" } ]]

      require("nvim-dap-virtual-text").setup()

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "[debug] Toggle debug breakpoint" })
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, { desc = "[debug] Run to cursor" })

      vim.keymap.set("n", "<leader>?", function()
        ui.eval(nil, { enter = true })
      end, { desc = "[debug] Evaluate expression" })
      vim.keymap.set("n", "<F1>", dap.continue, { desc = "[debug] Continue" })
      vim.keymap.set("n", "<F2>", dap.step_over, { desc = "[debug] Step over" })
      vim.keymap.set("n", "<F3>", dap.step_into, { desc = "[debug] Step into" })
      vim.keymap.set("n", "<F4>", dap.step_out, { desc = "[debug] Step out" })
      vim.keymap.set("n", "<F9>", dap.step_back, { desc = "[debug] Step back" })
      vim.keymap.set("n", "<F10>", dap.restart, { desc = "[debug] Restart" })

      vim.keymap.set("n", "<leader>du", ui.toggle, { desc = "[debug] Toggle debug UI" })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,

  }
}
