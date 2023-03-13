local gfs       = require("gears.filesystem")
local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local icons     = require('icons')
local beautiful = require("beautiful")
local helpers   = require("helpers")
local dpi       = require("beautiful.xresources").apply_dpi
local functions = require("theme.function")
require("awful.autofocus")

beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")



awful.screen.connect_for_each_screen(function(s)

    -- Taglist

    -- Set tags and default layout
    awful.tag({"Work", "Web", "Music", "Movie", "Fun"}, s,   awful.layout.suit.tile)
 
    
    local taglist_buttons = gears.table.join(
        awful.button({ }, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1, function(t)
                                  if client.focus then
                                      client.focus:move_to_tag(t)
                                  end
                              end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
                                  if client.focus then
                                      client.focus:toggle_tag(t)
                                  end
                              end)
    )
    
    taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.rounded_rect
        },
        layout   = {
            spacing = 0,
            spacing_widget = {
                color = '#181e23',
                shape = gears.shape.rounded_rect,
                widget = wibox.widget.separator,
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id = 'text_role',
                                widget = wibox.widget.textbox,
                            },
                            margins = 0,
                            widget = wibox.container.margin,
                        },
                        widget = wibox.container.background,
                    },
                    {
                        id     = 'index_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 7,
                right = 7,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:connect_signal('mouse::enter', function()
                    if #c3:clients() > 0 then
                        awesome.emit_signal("bling::tag_preview::update", c3)
                        awesome.emit_signal("bling::tag_preview::visibility", s, true)
                    end
    
                end)
                self:connect_signal('mouse::leave', function()
                    awesome.emit_signal("bling::tag_preview::visibility", s, false)
                    if self.has_backup then self.bg = self.backup end
                end)
            end,
            update_callback = function(self, c3, index, objects)
            end,
        },
        buttons = taglist_buttons
    }
    
    -- Clock

    local clock = wibox.widget.textclock(
        '<span> %d  %a %I:%M </span>', 5
    )
    -- Timer
    -- todo make signal an dbutton press
     --local timer = require("widgets.timer_bar")
     --local timer_bar = format_progress_bar(timer)
    -- Music

    --local music = require("widgets.playerctl_bar")

    -- Vol

    local volume_bar = require("widgets.volume_bar")
    local volume = functions.format_small_progress_bar(volume_bar)
    
    apps_volume = function()
        helpers.run_or_raise({class = "Pavucontrol"}, true, "pavucontrol")
    end
    
    volume:buttons(gears.table.join( -- Left click - Mute / Unmute
    awful.button({}, 1, function() helpers.volume_control(0) end),
    -- Scroll - Increase / Decrease volume
    awful.button({}, 4, function() helpers.volume_control(5) end),
    awful.button({}, 5, function() helpers.volume_control(-5) end)))

    -- Battery
    --bat = require("widgets.battary_bar")

    -- Start
    -- 14,14,10,6
    local start = wibox.widget {
        {widget = wibox.widget.imagebox, image = icons.png.start},
        layout = wibox.container.margin(start, 5, 5, 1, 1),
    }

    start:buttons(gears.table.join(awful.button({ }, 1, function() sidebar_toggle()
    end)))

    -- Hover Effect

    helpers.add_hover_cursor(start, "hand1")
    helpers.add_hover_cursor(taglist, "hand1")
    helpers.add_hover_cursor(volume, "hand1")

    -- Bar
    
    s.wibar = awful.wibar({
        screen = s,
	-- 60
        height = 18,
        bg = "#0000000",
        widget = wibox.container.background(),
    })
    
    -- Add widgets
    s.wibar:setup {
        {
            {
                {
                    layout = wibox.layout.align.horizontal,
                    expand = "none",
                    { -- Left widgets
                        layout = wibox.layout.fixed.horizontal,
                        start,
                        taglist,
                    },
                    {
                        layout = wibox.layout.fixed.horizontal,
                        wibox.layout.margin(clock, 0,5,0,0),
                        --wibox.layout.margin(timer, 0,5,2,2),
                       -- music,
                        -- layout = wibox.layout.fixed.horizontal, 
                    },
                    { -- Right widgets
                        layout = wibox.layout.fixed.horizontal,
                        --wibox.layout.margin(bat, 5, 10, 6,6),
                        wibox.layout.margin(volume, 5,5, 2, 2), 
                        -- wibox.layout.margin(clock, 0, 10, 0, 0),
                    },
                },
                bg = "#ffffff",
                widget = wibox.container.background
            },
            bottom = 2,
            widget = wibox.container.margin
        },
        bg = "#000000",
        widget = wibox.container.background
    }
end)
