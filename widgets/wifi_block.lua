local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require('beautiful.xresources').apply_dpi

-- Set colors
local colours =  require("theme.colours")
-- text box function
local function format_text_box(dis_text)
    local text = wibox.widget {
        markup = "null",
        align = 'center',
        valign = 'center',
        font = "MADE Outer Sans 14",
        widget = wibox.widget.textbox
    }    
    --text.forced_height = dpi(24)
    --text.forced_width = dpi(120)
    text.resize = true

    return text
end
local function format_icon_box(icon)
    local text = wibox.widget {
        markup = "null",
        align = 'center',
        valign = 'center',
        font = "MADE Outer Sans 30",
        widget = wibox.widget.textbox
    }    
    --text.forced_height = dpi(30)
    --text.forced_width = dpi(120)
    text.resize = true

    return text
end
-- function create string and colour
local function string_text(text, colour)
    local line = "<span foreground= '" .. colour .. "'> " .. text .. "</span> "
    return line
end 

local textone = format_icon_box('')    
local texttwo = format_icon_box('')
local textthree = format_text_box('')
-- connect wifi signal
awesome.connect_signal("signals::wifi", function(state,connection,wifi,act_con)
    textone.markup = string_text(state.a, wifi.c)
    texttwo.markup = string_text(connection.a, connection.c)
    textthree.markup = string_text(act_con.a, act_con.c) 
end)
-- icon box
local icon_box = wibox.widget {
    nill,
    { textone, texttwo,
    spacing = dpi(3),
    layout = wibox.layout.fixed.horizontal},
    expand = "none",
    layout = wibox.layout.fixed.horizontal
}

local w = wibox.widget {
         nil,
        { icon_box, textthree, spacing = dpi(3), layout = wibox.layout.fixed.horizontal},
        expand = "none",
        layout = wibox.layout.align.horizontal
    }


return w 
