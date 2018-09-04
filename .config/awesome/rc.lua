-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Widget library
--require("battery")
--require("brightness")
local volume_widget = require("volume")
separator = wibox.widget.textbox()
separator:set_text("|")
-- local lain = require("lain")
-- local markup = lain.util.markup

require("menu") -- provided by xdg_menu
-- xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > ~/.config/awesome/menu.lua

-- local mybattery = lain.widget.bat{battery="BAT1"}
-- local cpu = lain.widget.cpu {
--     settings = function()
--         widget:set_markup("Cpu " .. cpu_now.usage)
--     end
-- }
-- 

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
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
--beautiful.wallpaper = "/usr/share/archlinux/wallpaper/archlinux-simplyblack.png"
beautiful.wallpaper = os.getenv("HOME").."/wallpapers/solarflairnbw_3360x1050.png"


-- --local baticon = wibox.widget.imagebox(beautiful.widget_batt)
-- local bat = lain.widget.bat({
--   battery = "BAT1",
--     settings = function()
--         local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc
-- 
--         if bat_now.ac_status == 1 then
--             perc = perc .. " plug"
--         end
-- 
--         widget:set_markup(markup.fontfg(beautiful.font, beautiful.fg_normal, bat_now.perc .. " "))
--     end
-- })
-- This is used later as the default terminal and editor to run.
terminal = "termite"
safe_terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = safe_terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "refresh menu", "bash -c \"xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > "..os.getenv("HOME").."/.config/awesome/menu.lua\"" },
   { "quit", function() awesome.quit() end}
}

favoriteapps = {
                 { "spacefm", "spacefm", "/usr/share/icons/gnome/16x16/apps/system-file-manager.png" },
                 --{ "pcmanfm", "pcmanfm", freedesktop.utils.lookup_icon({ icon="system-file-manager" }) },
                 --{ "chromium", "chromium", "/usr/share/icons/hicolor/16x16/apps/chromium.png" },
                 { "firefox", "firefox", "/usr/share/icons/hicolor/16x16/apps/firefox.png" },
                 --{ "ario", "ario", "/usr/share/icons/hicolor/16x16/apps/ario.png" },
                 --{ "gbemol", "gbemol", "/usr/share/pixmaps/gbemol.png" },
                 --{ "smplayer", "smplayer", "/usr/share/icons/hicolor/16x16/apps/smplayer.png" },
                 { "gVim", "gvim", "/usr/share/icons/hicolor/48x48/apps/gvim.png" },
                 { "calc", "qalculate-gtk", "/usr/share/icons/gnome/16x16/apps/accessories-calculator.png" },
                 --{ "gcstar", "gcstar", "/usr/share/pixmaps/gcstar.png" },
                 --{ "libreoffice", "soffice -writer", "/usr/share/icons/hicolor/16x16/apps/ooo-writer.png" },
                 --{ "libreoffice -impress", "soffice -impress", "/usr/share/icons/hicolor/16x16/apps/ooo-impress.png" },
                 --{ "libreoffice -calc", "soffice -calc", "/usr/share/icons/hicolor/16x16/apps/ooo-calc.png" },
                 { "terminal", terminal, "/usr/share/icons/gnome/16x16/apps/utilities-terminal.png" },
}

system_items = { { "shutdown", "/usr/bin/poweroff", "/usr/share/icons/gnome/16x16/actions/system-shutdown.png" },
                 { "reboot", "/usr/bin/reboot", "/usr/share/icons/gnome/16x16/actions/reload3.png" },
                 { "suspend", "/usr/bin/sbin/pm-suspend", "/usr/share/icons/gnome/16x16/actions/player_pause.png" },
                 { "hibernate", "/usr/bin/sbin/pm-hibernate", "/usr/share/icons/gnome/16x16/actions/player_stop.png" }
}

