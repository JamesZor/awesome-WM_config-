local wibox     = require('wibox')
local dpi       = require("beautiful.xresources").apply_dpi
local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears')
local icons     = require('icons')
local helpers   = require("helpers")
local colours   = require('theme.colours')
local textFonts = require('theme.font')

local functions = {}

--  Bar function
function functions.format_progress_bar(bar, markup, colour_one, colour_two)
    local text = wibox.widget {
        markup = markup,
        align = 'center',
        valign = 'center',
        font = textFonts.text.bar, 
        widget = wibox.widget.textbox
    }
    text.forced_height = dpi(24)
    text.forced_width = dpi(50)
    text.resize = true

    bar.forced_height = dpi(25)
    bar.forced_width = dpi(270)
    bar.resize = true

    bar.border_color = colours.theme.black 
    bar.color = colour_one
    bar.bar_border_color = colour_two 

    local w = wibox.widget {
        nil,
        {text, bar, spacing = dpi(2), layout = wibox.layout.fixed.horizontal},
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
    return w
end
-- Function to create widgetboxes
function functions.create_boxed_widget(widget_to_be_boxed, width, height, back_col, bg_color )
    local box_container = wibox.container.background()
    --box_container.bg = "#ffffff"
    box_container.bg = colours.theme.white
    box_container.border_width = 2
    box_container.border_color = beautiful.border_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(30)

    local boxed_widget = wibox.widget {
        {
            {
                nil,
                {
                    nil,
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal
            },
            widget = box_container
        },
        margins = box_gap,
        color = "#00000000",
        widget = wibox.container.margin
    }
    return boxed_widget
end

--- simple bar for the top bar (since in bar it is smaller)

function functions.format_small_progress_bar(bar)
    local w = wibox.widget {
        
        nil,
        {bar, layout = wibox.layout.fixed.horizontal},
        expand = "none",
        -- 50
        forced_width = 100,
        forced_height = 1,
        layout = wibox.layout.align.horizontal
    }
    return w
end

return functions
