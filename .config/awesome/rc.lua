-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widget library
require("vicious")
-- Dynamic tagging library
-- require("shifty")

-- require("obvious.volume_alsa") -- Load the module
-- obvious.volume_alsa.setchannel("Master") -- Configure the module
-- obvious.volume_alsa() -- Add this to your widgets list 

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(os.getenv("HOME").."/.config/awesome/themes/default/theme.lua")
-- theme.wallpaper_cmd = { "awsetbg /home/archy/wallpapers/gray-1920x1080.png"}
--theme.wallpaper_cmd = { "nitrogen --restore" }

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
--editor = os.getenv("EDITOR") or "nano"
editor = "gvim"
--editor_cmd = terminal .. " -e " .. editor
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
    -- awful.layout.suit.magnifier,
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
                 --{ "pcmanfm", "pcmanfm", freedesktop.utils.lookup_icon({ icon="system-file-manager" }) },
                 --{ "chromium", "chromium", "/usr/share/icons/hicolor/16x16/apps/chromium.png" },
                 { "firefox", "firefox", "/usr/share/pixmaps/firefox-beta-bin-icon.png" },
                 { "ario", "ario", "/usr/share/icons/hicolor/16x16/apps/ario.png" },
                 --{ "gbemol", "gbemol", "/usr/share/pixmaps/gbemol.png" },
                 { "smplayer", "smplayer", "/usr/share/icons/hicolor/16x16/apps/smplayer.png" },
                 { "gVim", "gvim", "/usr/share/pixmaps/gvim.png" },
                 { "calc", "gcalctool", freedesktop.utils.lookup_icon({ icon="calc" }) },
                 --{ "gcstar", "gcstar", "/usr/share/pixmaps/gcstar.png" },
                 --{ "oo-writer", "soffice -writer", "/usr/share/icons/hicolor/16x16/apps/writer.png" },
                 --{ "oo-impress", "soffice -impress", "/usr/share/icons/hicolor/16x16/apps/impress.png" },
                 --{ "oo-calc", "soffice -calc", "/usr/share/icons/hicolor/16x16/apps/ooocalc.png" },
                 --{ "scrabble", "/home/archy/WordBiz/wordbiz", "/usr/share/icons/Tango/16x16/actions/format-text-bold.png" },
                 { "terminal", terminal, freedesktop.utils.lookup_icon({ icon="terminal" }) },
}

system_items = { { "shutdown", "sudo /sbin/halt", "/usr/share/icons/Tango/16x16/actions/system-shutdown.png" },
                 { "reboot", "sudo /sbin/reboot", "/usr/share/icons/Tango/16x16/actions/reload3.png" }
}
--menu_separator = { "", height="1" }

menu_items =  { { "awesome", myawesomemenu, beautiful.awesome_icon },
                { "applications", free_desktop_menu, os.getenv("HOME").."/.config/awesome/archlinux-wm-awesome.png" }
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
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
quicklaunch = {}
for l in ipairs(favoriteapps) do 
  table.insert(quicklaunch, awful.widget.launcher({ 
                                                    image=favoriteapps[l][3], 
                                                    --image=beautiful.awesome_icon, 
                                                    command=favoriteapps[l][2] })) 
end
quicklaunch.layout = awful.widget.layout.horizontal.leftright

-- {{{ Wibox
-- Set background color
function bg(color, text)
    return '<bg color="' .. color .. '" />' .. text
end

-- Set foreground color
function fg(color, text)
    return '<span color="' .. color .. '">' .. text .. '</span>'
end

-- Boldify text
function bold(text)
    return '<b>' .. text .. '</b>'
end

-- Emphasis text
function italic(text)
    return '<i>' .. text .. '</i>'
end

-- Create a textclock widget
-- {{{ Naughty Calendar
calendar = {
    offset = 0,
    font = "monospace"
}

function calendar:month(month_offset)
    local save_offset = self.offset
    self:remove()
    self.offset = save_offset + month_offset
    local datespec = os.date("*t")
    datespec = datespec.year * 12 + datespec.month - 1 + self.offset
    datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
    local cal = awful.util.pread("cal -m " .. datespec)
    if self.offset == 0 then -- this month, hilight day and month
        cal = string.gsub(cal, "%s" .. tonumber(os.date("%d")) .. "%s", italic(bold(fg(beautiful.hilight, "%1"))))
        cal = string.gsub(cal, "^(%s*%w+%s+%d+)", italic(bold(fg(beautiful.hilight, "%1"))))
    end

    self.display = naughty.notify {
        opacity = use_composite and beautiful.opacity.naughty or 1,
        text = string.format('<span font_desc="%s">%s</span>', self.font, cal),
        timeout = 0,
        hover_timeout = 0.5,
        margin = 10,
    }
end

function calendar:remove()
    if self.display ~= nil then
        naughty.destroy(self.display)
        self.display = nil
        self.offset = 0
    end
end
-- }}}

mytextclock = awful.widget.textclock({ align = "right" })
mytextclock:add_signal("mouse::leave", function() calendar:remove() end)
mytextclock:buttons(awful.util.table.join(
    awful.button({ }, 1, function() calendar:month(0) end),
    awful.button({ }, 2, function() calendar:month(0) end),
    awful.button({ }, 3, function() calendar:month(0) end),
    awful.button({ }, 5, function() calendar:month(1)  end),
    awful.button({ }, 4, function() calendar:month(-1)  end))
)



--[[
-- {{{ Cache these widgets
vicious.cache(vicious.widgets.net)
--vicious.cache(vicious.widgets.bat)
--vicious.cache(vicious.widgets.wifi)
vicious.cache(vicious.widgets.gmail)
-- }}}
]]--

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
--volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "Master")
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer set Master toggle >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 2, function () awful.util.spawn("amixer set Master toggle >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 3, function () awful.util.spawn(terminal.." -e alsamixer") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer set Master 5%+ >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer set Master 5%- >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 6, function () awful.util.spawn("amixer set Master 5%- >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 7, function () awful.util.spawn("amixer set Master 5%+ >/dev/null") vicious.force({volbar, volwidget}) end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())

-- Register widget
vicious.register(volicon, vicious.widgets.volume, 
      function (widget, args)
          if args[1] == 0 or args[2] == "♩" then 
            volicon.image=image(beautiful.widget_vol_mute)
          elseif args[1] > 66 then
            volicon.image=image(beautiful.widget_vol_hi)
          elseif args[1] > 33 and args[1] <= 66 then
            volicon.image=image(beautiful.widget_vol_mid)
          else
            volicon.image  = image(beautiful.widget_vol_low)
          end
          
      end, 
      2, "Master")
volicon:buttons(volbar.widget:buttons())
-- }}}

