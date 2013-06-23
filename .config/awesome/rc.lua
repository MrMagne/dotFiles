-- Standard awesome library
local gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Widget library
local vicious = require("vicious")
-- Dynamic tagging library
-- require("shifty")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
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
local layouts =
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

-- {{{ Wallpaper
-- -- beautiful.wallpaper = os.getenv("HOME").."/wallpapers/Arch_Wall_ by_kpolicano_1920x1080"
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}
  mylayoutitems = {}
  for l in ipairs(layouts) do
    name = awful.layout.getname(layouts[l])
    -- icon = image(beautiful["layout_"..name])
    icon = beautiful["layout_"..name]
    -- icon = {}
    mylayoutitems[l] = {name, function() awful.layout.set(layouts[l]) end, icon}
  end
  mylayoutmenu = awful.menu.new({ items=mylayoutitems, theme = { width=80 } }) 

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
  -- require('freedesktop.utils')
  -- freedesktop.utils.terminal = terminal  -- default: "xterm"
  -- freedesktop.utils.icon_theme = 'Tango' -- look inside /usr/share/icons/, default: nil (don't use icon theme)
  -- require('freedesktop.menu')
  --require("debian.menu")

  --free_desktop_menu = freedesktop.menu.new()
  free_desktop_menu = {}

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

favoriteapps = {
                 -- { "thunar", "thunar", freedesktop.utils.lookup_icon({ icon="system-file-manager" }) },
                 --{ "pcmanfm", "pcmanfm", freedesktop.utils.lookup_icon({ icon="system-file-manager" }) },
                 --{ "chromium", "chromium", "/usr/share/icons/hicolor/16x16/apps/chromium.png" },
                 { "firefox", "firefox", "/usr/share/icons/hicolor/16x16/apps/firefox.png" },
                 --{ "ario", "ario", "/usr/share/icons/hicolor/16x16/apps/ario.png" },
                 --{ "gbemol", "gbemol", "/usr/share/pixmaps/gbemol.png" },
                 { "smplayer", "smplayer", "/usr/share/icons/hicolor/16x16/apps/smplayer.png" },
                 { "gVim", "gvim", "/usr/share/pixmaps/gvim.png" },
                 -- { "calc", "gcalctool", freedesktop.utils.lookup_icon({ icon="calc" }) },
                 --{ "gcstar", "gcstar", "/usr/share/pixmaps/gcstar.png" },
                 --{ "libreoffice", "soffice -writer", "/usr/share/icons/hicolor/16x16/apps/ooo-writer.png" },
                 --{ "libreoffice -impress", "soffice -impress", "/usr/share/icons/hicolor/16x16/apps/ooo-impress.png" },
                 --{ "libreoffice -calc", "soffice -calc", "/usr/share/icons/hicolor/16x16/apps/ooo-calc.png" },
                 --{ "scrabble", "/home/archy/WordBiz/wordbiz", "/usr/share/icons/Tango/16x16/actions/format-text-bold.png" },
                 -- { "terminal", terminal, freedesktop.utils.lookup_icon({ icon="terminal" }) },
                 --{ "mplayerTube", "/home/archy/mplayerTube.sh", "/usr/share/icons/Tango/16x16/mimetypes/video-x-generic.png" },
}

system_items = { { "shutdown", "sudo /sbin/poweroff", "/usr/share/icons/Tango/16x16/actions/system-shutdown.png" },
                 { "reboot", "sudo /sbin/reboot", "/usr/share/icons/Tango/16x16/actions/reload3.png" },
                 { "suspend", "sudo /usr/sbin/pm-suspend", "/usr/share/icons/Tango/16x16/actions/player_pause.png" },
                 { "hibernate", "sudo /usr/sbin/pm-hibernate", "/usr/share/icons/Tango/16x16/actions/player_stop.png" }
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

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.cache_entries = true
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)
-- quicklaunch = {}
-- for l in ipairs(favoriteapps) do 
--   --table.insert(quicklaunch, awful.widget.launcher({ 
--   --                                                  image=favoriteapps[l][3], 
--   --                                                  --image=beautiful.awesome_icon, 
--   --                                                  command=favoriteapps[l][2] })) 
--   quicklaunch[#quicklaunch+1]= awful.widget.launcher({ 
--                                                     image=favoriteapps[l][3], 
--                                                     --image=beautiful.awesome_icon, 
--                                                     command=favoriteapps[l][2] })
-- end
--quicklaunch.layout = awful.widget.layout.horizontal.leftright

-- {{{ Wibox
--local mygradient = gears.color.create_linear_pattern({
local mygradient = {
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, beautiful.fg_widget },
    { 0.25, beautiful.fg_center_widget },
    { 1, beautiful.fg_end_widget }
  }
}
--})
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

-- Create a textclock widget
mytextclock = awful.widget.textclock()
mytextclock:connect_signal("mouse::leave", function() calendar:remove() end)
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
volicon = wibox.widget.imagebox()
--volicon:set_image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = wibox.widget.textbox()
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_color(mygradient)
-- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "Master")
-- Register buttons
volbar:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer set Master toggle >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 2, function () awful.util.spawn("amixer set Master toggle >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 3, function () awful.util.spawn(terminal.." -e alsamixer") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer set Master 5%+ >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer set Master 5%- >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 6, function () awful.util.spawn("amixer set Master 5%- >/dev/null") vicious.force({volbar, volwidget}) end),
    awful.button({ }, 7, function () awful.util.spawn("amixer set Master 5%+ >/dev/null") vicious.force({volbar, volwidget}) end)
)) -- Register assigned buttons
volwidget:buttons(volbar:buttons())

-- Register widget
vicious.register(volicon, vicious.widgets.volume, 
      function (widget, args)
          if args[1] == 0 or args[2] == "♩" then 
            volicon:set_image(beautiful.widget_vol_mute)
          elseif args[1] > 66 then
            volicon:set_image(beautiful.widget_vol_hi)
          elseif args[1] > 33 and args[1] <= 66 then
            volicon:set_image(beautiful.widget_vol_mid)
          else
            volicon:set_image(beautiful.widget_vol_low)
          end
          
      end, 
      2, "Master")
volicon:buttons(volbar:buttons())
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

--mympdstatefronttext = wibox.widget.textbox()
--mympdstatebacktext  = wibox.widget.textbox()
--mympdstatefronttext.text = ' <span color="#7f9f7f">[</span>'
--mympdstatebacktext.text  = '<span color="#7f9f7f">]</span>'

-- Initialize widget
mpdwidget = wibox.widget.textbox()
mpdwidget:buttons(mpdWidgetButtons)
mympdstateicon = wibox.widget.imagebox()
mympdstateicon:buttons(mpdWidgetButtons)
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd, 
        function (widget, args)
            if args["{state}"] == "Play" then
                mympdstateicon:set_image(beautiful.widget_mpd_playing)
            elseif args["{state}"] == "Pause" then
                mympdstateicon:set_image(beautiful.widget_mpd_paused)
            else
                mympdstateicon:set_image(beautiful.widget_mpd_stopped)
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

mymailicon       = wibox.widget.imagebox()
mymailicon:set_image(beautiful.widget_mail)
mymailicon:buttons(gmailWidgetButtons)

-- Initialize widget
gmailwidget = wibox.widget.textbox()
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
myneticondown   = wibox.widget.imagebox()
myneticonup     = wibox.widget.imagebox()

myneticonup:set_image(beautiful.widget_netup)
myneticondown:set_image(beautiful.widget_netdown)
-- Initialize widget
netwidgetdown = wibox.widget.textbox()
netwidgetdown.width=30
-- Register widget
vicious.register(netwidgetdown, vicious.widgets.net, '<span color="#CC9393">${wlan0 down_kb}</span> ', 3)

-- Initialize widget
netwidgetup = wibox.widget.textbox()
netwidgetup.width=30
-- Register widget
vicious.register(netwidgetup, vicious.widgets.net, '<span color="#7F9F7F">${wlan0 up_kb}</span>', 3)
-- }}}

