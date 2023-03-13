-- Provides
-- Signal::wifi
--

local awful = require("awful")
local colours = require("theme.colours")
local update_interval = 5
local wifi_script = [[
sh -c " 
    ~/.config/awesome/bash/./wifi_bash.sh 
"
    ]]
local function lines(str)
    local result ={}
    for line in str:gmatch('[^\n]+') do
        table.insert(result, line)
    end
    return result
end

-- Periodically get network information

awful.widget.watch( wifi_script , update_interval, function( widget , stdout )
    local data = lines(stdout)
    local state = { a="", c="" } 
    local connection = { a="", c="" } 
    local wifi =  {a="", c=""} 
    local act_con = { a= data[4], c=colours.theme.black } 
-- Logic statements
--  State [ connected , disconnected ]
    if ( data[1]:match('disconnected') == 'disconnected')then 
        state.a =  ""
        state.c = colours.button.closeB
    else
        state.a = ""
        state.c = colours.button.maxB
    end
-- Connectivity [  ]
    if ( data[2]:match('full') == "full" ) then
        connection.a = ""
        connection.c = colours.button.maxB
    elseif( data[2]:match('portal') == 'portal' ) or (data[2]:match('limited') == 'limited' ) then 
        connection.a = ""
        connection.c = colours.button.floatB
    else
        connection.a = ""
        connection.c = colours.button.closeD
        
    end

    if ( data[3]:match('disabled') == 'disabled' ) then
        wifi.a = data[3]
        wifi.c = colours.button.closeD
    else
        wifi.a =data[3]
        wifi.c = colours.button.maxB
    end

    awesome.emit_signal("signals::wifi", state, connection, wifi, act_con )
end)