--{{{ MPD widget
vicious.cache(vicious.widgets.mpd)
mpdWidgetButtons = awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("mpc toggle") vicious.force({ mpdwidget}) end),
    awful.button({ }, 2, function () awful.util.spawn("mpc toggle") vicious.force({ mpdwidget}) end),
    awful.button({ }, 3, function () awful.util.spawn("mpc stop") vicious.force({ mpdwidget}) end),
    awful.button({ }, 4, function () awful.util.spawn("mpc next") vicious.force({ mpdwidget}) end),
    awful.button({ }, 5, function () awful.util.spawn("mpc prev") vicious.force({ mpdwidget}) end),
    awful.button({ }, 6, function () awful.util.spawn("mpc prev") vicious.force({ mpdwidget}) end),
    awful.button({ }, 7, function () awful.util.spawn("mpc next") vicious.force({ mpdwidget}) end)
)

--mympdstatefronttext = widget({ type = "textbox" })
--mympdstatebacktext  = widget({ type = "textbox" })
--mympdstatefronttext.text = ' <span color="#7f9f7f">[</span>'
--mympdstatebacktext.text  = '<span color="#7f9f7f">]</span>'

-- Initialize widget
mpdwidget = widget({ type = "textbox" })
mpdwidget:buttons(mpdWidgetButtons)
mympdstateicon    = widget({ type = "imagebox", name = "mympdstateicon" })
mympdstateicon:buttons(mpdWidgetButtons)
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd, 
        function (widget, args)
            if args["{state}"] == "Play" then
                mympdstateicon.image = image(beautiful.widget_mpd_playing)
            elseif args["{state}"] == "Pause" then
                mympdstateicon.image = image(beautiful.widget_mpd_paused)
            else
                mympdstateicon.image = image(beautiful.widget_mpd_stopped)
            end
            return args["{Artist}"] .. " - " .. args["{Title}"] .. " "
        end, 1)
-- }}}
--[[

-- Gmail widget
gmailWidgetButtons = awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(emailclient) end),
    awful.button({ }, 3, function () vicious.force({ gmailwidget, }) end)
)

mymailicon       = widget({ type = "imagebox", name = "mymailicon" })
mymailicon.image = image(beautiful.widget_mail)
mymailicon:buttons(gmailWidgetButtons)

-- Initialize widget
gmailwidget = widget({ type = "textbox" })
gmailwidget:buttons(gmailWidgetButtons)
-- Register widget
vicious.register(gmailwidget, vicious.widgets.gmail, 
        function (widget, args)
            returnString = '<span color="#7F9F7F">[</span>' .. args["{count}"] .. '<span color="#7F9F7F">]</span>'
            
            if args["{count}"] > 0 then 
                returnString = returnString .. " " .. args["{subject}"]
            end

            return returnString
        end, 180, {40, "gmailwidget"})
]]--

