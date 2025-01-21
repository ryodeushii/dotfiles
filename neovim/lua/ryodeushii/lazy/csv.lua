return {
  {
    'hat0uma/csvview.nvim',
    ft = 'csv',
    cmd = {"CsvViewEnable", "CsvViewDisable", "CsvViewToggle"},
    config = function()
      require('csvview').setup({
        view = { display_mode = 'border' },
      })
    end
  }
}
