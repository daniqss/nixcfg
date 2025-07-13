local wezterm = require("wezterm")
local act = wezterm.action

local M = {}
local keys = {}

local map = function(key, mods, action)
  if type(mods) == "string" then
    table.insert(keys, { key = key, mods = mods, action = action })
  elseif type(mods) == "table" then
    for _, mod in pairs(mods) do
      table.insert(keys, { key = key, mods = mod, action = action })
    end
  end
end

local openUrl = act.QuickSelectArgs({
  label = "open url",
  patterns = { "https?://\\S+" },
  action = wezterm.action_callback(function(window, pane)
    local url = window:get_selection_text_for_pane(pane)
    wezterm.open_with(url)
  end),
})

map("o", { "LEADER", "ALT" }, openUrl)
map("t", "ALT", act.SpawnTab("CurrentPaneDomain"))
map("w", "ALT", act.CloseCurrentTab({ confirm = true }))
for i = 1, 9 do
  map(tostring(i), "ALT", act.ActivateTab(i - 1))
end

M.apply = function(c)
  c.leader = {
    key = " ",
    mods = "ALT",
    timeout_milliseconds = math.maxinteger,
  }
  c.keys = keys
end

return M