-- {{{ Network usage widget
vicious.cache(vicious.widgets.net)
myneticondown   = widget({ type = "imagebox", name = "myneticondown" })
myneticonup     = widget({ type = "imagebox", name = "myneticonup" })

myneticonup.image   = image(beautiful.widget_netup)
myneticondown.image = image(beautiful.widget_netdown)
-- Initialize widget
netwidgetdown = widget({ type = "textbox" })
netwidgetdown.width=30
-- Register widget
vicious.register(netwidgetdown, vicious.widgets.net, '<span color="#CC9393">${eth0 down_kb}</span> ', 3)

-- Initialize widget
netwidgetup = widget({ type = "textbox" })
netwidgetup.width=30
-- Register widget
vicious.register(netwidgetup, vicious.widgets.net, '<span color="#7F9F7F">${eth0 up_kb}</span>', 3)
-- }}}

-- {{{ CPU usage and temperature
vicious.cache(vicious.widgets.cpu)
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
cpuWidgetButtons = awful.util.table.join(
    awful.button({ }, 1, 
      function ()
        cpus_visible = not cpus_visible
        for i,c in ipairs(cpus) do
          c.widget.visible = cpus_visible
        end
      end)
)
cpuicon:buttons(cpuWidgetButtons)
-- Initialize widgets
cpugraph  = awful.widget.graph()
cpugraph:set_width(40):set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({
   beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
})
cpugraph.widget:buttons(cpuWidgetButtons)
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")

cpus = {}
cpus_widgets = {}
cpus_visible = false
for i = 1,4 do
  cpus[i] = awful.widget.graph()
  cpus_widgets[i] = cpus[i].widget
  cpus[i].widget.visible = cpus_visible
  cpus[i]:set_width(40):set_height(14)
  cpus[i]:set_background_color(beautiful.fg_off_widget)
  cpus[i]:set_border_color(beautiful.border_marked)
  cpus[i]:set_gradient_angle(0):set_gradient_colors({
    beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
  })
  vicious.register(cpus[i],  vicious.widgets.cpu,       "$"..(i+1))
  cpus[i].widget:buttons(cpuWidgetButtons)
end
-- }}}

-- {{{ Battery state
--baticon = widget({ type = "imagebox" })
--baticon.image = image(beautiful.widget_bat)
---- Initialize widget
--batwidget = widget({ type = "textbox" })
---- Register widget
--vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ Memory usage
vicious.cache(vicious.widgets.mem)
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_vertical(true):set_ticks(true)
membar:set_height(12):set_width(8):set_ticks_size(2)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ Pacman widget
pacman_icon = widget({type = "imagebox", name = "pacman_icon" })
pacman_icon.image = image(beautiful.widget_pacman)
pacman = widget({type = "textbox"})
--vicious.register(pacman, vicious.widgets.pkg, "$1", 300, "Arch")
vicious.register(pacman, vicious.widgets.pkg, 
  function(widget,args) 
    if (args[1]==0) then
      pacman.visible = false
      pacman_icon.visible = false
    else
      pacman.visible = true
      pacman_icon.visible = true
    end
    return args[1] 
  end, 300, "Arch")
pacman_buttons = awful.util.table.join(
  awful.button({ }, 1, 
    function () 
      awful.util.spawn(terminal..
        " -T pacman_update -e bash -c \"sudo pacman -Su;"..
        " read -p 'Press a key to continue'\"") 
      vicious.force({pacman})
    end)
)
pacman:buttons(pacman_buttons)
pacman_icon:buttons(pacman_buttons)
-- }}}


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
                    awful.button({ }, 2, function (c)
                                              c.minimized = not c.minimized
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
            separator,
            --FIXME
            {
              quicklaunch[1],
              quicklaunch[2],
              quicklaunch[3],
              quicklaunch[4],
              quicklaunch[5],
              quicklaunch[6],
              layout = quicklaunch["layout"]
            },
            --quicklaunch,
            separator,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s], separator,
        pacman, pacman_icon, mytextclock, separator,
        (s == 1) and mysystray or nil,
        volwidget,  volbar.widget, volicon, separator,
        --pacman, pacman_icon, separator,
        netwidgetup, myneticonup, netwidgetdown, myneticondown, separator,
        membar.widget, memicon, separator,
        --FIXME
        --cpus_widgets,
        cpus_widgets[1], cpus_widgets[2], cpus_widgets[3], cpus_widgets[4],
        cpugraph.widget, cpuicon, separator,
        --gmailwidget, separator,
        --[[mympdstatebacktext,]]mympdstateicon,mpdwidget,--[[mympdstatefronttext,]]separator,
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

    --awful.button({ modkey }, 2, awful.client.floating.set( client, not client.ontop ) )
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
    { rule = { class = "Qt4-ssh-askpass" },
      properties = { floating = true, ontop = true, modal=true, focus=true } },

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
