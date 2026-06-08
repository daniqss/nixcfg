-- compositor commands
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(emulator))
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + Q", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + O", hl.dsp.window.pseudo())
hl.bind(mod .. " + I", hl.dsp.layout("togglesplit"))

-- move focus
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

-- special workspace
hl.bind(mod .. " + A", hl.dsp.workspace.toggle_special())
hl.bind(mod .. " + ALT + A", hl.dsp.window.move({ workspace = "special", silent = true }))

-- cycle workspaces with the mouse wheel
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

-- workspaces 1-9
for i = 1, 9 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + ALT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- default app per workspace
function default_app()
  local apps = {
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

  local currentWorkspace = hl.get_active_workspace()
  local cmd = apps[currentWorkspace.id]
  if cmd then
    hl.exec_cmd(cmd)
  end
end

hl.bind(mod .. " + 0", default_app)

-- window resizing (repeating)
hl.bind(mod .. " + CTRL + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- window swapping (repeating)
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }), { repeating = true })
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }), { repeating = true })
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }), { repeating = true })
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }), { repeating = true })

-- mouse movements
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- vicinae launcher
if vicinae_enabled then
  hl.bind(mod .. " + TAB", hl.dsp.exec_cmd("vicinae 'vicinae://launch/applications?toggle=true'"))
  hl.bind(mod .. " + C", hl.dsp.exec_cmd("vicinae 'vicinae://launch/clipboard/history?toggle=true'"))
  hl.bind(mod .. " + E", hl.dsp.exec_cmd("vicinae 'vicinae://launch/core/search-emojis?toggle=true'"))
  hl.bind(mod .. " + B", hl.dsp.exec_cmd("vicinae 'vicinae://launch/@Gelei/vicinae-extension-bluetooth-0/devices'"))
  hl.bind(
    mod .. " + S",
    hl.dsp.exec_cmd("vicinae 'vicinae://launch/@rastsislaux/vicinae-extension-pulseaudio-0/outputDevices'")
  )
  hl.bind(mod .. " + P", hl.dsp.exec_cmd("vicinae 'vicinae://launch/power'"))
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

-- screenshot (locked)
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"), { locked = true })
hl.bind(mod .. " + M", hl.dsp.exec_cmd("hyprshot -m region"), { locked = true })

-- toggle keyboard layout (swaps which of es/us is active)
hl.bind(mod .. " + SPACE", function()
  if hl.get_config("input.kb_layout"):find("^es") then
    hl.config({ input = { kb_layout = "us,es" } })
  else
    hl.config({ input = { kb_layout = "es,us" } })
  end
end)

-- gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
