local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        ft = { "go" },
      },
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = { "<F1>", "<F2>", "<F3>", "<F4>", "<F9>", "<F10>", "<leader>b", "<leader>gb", "<leader>?", "<leader>du" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "delve",
          "js",
        },
      })

      local dap = require("dap")
      local ui = require("dapui")

      require("dapui").setup({
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.30,
              },
              {
                id = "breakpoints",
                size = 0.20,
              },
              {
                id = "stacks",
                size = 0.30,
              },
              {
                id = "watches",
                size = 0.30,
              },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              {
                id = "console",
                size = 0.25,
              },
              {
                id = "repl",
                size = 0.75,
              },
            },
            position = "bottom",
            size = 10,
          },
        },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
      })
      require("dap-go").setup()

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
            args = {
              "${port}",
            },
          },
        }
      end

      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      for _, language in ipairs(js_filetypes) do
        require("dap").configurations[language] = {
          {
            name = "Launch file",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            args = { "${file}" },
            sourceMaps = true,
            sourceMapPathOverrides = {
              ["./*"] = "${workspaceFolder}/src/*",
            },
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            name = "Attach",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Auto Attach",
            cwd = vim.fn.getcwd(),
            protocol = "inspector",
          },
          {
            name = "Debug Jest Tests",
            type = "pwa-node",
            request = "launch",
            runtimeExecutable = "node",
            runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest", "--runInBand" },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            -- args = {'${file}', '--coverage', 'false'},
            -- sourceMaps = true,
            -- skipFiles = {'<node_internals>/**', 'node_modules/**'},
          },
          {
            name = "Debug Vitest Tests",
            type = "pwa-node",
            request = "launch",
            cwd = vim.fn.getcwd(),
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "run", "${file}" },
            autoAttachChildProcesses = true,
            smartStep = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          -- Debug web applications (client side)
          {
            name = "Launch & Debug Chrome",
            type = "pwa-chrome",
            request = "launch",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },

            -- From https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/dap.lua
            -- To test how it behaves
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            sourceMapPathOverrides = {
              ["./*"] = "${workspaceFolder}/src/*",
            },
          },
        }
      end

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
  },
}
