return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-surround").setup({})
    -- S in visual mode
    -- ys<motion><surround> to add surround
    -- cs<old><new> to change surround for nearest <old> to <new>
    -- csq<char> change nearest quotes pair to <char>
    -- csqb change nearest quotes pair to brackets
  end,
}
