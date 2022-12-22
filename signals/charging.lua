-- Provides
-- Signal::charging

local awful = require("awful")
local update_interval = 1

local charge_script  = [[
sh -c "
    upower -d | grep -m1 'state:' | awk '{print $2}' 
    "
    ]]

-- Periodically get battery information
awful.widget.watch( charge_script , update_interval, function( widget , stdout)
    local state =  stdout:match('%a+')
    local out = 'null'
    if state == 'discharging' then
        out = ''
    elseif state == 'charging' then
        out = ''
    elseif state == 'fully' then
        out = ''
    end

    awesome.emit_signal("signals::charging", out, state)
end)
