local wibox     = require('wibox')
local dpi       = require("beautiful.xresources").apply_dpi
local awful     = require('awful')
local beautiful = require('beautiful')
local gears     = require('gears')
local icons     = require('icons')
local helpers   = require("helpers")
local colours   = require('theme.colours')
local textFonts = require('theme.font')
local functions = require('theme.function')

-- #########################################################
-- widgets

-- Info

local img = wibox.widget.imagebox(icons.png.me)
img.resize = true
img.forced_width = 60
img.forced_height = 60
local text = wibox.widget {
     markup = "<span foreground='" .. colours.black.main .. "' ><b>Welcome</b></span>",
     widget = wibox.widget.textbox,
     font = textFonts.display.large 
 }

local user = wibox.widget {
    markup =  "<span foreground='" .. colours.black.second.."'>James Z </span>",
    widget = wibox.widget.textbox,
    font = textFonts.display.clock
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

local info = functions.create_boxed_widget(profile, 100, 150,colours.theme.white,beautiful.bg_widget)
--
-- =====================================================================
-- Clock
-- %p for pm/am
local clock = wibox.widget.textclock(
    "<span foreground='" .. colours.black.main .."'> %k:%M:%S </span>",
    1,
    2
)
clock.align = "center"
clock.valign = "center"
clock.font = textFonts.clock.main 

local clock_box = functions.create_boxed_widget(clock, 390 , 72,colours.theme.white , beautiful.bg_widget)

-- wifi_block
local wifi = require("widgets.wifi_block")
local wifi_box = functions.create_boxed_widget(wifi, 50,95,colours.theme.white , beautiful.bg_widget) 

-- battery
local bat = require("widgets.battary_bar")

-- Cpu
local cpu_bar = require("widgets.cpu_bar")
local cpu = functions.format_progress_bar(cpu_bar, "<span foreground='" .. colours.theme.black .."'><b></b></span>", colours.button.closeD, colours.button.closeB)

-- Ram
local ram_bar = require("widgets.ram_bar")
local ram = functions.format_progress_bar(ram_bar, "<span foreground='" .. colours.theme.black .."'><b></b></span>", colours.extra.blue , colours.extra.blue)

-- Ram, bat and CPU grouped
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
local sys_box = functions.create_boxed_widget(sys_bars, 390, 140, colours.theme.white, beautiful.bg_widget)
-- =======================================================================
-- Cal
local cal = wibox.widget {
    date = os.date('*t'),
    font = textFonts.calender.main,
    long_weekdays = false,    
    widget = wibox.widget.calendar.month
}

local cal_margin = wibox.widget {
    cal,
    left = dpi(50),
    widget = wibox.container.margin,
}

local cal_box = functions.create_boxed_widget(cal_margin, 390, 300,colours.theme.white, beautiful.bg_widget)
---- ====================== test button ====================
--
--local button_example = wibox {
--    visible = true,
--    bg = colours.theme.black, 
--    ontop = true,
--    height = 1E00,
--    width = 200,
--    shape = function(cr, width, height )
--        gears.shape.rounded_rect(cr,width,height , 3)
--    end
--}
--local button = wibox.widget{
--    {
--        {
--    text = "I'm a button!",
--    widget = wibox.widget.textbox
--        },
--    top=4, bottom=4, left=8, right=8,
--    widget = wibox.container.margin,
--    },
--    bg = '#4C566A',
--    bg = '#00000000',
--    shape_border_width=1, shape_border_color = colours.theme.black,
--    shape = function( cr , width , height)
--        gears.shpae.rounded_rect(cr, width, height, 4 )
--    end,
--    widget = wibox.container.background
--}
--
--local button_box = functions.create_boxed_widget( button, 390,100, colours.theme.white , beautiful.bg_widget )
--


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
                    --{
                    --    button,
                    --    top=15,
                    --    left=30,
                    --    right=30,
                    --    widget = wibox.container.margin,
                    --},

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
    bg = colours.theme.black,
    widget = wibox.container.background
}