-- {{{ CPU usage and temperature
vicious.cache(vicious.widgets.cpu)
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuWidgetButtons = awful.util.table.join(
    awful.button({ }, 1, 
      function ()
        cpus_visible = not cpus_visible
        for i,c in ipairs(cpus) do
          c.visible = cpus_visible
        end
      end)
)
cpuicon:buttons(cpuWidgetButtons)
-- Initialize widgets
cpugraph  = awful.widget.graph()
cpugraph:set_width(40):set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_color(mygradient)
cpugraph:buttons(cpuWidgetButtons)
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")

cpus = {}
cpus_visible = false
for i = 1,2 do
  cpus[i] = awful.widget.graph()
  cpus[i].visible = cpus_visible
  cpus[i]:set_width(40):set_height(14)
  cpus[i]:set_background_color(beautiful.fg_off_widget)
  cpus[i]:set_border_color(beautiful.border_marked)
  cpus[i]:set_color(mygradient)
  vicious.register(cpus[i],  vicious.widgets.cpu,       "$"..(i+1))
  cpus[i]:buttons(cpuWidgetButtons)
end
-- }}}

-- {{{ Battery state
vicious.cache(vicious.widgets.bat)
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_bat)
---- Initialize widget
batwidget = wibox.widget.textbox()
---- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ Memory usage
vicious.cache(vicious.widgets.mem)
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_vertical(true):set_ticks(true)
membar:set_height(12):set_width(8):set_ticks_size(2)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_color(mygradient)-- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ Pacman widget
pacman_icon = wibox.widget.imagebox()
pacman_icon:set_image(beautiful.widget_pacman)
pacman = wibox.widget.textbox()
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
--mysystray = wibox.widget.systray()

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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
--                                               if not c:isvisible() then
--                                                   awful.tag.viewonly(c:tags()[1])
--                                               end
--                                               client.focus = c
--                                               c:raise()
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
    mypromptbox[s] = awful.widget.prompt()
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
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    -- mytasklist[s] = awful.widget.tasklist(function(c)
    --                                           return awful.widget.tasklist.label.currenttags(c, s)
    --                                       end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(separator)
    --left_layout:add(quicklaunch)
    for l in ipairs(favoriteapps) do 
      left_layout:add(awful.widget.launcher({ image=favoriteapps[l][3], 
                                              command=favoriteapps[l][2] }))
    end
    left_layout:add(separator)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(separator)
    right_layout:add(mpdwidget)
    right_layout:add(mympdstateicon)
    right_layout:add(separator)
    right_layout:add(cpuicon)
    right_layout:add(cpugraph)
    right_layout:add(cpus[1]) --FIXME
    right_layout:add(cpus[2]) --FIXME
    right_layout:add(separator)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(separator)
    right_layout:add(memicon)
    right_layout:add(membar)
    right_layout:add(separator)
    right_layout:add(myneticondown)
    right_layout:add(netwidgetdown)
    right_layout:add(myneticonup)
    right_layout:add(netwidgetup)
    right_layout:add(separator)
    right_layout:add(volicon)
    right_layout:add(volbar)
    right_layout:add(volwidget)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(pacman_icon)
    right_layout:add(pacman)
    right_layout:add(separator)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Lock Screen
    -- awful.key({ modkey, "Control", altkey }, "Delete", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ modkey, "Control", altkey }, "Delete", function () awful.util.spawn("i3lock -i "..beautiful.wallpaper) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, altkey    }, "j", awful.tag.viewnext),
    awful.key({ modkey, altkey    }, "k", awful.tag.viewprev),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
    --awful.key({ modkey, "Shift"   }, "Tab", function ()
    --      awful.client.cycle(false)
    --      awful.client.focus.byidx(1)
    --      client.focus:raise()
    --    end),
    --awful.key({ modkey,           }, "Tab", function ()
    --      awful.client.cycle(true)
    --      awful.client.focus.byidx(-1)
    --      client.focus:raise()
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

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
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
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true, on_top = true } },
    { rule = { class = "Smplayer" },
      properties = { floating = true, on_top = true } },
    { rule = { class = "Pidgin" },
      properties = { floating = true, focus = false } },
    { rule = { class = "Pidgin",role="conversation" },
      properties = { floating = true, focus = false } },
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
    { rule = { class = "Enemy Territory" },
      properties = { floating = true, ontop = true, modal=true, focus=true }, callback = awful.placement.centered },
    { rule = { class = "Qt4-ssh-askpass" },
      properties = { floating = true, ontop = true, modal=true, focus=true }, callback = awful.placement.centered },
    { rule = { class = "Firefox", role="Manager" },
      properties = { focus=false }, callback = awful.client.setslave },
    { rule = { class = "URxvt" },
      callback = awful.client.setslave },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--
--os.execute("gnome-keyring-daemon")
os.execute("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
