-- This LUA code is a custom configuration for WezTerm (written in Rust),
--   and specificaly customized on the Apple ARM64 M3, MacOSX, Sonoma 14.5.
--   Also, tested and usable with Linux (RHEL9), with significant differences.
--
-- Other information:
-- -> on OSX, use the hotkey Ctrl-Shift-P for the Command Palette (like VS Code)
-- -> Check GPU(s): debug overlay (ctrl-shift-L), >> wezterm.gui.enumerate_gpus()
--
---------------------------------------- OpenSource Licensing, GPLv3, 2024 -----
------------------- Kindly requesting attribution upon public distribution -----
------------------------------------------ matt.a.feenstra@gmail.com -----------
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
--------------------------------------------------------------------------------
config.adjust_window_size_when_changing_font_size = false
config.enable_scroll_bar = true
config.scrollback_lines = 100000
config.initial_cols = 120
config.initial_rows = 32
config.font_size = 14.0

-- I really enjoy working with this newly designed Intel One Mono font.
--   www.intel.com/content/www/us/en/company-overview/one-monospace-font.html
-- Window Area --
config.font = wezterm.font(
  "Intel One Mono",
  { weight = "Regular",
    stretch = "Normal",
    style="Normal" } )

-- The Adobe Source Code Pro (mono spaced) is my second favorite.
--   https://fonts.adobe.com/fonts/source-code-pro
-- config.font = wezterm.font(
--   "Source Code Pro",
--   { weight = "DemiBold",
--     stretch = "Normal",
--     style="Normal" } )

-- Tabs and Top Bar Area --
config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#6200ff',
  inactive_titlebar_bg = '#4a3b63' }

config.bold_brightens_ansi_colors = true
config.audible_bell = 'Disabled'
config.harfbuzz_features = { 'zero', 'calt=0', 'clig=0', 'liga=0' }
config.window_padding = {
  left = 12, right = 15, top = 12, bottom = 12 }
config.window_background_opacity = 0.88
config.text_background_opacity = 0.6
config.use_fancy_tab_bar = true
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS|MACOS_FORCE_ENABLE_SHADOW"
config.macos_window_background_blur = 30
config.inactive_pane_hsb = { saturation = 0.85, brightness = 0.55 }

-- more window edge to grab (for re-sizing the window)
config.window_padding = {
  left = 12, right = 15, top = 12, bottom = 12 }

-- blink may be resource intensive for older machines
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 450
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150, }

-- Color Scheme --
--   purple and navyblue/turquoise/cyan, a few eye-popping higlights, "vaporwave"
config.colors = {
  foreground = '#ebd2e3',
  background = '#0a032f',
  visual_bell = '#732050',
  cursor_bg = '#ff3900',
  cursor_fg = '#00ff4a',
  cursor_border = '#ff00f6',
  scrollbar_thumb = '#a400ff',
  scrollbar_thumb = '#ff2f53',
  split = '#00ff79',
  -- updates for these active/inactive color changes a bit slow --
  tab_bar = {
    -- see the above "config.window_frame" for more options --
    background = '#ffb300',
    inactive_tab_edge = '#0040ff',
    active_tab = {
      fg_color = '#ffb300',
      bg_color = '#003490' },
    inactive_tab = {
      bg_color = '#3c6f96',
      fg_color = '#0b216b', },
    inactive_tab_hover = {
      bg_color = '#50627e',
      fg_color = '#0b216b',
      italic = true } } }

-- MacBook Pro / Apple aluminum, keyboard hotkeys --
--   - adds CMD-arrow (Apple) character/word-break string navigation
--   - use SHIFT + Left/Right Arrow for Tab navigation
--   - uses OPT + arrow keys to move around window panes
--   - use CMD + s/d for creating a new Pane, (s)ide or (d)own
--   - CMD + w to close current pane
config.keys = {
  { key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true }
  },
  { key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action { SendString = "\x1bOH" } 
  },
  { key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action { SendString = "\x1bOF" }
  },
  { key = 'LeftArrow',
    mods = 'SHIFT',
    action = wezterm.action.ActivateTabRelative(-1)
  },
  { key = 'RightArrow',
    mods = 'SHIFT',
    action = wezterm.action.ActivateTabRelative(1)
  },
  { key = 's',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  { key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  { key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  { key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  { key = 'UpArrow',
    mods = 'OPT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  { key = 'DownArrow',
    mods = 'OPT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  }
}
----- behold, a cute 'lil clock ------------------------------------------------
-- if many tabs are open in the same terminal window, they will cover it up ----
wezterm.on('update-right-status', function(window, pane)
  local isodate = wezterm.strftime '%Y - %m - %d'
  local wday = wezterm.strftime '%A'
  local mytime = wezterm.strftime '%r'
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#44316e' } },
    { Text = '  ' .. isodate .. '  ' .. wezterm.nerdfonts.oct_clock_fill .. 
             '  ' .. wday .. '  ' .. wezterm.nerdfonts.oct_clock_fill ..
             '  ' .. mytime .. '    ' },
  } )
  end )
-- That's all, folks!  Many thanks to Mr. Wez for creating WezTerm! ------------
return config
