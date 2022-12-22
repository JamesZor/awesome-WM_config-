local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local colours = require("theme.colours")
-- Set colors
local active_color = colours.theme.black
local background_color = colours.theme.white 

local timer_bar = wibox.widget {
    max_value = 100,
    value = 50,
    forced_height = 5,
    forced_width = 100,
    shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h, 16) end,
    bar_shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h, 14) end,
    color = active_color,
    background_color = background_color,
    border_width = 2,
    border_color = "#000000",
    color = '#bae1ff',
    widget = wibox.widget.progressbar
}


----awesome.connect_signal("signals::timer", function(time, index )
--    if index % 2 == 0 then
--        timer_bar.color =colours.extra.red
--        timer_bar.value = ( time / 45  ) * 100
--    else
--        timer_bar.color =colours.extra.blue
--        timer_bar.value = ( time / 15  ) * 100
--
--    end
--
return timer_bar
