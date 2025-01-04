local neotest = require("neotest")
neotest.setup({
  adapters = {
    require("neotest-rust") {
      args = { "--no-capture" },
      dap_adapter = "lldb"
    },
  }
})
