local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require('beautiful.xresources').apply_dpi

-- Set colors
local active_color = {
    color = "#000000"
}
local background_color = "#ffffff"

-- create leading textbox, use markup
local text = wibox.widget {
        markup = '',
        align = 'center',
        valign = 'center',
        font = "MADE Outer Sans 20",
        widget = wibox.widget.textbox
    }
    text.forced_height = dpi(24)
    text.forced_width = dpi(50)
    text.resize = true
-- create the bar
local bat_bar = wibox.widget {
    max_value = 100,
    value = nil ,
    forced_height = 30,
    forced_width = 350,
    -- 16
    shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h, 16) end,
    bar_shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h, 14) end,
    color = active_color,
    background_color = background_color,
    border_width = 2,
    border_color = "#000000",
    widget = wibox.widget.progressbar
}
    bat_bar.forced_height = dpi(25)
    bat_bar.forced_width  = dpi(270)
    bat_bar.resize =true
    bat_bar.border_color = '#000000'
-- connect battery level and colour
awesome.connect_signal("signals::battery", function(percentage, battery_colour)
    bat_bar.value = percentage 
    bat_bar.color = battery_colour
end)
-- connect battery state / symbol
awesome.connect_signal("signals::charging", function( out, state)
    text.markup = out
end)

local w = wibox.widget {
        nil,
        { text ,bat_bar , spacing = dpi(2), layout = wibox.layout.fixed.horizontal},
        expand = "none",
        layout = wibox.layout.align.horizontal
    }



return w 
