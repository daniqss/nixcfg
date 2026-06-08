local small = "(monitor_w*0.4) (monitor_h*0.5)"
local big = "(monitor_w*0.75) (monitor_h*0.85)"

local function floatCentered(match, size)
  hl.window_rule({ match = match, float = true, center = true, size = size })
end

local function centeredBig(class)
  hl.window_rule({ match = { class = class }, center = true, size = big })
end

-- decoration tweaks
hl.window_rule({ match = { class = "^(com.mitchellh.ghostty)$" }, no_blur = true })
hl.window_rule({ match = { focus = 0 }, no_shadow = true })
hl.window_rule({ match = { float = true }, rounding = 12 })

-- floating + centered dialogs
floatCentered({ class = "^(pavucontrol)$" }, small)
floatCentered({ title = "^(Enter name of file to save to…)$" }, small)
floatCentered({ class = "^(blueman-manager)$" }, small)
floatCentered({ class = "^(nm-applet)$" }, small)
floatCentered({ class = "^(nm-connection-editor)$" }, small)
floatCentered({ class = "^(blueman)$" }, small)
floatCentered({ class = "^(kitty)$" }, "(monitor_w*0.5) (monitor_h*0.6)")
floatCentered({ title = "^(Lista de amigos)$" }, "(monitor_w*0.4) (monitor_h*0.55)")

-- centered, not floating
centeredBig("^(discord)$")
centeredBig("^(Spotify)$")

-- don't let windows force maximize
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- allow tearing and fullscreen for games
local games = {
  "^(Stardew Valley)$",
  "^(steam_app_367520)$",
  "^(Hollow Knight Silksong)$",
  "^(Minecraft [0-9]+(\\.[0-9]+)*$)",
  "^(cs2)$",
  "^(steam_app_22380)$",
  "^(steam_app_1145360)$",
  "^(steam_app_3241660)$",
  "^(steam_app_553420)$",
}
for _, class in ipairs(games) do
  hl.window_rule({ match = { class = class }, immediate = true, fullscreen = true })
end
