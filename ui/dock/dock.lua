local dpi = require('beautiful.xresources').apply_dpi
local wibox  = require('wibox')
local awful = require('awful')
local icons = require('icons')
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")

spotify = "firefox http://192.168.1.100/" 
chrome = "firefox"
mail = "discord"
--mail = "google-chrome-stable https://www.gmail.com"
file = "pcmanfm -d "
netflix = "vlc"
vscode = "rstudio"

awful.screen.connect_for_each_screen(function (scr)

   local dock = awful.wibar{
      position = "bottom",
      height = 100,
      -- = 117
     -- height = 80,
      screen =screen.primary,     
      width = 859,
     -- screen = scr,
      visible = false,
      bg = "#00000000",
      bgimage = beautiful.dock_bg,
   }
   
   dock.y = 995
   -- = 950

   dockbar_show = function()
       dock.visible = true
    end

    dockbar_hide =function()
        dock.visible =false
    end

    dockbar_toggle = function()
        dock.visible = not dock.visible
    end


   local function create_img_widget(image, apps)
      local widget = wibox.widget {
         image = image,
         widget = wibox.widget.imagebox()
      }
      widget:buttons(gears.table.join(awful.button({}, 1, function()
         awful.spawn(apps)
     end)))
      return widget
   end

   local spotify = create_img_widget(icons.png.spotify, spotify)
   local chrome = create_img_widget(icons.png.chrome, chrome)
   local mail = create_img_widget(icons.png.mail, mail)
   local file = create_img_widget(icons.png.file, file)
   local netflix = create_img_widget(icons.png.netflix, netflix)
   local vscode = create_img_widget(icons.png.vscode, vscode)

   helpers.add_hover_cursor(spotify, "hand1")
   helpers.add_hover_cursor(chrome, "hand1")
   helpers.add_hover_cursor(mail, "hand1")
   helpers.add_hover_cursor(file, "hand1")
   helpers.add_hover_cursor(netflix, "hand1")
   helpers.add_hover_cursor(vscode, "hand1")

   dock : setup {
      {
                 layout = wibox.layout.align.horizontal,
                 expand = "none",
                 { -- Left 
                     layout = wibox.layout.fixed.horizontal,
                 },
                 {
                     wibox.layout.margin(spotify, 0, 0, 0, 20), 
                     wibox.layout.margin(chrome, 0, 0, 0, 20), 
                     wibox.layout.margin(mail, 0, 0, 0, 20), 
                     wibox.layout.margin(file, 0, 0, 0, 20), 
                     wibox.layout.margin(netflix, 0, 0, 0, 20), 
                     wibox.layout.margin(vscode, 0, 0, 0, 20),
                     spacing = dpi(40),
                     layout = wibox.layout.fixed.horizontal,
                 },
                 { -- Right 
                     layout = wibox.layout.fixed.horizontal,
                 },
             },
             widget = wibox.container.background
 }

end)



