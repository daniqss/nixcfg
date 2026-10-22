-- random mouse mover with virtual mouse, toggled with a keybind
local jiggler = {
  timer = nil,
  min_interval = 500,
  max_interval = 3000,
  max_step = 150,
}

math.randomseed(os.time())

local function jiggle()
  local dx = math.random(-jiggler.max_step, jiggler.max_step)
  local dy = math.random(-jiggler.max_step, jiggler.max_step)
  hl.exec_cmd("wlrctl pointer move " .. dx .. " " .. dy)

  if jiggler.timer then
    jiggler.timer:set_timeout(math.random(jiggler.min_interval, jiggler.max_interval))
  end
end

hl.bind(mod .. " + ALT + M", function()
  if jiggler.timer == nil then
    jiggler.timer = hl.timer(jiggle, { timeout = jiggler.min_interval, type = "repeat" })
  else
    jiggler.timer:set_enabled(not jiggler.timer:is_enabled())
  end
end)
