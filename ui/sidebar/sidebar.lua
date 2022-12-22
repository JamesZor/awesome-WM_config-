local wibox = require('wibox')
local dpi = require("beautiful.xresources").apply_dpi
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local icons = require('icons')
local helpers = require("helpers")
local lain = require("lain")
local markup = lain.util.markup

-- Theme colours
local colour_theme_white = "#ffffff"
local colour_theme_black = "#000000"
local colour_theme_grey  = "#d5d5d5" 
local colour_black_one   = "#0e1111"
local colour_black_two   = "#353839"
local colour_theme_yellow = "#ffdc75"
local colour_theme_purple = "#cfd3df"
local colour_orange_main = "#ffd7b5"
local colour_orange_sec  = "#ffb38a"
local colour_yellow_main = "#f8ed62"
local colour_yellow_sec  = "#e9d700"
local colour = {}
colour.red          = '#ffb3ba'
colour.orange       = '#ffdfba'
colour.yellow       = '#ffffba'
colour.green        = '#baffc9'
colour.blue         = '#bae1ff'

--  ############################################################
--  Create Functions Section
--  Bar function
local function format_progress_bar(bar, markup, colour_one, colour_two)
    local text = wibox.widget {
        markup = markup,
        align = 'center',
        valign = 'center',
        font = "MADE Outer Sans 20",
        widget = wibox.widget.textbox
    }
    text.forced_height = dpi(24)
    text.forced_width = dpi(50)
    text.resize = true

    bar.forced_height = dpi(25)
    bar.forced_width = dpi(270)
    bar.resize = true

    bar.border_color = colour_theme_black
    --bar.color = colour_one
    --bar.bar_border_color = colour_two 

    local w = wibox.widget {
        nil,
        {text, bar, spacing = dpi(2), layout = wibox.layout.fixed.horizontal},
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
    return w
end

-- Function to create widgetboxes
local function create_boxed_widget(widget_to_be_boxed, width, height, back_col, bg_color )
    local box_container = wibox.container.background()
    --box_container.bg = "#ffffff"
    box_container.bg = back_col
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

-- #########################################################
-- widgets

-- Info

local img = wibox.widget.imagebox(icons.png.me)
img.resize = true
img.forced_width = 60
img.forced_height = 60
local text = wibox.widget {
     markup = "<span foreground='" .. colour_black_one .. "' ><b>Welcome</b></span>",
     widget = wibox.widget.textbox,
     font = "MADE Outer Sans 30"
 }

local user = wibox.widget {
    markup =  "<span foreground='" .. colour_black_two .."'>James Z </span>",
    widget = wibox.widget.textbox,
    font = "MADE Outer Sans 20"
}
-- Unused ?? (text_box) 
local box_test = wibox.widget {
    {
        {
            test_box,
            left=30,
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.fixed.horizontal
}

local profile = wibox.widget {
    {    
        {
            text,
            left = 30,
            widget = wibox.container.margin
        },
        {
            user,
            top = 10,
            left = 30,
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.fixed.horizontal
}

local info = create_boxed_widget(profile, 100, 150,colour_theme_white,beautiful.bg_widget)

-- Clock
-- %p for pm/am
local clock = wibox.widget.textclock(
    "<span foreground='" .. colour_black_one .."'> %k:%M:%S </span>",
    1,
    2
)
clock.align = "center"
clock.valign = "center"
clock.font = "MADE Outer Sans 25"

local clock_box = create_boxed_widget(clock, 390 , 72,colour_theme_white, beautiful.bg_widget)
-- wifi_block
local wifi = require("widgets.wifi_block")
local wifi_box = create_boxed_widget(wifi, 50,95,colour_theme_white, beautiful.bg_widget) 
-- battery
local bat = require("widgets.battary_bar")

-- Cpu
local cpu_bar = require("widgets.cpu_bar")
-- #000000 Black  #d5d5d5 grey 
local cpu = format_progress_bar(cpu_bar, "<span foreground='" .. "#000000" .."'><b></b></span>", colour.red, colour.red )
-- Ram
local ram_bar = require("widgets.ram_bar")
local ram = format_progress_bar(ram_bar, "<span foreground='" .. "#000000" .."'><b></b></span>", colour.blue , colour.blue)
-- Ram and CPU grouped
local sys_bars = wibox.widget {
    {
        cpu,
        top = 10,
        left =10,
        right =10,
        widget =wibox.container.margin,
    },
    {
        ram,
        top = 10,
        left =10,
        right =10,
        widget =wibox.container.margin,
    },
    {
        bat,
        top = 10,
        left =10,
        right =10,
        widget =wibox.container.margin,
    },

    layout = wibox.layout.flex.vertical,
}
-- Ram and CPU Container
local sys_box = create_boxed_widget(sys_bars, 390, 140,colour_theme_white, beautiful.bg_widget)

-- Cal

local cal = wibox.widget {
    date = os.date('*t'),
    font = "MADE Outer Sans 16",
    long_weekdays = false,    
    widget = wibox.widget.calendar.month
}

local cal_margin = wibox.widget {
    cal,
    left = dpi(50),
    widget = wibox.container.margin,
}

local cal_box = create_boxed_widget(cal_margin, 390, 300,colour_theme_white, beautiful.bg_widget)

-- Sidebar

sidebar = wibox({visible = false, ontop = true, screen = screen.primary})
sidebar.bg = "#00000000"
sidebar.fg = "#000000"
sidebar.height = 1060 -- 1020 
sidebar.width = 450
sidebar.y = 18 -- 60 (to top bar)

sidebar_show = function()
    sidebar.visible = true
end

sidebar_hide = function()
    sidebar.visible = false
end

sidebar_toggle = function()
    sidebar.visible = not sidebar.visible
end

sidebar : setup {
    {
        {
            {
                layout = wibox.layout.fixed.vertical,
                {       -- top
                    {
                       -- info 
                        info,
                        top = 30,
                        left = 30,
                        right = 30,
                        widget = wibox.container.margin,
                    },
                    {
                        clock_box,
                        top = 15,
                        left = 30,
                        right = 30,
                        widget = wibox.container.margin,
                    },
                    {
                        sys_box,
                        top = 15,
                        left = 30,
                        right =30,
                        widget = wibox.container.margin,
                    },
                    {
                        wifi_box,
                        top= 15,
                        left =30,
                        right=30,
                        widget = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.vertical
                },
                {    -- bottom
                    nil,
                    {
                        cal_box,
                        top = 15,
                        bottom = 30,
                        widget = wibox.container.margin,
                    },
                    nil,
                    layout = wibox.layout.align.horizontal,
                    expand = "none",
                },
            },
            bg = beautiful.bg,
            widget = wibox.container.background
        },
        bottom = 2,
        right = 2,
        widget = wibox.container.margin
    },
    bg = "#000000",
    widget = wibox.container.background
}
