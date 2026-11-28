-- compositor commands
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(emulator))
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + Q", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + O", hl.dsp.window.pseudo())
hl.bind(mod .. " + I", hl.dsp.layout("togglesplit"))

-- directional binds
local directions = {
  { key = "H", dir = "l", x = -30, y = 0 },
  { key = "J", dir = "d", x = 0, y = 30 },
  { key = "K", dir = "u", x = 0, y = -30 },
  { key = "L", dir = "r", x = 30, y = 0 },
}
for _, d in ipairs(directions) do
  hl.bind(mod .. " + " .. d.key, hl.dsp.focus({ direction = d.dir }))
  hl.bind(mod .. " + SHIFT + " .. d.key, hl.dsp.window.swap({ direction = d.dir }), { repeating = true })
  hl.bind(
    mod .. " + CTRL + " .. d.key,
    hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }),
    { repeating = true }
  )
end

-- rotate focus between monitors
hl.bind(mod .. " + period", hl.dsp.focus({ monitor = "+1" }))

-- workspaces focus and move
local function workspace_binds(key, focus, workspace)
  hl.bind(mod .. " + " .. key, focus)
  hl.bind(mod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
end
for i = 1, 9 do
  workspace_binds(i, hl.dsp.focus({ workspace = i, on_current_monitor = workspaces_on_current_monitor }), i)
end
workspace_binds("A", hl.dsp.workspace.toggle_special(), "special")

-- default app per workspace
function default_app(workspace)
  local personal_apps = {
    [1] = "code",
    [2] = "chromium",
    [3] = emulator,
    [4] = "obsidian",
    [5] = "nautilus",
    [6] = "discord",
    [7] = "steam",
    [8] = "spotify",
    [9] = "google-chrome-stable",
  }

  local work_apps = {
    [1] = "code",
    [2] = "firefox",
    [3] = emulator,
    [4] = "chromium",
    [5] = "nautilus",
    [6] = "slack",
    [7] = "calculator",
    [8] = "spotify",
    [9] = "google-chrome",
  }

  local apps = work_enabled and work_apps or personal_apps

  workspace = workspace or hl.get_active_workspace().id
  local cmd = apps[workspace]

  if cmd then
    return hl.dsp.exec_cmd(cmd, { workspace = (tostring(workspace) .. " silent") })
  end
end

hl.bind(mod .. " + 0", function()
  local d = default_app()
  if d then
    hl.dispatch(d)
  end
end)

-- mouse movements
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- cycle workspaces with the mouse wheel
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

-- gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- mandra menus accessed through global shortcuts
-- using ipc add latency related to creating the qs ipc processes
if quickshell_enabled then
  local menu_binds = {
    { "TAB", "launcher" },
    { "C", "clipboard" },
    { "E", "emoji" },
    { "S", "sound" },
    { "B", "bluetooth" },
    { "P", "power" },
  }
  for _, b in ipairs(menu_binds) do
    hl.bind(mod .. " + " .. b[1], hl.dsp.global("quickshell:menu-toggle-" .. b[2]))
  end

  hl.bind(mod .. " + Z", hl.dsp.global("quickshell:bar-toggle"))
end

-- volume (locked + repeating)
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(mod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("playerctl previous"), { locked = true, repeating = true })
hl.bind(mod .. " + XF86AudioMute", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, repeating = true })
hl.bind(mod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("playerctl next"), { locked = true, repeating = true })

-- media & brightness (locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })

local screenshot = 'flock -n -o "$XDG_RUNTIME_DIR/hyprshot.lock" hyprshot -m region'
hl.bind("Print", hl.dsp.exec_cmd(screenshot), { locked = true })
hl.bind(mod .. " + M", hl.dsp.exec_cmd(screenshot), { locked = true })

-- toggle keyboard layout (swaps which of es/us is active)
hl.bind(mod .. " + SPACE", function()
  -- kb_variant is positional, so it has to be swapped along with kb_layout
  if hl.get_config("input.kb_layout"):find("^es") then
    hl.config({ input = { kb_layout = "us,es", kb_variant = "altgr-intl," } })
  else
    hl.config({ input = { kb_layout = "es,us", kb_variant = ",altgr-intl" } })
  end
end)