menu_items =  { { "awesome", myawesomemenu, beautiful.awesome_icon },
                { "applications", xdgmenu, beautiful.awesome_icon },
                { "open terminal", terminal }
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
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
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
    -- local cal = awful.util.pread("cal -m " .. datespec)
    awful.spawn.easy_async("cal -m " .. datespec, function(stdout, stderr, reason, exit_code)
      local cal = stdout
      if self.offset == 0 then -- this month, hilight day and month
        cal = string.gsub(cal, "%s" .. tonumber(os.date("%d")) .. "%s", italic(bold(fg(beautiful.bg_focus, "%1"))))
        cal = string.gsub(cal, "^(%s*%w+%s+%d+)", italic(bold(fg(beautiful.bg_focus, "%1"))))
      end
      self.display = naughty.notify {
        opacity = use_composite and beautiful.opacity.naughty or 1,
        text = string.format('<span font_desc="%s">%s</span>', self.font, cal),
        timeout = 0,
        hover_timeout = 0.5,
        margin = 10,
      }
    end)
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
mytextclock = wibox.widget.textclock()
mytextclock:connect_signal("mouse::leave", function() calendar:remove() end)
mytextclock:buttons(awful.util.table.join(
    awful.button({ }, 1, function() calendar:month(0) end),
    awful.button({ }, 2, function() calendar:month(0) end),
    awful.button({ }, 3, function() calendar:month(0) end),
    awful.button({ }, 5, function() calendar:month(1)  end),
    awful.button({ }, 4, function() calendar:month(-1)  end))
)


-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
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
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false, {x= -s.geometry.x, y= -s.geometry.y})
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

mylayoutitems = {}
for l in ipairs(awful.layout.layouts) do
  name = awful.layout.getname(awful.layout.layouts[l])
  -- icon = image(beautiful["layout_"..name])
  icon = beautiful["layout_"..name]
  -- icon = {}
  mylayoutitems[l] = {name, function() awful.layout.set(awful.layout.layouts[l]) end, icon}
end
mylayoutmenu = awful.menu.new({ items=mylayoutitems, theme = { width=80 } }) 

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 2, function () awful.layout.inc(-1) end),
                           awful.button({ }, 3, function () mylayoutmenu:toggle() end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            separator,
            volume_widget,
            separator,
            --brightness_icon, brightness_widget,
            --separator,
            --battery_widget,
            --{
            --  volbar,
            --  forced_height = 12,
            --  forced_width  = 8,
            --  layout        = wibox.container.rotate,
            --},
            --volwidget,
            -- cpu,
            -- bat, --mybattery,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Multimedia keys
    awful.key({ }, "XF86AudioRaiseVolume",    function ()
      awful.spawn.easy_async("amixer set Master 2%+", function(stdout, stderr, reason, exit_code)
      end)
    end),
    awful.key({ }, "XF86AudioLowerVolume",    function ()
      awful.spawn.easy_async("amixer set Master 2%-", function(stdout, stderr, reason, exit_code)
      end)
    end),
    awful.key({ }, "XF86AudioMute",    function ()
      awful.spawn.easy_async("amixer set Master toggle", function(stdout, stderr, reason, exit_code)
      end)
    end),
    awful.key({ }, "XF86MonBrightnessDown",    function ()
      awful.spawn.easy_async("xbacklight -dec 10", function(stdout, stderr, reason, exit_code)
      end)
    end),
    awful.key({ }, "XF86MonBrightnessUp",    function ()
      awful.spawn.easy_async("xbacklight -inc 10", function(stdout, stderr, reason, exit_code)
      end)
    end),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --          {description = "show main menu", group = "awesome"}),
    --awful.key({ modkey, "Control", altkey }, "Delete", function () mymainmenu:show() end,
    --          {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control", altkey }, "Delete", function () awful.util.spawn("i3lock -i "..beautiful.wallpaper) end,
              {description = "Lock Screen", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

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

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Lock Screen
    -- awful.key({ modkey, "Control", altkey }, "Delete", function () awful.util.spawn("xscreensaver-command -lock") end),
    --awful.key({ modkey, "Control", altkey }, "Delete", function () awful.spawn("i3lock -t -i "..beautiful.wallpaper) end),
    awful.key({ modkey }, "F12", function () awful.spawn("i3lock -t -i "..beautiful.wallpaper) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "w",      function (c) c:kill()                         end,
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
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },
    { rule_any = {type = { "normal" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
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
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
