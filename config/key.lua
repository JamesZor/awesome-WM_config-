local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

--bling module
local bling = require("bling")

local keys = {}

require("awful.hotkeys_popup.keys")
require("awful.autofocus")

local terminal = "alacritty"
local browser = "firefox"
local fm = "thunar"
local vscode = "vscodium"
local discord = "discord"
local maths = "/home/james/Wolfram/Mathematica/12.3/Executables/Mathematica --name M-12.3"
local sda = "pcmanfm /home/james/Maths/SDA"
local com_an = "pcmanfm /home/james/Maths/Complex_Analysis"
local comp_org = "pcmanfm /home/james/Maths/Computer_Org"
local modkey = "Mod4"

local editor = os.getenv("EDITOR") or "vim"
local editor_cmd = terminal .. " -e " .. editor

local mykeyboardlayout = awful.widget.keyboardlayout()

-- Bling's Flash Focus
--bling.module.flash_focus.enable()
-- bling flash focus settings 
--theme.flash_focus_start_opacity = 0.1 -- Starting opacity
--theme.flash_focus_step = 0.01         -- the step up



clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),
  awful.button({ modkey }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
  end)
)


keys.desktopbuttons = gears.table.join(
    awful.button({ }, 2, function() sidebar_toggle()
    end)
)
keys.desktopbuttons = gears.table.join(
    awful.button({ }, 2, function() dockbar_toggle()
    end)
)

globalkeys = gears.table.join(
    awful.key({ modkey,           }, "n",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "m",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
           -- bling.module.flash_focus(client.focus)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
           -- bling.module.flash_focus(client.focus)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () awful.spawn(browser) end,
              {description = "spawn browser", group = "launcher"}),
--[[
    awful.key({ modkey,           }, "t", function () awful.spawn(maths) end,
              {description = "spawn mathematica", group = "launcher"}),
              ]]--

    awful.key({ modkey,           }, "u", function () awful.spawn(sda) end,
              {description = "spawn file sda", group = "launcher"}),
    awful.key({ modkey,           }, "i", function () awful.spawn(com_an) end,
              {description = "spawn browser", group = "launcher"}),
    awful.key({ modkey,           }, "p", function () awful.spawn(comp_org) end,
              {description = "spawn browser", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Audio
	awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ +3%",
        function() awesome.emit_signal("volume_refresh") end)
    end, { description = "raise volume by 3%", group = "audio" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ -3%",
        function() awesome.emit_signal("volume_refresh") end)
    end, {description = "lower volume by 3%", group = "audio"}),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn.easy_async_with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle",
        function() awesome.emit_signal("volume_refresh") end)
    end, {description = "mute audio", group = "audio"}),

-- screen brightness
    awful.key({ }, "XF86MonBrightnessUp", function( ) os.execute("xbacklight -inc 10") end,
        {description = "+5%", group ="hotkeys"}),
   awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 10") end,
        {description = "-5%", group ="hotkeys"}),

    -- Standard program
    awful.key({ modkey,           }, "s",   function ()  hotkeys_popup:show_help() end ,
              {description="show help", group ="awesome"}),

    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ }, "Print", function () awful.spawn.easy_async_with_shell("scrot -cd1 -q100 ~/Pictures/H%M%S.png") end, 
              {description = "take screenshot", group = "screen"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    -- side bar / bar pop up
    awful.key({ modkey },            "z",     function() sidebar_toggle()                     end,
              {description = "show or hide sidebar", group = "awesome"}),
    awful.key({ modkey },            "x",     function() dockbar_toggle()                     end,
              {description = "show or hide dockbar", group = "awesome"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),
    -- Menubar
    awful.key({ modkey }, "r", function() awful.spawn.easy_async_with_shell("rofi -show drun") end,
              {description = "show the menubar", group = "launcher"}),
   -- Prompt
--     awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
--               {description = "run prompt", group = "launcher"}),

-- emoji
    awful.key({ modkey }, "d", function() awful.spawn.easy_async_with_shell("rofi -show emoji -modi emoji") end,
              {description = "emoji menu", group = "launcher"})

)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end


-- screen brightness
--    awful.key({ }, "XF86MonBrightnessUp", function( ) os.execute("xbacklight -inc 10") end,
--        {description = "+10%", group ="hotkeys"}),
 --   awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 10") end,
--        {description = "-10%", group ="hotkeys"}),

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

root.buttons(keys.desktopbuttons)





return keys
