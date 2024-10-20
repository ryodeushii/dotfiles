local M = {}

local global_snippets = {
  { trigger = "shebang", body = "#!/bin/bash\n" }
}

local typescript = {
  { trigger = "fun",       body = "function ${1:name}(${2:args}): ${3:void} { ${0} }" },
  { trigger = "funa",      body = "const ${1:name} = (${2:args}): ${3:void} => { ${0} }" },
  { trigger = "funp",      body = "const ${1:name} = (${2:args}): ${3:void} => ${0}" },
  { trigger = "funr",      body = "const ${1:name} = (${2:args}): ${3:void} => ${0}" },
  { trigger = "describe",  body = "describe(\"${1:description}\", () => {\n\t${0}\n})" },
  { trigger = "describea", body = "describe(\"${1:description}\", async () => {\n\t${0}\n})" },
  { trigger = "let",       body = "let ${1:name}:${2:type} = ${3};" },
  { trigger = "const",     body = "const ${1:name}:${2:type} = ${3};" },
  { trigger = "field",     body = "${1:name}:${2:type};" },
  { trigger = "class",     body = "class ${1:name} {\n${0}\n}" },
}

local snippets_by_filetype = {
  lua = {
    { trigger = "fun", body = "function ${1:name}(${2:args}) ${0}\nend" },
  },
  typescript = typescript,
  javascript = typescript,
}

snippets_by_filetype.typescriptreact = snippets_by_filetype.typescript
snippets_by_filetype.javascript = snippets_by_filetype.typescript


local function get_buf_snips()
  local ft = vim.bo.filetype
  local snips = vim.list_slice(global_snippets)


  if ft and snippets_by_filetype[ft] then
    vim.list_extend(snips, snippets_by_filetype[ft])
  end

  return snips
end


-- cmp source for snippets to show up in completion menu
function M.register_cmp_source()
  local cmp_source = {}
  local cache = {}
  function cmp_source.complete(_, _, callback)
    local bufnr = vim.api.nvim_get_current_buf()

    if not cache[bufnr] then
      local completion_items = vim.tbl_map(function(s)
        ---@type lsp.CompletionItem
        local item = {
          word = s.trigger,
          label = s.trigger,
          kind = vim.lsp.protocol.CompletionItemKind.Snippet,
          insertText = s.body,
          insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
        }
        return item
      end, get_buf_snips())

      cache[bufnr] = completion_items
    end

    callback(cache[bufnr])
  end

  require('cmp').register_source('snp', cmp_source)
end

-- setup keybinds for snippets jumping
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.snippet and vim.snippet.jumpable and vim.snippet.jumpable(1) then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  else
    return '<Tab>'
  end
end, { expr = true })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if vim.snippet and vim.snippet.jumpable and vim.snippet.jumpable(-1) then
    return '<cmd>lua vim.snippet.jump(-1)<cr>'
  else
    return '<S-Tab>'
  end
end, { expr = true })

return M
