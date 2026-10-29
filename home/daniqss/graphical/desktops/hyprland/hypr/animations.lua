hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
  -- TODO: with disabled animations the touchpad gesture animation dont get the style
  -- must be solve uptream
hl.animation({ leaf = "workspaces", enabled = false, speed = 6, bezier = "overshot", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 6, bezier = "overshot", style = "slidevert" })
