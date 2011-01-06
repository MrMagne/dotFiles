-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

require("vicious")
require("vicious.pulse.volume")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(os.getenv("HOME").."/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "gvim"
editor_cmd = editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}
  mylayoutitems = {}
  for l in ipairs(layouts) do
    name = awful.layout.getname(layouts[l])
    icon = image(beautiful["layout_"..name])
    mylayoutitems[l] = {name, function() awful.layout.set(layouts[l]) end, icon}
  end
  mylayoutmenu = awful.menu.new({ items=mylayoutitems, width=80 }) 

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
    for t in ipairs(tags[s]) do
      awful.tag.setmwfact(0.75, tags[s][t])
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
  -- applications menu
  require('freedesktop.utils')
  freedesktop.utils.terminal = terminal  -- default: "xterm"
  freedesktop.utils.icon_theme = 'Tango' -- look inside /usr/share/icons/, default: nil (don't use icon theme)
  require('freedesktop.menu')
  --require("debian.menu")

  free_desktop_menu = freedesktop.menu.new()

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

favoriteapps = {
                 { "pcmanfm", "pcmanfm", freedesktop.utils.lookup_icon({ icon="system-file-manager" }) },
                 { "chromium", "chromium-browser", "/usr/share/pixmaps/chromium-browser.png" },
                 { "ario", "ario", freedesktop.utils.lookup_icon({ icon="ario" }) },
                 { "smplayer", "smplayer", freedesktop.utils.lookup_icon({ icon="smplayer" }) },
                 { "gVim", "gvim", os.getenv("HOME").."/.config/awesome/icons/vim.png" },
                 { "calc", "gcalctool", freedesktop.utils.lookup_icon({ icon="calc" }) },
                 -- { "gcstar", "gcstar", "/usr/share/pixmaps/gcstar.png" },
                 -- { "oo-writer", "soffice -writer", "/usr/share/icons/hicolor/16x16/apps/writer.png" },
                 -- { "oo-impress", "soffice -impress", "/usr/share/icons/hicolor/16x16/apps/impress.png" },
                 -- { "oo-calc", "soffice -calc", "/usr/share/icons/hicolor/16x16/apps/ooocalc.png" },
                 { "terminal", terminal, freedesktop.utils.lookup_icon({ icon="terminal" }) }
}

system_items = { { "shutdown", "sudo /sbin/halt", "/usr/share/icons/Tango/16x16/actions/system-shutdown.png" },
                 { "reboot", "sudo /sbin/reboot", "/usr/share/icons/Tango/16x16/actions/reload3.png" }
}
--menu_separator = { "", height="1" }

menu_items =  { { "awesome", myawesomemenu, beautiful.awesome_icon },
                { "applications", free_desktop_menu, "/usr/share/icons/gnome/16x16/places/ubuntu-logo.png" }
}
for l in ipairs(favoriteapps) do table.insert(menu_items, favoriteapps[l]) end
--table.insert(menu_items, menu_separator)
for l in ipairs(system_items) do table.insert(menu_items, system_items[l]) end
--table.insert(menu_items, menu_separator)
--table.insert(menu_items, system_items)
mymainmenu = awful.menu({ items = menu_items })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}
--separator = widget({ type = "imagebox" })
--separator.image = image(beautiful.widget_sep)
quicklaunch = {}
for l in ipairs(favoriteapps) do 
  table.insert(quicklaunch, awful.widget.launcher({ 
                                                    image=favoriteapps[l][3], 
                                                    --image=beautiful.awesome_icon, 
                                                    command=favoriteapps[l][2] })) 
end
quicklaunch.layout = awful.widget.layout.horizontal.leftright

-- {{{ Wibox
-- Create a pulse volume widget
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
--vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar, vicious.widgets.pulse.volume, 
                   function (widget, args) 
                     return string.format("%.2f", args[1])
                   end,  2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
vicious.register(volwidget, vicious.widgets.pulse.volume, 
                   function (widget, args) 
                     return string.format("%.2f", args[1]).."%"
                   end,  2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
--vicious.register(volwidget, vicious.widgets.pulse.volume, " $1%", 2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn("pavucontrol") end),
   awful.button({ }, 4, function () vicious.pulse.volume.add(5,"alsa_output.pci-0000_00_1b.0.analog-stereo") end),
   awful.button({ }, 5, function () vicious.pulse.volume.add(-5,"alsa_output.pci-0000_00_1b.0.analog-stereo") end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           --awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 1, function () mylayoutmenu:toggle() end),
                           awful.button({ }, 3, function () mylayoutmenu:toggle() end),
                           --awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            --separator,
            --FIXME
            {
              quicklaunch[1],
              quicklaunch[2],
              quicklaunch[3],
              quicklaunch[4],
              quicklaunch[5],
              quicklaunch[6],
              layout = awful.widget.layout.horizontal.leftright
            },
            --quicklaunch,
            --separator,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        volwidget, volbar.widget, volicon,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function () mymainmenu:hide() end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Lock Screen
    awful.key({ modkey, "Control", altkey }, "Delete", function () awful.util.spawn("xscreensaver-command -lock") end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, "Shift"   }, "Tab", function () 
          awful.client.cycle(false)
          awful.client.focus.byidx(1)
          client.focus:raise()
        end),
    awful.key({ modkey,           }, "Tab", function () 
          awful.client.cycle(true)
          awful.client.focus.byidx(-1)
          client.focus:raise()
        --function ()
        --    awful.client.focus.history.previous()
        --    if client.focus then
        --        client.focus:raise()
        --    end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    -- awful.button({ modkey }, 4, function () awful.client.moveresize( 20,  20, -40, -40) end),
    -- awful.button({ modkey }, 5, function () awful.client.moveresize( -20,  -20, 40, 40) end)
    awful.button({ modkey }, 4, function (c) 
                                  if awful.client.floating.get(c) then 
                                    awful.client.moveresize( 20, 20, -40, -40)
                                  else
                                    awful.tag.incmwfact( 0.2)
                                  end
                                end),    
    awful.button({ modkey }, 5, function (c) 
                                  if awful.client.floating.get(c) then 
                                    awful.client.moveresize( -20, -20, 40, 40)
                                  else
                                    awful.tag.incmwfact( -0.2)
                                  end
                                end)
    )

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true, on_top = true } },
    { rule = { class = "Smplayer" },
      properties = { floating = true, on_top = true } },
      --properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gcalctool" },
      properties = { floating = true } },
    -- { rule = { class = "gimp" },
    --   properties = { floating = true, on_top = true } },
    { rule = { role = "gimp-dock" },
      properties = { floating = true, ontop = true } },
    { rule = { role = "gimp-toolbox" },
      properties = { floating = true, ontop = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey, height="12" })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
