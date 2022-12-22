-- Provides
-- Signal::battery

local awful = require("awful")
local update_interval = 2
local colour = {}
colour.red      = '#ffb3ba'
colour.yellow   = '#ffffba'

local battery_script = [[
sh -c "
    upower -d | grep -m1 'percentage:' | awk '{print $2}' 
    "
    ]]

-- Periodically get battery information
awful.widget.watch( battery_script , update_interval, function( widget , stdout)
    local percentage = tonumber(stdout:match('%d+'))
    local battery_colour    = colour.yellow 

    if percentage <= 35 then
        battery_colour = colour.red
    elseif percentage > 35 then
        battery_colour = colour.yellow
    end
    awesome.emit_signal("signals::battery", percentage, battery_colour)
end)
