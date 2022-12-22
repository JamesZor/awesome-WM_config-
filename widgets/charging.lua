local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Set colors
local active_color = {
    color = "#000000"
}

local background_color = "#ffffff"

local charging_box = wibox.widget {
    markup = 'Hello',
    font = 'MADE Outer Sans 20', 
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}
awesome.connect_signal("signals::charging", function(out , state )
    charging_box.markup = "Hello " .. out 
end)

return charging_box  
