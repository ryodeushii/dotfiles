-- file: colors/my-colorscheme-name.lua

-- local colorbuddy = require('colorbuddy')
--
-- -- Set up your custom colorscheme if you want
-- colorbuddy.colorscheme("ryodeushii")

-- And then modify as you like
-- local Color = colorbuddy.Color
-- local colors = colorbuddy.colors
-- local Group = colorbuddy.Group
-- local groups = colorbuddy.groups
-- local styles = colorbuddy.styles
--
-- -- Use Color.new(<name>, <#rrggbb>) to create new colors
-- -- They can be accessed through colors.<name>
-- Color.new('background',  '#222222')
-- Color.new('red',         '#cc6666')
-- -- Color.new('green',       '#99cc99')
-- Color.new('green',       '#43fa86')
-- -- Color.new('yellow',      '#f0c674')
-- Color.new('yellow',      '#fcdc65')
--
require("colorbuddy").colorscheme('ryodeushii')

local colorbuddy = require('colorbuddy')
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups
local s = colorbuddy.styles

Color.new('white', '#f2e5bc')
Color.new('red', '#cc6666')
Color.new('pink', '#fcdc65')
Color.new('green', '#99cc99')
Color.new('yellow', '#f8fe7a')
Color.new('blue', '#81a2be')
Color.new('aqua', '#8ec07c')
Color.new('cyan', '#8abeb7')
Color.new('purple', '#8e6fbd')
Color.new('violet', '#b294bb')
Color.new('orange', '#de935f')
Color.new('brown', '#a3685a')

Color.new('seagreen', '#99cc99')
Color.new('turquoise', '#43fa86')

local background_string = "#111111"
Color.new("background", background_string)
Color.new("gray0", background_string)

Group.new("Normal", c.superwhite, c.gray0)

Group.new("@constant", c.orange, nil, s.none)
Group.new("@function", c.yellow, nil, s.none)
Group.new("@function.bracket", g.Normal, g.Normal)
Group.new("@keyword", c.violet, nil, s.none)
Group.new("@keyword.faded", g.nontext.fg:light(), nil, s.none)
Group.new("@property", c.blue)
Group.new("@variable", c.superwhite, nil)
Group.new("@variable.builtin", c.purple:light():light(), g.Normal)

-- I've always liked lua function calls to be blue. I don't know why.

Group.new("@function.call.lua", c.blue:dark(), nil, nil)