local awful = require("awful")

--- Global mouse bindings
awful.mouse.append_global_mousebindings({
  awful.button(nil, 4, awful.tag.viewprev),
  awful.button(nil, 5, awful.tag.viewnext),
})
