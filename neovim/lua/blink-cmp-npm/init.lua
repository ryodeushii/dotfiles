local Job = require("plenary.job")

--- @module 'blink.cmp'
--- @class blink.cmp.Source
--- @field npm_opts BlinkCmpNpmSourceOpts
local source = {}

--- @class BlinkCmpNpmSourceOpts
--- @field version_filter string|nil
local default_opts = {
  version_filter = nil, -- "latest" or nil,
}

--- @param opts BlinkCmpNpmSourceOpts
source.new = function(opts)
  local self = setmetatable({}, { __index = source })
  self.npm_opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  return self
end

source.get_trigger_characters = function()
  return { '"' }
end

source.enabled = function()
  return vim.fn.executable("npm") == 1 and vim.bo.filetype == "json" and vim.fn.expand("%:t") == "package.json"
end

local function fetch_versions(package_name, version_filter, callback)
  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    command = "npm",
    args = { "view", package_name, "versions", "--json" },
    on_exit = function(j, return_val)
      if return_val == 0 then
        local result = table.concat(j:result(), "\n")
        vim.schedule(function()
          local versions = vim.fn.json_decode(result)
          if version_filter == "latest" then
            callback({ versions[#versions] })
          else
            callback(versions)
          end
        end)
      else
        callback({})
      end
    end,
  }):start()
end

--- Find the nearest double quote to the left of a given position
-- @param str The string to search
-- @param pos The position to start searching from (1-based)
-- @return Index of the found double quote or nil if not found
local function find_left_quote(str, pos)
  for i = pos, 1, -1 do
    if str:sub(i, i) == '"' then
      return i
    end
  end
  return nil -- Not found
end

function source:get_completions(ctx, callback)
  -- row format is "package_name": "version" or "package_name":"version"
  local package_name = ctx.line:match('"([^"]+)":')
  if package_name == nil then
    callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
  else
    local end_col = ctx.line:find('"', ctx.bounds.start_col)
    local text = ctx.line:sub(ctx.bounds.start_col - 1, (end_col or ctx.cursor[1]) - 1)
    -- if cursor is in package_name quotes - ignore
    if text == package_name then
      callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
    else
      print("bounds: ", vim.inspect(ctx.bounds))
      fetch_versions(package_name, self.npm_opts.version_filter, function(versions)
        --- @type lsp.CompletionItem[]
        local items = {}
        for _, version in ipairs(versions) do
          table.insert(items, {
            label = version,
            kind = require("blink.cmp.types").CompletionItemKind.Property,
            data = package_name,
            textEdit = {
              newText = version,
              range = { -- replace text in version quotes
                -- start = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col - 1 },
                -- replace everything in 2nd pair of quotes
                start = {
                  line = ctx.bounds.line_number - 1,
                  -- character = ctx.bounds.start_col - 1, -- works if version string is like "11.22.63", but does not work if "^11.22.63" or "~11.22.63"
                  character = find_left_quote(ctx.line, ctx.bounds.start_col - 1),
                },
                ["end"] = {
                  line = ctx.bounds.line_number - 1,
                  character = (ctx.line:find('"', ctx.bounds.start_col) or #ctx.line) - 1,
                },
              },
            },
            insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
          })
        end
        callback({
          items = items,
          is_incomplete_backward = false,
          is_incomplete_forward = true,
        })
      end)
    end
  end

  -- (Optional) Return a function which cancels the request
  -- If you have long running requests, it's essential you support cancellation
  return function() end
end

--[[ local function get_package_desc(package_name, package_version, callback)
  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    command = "npm",
    args = { "view", package_name .. "@" .. package_version, "description" },
    on_exit = function(j, return_val)
      if return_val == 0 then
        local result = table.concat(j:result(), "\n")
        vim.schedule(function()
          callback(result)
        end)
      else
        callback("")
      end
    end,
  }):start()
end ]]

-- called to "show docs" before insert
function source:resolve(item, callback)
  -- item = vim.deepcopy(item)
  --
  -- -- Shown in the documentation window (<C-space> when menu open by default)
  item.documentation = {
    kind = "plaintext",
    ---@diagnostic disable-next-line: assign-type-mismatch
    value = item.data,
  }
  --
  -- -- Additional edits to make to the document, such as for auto-imports
  -- item.additionalTextEdits = {
  --   {
  --     newText = "foo",
  --     range = {
  --       start = { line = 0, character = 0 },
  --       ["end"] = { line = 0, character = 0 },
  --     },
  --   },
  -- }

  callback(item)
end

function source:execute(ctx, item, callback, default_implementation)
  -- By default, your source must handle the execution of the item itself,
  -- but you may use the default implementation at any time
  default_implementation()

  -- The callback _MUST_ be called once
  callback()
end
return source
