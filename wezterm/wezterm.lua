-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').main

local config = wezterm.config_builder()

config.colors = theme.colors()
config.window_frame = theme.window_frame() -- needed only if using fancy tab bar


-- This is where you actually apply your config choices

-- if it's windows - use wsl, otherwise use the default shell
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = {'wsl.exe'}
else
  config.default_prog = {'$SHELL'}
end




config.keys = {
  -- paste from the clipboard
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
}

config.font = wezterm.font('MonaspiceAr NFM')

-- and finally, return the configuration to wezterm
return config
