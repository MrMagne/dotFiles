local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")

local path_to_icons = "/usr/share/icons/Arc/status/symbolic/"

volume_widget = wibox.widget {
    {
        id = "icon",
   		image = path_to_icons .. "audio-volume-muted-symbolic.svg",
		resize = false,
        widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(brightness_icon, 0, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end
}

volume_widget.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer set Master toggle") end),
    awful.button({ }, 2, function () awful.util.spawn("amixer set Master toggle") end),
    awful.button({ }, 3, function () awful.util.spawn(terminal.." -e alsamixer") end),
    awful.button({ }, 4, function () awful.util.spawn("amixer set Master 5%+ >/dev/null") end),
    awful.button({ }, 5, function () awful.util.spawn("amixer set Master 5%- >/dev/null") end),
    awful.button({ }, 6, function () awful.util.spawn("amixer set Master 5%- >/dev/null") end),
    awful.button({ }, 7, function () awful.util.spawn("amixer set Master 5%+ >/dev/null") end)
))


watch(
    'amixer sget Master', 1,
    function(widget, stdout, stderr, reason, exit_code)   
        local mute = string.match(stdout, "%[(o%D%D?)%]")
        local volume = string.match(stdout, "(%d?%d?%d)%%")
		volume = tonumber(string.format("% 3d", volume))
		local volume_icon_name
		if mute == "off" then volume_icon_name="audio-volume-muted-symbolic"
		elseif (volume >= 0 and volume < 25) then volume_icon_name="audio-volume-muted-symbolic"
		elseif (volume >= 25 and volume < 50) then volume_icon_name="audio-volume-low-symbolic"
		elseif (volume >= 50 and volume < 75) then volume_icon_name="audio-volume-medium-symbolic"
		elseif (volume >= 75 and volume <= 100) then volume_icon_name="audio-volume-high-symbolic"
		end
        volume_widget.image = path_to_icons .. volume_icon_name .. ".svg"
    end
)
