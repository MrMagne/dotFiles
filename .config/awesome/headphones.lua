local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")

local path_to_icons = "/usr/share/icons/Arc/status/symbolic/"
local path_to_devices_icons = "/usr/share/icons/Arc/devices/symbolic/"

headphones_widget = wibox.widget {
    {
        id = "icon",
   		image = path_to_devices_icons .. "audio-headphones-symbolic.svg",
		resize = false,
        widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(brightness_icon, 0, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end
}
headphones_volume_widget = wibox.widget {
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

headphones_volume_widget.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -c0 set PCM 0%") end),
    awful.button({ }, 2, function () awful.util.spawn("amixer -c0 set PCM 50%") end),
    awful.button({ }, 3, function () awful.util.spawn(terminal.." -e alsamixer -c0") end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -c0 set PCM 5%+ >/dev/null") end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -c0 set PCM 5%- >/dev/null") end),
    awful.button({ }, 6, function () awful.util.spawn("amixer -c0 set PCM 5%- >/dev/null") end),
    awful.button({ }, 7, function () awful.util.spawn("amixer -c0 set PCM 5%+ >/dev/null") end)
))


watch(
    'amixer -c0 sget PCM', 1,
    function(widget, stdout, stderr, reason, exit_code)   
        local mute = string.match(stdout, "%[(o%D%D?)%]")
        local volume = string.match(stdout, "(%d?%d?%d)%%")
		volume = tonumber(string.format("% 3d", volume))
		local volume_icon_name
		if mute == "off" then volume_icon_name="network-cellular-signal-none-symbolic.svg"
		elseif (volume >= 0 and volume < 5) then volume_icon_name="network-cellular-signal-none-symbolic.svg"
		elseif (volume >= 0 and volume < 25) then volume_icon_name="network-cellular-signal-weak-symbolic.svg"
		elseif (volume >= 25 and volume < 50) then volume_icon_name="network-cellular-signal-ok-symbolic.svg"
		elseif (volume >= 50 and volume < 75) then volume_icon_name="network-cellular-signal-good-symbolic.svg"
		elseif (volume >= 75 and volume <= 100) then volume_icon_name="network-cellular-signal-excellent-symbolic.svg"
		end
        headphones_volume_widget.image = path_to_icons .. volume_icon_name
    end
)
